//
//  RenderEngine.h
//  SZTVR_SDK
//
//  Created by szt on 2017/5/20.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderGLView.h"
#import "Singleton.h"

@interface RenderEngine : NSObject
SingletonH(RenderEngine)

@property(nonatomic, strong)RenderGLView *renderView;

- (void)setRenderFrame:(CGRect)rect;

- (UIView *)renderView:(CGRect)frame;

- (void)startRender;
- (void)stopRender;

// 开启/关闭本地摄象机
- (void)openLocalCamera;
- (void)stopLocalCamera;

/**
 * 截图
 * @param index 如果传入的索引一样，则会替换之前的图片,block返回的是图片存储路径
 */
- (void)takePhotosByIndex:(int)index screenDoneblock:(void (^)(NSString *))block;

/**
 * Adds a object to the end of the receiver’s list of subviews.
 */
- (void)addSubObject:(SZTBaseObject *)object;

/**
 * remove object from the subviews.
 */
- (void)removeObject:(SZTBaseObject *)object;

@end
