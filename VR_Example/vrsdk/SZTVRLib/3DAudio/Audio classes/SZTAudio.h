//
//  SZTAudio.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/8.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

// 默认半径
#define SOUND_SPACE_RADIUS 35

@class Sound;

@interface SZTAudio : NSObject
// 监听者位置
- (void)setListenerPosition:(float)x Y:(float)y Z:(float)z;

- (void)addSubAudio:(Sound *)sound;

- (void)destory;

@end
