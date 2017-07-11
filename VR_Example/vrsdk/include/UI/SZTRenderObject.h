//
//  SZTObjectFilter.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/9/9.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTBaseObject.h"
#import "SZTObject3D.h"

@class SZTTexture;
typedef NS_ENUM(NSInteger, SZTFilterMode) {
    SZTVR_NORMAL,           // 普通
    SZTVR_LUMINANCE,        // 像素色值亮度平均，图像黑白 (黑白效果)
    SZTVR_PIXELATE,         // 马赛克
    SZTVR_EXPOSURE,         // 曝光 (美白)
    SZTVR_DISCRETIZE,       // 离散
    SZTVR_BLUR,             // 模糊
    SZTVR_BILATERAL,        // 双边模糊
    SZTVR_HUE,              // 饱和度 
    SZTVR_POLKADOT,         // 像素圆点花样
    SZTVR_GAMMA,            // 伽马线
    SZTVR_GLASSSPHERE,      // 水晶球效果
    SZTVR_CROSSHATCH,       // 法线交叉线
};

// 渲染模型
typedef NS_ENUM(NSInteger, SZTRenderModel) {
    SZTVR_2D,                                   // 2d
    SZTVR_SPHERE,                               // 全景
    SZTVR_STEREO_HEMISPHERE,                    // 3D180(左右格式)
    SZTVR_STEREO_SPHERE,                        // 立体全景(上下格式)
    SZTVR_PLANE,                                // 平面
    SZTVR_DOME180,                              // 圆顶180
    SZTVR_STEREO_PLANE_LEFT_RIGHT,              // 立体平面 - 上下
    SZTVR_STEREO_PLANE_UP_DOWN,                 // 立体平面 - 左右
    SZTVR_FISHSPHERE_HIGH,                      // 960 * 2560
    SZTVR_FISHSPHERE_RETINA_HIGH,               // 1520 * 2688
    SZTVR_FISHSPHERE_MEDIUM,                    // 960 * 1920
    SZTVR_FISHSPHERE_RETINA_MEDIUM,             // 1080 * 1920
    SZTVR_3D_MODEL,                             // 3D模型
    SZTVR_CURVEDSURFACE,                        // 曲面屏幕 - 不规则曲面(5面)
    SZTVR_SECTOR,                               // 扇形曲面 - 平滑曲面
};

// 视频质量大小
typedef NS_ENUM(NSInteger, SZTVideoFrameMode) {
    SZTVIDEO_DEFAULT,                           // 视频默认尺寸
    SZTVIDEO_FRAME_540P,                        // 1080 * 540
    SZTVIDEO_FRAME_720P,                        // 1440 * 720
    SZTVIDEO_FRAME_1080P,                       // 1920 * 1080
    SZTVIDEO_FRAME_1440P,                       // 2880 * 1440
    SZTVIDEO_FRAME_1920P,                       // 3840 * 1920
};

typedef NS_ENUM(NSInteger, SZTTextureFilter) {
    SZT_NEAREST,
    SZT_LINEAR,
    SZT_NEAREST_MIPMAP_NEAREST,
    SZT_LINEAR_MIPMAP_NEAREST,
    SZT_NEAREST_MIPMAP_LINEAR,
    SZT_LINEAR_MIPMAP_LINEAR,
};

@interface SZTRenderObject : SZTBaseObject

/** 
 * 是否开启物体跟随摄像机视角
 * 要在设置完坐标后调用，需要用到坐标的z值
 */
@property(nonatomic, assign)BOOL isOpenObjectFollowingCameraView;

/**
 * 修改滤波器
 */
- (void)changeFilter:(SZTFilterMode)filterMode;

/**
 * 修改渲染模式
 */
- (void)changeDisplayMode:(SZTRenderModel)vrVideoMode;

@property(nonatomic, strong)SZTProgram *program;

@property(nonatomic, strong)SZTObject3D *obj_Left;
@property(nonatomic, strong)SZTObject3D *obj_Right;

@property(nonatomic, assign)SZTFilterMode filterMode;
@property(nonatomic ,assign)SZTRenderModel renderModel;
@property(nonatomic, assign)SZTTextureFilter textureFilter;

@property(nonatomic ,assign)BOOL isFlip;

@property(nonatomic, assign)BOOL isRenderMonocular;

/**
 * 针对全景的纵深
 */
@property (nonatomic , assign)int zOrderForSphere;

/**是否直接渲染在屏幕上*/
@property(nonatomic, assign)BOOL isScreen;

#pragma mark - SZTVideoFilter property
// SZTVR_PIXELATE 模式
@property(nonatomic, assign)float particles;

// SZTVR_BLUR 模式
@property(nonatomic, assign)float radius;

// SZTVR_HUE 模式
@property(nonatomic ,assign)float hueAdjust;

// SZTVR_POLKADOT 模式
@property(nonatomic ,assign)float fractionalWidthOfPixel;
@property(nonatomic ,assign)float aspectRatio;
@property(nonatomic ,assign)float dotScaling;

// SZTVR_CROSSHATCH 模式
@property(nonatomic, assign)float crossHatchSpacing;
@property(nonatomic, assign)float lineWidth;

// SZTVR_EXPOSURE 模式
@property(nonatomic ,assign)float exposure;

// SZTVR_GAMMA 模式 (0.0 ~ <1.0 变亮 && >1.0 变暗)
@property(nonatomic ,assign)float gamma;

// SZTVR_GLASSSPHERE 模式
@property(nonatomic ,assign)float refractiveIndex;

// 进度条
@property(nonatomic ,assign)GLKVector3 uLpos;
@property(nonatomic ,assign)float uStartPosition;
@property(nonatomic ,assign)GLKMatrix4 inModelMatrix;

/*************************内部调用,外部调用无效****************************/
- (void)setupFilterMode;
- (void)drawElements:(int)index;
- (void)destory;

// 对象是否在摄像机视角内
@property(nonatomic, assign)BOOL isInFrustum;

/** 开启物体跟随摄像机视角*/
- (void)openObjectFollowingCameraView;
@end
