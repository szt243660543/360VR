//
//  AudioSound.m
//  SZTVR_SDK
//
//  Created by szt on 2016/12/7.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "AudioSound.h"
#import "SZTRay.h"

@interface AudioSound ()
{
    CADisplayLink *_displayLink;
}

@property(nonatomic, strong)AVAudioPlayer *audioPlayer;

@property(nonatomic, assign)float radian;

@property(nonatomic, assign)float initVolume;
@end

@implementation AudioSound

- (instancetype)initWithPath:(NSString *)path radians:(float)radian
{
    self = [super init];
    
    if (self) {
        self.radian = radian;
        
        NSURL* url = [NSURL fileURLWithPath:path];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        self.audioPlayer.volume = 1.0 - fabs(radian/180.0);
        self.initVolume = 1.0 - fabs(radian/180.0);
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return self;
}

- (void)update
{
    float x = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray].x;
    float y = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray].y;
    float z = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray].z;
    
    float yAngle = [MathC getYAngle:GLKVector3Make(x, y, z) pivotPoint:GLKVector3Make(0, 0, 0)];
    if (yAngle > 180.0) {
        yAngle = yAngle - 360.0;
    }
    
    if (yAngle < 0) { // right
        
        if (self.radian > 0) { //声源在左侧
            if (yAngle < -(180.0 - self.radian)) {
                self.audioPlayer.volume = fabs(self.initVolume - fabs(yAngle/180.0));
            }else{
                self.audioPlayer.volume = self.initVolume - fabs(yAngle/180.0);
            }
        }else{ //声源在右侧
            if (yAngle > self.radian) {
                self.audioPlayer.volume = self.initVolume + fabs(yAngle/180.0);
            }else{
                self.audioPlayer.volume = 2.0 - self.initVolume - fabs(yAngle/180.0);
            }
        }
        
    }else{ // left
        
        if (self.radian > 0) { //声源在左侧
            if (yAngle < self.radian) {
                self.audioPlayer.volume = self.initVolume + yAngle/180.0;
            }else{
                self.audioPlayer.volume = 2.0 - self.initVolume - yAngle/180.0;
            }
        }else{ //声源在右侧
            if (yAngle < 180.0 - fabs(self.radian)) {
                self.audioPlayer.volume = self.initVolume - fabs(yAngle/180.0);
            }else{
                self.audioPlayer.volume = fabs(self.initVolume - fabs(yAngle/180.0));
            }
        }
    }
}

- (void)play
{
    [self.audioPlayer play];
}

- (void)pause
{
    [self.audioPlayer pause];
}

- (void)stop
{
    [self.audioPlayer stop];
}

- (NSTimeInterval)getCurrentTime;
{
    return self.audioPlayer.currentTime;
}

- (NSTimeInterval)getDuration;
{
    return self.audioPlayer.duration;
}

- (void)destory
{
    if (_displayLink) {
        [_displayLink invalidate];
    }
    
    self.audioPlayer = nil;
}

- (void)dealloc
{
    [self destory];
    
    SZTLog(@"AudioSound dealloc");
}

@end
