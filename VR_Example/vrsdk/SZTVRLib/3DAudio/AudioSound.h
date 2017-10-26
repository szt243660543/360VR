//
//  AudioSound.h
//  SZTVR_SDK
//
//  Created by szt on 2016/12/7.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioSound : NSObject

/**
 * 实例化音频文件
 * @param radians  [-180,180] left（0～180）right (0~-180), 0的位置声音最大为1，180或-180的位置声音最小为0
 */
- (instancetype)initWithPath:(NSString *)path radians:(float)radian;

- (void)play;

- (void)pause;

- (void)stop;

- (NSTimeInterval)getCurrentTime;

- (NSTimeInterval)getDuration;

- (void)destory;

@end
