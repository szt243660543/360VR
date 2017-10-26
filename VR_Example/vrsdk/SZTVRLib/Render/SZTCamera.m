//
//  SZTCamera.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/27.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTCamera.h"
#import "SZTRay.h"
#import "Picking.h"

@interface SZTCamera()
{
    float _fingerX;
    float _fingerY;
    BOOL _isReset;
    BOOL _isRotateCamera;
    
    float _distance;
}
@end

@implementation SZTCamera

SingletonM(SZTCamera)

- (void)setupMatrix
{
    _isUsingMotion = true;
    _isReset = false;
    
    _nearZ = 0.01f;
    _farZ = 1000.0f;

    _distance = 0.0;
    
    _mModelViewProjectionMatrix = GLKMatrix4Identity;
    _mModelViewMatrix = GLKMatrix4Identity;
    _mProjectionMatrix = GLKMatrix4Identity;
    _mViewMatrix = GLKMatrix4Identity;
    _mCurrentMatrix = GLKMatrix4Identity;
    _mInverseMatrix = GLKMatrix4Identity;
    _mModelMatrix = GLKMatrix4Identity;
    
    [self setupCamera];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation != UIInterfaceOrientationPortrait) {
        _isRotateCamera = true;
    }
    
    _orientation = -1;
}

- (void)setupCamera
{
    float eyeX = 0.0f;
    float eyeY = 0.0f;
    float eyeZ = 0.0f;
    
    float lookX = 0.0f;
    float lookY = 0.0f;
    float lookZ = -1.0f;
    
    float upX = 0.0f;
    float upY = 1.0f;
    float upZ = 0.0f;
    
    _mViewMatrix = GLKMatrix4MakeLookAt(eyeX, eyeY, eyeZ, lookX, lookY, lookZ, upX, upY, upZ);
}

// 视角偏移
- (void)setEyePosition:(int)index
{
    if (index == 0) {
        _mModelMatrix = GLKMatrix4Translate(_mModelMatrix, _binocularDistance, 0.0, 0.0);
    }else{
        _mModelMatrix = GLKMatrix4Translate(_mModelMatrix, -_binocularDistance, 0.0, 0.0);
    }
    
    _mModelMatrix = GLKMatrix4TranslateWithVector3(_mModelMatrix, GLKVector3Make(0.0, 0.0, _distance));
}

- (void)setIsUsingMotion:(BOOL)isUsingMotion
{
    _isUsingMotion = isUsingMotion;
    
    if (!_isUsingMotion) {
        _fingerX = 0;
        _fingerY = 0;
    }
}

- (void)setScreenNumber:(int)screenNumber
{
    _screenNumber = screenNumber;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self updateProjectionMatrix:orientation];
}

- (void)updateProjectionMatrix:(UIInterfaceOrientation)orientation
{
//    if (_orientation == orientation) return;
    _orientation = orientation;
    
    float aspect;
    float fov;
    swapt(&_width, &_height);
    
    if (_screenNumber == 2) {
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            aspect = (_width * 0.5)/_height;
        }else{
//            aspect = (_height * 0.5)/_width;
            aspect = _height/(_width * 0.5);
        }
        
        fov = 70;
    }else{
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            aspect = _width/_height;
        }else{
            aspect = _height/_width;
        }
        
        fov = 55;
    }
    
    float scale = [[UIScreen mainScreen] nativeScale];
    _widthPx = scale * _width;
    _HeightPx = scale * _height;
    
    _mProjectionMatrix = GLKMatrix4Identity;
    _mProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fov), aspect, _nearZ, _farZ);
}

- (void)updateSensorMatrix:(GLKMatrix4)sensor
{
    _mSensorMatrix = sensor;
}

- (void)updateOrientation:(UIInterfaceOrientation)orientation
{
    [self updateProjectionMatrix:orientation];
}

- (void)updateFingerRotation:(float)fingerX FingerRotationY:(float)fingerY
{
    _fingerX = fingerX;
    _fingerY = fingerY;
}

- (void)updateDeviceMotionGravity:(double)zTheta
{
    _zTheta = zTheta;
}

- (void)updateDeviceMotionGravity_rotationX:(double)rotationX;
{
    _rotationX = rotationX;
}

- (void)setCameraDistanceRatio:(float)ratio
{
    _distance -= ratio;
    
    if (_distance < -200) {
        _distance = -200;
    }
    
    if (_distance > 100) {
        _distance = 100;
    }
}

- (void)updateMatrix:(int)index
{
    [self setEyePosition:index];
    // 切换模式
    [self interactiveMode];
    
    [self setInverseMatrix];
    
    _mCurrentMatrix = GLKMatrix4Multiply(_mCurrentMatrix, _mInverseMatrix);
    _mModelMatrix = GLKMatrix4Multiply(_mModelMatrix, _mCurrentMatrix);
    
    _mModelViewMatrix = GLKMatrix4Multiply(_mViewMatrix, _mModelMatrix);
    _mModelViewProjectionMatrix = GLKMatrix4Multiply(_mProjectionMatrix, _mModelViewMatrix);
    
    // 射线
    if (index == 0 && [Picking sharedPicking].focusPickingState) {
        [[SZTRay sharedSZTRay] calculateABPosition:_widthPx * 0.5 y:_HeightPx * 0.5 width:_widthPx height:_HeightPx left:_widthPx/_HeightPx top:1.0f near:_nearZ far:_farZ];
    }
    
    [self resetMatrix];
}

- (void)interactiveMode
{
    if (_isUsingMotion && !_isUsingTouch) {
        if (!_isUseingGvrGyro && _isRotateCamera) {
            _mCurrentMatrix = GLKMatrix4Rotate(_mCurrentMatrix, GLKMathDegreesToRadians(-90.0), 0.0, 1.0, 0.0);
        }
        _mCurrentMatrix = GLKMatrix4Multiply(_mSensorMatrix, _mCurrentMatrix);
    }
    
    if (!_isUsingMotion && _isUsingTouch) {
        _mCurrentMatrix = GLKMatrix4RotateX(_mCurrentMatrix, _fingerX);
        _mCurrentMatrix = GLKMatrix4RotateY(_mCurrentMatrix, -_fingerY);
    }
    
    if (_isUsingMotion && _isUsingTouch) {
        if (!_isUseingGvrGyro && _isRotateCamera) {
            _mCurrentMatrix = GLKMatrix4Rotate(_mCurrentMatrix, GLKMathDegreesToRadians(-90.0), 0.0, 1.0, 0.0);
        }
        _mCurrentMatrix = GLKMatrix4Multiply(_mSensorMatrix, _mCurrentMatrix);
        
        _mCurrentMatrix = GLKMatrix4RotateY(_mCurrentMatrix, -_fingerY);
    }
}

- (void)setInverseMatrix
{
    if(_isReset)
    {
        bool isInverse;
        _mInverseMatrix = GLKMatrix4Invert(_mCurrentMatrix, &isInverse);
                                                    
        if (!isInverse) {
            _mInverseMatrix = GLKMatrix4Identity;
        }
        
        _isReset = false;
    }
}

- (void)resetScreen
{
    _isReset = true;
}

- (void)resetMatrix
{
    _mModelMatrix = GLKMatrix4Identity;
    _mCurrentMatrix = GLKMatrix4Identity;
}

@end
