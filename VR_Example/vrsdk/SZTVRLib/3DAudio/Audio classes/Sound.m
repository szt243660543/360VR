//
//  Sound.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/8.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "Sound.h"
#import "AppleOpenALSupport.h"

@implementation Sound

- (instancetype)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    
    if (self) {
        NSURL *nsFileURL = [NSURL fileURLWithPath:filePath];
        CFURLRef fileURL = (__bridge CFURLRef)nsFileURL;
        
        // Load audio data from the sound file
        [self loadAudio:fileURL];
    }
    
    return self;
}

- (void)loadAudio:(CFURLRef)fileURL
{
    alGetError(); // Clear any previous error.
    ALenum error;
    
    /***************************** Load audio data from the sound file. ******************************/
    ALsizei size, freq;
    ALenum format;
    ALdouble duration;
    
    data = MyGetOpenALAudioData(fileURL, &size, &format, &freq, &duration);
    
    if((error = alGetError()) != AL_NO_ERROR)
    {
        SZTLog(@"Error loading data from file.");
        return;
    }
    
    if ((format == AL_FORMAT_STEREO8) || (format == AL_FORMAT_STEREO16))
    {
        SZTLog(@"Audio format in stereo.  Audio will not be played in 3D space.");
        return;
    }
    
    /***************************** Get a buffer ID from openAL. ******************************/
    alGenBuffers(1, &bufferID);
    if((error = alGetError()) != AL_NO_ERROR) {
        SZTLog(@"Error getting a buffer ID.");
        return;
    }
    
    /***************************** Push audio data into the openAL buffer. ******************************/
    alBufferData(bufferID, format, data, size, freq);
    if((error = alGetError()) != AL_NO_ERROR) {
        SZTLog(@"Error pushing data into openAL buffer.");
        return;
    }
    
    /***************************** Get a source from openAL. ******************************/
    alGenSources(1, &sourceID);
    if((error = alGetError()) != AL_NO_ERROR) {
        SZTLog(@"Error getting a source.");
        return;
    }

    // 设置默认值
    [self initData];
}

- (void)initData
{
    alSourcei(sourceID, AL_BUFFER, bufferID);
    
    [self setAudioLooping:YES];
    [self setVolume:1.0];
    [self setSpeedOfSound:1.0];
    [self setSourceDistance:MINIMUM_SOUND_SOURCE_DISTANCE];
    alSourcef(sourceID, AL_ROLLOFF_FACTOR, 0.25);
}

- (void)setPosition:(float)x Y:(float)y Z:(float)z
{
	// Clear any previous error.
	alGetError();
	ALenum error;
    
	ALfloat sourcePosition[] = {x, y, z};
	alSourcefv(sourceID, AL_POSITION, sourcePosition);
    
	if((error = alGetError()) != AL_NO_ERROR) {
        SZTLog(@"Error positioning the source.");
    }
}

- (void)play
{
    ALint state;
    alGetSourcei(sourceID, AL_SOURCE_STATE, &state);
    if (state != AL_PLAYING)
    {
        alSourcePlay(sourceID);
    }
}

- (void)stop
{
    ALint state;
    alGetSourcei(sourceID, AL_SOURCE_STATE, &state);
    if (state != AL_STOPPED)
    {
        alSourceStop(sourceID);
    }
}

- (void)pause
{
    ALint state;
    alGetSourcei(sourceID, AL_SOURCE_STATE, &state);
    if (state != AL_PAUSED)
    {
        alSourcePause(sourceID);
    }
}

- (int)getProgress
{
    int processed;
    
    alGetSourcei(sourceID, AL_BUFFERS_PROCESSED, &processed);
    
    return processed;
}

// 设置音量大小，1.0f表示最大音量。openAL动态调节音量大小就用这个方法
- (void)setVolume:(float)volume
{
    alSourcef(sourceID, AL_GAIN, volume);
}

- (void)setSpeedOfSound:(float)speed
{
    alSpeedOfSound(1.0);
}

- (void)setSourceDistance:(float)distance
{
    alDistanceModel(AL_INVERSE_DISTANCE_CLAMPED);
    alSourcef(sourceID, AL_REFERENCE_DISTANCE, distance);
}

- (void)setAudioLooping:(BOOL)isLoop
{
    alGetError();
    ALenum error;
    
    if (isLoop) {
        alSourcei(sourceID, AL_LOOPING, AL_TRUE);
    }else{
        alSourcei(sourceID, AL_LOOPING, AL_FALSE);
    }
    
    if((error = alGetError()) != AL_NO_ERROR) {
        SZTLog(@"Error setting the source to loop.");
        return;
    }
}

- (void)destory
{
    alSourceStop(sourceID);
    alDeleteSources(1, &sourceID);
    alDeleteBuffers(1, &bufferID);
    if(data) {
        free(data);
        data = NULL;
    }
}

- (void)dealloc
{
    [self destory];
    
    SZTLog(@"Sound dealloc");
}

@end
