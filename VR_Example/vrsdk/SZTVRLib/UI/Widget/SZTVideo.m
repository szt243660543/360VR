//
//  SZTVideo.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTVideo.h"
#import "SZTVideoTexture.h"
#import "SZTProgram.h"
#import "SZTObject3D.h"
#if USE_IJK_PLAYER
#import <IJKMediaFramework/IJKMediaFramework.h>
#endif

@interface SZTVideo()<VIMVideoPlayerDelegate>
{
    SZTTexture * _texture;
    BOOL _isPrepareToPlay;
    
    NSTimer *_timer;
    BOOL _isSuccess;
    BOOL _isOnce;
}

@property(nonatomic, strong)AVPlayerItem *playerItem;

#if USE_IJK_PLAYER
@property(nonatomic, strong)id <IJKMediaPlayback> ijkPlayer;
#endif

@property(nonatomic, strong)VIMVideoPlayer *avPlayer;

@end

@implementation SZTVideo

#pragma mark init
- (instancetype)initAVPlayerVideoWithURL:(NSURL *)url VideoMode:(SZTRenderModel)renderModel
{
    self = [super init];
    
    if (self) {
        self.renderModel = renderModel;
        self.isFlip = NO;
        self.url = url;
        
        [self setupAVPlayer:url PlayerItem:nil];
    }
    
    return self;
}

- (instancetype)initAVPlayerVideoWithPlayerItem:(AVPlayerItem *)playerItem VideoMode:(SZTRenderModel)renderModel
{
    self = [super init];
    
    if (self) {
        self.renderModel = renderModel;
        
        [self setupAVPlayer:nil PlayerItem:playerItem];
    }
    
    return self;
}

- (instancetype)initIJKPlayerVideoWithURL:(NSURL *)url VideoMode:(SZTRenderModel)renderModel isVideoToolBox:(BOOL)key videoFrameMode:(SZTVideoFrameMode)frameMode
{
    self = [super init];
    
    if (self) {
        self.renderModel = renderModel;
        self.url = url;
        
        float width = [self getFrameWidth:frameMode];
        [self setupIJKPlayer:url videoToolBox:key width:width];
    }
    
    return self;
}

- (void)setupAVPlayer:(NSURL *)url PlayerItem:(AVPlayerItem *)item
{
    AVPlayerItem *playerItem = url?[[AVPlayerItem alloc] initWithURL:url]:item;
    self.playerItem = playerItem;
    
    self.avPlayer = [[VIMVideoPlayer alloc] init];
    self.avPlayer.delegate = self;
    [self.avPlayer setPlayerItem:playerItem];
    [self.avPlayer play];
    
    [self setupVideoPlayerItem:playerItem];
}

- (void)setupIJKPlayer:(NSURL *)url videoToolBox:(BOOL)key width:(float)width
{
    if (!USE_IJK_PLAYER) {
        SZTLog(@"Failed to play video, because the ijkplayer is not included in the project!");
    }
    
#if USE_IJK_PLAYER
    if (!self.ijkPlayer)
    {
        [IJKFFMoviePlayerController setLogReport:YES];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_UNKNOWN];
        [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
        
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame" ofCategory:kIJKFFOptionCategoryCodec];
        [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec];
        [options setOptionIntValue:key forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
        
        if (width > 0) {
            [options setOptionIntValue:1 forKey:@"video-max-frame-width-default" ofCategory:kIJKFFOptionCategoryPlayer];
            [options setOptionIntValue:width forKey:@"videotoolbox-max-frame-width" ofCategory:kIJKFFOptionCategoryPlayer];
        }else{
            [options setOptionIntValue:0 forKey:@"video-max-frame-width-default" ofCategory:kIJKFFOptionCategoryPlayer];
        }
        
        self.ijkPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
        self.ijkPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.ijkPlayer.view.frame = [UIScreen mainScreen].bounds;
        self.ijkPlayer.scalingMode = IJKMPMovieScalingModeAspectFit;
        self.ijkPlayer.shouldAutoplay = YES;
        
        [NotificationCenter addObserver:self selector:@selector(moviePlayerFirstVideoFrameRender:) name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification object:self.ijkPlayer];
        [NotificationCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinishNotification:) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.ijkPlayer];
    }
    
    [self.ijkPlayer prepareToPlay];
    
    [self setupVideoIJKPlayer:self.ijkPlayer];
#endif
    
}

- (void)moviePlayerFirstVideoFrameRender:(NSNotification *)notification
{
    if (didIJKPlayerReady) {
        didIJKPlayerReady(self);
    }
    
    [self setPrepareToPlay:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoIsReadyToPlay:)]) {
        [self.delegate videoIsReadyToPlay:self];
    }
}

- (void)videoPlayerIsReadyToPlayVideo:(VIMVideoPlayer *)videoPlayer
{
    [self setPrepareToPlay:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoIsReadyToPlay:)]) {
        [self.delegate videoIsReadyToPlay:self];
    }
}

- (void)moviePlayerPlaybackDidFinishNotification:(NSNotification *)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoDidPlayBcakFinished:)]) {
        [self.delegate videoDidPlayBcakFinished:self];
    }
}

- (void)videoPlayerDidReachEnd:(VIMVideoPlayer *)videoPlayer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoDidPlayBcakFinished:)]) {
        [self.delegate videoDidPlayBcakFinished:self];
    }
}

- (void)setupVideoPlayerItem:(AVPlayerItem *)playerItem
{
    SZTVideoTexture *videoTexture = [[SZTVideoTexture alloc] init];
    _texture = [videoTexture createWithAVPlayerItem:playerItem];
}

#if USE_IJK_PLAYER
- (void)setupVideoIJKPlayer:(id<IJKMediaPlayback>)player
{
    SZTVideoTexture *videoTexture = [[SZTVideoTexture alloc] init];
    _texture = [videoTexture createWithIJKPlayer:player];
}
#endif

- (void)setPrepareToPlay:(BOOL)isPlay
{
    _isPrepareToPlay = isPlay;
}

- (void)renderToFbo:(int)index
{
    if (!_isPrepareToPlay) return;
    
    [super renderToFbo:index];
    
    [self renderTexture:index];
    if (!_isSuccess) return;
    
    // draw
    [self drawElements:index];
}

- (void)renderTexture:(int)index
{
    CVPixelBufferRef pixelBufferRef;
    
    if (index == 0) {
        pixelBufferRef = [_texture updateVideoTexture:self.glContext];
    }
    
    [_texture updateTexture:self.program.uSamplerLocal];
    
    if (pixelBufferRef == nil) {
        if (!_isOnce) {
            _isOnce = true;
            _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(failedToLoadPlayer) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        }
    }else{
        _isSuccess = YES;
    }
}

- (void)failedToLoadPlayer
{
    if (!_isSuccess) {
        _isOnce = false;
        
        if (self.avPlayer) {
            SZTLog(@"failed to load playerItem, reload avPlayer!");
        }
        
#if USE_IJK_PLAYER
        if (self.ijkPlayer) {
            SZTLog(@"failed to load ijk buffer, reload ijkPlayer!");
        }
#endif
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(errorToLoadVideo:)]) {
            [self.delegate errorToLoadVideo:self];
        }
    }
    
    [_timer invalidate];
    _timer = nil;
}

- (float)getFrameWidth:(SZTVideoFrameMode)frameMode
{
    float w;
    
    switch (frameMode) {
        case SZTVIDEO_DEFAULT:
            w = 0;
            break;
        case SZTVIDEO_FRAME_540P:
            w = 1080;
            break;
        case SZTVIDEO_FRAME_720P:
            w = 1440;
            break;
        case SZTVIDEO_FRAME_1080P:
            w = 1920;
            break;
        case SZTVIDEO_FRAME_1440P:
            w = 2880;
            break;
        case SZTVIDEO_FRAME_1920P:
            w = 3840;
            break;
        default:
            break;
    }
    
    return w;
}

#pragma mark video player属性
- (float)duration
{
    if (self.avPlayer) {
        return CMTimeGetSeconds(self.playerItem.duration);
    }
    
#if USE_IJK_PLAYER
    if (self.ijkPlayer) {
        return self.ijkPlayer.duration - 1.0;
    }
#endif
    
    return 0;
}

- (float)currentTime
{
    if (self.avPlayer) {
        return CMTimeGetSeconds([self.playerItem currentTime]);
    }
    
#if USE_IJK_PLAYER
    if (self.ijkPlayer) {
        return self.ijkPlayer.currentPlaybackTime;
    }
#endif
    
    return 0;
}

- (void)seekToTime:(float)time
{
    if (self.avPlayer) {
        [self.avPlayer seekToTime:time];
    }
    
#if USE_IJK_PLAYER
    if (self.ijkPlayer) {
        self.ijkPlayer.currentPlaybackTime = time;
    }
#endif
}

- (void)pause
{
    if (self.avPlayer) {
        [self.avPlayer pause];
    }
    
    
#if USE_IJK_PLAYER
    if (self.ijkPlayer) {
        [self.ijkPlayer pause];
    }
#endif
}

- (void)stop
{
    if (self.avPlayer) {
        [self.avPlayer pause];
    }
    
#if USE_IJK_PLAYER
    if (self.ijkPlayer) {
        [self.ijkPlayer stop];
    }
#endif
}

- (void)play
{
    if (self.avPlayer) {
        [self.avPlayer play];
    }
    
#if USE_IJK_PLAYER
    if (self.ijkPlayer) {
        [self.ijkPlayer play];
    }
#endif
}

- (void)didIJKPlayerFirstFrameRenderBlock:(didIJKPlayerFirstFrameRender)block
{
    didIJKPlayerReady = block;
}

- (void)screenShotByIndex:(int)index screenDoneblock:(void (^)(NSString *))block;
{
    [_texture screenShotByIndex:index VideoTag:self.tag screenDoneblock:^(NSString * path) {
        block(path);
    }];
}

- (void)destoryIjkPlayer
{
#if USE_IJK_PLAYER
    [self.ijkPlayer shutdown];
    [self.ijkPlayer stop];
    self.ijkPlayer = nil;
    [NotificationCenter removeObserver:self name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification object:self.ijkPlayer];
#endif
}

- (void)destoryAvPlayer
{
    self.avPlayer = nil;
}

- (void)destory
{
    [super destory];
    
    [self removeObject];
    if (_texture) [_texture destory];
    
    if (self.avPlayer) {
        [self destoryAvPlayer];
    }
    
#if USE_IJK_PLAYER
    if (self.ijkPlayer) {
        [self destoryIjkPlayer];
    }
#endif
}

- (void)dealloc
{
    SZTLog(@"video dealloc");
    [self destory];
}

@end
