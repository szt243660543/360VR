//
//  CameraOpenGLView.h
//  SZTVR_SDK
//
//  Created by szt on 2017/4/27.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "BaseRenderView.h"
#import <OpenGLES/ES2/glext.h>
#import "YUVData.h"

typedef NS_ENUM(NSInteger, VideoSetting) {
    BGRA,
    YUV,
};

@interface RenderGLView : BaseRenderView

//- (void)displayYUVData:(YUVData *)yuvData;

/*************要开启本地摄像头渲染的话需要调用这些个方法**************/
// 开始渲染
- (void)startRenderCameraData;

/* 该方法只用处理手机自带摄像机的pixelBuffer*/
- (void)displayCameraSampleBuffer:(CMSampleBufferRef)sampleBuffer;

// 停止渲染
- (void)stopRenderCameraData;

// 设置纹理渲染类型 - 默认为BGRA
- (void)setVideoSetting:(VideoSetting)type;

@property(nonatomic, assign)float captureWidth;
@property(nonatomic, assign)float captureHeight;

@end
