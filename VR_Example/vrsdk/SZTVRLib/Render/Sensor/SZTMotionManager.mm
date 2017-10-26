//
//  SZTMotionManager.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 16/11/25.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTMotionManager.h"
#import <CoreMotion/CoreMotion.h>
#import "GLUtils.h"
#include "OrientationEKF.h"

const float _defaultNeckHorizontalOffset = 0.08f;
const float _defaultNeckVerticalOffset = 0.075f;
static const size_t CBDInitialSamplesToSkip = 10;

@interface SZTMotionManager()
{
    OrientationEKF *_tracker;
    size_t _sampleCount;
    NSTimeInterval _lastGyroEventTimestamp;
    GLKMatrix4 _displayFromDevice;
    GLKMatrix4 _lastHeadView;
    bool _headingCorrectionComputed;
    GLKMatrix4 _inertialReferenceFrameFromWorld;
    GLKMatrix4 _correctedInertialReferenceFrameFromWorld;
    bool _neckModelEnabled;
    GLKMatrix4 _neckModelTranslation;
    float _orientationCorrectionAngle;
    
    bool _isLockStatusBarOrientation; // 是否锁视角
    
    UIInterfaceOrientation _lastOrientation;
}

@property(nonatomic, strong)CMMotionManager *motionManager;

@end

@implementation SZTMotionManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self initData];
    }
    
    return self;
}

- (void)initData
{
    _displayFromDevice = [GLUtils GetRotateEulerMatrix:0.0 Y:0.0 Z:-90.0];
    _inertialReferenceFrameFromWorld = [GLUtils GetRotateEulerMatrix:-90.0 Y:0.0 Z:90.0];
    _lastGyroEventTimestamp = 0;
    _orientationCorrectionAngle = 0;
    _tracker = [[OrientationEKF alloc] init];
    _neckModelEnabled = false;
    _correctedInertialReferenceFrameFromWorld = _inertialReferenceFrameFromWorld;
    _lastHeadView = GLKMatrix4Identity;
    _neckModelTranslation = GLKMatrix4Identity;
    _neckModelTranslation = GLKMatrix4Translate(_neckModelTranslation, 0, -_defaultNeckVerticalOffset, _defaultNeckHorizontalOffset);
    _orientation = UIInterfaceOrientationLandscapeRight;
}

- (void)setIsUseingGvrGyro:(BOOL)isUseingGvrGyro
{
    _isUseingGvrGyro = isUseingGvrGyro;
    
    [self stopDeviceMotion];
    
    [self startMotion];
}

- (void)startMotion
{
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.gyroUpdateInterval = 1.0f / 60.0;
    self.motionManager.showsDeviceMovementDisplay = YES;
    
    if (_isUseingGvrGyro) {
        [self startDeviceMotionWithGvr];
    }else{
        [self startDeviceMotion];
    }
}

#pragma mark - Device Motion
- (void)startDeviceMotion
{
    self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    
    //处理陀螺仪数据，无跟随效果
    NSOperationQueue* motionQueue = [[NSOperationQueue alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.motionManager startDeviceMotionUpdatesToQueue:motionQueue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        CMAttitude* attitude = motion.attitude;
        if (attitude == nil) return;
        
        GLKMatrix4 sensor = GLKMatrix4Identity;
        CMQuaternion quaternion = attitude.quaternion;
    
        sensor = [GLUtils calculateMatrixFromQuaternion:&quaternion orientation:_orientation];
        sensor = GLKMatrix4RotateX(sensor, M_PI_2);
        
        [[SZTCamera sharedSZTCamera] updateOrientation:_orientation];
        _lastHeadView = sensor;
        
        // get deviceMotion gravity
        double gravityX = weakSelf.motionManager.deviceMotion.gravity.x;
        double gravityY = weakSelf.motionManager.deviceMotion.gravity.y;
        double gravityZ = weakSelf.motionManager.deviceMotion.gravity.z;
        CMRotationRate rotationRate = weakSelf.motionManager.deviceMotion.rotationRate;
        
        double zTheta = atan2(gravityZ, sqrtf(gravityX * gravityX + gravityY * gravityY))/M_PI*180.0;
        double rotationX = rotationRate.x;
        
        [[SZTCamera sharedSZTCamera] updateDeviceMotionGravity:zTheta];
        [[SZTCamera sharedSZTCamera] updateDeviceMotionGravity_rotationX:rotationX];
    }];
}

- (void)startDeviceMotionWithGvr
{
    self.motionManager.deviceMotionUpdateInterval = 1.0 / 100.0;
    
    _headingCorrectionComputed = false;
    [_tracker reset];
    _sampleCount = 0; // used to skip bad data when core motion starts
    
    NSOperationQueue *deviceMotionQueue = [[NSOperationQueue alloc] init];
    __weak typeof(self) weakSelf = self;
    [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical toQueue:deviceMotionQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        ++_sampleCount;
        if (_sampleCount <= CBDInitialSamplesToSkip) { return; }
        _displayFromDevice = [GLUtils updateDeviceOrientation:_orientation];
     
        CMAcceleration acceleration = motion.gravity;
        CMRotationRate rotationRate = motion.rotationRate;
        // note core motion uses units of G while the EKF uses ms^-2
        const float kG = 9.81f;
        [_tracker processAcceleration:GLKVector3Make(kG*acceleration.x, kG*acceleration.y, kG*acceleration.z) time:motion.timestamp];
        [_tracker processGyro:GLKVector3Make(rotationRate.x, rotationRate.y, rotationRate.z) time:motion.timestamp];
        _lastGyroEventTimestamp = motion.timestamp;
        
        // get deviceMotion gravity
        double gravityX = weakSelf.motionManager.deviceMotion.gravity.x;
        double gravityY = weakSelf.motionManager.deviceMotion.gravity.y;
        double gravityZ = weakSelf.motionManager.deviceMotion.gravity.z;
        
        double zTheta = atan2(gravityZ, sqrtf(gravityX * gravityX + gravityY * gravityY))/M_PI*180.0;
        double rotationX = rotationRate.x;
        
        [[SZTCamera sharedSZTCamera] updateOrientation:_orientation];
        [[SZTCamera sharedSZTCamera] updateDeviceMotionGravity:zTheta];
        [[SZTCamera sharedSZTCamera] updateDeviceMotionGravity_rotationX:rotationX];
    }];
}

- (BOOL)isReady
{
    bool isTrackerReady = (_sampleCount > CBDInitialSamplesToSkip);
    isTrackerReady = isTrackerReady && [_tracker isReady];
    
    return isTrackerReady;
}

- (GLKMatrix4)lastHeadView
{
    if (_isUseingGvrGyro) {
        NSTimeInterval currentTimestamp = CACurrentMediaTime();
        double secondsSinceLastGyroEvent = currentTimestamp - _lastGyroEventTimestamp;
        // 1/30 of a second prediction (shoud it be 1/60?)
        double secondsToPredictForward = secondsSinceLastGyroEvent + 1.0/30.0;
        GLKMatrix4 deviceFromInertialReferenceFrame = [_tracker getPredictedGLMatrix:secondsToPredictForward];
        
        if (![self isReady]) { return _lastHeadView;}
        
        if (!_headingCorrectionComputed)
        {
            // fix the heading by aligning world -z with the projection
            // of the device -z on the ground plane
            
            GLKMatrix4 deviceFromWorld = GLKMatrix4Multiply(deviceFromInertialReferenceFrame, _inertialReferenceFrameFromWorld);
            GLKMatrix4 worldFromDevice = GLKMatrix4Transpose(deviceFromWorld);
            
            GLKVector3 deviceForward = GLKVector3Make(0.f, 0.f, -1.f);
            GLKVector3 deviceForwardWorld = GLKMatrix4MultiplyVector3(worldFromDevice, deviceForward);
            
            if (fabsf(deviceForwardWorld.y) < 0.99f)
            {
                deviceForwardWorld.y = 0.f;  // project onto ground plane
                
                deviceForwardWorld = GLKVector3Normalize(deviceForwardWorld);
                
                // want to find R such that
                // deviceForwardWorld = R * [0 0 -1]'
                // where R is a rotation matrix about y, i.e.:
                //     [ c  0  s]
                // R = [ 0  1  0]
                //     [-s  0  c]
                
                float c = -deviceForwardWorld.z;
                float s = -deviceForwardWorld.x;
                // note we actually want to use the inverse, so
                // transpose when building
                GLKMatrix4 Rt = GLKMatrix4Make(
                                               c, 0.f,  -s, 0.f,
                                               0.f, 1.f, 0.f, 0.f,
                                               s, 0.f,   c, 0.f,
                                               0.f, 0.f, 0.f, 1.f );
                
                _correctedInertialReferenceFrameFromWorld = GLKMatrix4Multiply(_inertialReferenceFrameFromWorld, Rt);
            }
            _headingCorrectionComputed = true;
        }
        
        GLKMatrix4 deviceFromWorld = GLKMatrix4Multiply(deviceFromInertialReferenceFrame, _correctedInertialReferenceFrameFromWorld);
        GLKMatrix4 displayFromWorld = GLKMatrix4Multiply(_displayFromDevice, deviceFromWorld);
        
        if (_neckModelEnabled)
        {
            displayFromWorld = GLKMatrix4Multiply(_neckModelTranslation, displayFromWorld);
            displayFromWorld = GLKMatrix4Translate(displayFromWorld, 0.0f, _defaultNeckVerticalOffset, 0.0f);
        }
        
        _lastHeadView = displayFromWorld;
        
        return _lastHeadView;
    }else{
        return _lastHeadView;
    }
}

- (void)stopDeviceMotion
{
    if (self.motionManager) {
        [self.motionManager stopDeviceMotionUpdates];
        self.motionManager = nil;
    }
}

- (void)dealloc
{
    if (_tracker) {
        _tracker = nil;
    }
    
    [self stopDeviceMotion];
    
    SZTLog(@"SZTMotionManager dealloc");
}

@end
