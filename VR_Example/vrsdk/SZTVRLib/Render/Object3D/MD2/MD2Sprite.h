//
//  MD2Sprite.h
//  SZTVR_SDK
//
//  Created by szt on 2017/7/5.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTObject3D.h"
#import "MD2Model.h"

@interface MD2Sprite : SZTObject3D

- (instancetype)initWithFilePath:(NSString *)path;

// 播放帧动画
- (void)playFrameFrom:(int)beginFrame To:(int)endFrame;

- (void)play;

- (void)pause;

// 帧间隔 - 默认为0.08秒,越大播放速度越快
@property(nonatomic, assign)float frameInterval;

@property(nonatomic, assign)BOOL isCycle;

- (void)updateKeyFrame;

@end
