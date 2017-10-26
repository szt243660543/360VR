//
//  SZTMD2Model.h
//  SZTVR_SDK
//
//  Created by szt on 2017/7/5.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTRenderObject.h"

@interface SZTMD2Model : SZTRenderObject

/** 加载本地md2模型 - 全路径*/
- (instancetype)initWithPath:(NSString *)path;

- (void)setupTextureWithImage:(UIImage *)image;

- (void)setupTextureWithFilePath:(NSString *)filePath;

/** 加载网络md2模型*/
- (instancetype)initWithObjUrl:(NSString *)urlPath;

- (void)setupTextureWithUrl:(NSString *)fileUrl;

/**
 * 播放帧动画 - 如果没设置，默认从地0帧播放到结束
 */
- (void)playFrameFrom:(int)beginFrame To:(int)endFrame;

// 是否循环播放，默认true
@property(nonatomic, assign)BOOL isCycle;

- (void)play;

- (void)pause;

// 帧间隔 - 默认为0.08秒,越大播放速度越快
@property(nonatomic, assign)float frameInterval;

@end
