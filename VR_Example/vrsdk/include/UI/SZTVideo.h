//
//  SZTVideo.h
//  SZTVR_SDK
//  视频对象
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VIMVideoPlayer.h"
#import "SZTRenderObject.h"

@class SZTVideo;

@protocol SZTVideoDelegate <NSObject>
@optional
- (void)errorToLoadVideo:(SZTVideo *)video;
- (void)videoIsReadyToPlay:(SZTVideo *)video;
- (void)videoDidPlayBcakFinished:(SZTVideo *)video;

@end

typedef void(^didIJKPlayerFirstFrameRender)(SZTVideo *);

@interface SZTVideo : SZTRenderObject
{
    didIJKPlayerFirstFrameRender didIJKPlayerReady;
}

/**
 * 初始化－avplayer 视频资源/模式
 * @param url 视频地址
 * @param vrVideoMode 视频模式
 */
- (instancetype)initAVPlayerVideoWithURL:(NSURL *)url VideoMode:(SZTRenderModel)vrVideoMode;

/**
 * 初始化－avplayer 视频资源/模式
 * @param playitem 资源管理集
 * @param vrVideoMode 视频模式
 */
- (instancetype)initAVPlayerVideoWithPlayerItem:(AVPlayerItem *)playerItem VideoMode:(SZTRenderModel)vrVideoMode;

/**
 * 初始化－ijkplayer 视频资源/模式
 * @param url 视频地址
 * @param vrVideoMode 视频模式
 * @param isVideoToolBox 是否开启硬解码
 * @param videoFrameMode 视频质量大小
 */
- (instancetype)initIJKPlayerVideoWithURL:(NSURL *)url VideoMode:(SZTRenderModel)renderModel isVideoToolBox:(BOOL)key videoFrameMode:(SZTVideoFrameMode)frameMode;

/**
 * 截图
 * @param index 如果传入的索引一样，则会替换之前的图片,block返回的是图片存储路径
 */
- (void)screenShotByIndex:(int)index screenDoneblock:(void (^)(NSString *))block;

@property(nonatomic , assign) NSURL *url;
@property(nonatomic , weak)id <SZTVideoDelegate> delegate;

#pragma mark video player属性
@property(nonatomic, assign)float duration;

@property(nonatomic, assign)float currentTime;

- (void)seekToTime:(float)time;

- (void)pause;

- (void)stop;

- (void)play;

#pragma mark - block
- (void)didIJKPlayerFirstFrameRenderBlock:(didIJKPlayerFirstFrameRender)block;
@end
