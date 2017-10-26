//
//  SZTBitmapVideo.h
//  SZTVR_SDK
//  位图
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTRenderObject.h"

@interface SZTImageView : SZTRenderObject

/**
 * 实例话
 * @param renderModel 渲染模式
 */
- (instancetype)initWithMode:(SZTRenderModel)renderModel;

/**
 * 设置图片纹理 图片名
 * @param imageName 图片image
 */
- (void)setupTextureWithImage:(UIImage *)imageName;

/**
 * 设置图片纹理 网络下载
 * @param fileUrl 网络地址/自动缓存
 * @param paceholder 占位图
 */
- (void)setupTextureWithUrl:(NSString *)fileUrl Paceholder:(UIImage *)paceholder;

/**
 * 设置图片纹理
 * @param color 根据图片颜色生成纹理
 * @param frameSize 生成图片的尺寸
 */
- (void)setupTextureWithColor:(UIColor *)color Rect:(CGRect)frameSize;

/**
 * 设置图片纹理
 * @param fileName 图片名
 */
- (void)setupTextureWithFileName:(NSString *)fileName;

/**
 * 设置左右屏幕图片纹理
 */
- (void)setTextureWithLeftImage:(UIImage *)LeftImage RightImage:(UIImage *)rightImage;

- (void)setTextureWithLeftUrl:(NSString *)leftUrl RightUrl:(NSString *)rightUrl Paceholder_Left:(UIImage *)paceholder_left Paceholder_Right:(UIImage *)paceholder_right;

@end
