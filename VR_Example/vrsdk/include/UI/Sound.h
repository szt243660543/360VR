//
//  Sound.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/8.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

#define MINIMUM_SOUND_SOURCE_DISTANCE 1.0  // 默认声源距离

@interface Sound : NSObject {
	ALuint	bufferID;		
	ALvoid	*data;
	ALuint	sourceID;	
}

- (instancetype)initWithFilePath:(NSString *)filePath;

// 声源在世界坐标系中的位置
- (void)setPosition:(float)x Y:(float)y Z:(float)z;

- (void)play;

- (void)stop;

- (void)pause;

- (void)destory;

// 获取进度
- (int)getProgress;

/**
 * 设置音量大小，1.0f表示最大音量 * Range:【0.0 - 1.0]
 */
- (void)setVolume:(float)volume;

// 设置声音的播放速度
- (void)setSpeedOfSound:(float)speed;

// 设置音频播放是否为循环播放
- (void)setAudioLooping:(BOOL)isLoop;

// Reference distance is 1 meter.  I.e. the source is at least 1 meter away from the listener.
- (void)setSourceDistance:(float)distance;

@end

