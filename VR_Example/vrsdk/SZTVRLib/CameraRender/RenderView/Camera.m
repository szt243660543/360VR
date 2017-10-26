//
//  Camera.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/15.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "Camera.h"

@implementation Camera
SingletonM(Camera)

- (void)updateLocalCameraMatrix
{
    float aspect = fabs(_renderWidth/_renderHeight);
    GLKMatrix4 projectionMatrix = GLKMatrix4Identity;
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(_fov), aspect, 0.1f, 1000.0f);
    projectionMatrix = GLKMatrix4Translate(projectionMatrix, 0.0, 0.0, -150.0);
    
    self.cameraModelMatrix = projectionMatrix;
}

@end
