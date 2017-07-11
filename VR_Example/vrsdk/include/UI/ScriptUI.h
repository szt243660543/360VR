//
//  ScriptUI.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/21.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTRenderObject.h"

typedef NS_ENUM(NSInteger, VideoPLayerMode) {
    SZT_AVPlayer,
    SZT_IJKPlayer,
};

@interface ScriptUI : SZTRenderObject

/** 
 * 实例化对象，传入脚本名
 */
- (instancetype)initWithJsonName:(NSString *)jsonName;

/**
 * 实例化对象，从沙盒目录中读取脚本，沙盒绝对路径
 */
- (instancetype)initWithSandboxPath:(NSString *)jsonPath;

/** 
 * 设置脚本内部视频播放器类型 -- 默认为IJkplayer
 */
- (void)setVideoPlsyer:(VideoPLayerMode)playerMode;

/** 
 * 传入热更新json脚本 -- 后续直播使用，还未实现
 */
- (void)loadHotUpdateJson:(NSString *)jsonPath;

- (void)seekTime:(float)time;

/** destory*/
- (void)destory;

@end
