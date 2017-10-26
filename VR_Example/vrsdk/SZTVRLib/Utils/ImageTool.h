//
//  TextTool.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/19.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageTool : NSObject

+ (UIImage *)imageWithText:(NSMutableArray *)textArr fontSize:(float)size color:(UIColor *)color lineNumber:(int)lineNumber rightAlign:(BOOL)rightAlign isOpaque:(BOOL)opaque definition:(float)definition;

+ (UIImage *)imageWithText:(NSString *)text fontSize:(float)size color:(UIColor *)color width:(float)width height:(float)height rightAlign:(BOOL)rightAlign isOpaque:(BOOL)opaque definition:(float)definition;

+ (UIImage *)imageFromCMSampleBufferRef:(CMSampleBufferRef)sampleBuffer;

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

+ (UIImage *)convertSampleBufferToUIImageSampleBuffer:(CMSampleBufferRef)sampleBuffer;

+ (UIImage *)imageFromCVPixelBufferRef:(CVPixelBufferRef)pixelBuffer;

+ (UIImage *)setImageFromColor:(UIColor *)color Rect:(CGRect)frameSize;

/**
 * 根据视频url获取图片
 */
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 * 设置图片透明度
 * @param alpha 透明度
 * @param image 图片
 */
+ (UIImage *)imageByApplyingAlpha:(CGFloat )alpha image:(UIImage*)image;

+ (CVPixelBufferRef)yuvPixelBufferWithData:(NSData *)dataFrame width:(size_t)w heigth:(size_t)h;

// 图片旋转
+ (UIImage *)imageRotate:(UIImage *)image rotation:(UIImageOrientation)orientation;
@end
