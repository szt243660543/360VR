//
//  SZTCamera.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/27.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Singleton.h"

@interface SZTCamera : NSObject
{
    GLKMatrix4 _mSensorMatrix;
    GLKMatrix4 _mCurrentMatrix;
    GLKMatrix4 _mInverseMatrix;
}

@property(nonatomic, assign)GLKMatrix4 mModelViewProjectionMatrix;

@property(nonatomic, assign)GLKMatrix4 mModelMatrix;
@property(nonatomic, assign)GLKMatrix4 mViewMatrix;
@property(nonatomic, assign)GLKMatrix4 mProjectionMatrix;
@property(nonatomic, assign)GLKMatrix4 mModelViewMatrix;

@property(nonatomic, assign)int screenNumber;

@property(nonatomic, assign)BOOL isUsingMotion;

@property(nonatomic, assign)BOOL isUsingTouch;

@property(nonatomic, assign)BOOL isUseingGvrGyro;

@property(nonatomic, assign)float binocularDistance;

@property(nonatomic, assign)double zTheta;
@property(nonatomic, assign)double rotationX;

// view宽高
@property(nonatomic, assign)float width;
@property(nonatomic, assign)float height;
// 像素宽高
@property(nonatomic, assign)float widthPx;
@property(nonatomic, assign)float HeightPx;

@property(nonatomic, assign)float nearZ;
@property(nonatomic, assign)float farZ;

@property(nonatomic, assign)UIInterfaceOrientation orientation;

SingletonH(SZTCamera)

/**
 * 初始化矩阵
 */
- (void)setupMatrix;

/**
 * 更新矩阵
 */
- (void)updateMatrix:(int)index;

/**
 * 更新model矩阵
 */
- (void)updateSensorMatrix:(GLKMatrix4)sensor;

- (void)updateOrientation:(UIInterfaceOrientation)orientation;

- (void)updateDeviceMotionGravity:(double)zTheta;
// 角速度
- (void)updateDeviceMotionGravity_rotationX:(double)rotationX;

/**
 * 触摸位移
 */
- (void)updateFingerRotation:(float)fingerX FingerRotationY:(float)fingerY;

- (void)resetScreen;

/**
 * 设置摄像机距离缩放系数
 */
- (void)setCameraDistanceRatio:(float)ratio;

@end
