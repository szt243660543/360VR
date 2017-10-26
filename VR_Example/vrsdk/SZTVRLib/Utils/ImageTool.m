//
//  TextTool.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/19.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "ImageTool.h"

#define CONTENT_MAX_WIDTH 300.0f

@implementation ImageTool

+ (UIImage *)imageWithText:(NSMutableArray *)textArr fontSize:(float)size color:(UIColor *)color lineNumber:(int)lineNumber rightAlign:(BOOL)rightAlign isOpaque:(BOOL)opaque definition:(float)definition
{
    
    int row = lineNumber > (int)textArr.count?(int)textArr.count:lineNumber;
    int column = (int)textArr.count%row>0?(int)(textArr.count/row + 1.0):(int)textArr.count/row;
    
    float width = size * row;
    float height = (column) * size + 5.0;
    
    CGSize expectedLabelSize = CGSizeMake(width, height);
    
    float offsetX = rightAlign?(width - expectedLabelSize.width) : 0.0f;
    NSDictionary *attribute = @{NSFontAttributeName:[self getFontFromLib:@"Helvetica" size:size],NSForegroundColorAttributeName:color};
    
    UIImage *image = [[UIImage alloc] init];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), opaque, definition);
    [image drawInRect:CGRectMake(offsetX,
                                 expectedLabelSize.height/2.0,
                                 expectedLabelSize.width,
                                 expectedLabelSize.height)
            blendMode:kCGBlendModeNormal
                alpha:1.0f];
    [image drawAtPoint:CGPointMake(offsetX, 0.0f)];

    int nIndex = 0;
    NSString *sContent;
    for (int i = 0; i < column; i++) {
        for (int j = 0; j < row; j++) {
            if (nIndex > textArr.count - 1) break;
            
            sContent = textArr[nIndex];
            [sContent drawAtPoint:CGPointMake(size * j, size * i) withAttributes:attribute];
            nIndex ++;
        }
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)imageWithText:(NSString *)text fontSize:(float)size color:(UIColor *)color width:(float)width height:(float)height rightAlign:(BOOL)rightAlign isOpaque:(BOOL)opaque definition:(float)definition
{
    CGSize expectedLabelSize = CGSizeMake(width, height);
    
    float offsetX = rightAlign?(width - expectedLabelSize.width) : 0.0f;
    UIImage *image2 = [[UIImage alloc] init];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), opaque, definition);
    [image2 drawInRect:CGRectMake(offsetX,
                                  expectedLabelSize.height/2.0,
                                  expectedLabelSize.width,
                                  expectedLabelSize.height)
             blendMode:kCGBlendModeNormal
                 alpha:1.0f];
    [image2 drawAtPoint:CGPointMake(offsetX, 0.0f)];
    [text drawAtPoint:CGPointMake(offsetX,0.0f)
       withAttributes:@{NSFontAttributeName:[self getFontFromLib:@"Helvetica" size:size],
                        NSForegroundColorAttributeName:color}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

+ (UIImage *)imageFromCMSampleBufferRef:(CMSampleBufferRef)sampleBuffer
{
    if (!sampleBuffer) {
        SZTLog(@"sampleBuffer is nil!");
        return nil;
    }
    
    CVImageBufferRef imageBuffer =  CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
    if (width == 0 || height == 0) {
        SZTLog(@"faile to image create beacuse width or height is 0!");
        return nil;
    }
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    CGImageRef cgImage = CGImageCreate(width, height, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaNoneSkipFirst|kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(rgbColorSpace);
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    image = [UIImage imageWithData:imageData];
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {

    if (!sampleBuffer) {
        SZTLog(@"sampleBuffer is nil!");
        return nil;
    }
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    if (width == 0 || height == 0) {
        SZTLog(@"faile to image create beacuse width or height is 0!");
        return nil;
    }
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
}

// Works only if pixel format is kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
+ (UIImage *)convertSampleBufferToUIImageSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    
    if (!sampleBuffer) {
        SZTLog(@"sampleBuffer is nil!");
        return nil;
    }
    
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the plane pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    
    // Get the number of bytes per row for the plane pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    if (width == 0 || height == 0) {
        SZTLog(@"faile to image create beacuse width or height is 0!");
        return nil;
    }
    
    // Create a device-dependent gray color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGImageAlphaNone);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

+ (UIImage *)imageFromCVPixelBufferRef:(CVPixelBufferRef)pixelBuffer{
    CVPixelBufferRef pb = (CVPixelBufferRef)pixelBuffer;
    CVPixelBufferLockBaseAddress(pb, kCVPixelBufferLock_ReadOnly);
    size_t w = CVPixelBufferGetWidth(pb);
    size_t h = CVPixelBufferGetHeight(pb);
    size_t r = CVPixelBufferGetBytesPerRow(pb);
    size_t bytesPerPixel = r/w;
    
    unsigned char *buffer = CVPixelBufferGetBaseAddress(pb);
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    unsigned char* data = CGBitmapContextGetData(c);
    if (data != NULL) {
        size_t maxY = h;
        for(int y = 0; y < maxY; y++) {
            for(int x = 0; x < w; x++) {
                size_t offset = bytesPerPixel*((w*y)+x);
                data[offset] = buffer[offset];     // R
                data[offset+1] = buffer[offset+1]; // G
                data[offset+2] = buffer[offset+2]; // B
                data[offset+3] = buffer[offset+3]; // A
            }
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CVPixelBufferUnlockBaseAddress(pb, kCVPixelBufferLock_ReadOnly);
    
    return image;
}

// 通过颜色来生成一个纯色图片
+ (UIImage *)setImageFromColor:(UIColor *)color Rect:(CGRect)frameSize
{
    CGRect rect = CGRectMake(0, 0, frameSize.size.width, frameSize.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

+ (UIFont *)getFontFromLib:(NSString *)fontName size:(CGFloat)fontSize
{
    /** 打印所有的字体库fontName
    NSArray * fontArrays = [[UIFont familyNames] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        return [str1 compare:str2];
    }];
    for(NSString *fontfamilyname in fontArrays)
    {
        NSLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
    }*/
    
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIImage *)imageByApplyingAlpha:(CGFloat )alpha image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

static OSType KVideoPixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;

+ (CVPixelBufferRef)yuvPixelBufferWithData:(NSData *)dataFrame width:(size_t)w heigth:(size_t)h
{
    unsigned char* buffer = (unsigned char*) dataFrame.bytes;
    CVPixelBufferRef getCroppedPixelBuffer = [self copyDataFromBuffer:buffer toYUVPixelBufferWithWidth:w Height:h];
    return getCroppedPixelBuffer;
}

+ (CVPixelBufferRef)copyDataFromBuffer:(const unsigned char*)buffer toYUVPixelBufferWithWidth:(size_t)w Height:(size_t)h
{
    NSDictionary *pixelBufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionary],kCVPixelBufferIOSurfacePropertiesKey,nil];
    
    CVPixelBufferRef pixelBuffer;
    CVPixelBufferCreate(NULL, w, h, KVideoPixelFormatType, (__bridge CFDictionaryRef)(pixelBufferAttributes), &pixelBuffer);
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    size_t d = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0);
    const unsigned char* src = buffer;
    unsigned char* dst = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    
    for (unsigned int rIdx = 0; rIdx < h; ++rIdx, dst += d, src += w) {
        memcpy(dst, src, w);
    }
    
    d = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1);
    dst = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    h = h >> 1;
    for (unsigned int rIdx = 0; rIdx < h; ++rIdx, dst += d, src += w) {
        memcpy(dst, src, w);
    }
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return pixelBuffer;
}

+ (UIImage *)imageRotate:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

@end
