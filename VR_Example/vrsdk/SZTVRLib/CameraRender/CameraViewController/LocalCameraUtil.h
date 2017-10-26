//
//  LocalCameraUtil.h
//  SZTVR_SDK
//
//  Created by szt on 2017/5/20.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SZTSessionPreset) {
    SessionPreset640x480,
    SessionPreset1280x720,
    SessionPreset1920x1080,
    SessionPreset3840x2160,
};

@interface LocalCameraUtil : NSObject

- (void)setCaptureSessionPreset:(SZTSessionPreset)sessionPreset;

- (void)startRunning;

- (void)stopRunning;

/**
 * 截图
 * @param index 如果传入的索引一样，则会替换之前的图片,block返回的是图片存储路径
 */
- (void)takePhotosByIndex:(int)index screenDoneblock:(void (^)(NSString *))block;

@end
