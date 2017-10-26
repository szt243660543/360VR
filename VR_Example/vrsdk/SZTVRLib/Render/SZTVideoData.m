//
//  SZTVideoData.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTVideoData.h"

@interface SZTVideoData()
{
    CMTime _lastTime;
}

@property (nonatomic, strong)AVPlayerItemVideoOutput* output;
@property (nonatomic, weak)AVPlayerItem* playerItem;

#if USE_IJK_PLAYER
@property (nonatomic, weak)id<IJKMediaPlayback> ijkplayer;
#endif

@end

static void *VideoPlayer_PlayerItemStatusContext = &VideoPlayer_PlayerItemStatusContext;

@implementation SZTVideoData

- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem{
    self = [super init];
    if (self) {
        self.playerItem = playerItem;
        self.isijkPlayer = false;
    
        [self addObserver];
    }
    
    return self;
}

#if USE_IJK_PLAYER
- (instancetype)initWithIJKPlayer:(id<IJKMediaPlayback>)player
{
    self = [super init];
    if (self) {
        self.isijkPlayer = true;
        self.ijkplayer = player;
    }
    
    return self;
}
#endif

- (void)setup
{
    NSDictionary *pixBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    self.output = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixBuffAttributes];
    
    [self.playerItem addOutput:self.output];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == VideoPlayer_PlayerItemStatusContext) {
        AVPlayerStatus newStatus = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        if (newStatus == AVPlayerItemStatusReadyToPlay && self.output == nil) {
            [self setup];
        }
    }
}

- (void)addObserver
{
    [self.playerItem addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(status))
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                         context:VideoPlayer_PlayerItemStatusContext];
}

- (void)removeObserver{
    if (self.playerItem == nil) return;
    
    @try {
        [self.playerItem removeObserver:self
                             forKeyPath:NSStringFromSelector(@selector(status))
                                context:VideoPlayer_PlayerItemStatusContext];
    } @catch (NSException *exception) {
        NSLog(@"Exception removing observer: %@", exception);
    }
}

#pragma mark pixelBuffer
- (CVPixelBufferRef)copyPixelBuffer
{
    if (self.isijkPlayer) {
#if USE_IJK_PLAYER
        CVPixelBufferRef pixelBuffer = [self.ijkplayer framePixelbuffer];
        
        return pixelBuffer;
#endif
    }else{        
        if (self.output == nil) return nil;
        
        CMTime currentTime = [self.playerItem currentTime];
        CVPixelBufferRef pixelBuffer = [self.output copyPixelBufferForItemTime:currentTime itemTimeForDisplay:nil];
    
        if (pixelBuffer) {
            _lastTime = currentTime;
        
            return pixelBuffer;
        }else{
            if (CMTimeGetSeconds(_lastTime) > 0.0) {
                return [self.output copyPixelBufferForItemTime:_lastTime itemTimeForDisplay:nil];
            }else{
                return nil;
            }
        }
    }
    
    return nil;
}

- (void)lockPixelBuffer
{
#if USE_IJK_PLAYER
    [self.ijkplayer framePixelbufferLock];
#endif
}

- (void)unlockPixelBuffer
{
#if USE_IJK_PLAYER
    [self.ijkplayer framePixelbufferUnlock];
#endif
}

- (void)teardown
{
    if (self.playerItem != nil && self.output != nil) {
        [self.playerItem removeOutput:self.output];
        self.output = nil;
    }
    
#if USE_IJK_PLAYER
    if (self.ijkplayer != nil) {
        self.ijkplayer = nil;
    }
#endif
}

- (void)dealloc
{
    [self teardown];
    [self removeObserver];
    if (self.output != nil) {
        self.output = nil;
    }
}

@end
