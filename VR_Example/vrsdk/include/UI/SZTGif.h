//
//  SZTGif.h
//  SZTVR_SDK
//  Gif图
//  Created by SZTVR on 16/7/30.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTRenderObject.h"

@class SZTGif;

typedef void(^gifDidFinishedBlockParam)(SZTGif *);

@interface SZTGif : SZTRenderObject
{
    gifDidFinishedBlockParam gifDidFinished;
}

/**
 * 网路下载gif图并显示
 * @param fileUrl 图片路径
 * @param 本地路径／网络路径 自动识别加载
 */
- (void)setupGifWithFileUrl:(NSString *)fileUrl;

/**
 * 本地gif图
 * @param gifName gif图片名
 */
- (void)setupGifWithGifName:(NSString *)gifName;

/**
 * 本地gif图
 * @param gifName gif path
 */
- (void)setupGifWithGifPath:(NSString *)pathName;

/**
 * 用图片序列图加载gif动画
 * @param frameImages 图片名数组
 * @param time 播放序列帧动画总时间
 */
- (void)setupGifViewWithFrames:(NSArray *)frameNames playTime:(float)time;

/**
 * 本地aPng图
 * @param path apng图片路径
 * @param time 播放序列帧动画总时间
 */
- (void)setupApngWithApngPath:(NSString *)path playTime:(float)time;

/**
 * 网路下载apng图
 * @param fileUrl 网络路径径
 * @param time 播放序列帧动画总时间
 */
- (void)setupApngWithApngUrl:(NSString *)fileUrl playTime:(float)time;

/**
 * 本地aPng图
 * @param apngName aPng图片名
 */
- (void)setupApngWithApngName:(NSString *)apngName playTime:(float)time;

/**
 * 播放重复次数
 */
@property(nonatomic, assign)int repeatTimes;

/**
 * gif播放速率
 */
@property(nonatomic, assign)int speed;

/**
 * 设置gif播放总时间，不传默认为gif自身的时间,该参数需要在对象生成之前设置，否则无效
 */
- (void)setPlayTime:(float)time;

/**
 * 播放完毕回调
 */
- (void)gifDidFinishedCallback:(gifDidFinishedBlockParam)block;

- (void)pause;

- (void)play;

- (void)resume;

@end
