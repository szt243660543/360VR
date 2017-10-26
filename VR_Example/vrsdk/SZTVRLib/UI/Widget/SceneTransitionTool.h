//
//  SceneTransitionTool.h
//  SZTVR_SDK
//
//  Created by szt on 2017/4/25.
//  Copyright © 2017年 szt. All rights reserved.
//

// 进度条的模式只能为: SZTVR_SPHERE

#import "SZTImageView.h"

typedef void(^didComplete)();

@interface SceneTransitionTool : SZTImageView
{
    didComplete completed;
}

- (instancetype)initWithMode:(SZTRenderModel)renderModel;

// 渐入效果
- (void)fadeInScene:(float)time complete:(void (^)(void))isComplete;

// 淡出效果
- (void)fadeOutScene:(float)time complete:(void (^)(void))isComplete;

@end
