//
//  SZTAudio.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/8.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTAudio.h"
#import "Sound.h"
#import "SZTRay.h"

@interface SZTAudio()
{
    CADisplayLink *_displayLink;
    ALCdevice *_device;
    ALCcontext *_context;
}

@end

@implementation SZTAudio

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupDevice];
        
        [self setupContext];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return self;
}

- (void)setupDevice
{
    _device = alcOpenDevice(NULL); // Select default device.
    if (!_device)
    {
        SZTLog(@"Error initializing the device.");
    }
}

- (void)setupContext
{
    _context = alcCreateContext(_device, NULL); // Use the device to create a context.
    if(!_context)
    {
        SZTLog(@"Error creating a context.");
    }
    alcMakeContextCurrent(_context); // Set the context to be currently active.
}

- (void)setListenerPosition:(float)x Y:(float)y Z:(float)z
{
    alGetError(); // Clear any previous error.
    ALenum error;
    ALfloat listenerPosition[] = {x, y, z};
    alListenerfv(AL_POSITION, listenerPosition);
    if((error = alGetError()) != AL_NO_ERROR)
    {
        SZTLog(@"Error positioning the listener.");
    }
}

- (void)addSubAudio:(Sound *)sound
{
    [sound play];
}

- (void)update
{
    float x = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray].x * SOUND_SPACE_RADIUS;
    float y = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray].y * SOUND_SPACE_RADIUS;
    float z = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray].z * SOUND_SPACE_RADIUS;
    
    [self setListenerPosition:x Y:y Z:z];
}

- (void)destory
{
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    if (_context) {
        alcDestroyContext(_context);
        _context = nil;
    }
    
    if (_device) {
        alcCloseDevice(_device);
        _device = nil;
    }
}

- (void)dealloc
{
    [self destory];
    SZTLog(@"SZTAudio dealloc");
}

@end
