//
//  SZTLibrary.h
//  SZTVR_SDK
//
//  Created by szt on 16/7/28.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SZTBaseObject;

typedef NS_ENUM(NSInteger, SZTModeInteractive) {
    SZTModeInteractiveTouch,            // 触摸
    SZTModeInteractiveMotion,           // 陀螺仪
    SZTModeInteractiveMotionWithTouch,  // 陀螺仪和触摸
};

typedef NS_ENUM(NSInteger, SZTModeDisplay) {
    SZTModeDisplayNormal,   // 普通模式
    SZTModeDisplayGlass,    // 分屏模式
};

typedef NS_ENUM(NSInteger, SZTDistortion) {
    SZTDistortionNormal,   // 无畸变
    SZTBarrelDistortion,   // 桶形畸变模式
};

typedef NS_ENUM(NSInteger, SZTPickingEyes) {
    SZTbinoculusPicking,   // 双目拾取
    SZTMonocularPicking,   // 单目拾取
};

typedef NS_ENUM(NSInteger, SZTSensorMode) {
    SZTSensorNormal,       // 系统默认处理
    SZTSensorGvr,          // gvr陀螺仪处理（有跟随效果）
};

@interface SZTLibrary : NSObject

/**
 * build SZTLibrary SDK
 * @param vc 父控制器
 */
- (instancetype)initWithController:(UIViewController *)vc;

- (instancetype)initWithView:(UIView *)v;

/**
 * 设置单双屏幕模式  － 默认分屏
 */
- (void)dispalyMode:(SZTModeDisplay)mode;

- (SZTModeDisplay)getDispalyMode;

/**
 * 设置交互模式  － 默认陀螺仪
 */
- (void)interactiveMode:(SZTModeInteractive)mode;

/**
 * 畸变模式 - 默认无畸变
 */
- (void)distortionMode:(SZTDistortion)mode;

/**
 * 开启焦点拾取 - 默认关闭
 */
- (void)setFocusPicking:(BOOL)isopen;

/**
 * 设置拾取模式 -- 默认双目拾取
 */
- (void)setPickingEyes:(SZTPickingEyes)mode;

/**
 * 开启点击拾取 - 默认关闭 (不能与焦点拾取同时存在)
 */
- (void)setTouchEvent:(BOOL)isopen;

/**
 * 开启耳机点击事件 - 默认关闭
 */
- (void)setEarPhoneTarget:(BOOL)isopen;

/**
 * 开启陀螺仪数据处理模式 - 默认使用gvr
 */
- (void)setSensorWithGvr:(SZTSensorMode)mode;

/**
 * 设置桶形畸变边缘黑边宽度，范围0.0~1.0 - 默认为0.9
 * 只有开启桶形畸变，设置参数才有效
 */
- (void)setValuesOfBlackEdge:(float)values;

/**
 * 设置双目间距（范围0.0 ～ 1.5）默认0.0，0.0的话没有立体效果，值越大立体效果越明显
 */
- (void)setBinocularDistance:(float)value;

/**
 * 重置屏幕／画面
 */
- (void)resetScreen;

/**
 * 设置屏幕旋转方向 - 默认位右横屏 UIDeviceOrientationLandscapeRight
 * 设置错误会导致显示出错
 */
- (void)setOrientation:(UIInterfaceOrientation)orientation;

/**
 * 渲染帧数, 默认60帧
 */
@property(nonatomic, assign)int fps;

/**
 * Adds a object to the end of the receiver’s list of subviews.
 */
- (void)addSubObject:(SZTBaseObject *)object;

/**
 * remove object from the subviews.
 */
- (void)removeObject:(SZTBaseObject *)object;

@end
