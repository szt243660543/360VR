//
//  SZTRay.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 16/11/23.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTRay.h"

@interface SZTRay()

@end

@implementation SZTRay

SingletonM(SZTRay)

- (void)calculateABPosition:(float)x y:(float)y width:(float)w height:(float)h left:(float)left top:(float)top near:(float)near far:(float)far
{
    float x0 = x - w/2;
    float y0 = h/2 - y;
    
    float xNear = 2 * x0 * left/w;
    float yNear = 2 * y0 * top/h;
    
    float ratio = far/near;
    float xFar = ratio * xNear;
    float yFar = ratio * yNear;
    
    float ax = xNear;
    float ay = yNear;
    float az = -near;
    
    float bx = xFar;
    float by = yFar;
    float bz = -far;
    
    GLKVector3 A = [self fromPtoPreP:ax y:ay z:az];
    GLKVector3 B = [self fromPtoPreP:bx y:by z:bz];
    
    self.nearPos = A;
    self.farPos = B;
    
    float dirx = _farPos.x - _nearPos.x;
    float diry = _farPos.y - _nearPos.y;
    float dirz = _farPos.z - _nearPos.z;
    
    self.ray = GLKVector3Make(dirx, diry, dirz);
}

- (GLKVector3)fromPtoPreP:(float)x y:(float)y z:(float)z
{
    bool isInverse;
    GLKMatrix4 invM = GLKMatrix4Invert([SZTCamera sharedSZTCamera].mModelViewMatrix, &isInverse);
    
    GLKVector3 preP = GLKMatrix4MultiplyVector3(invM, GLKVector3Make(x, y, z));

    return preP;
}

- (void)calculateABPositionWithTouchPoint:(GLKVector2)touch screenCount:(int)index
{
    /* calculate window size */
    GLKVector2 winSize = GLKVector2Make(CGRectGetWidth([UIScreen mainScreen].bounds)/index, CGRectGetHeight([UIScreen mainScreen].bounds));
    
    /* touch point in window space */
    GLKVector2 point = GLKVector2Make(touch.x, winSize.y-touch.y);
    
    /* touch point in viewport space */
    GLKVector2 pointNDC = GLKVector2SubtractScalar(GLKVector2MultiplyScalar(GLKVector2Divide(point, winSize), 2.0f), 1.0f);
    
    /* touch point in 3D for both near and far planes */
    GLKVector4 win[2];
    win[0] = GLKVector4Make(pointNDC.x, pointNDC.y, -1.0f, 1.0f);
    win[1] = GLKVector4Make(pointNDC.x, pointNDC.y, 1.0f, 1.0f);
    
    /* inverse of model-view-projection matrix
     * This takes the touch points to the object space
     */
    bool success;
    GLKMatrix4 invMVP = GLKMatrix4Invert([SZTCamera sharedSZTCamera].mModelViewProjectionMatrix, &success);
    assert(success);
    
    /* ray at near and far plane in the object space */
    GLKVector4 ray[2];
    ray[0] = GLKMatrix4MultiplyVector4(invMVP, win[0]);
    ray[1] = GLKMatrix4MultiplyVector4(invMVP, win[1]);
    
    /* covert rays from homogenous coordsys to cartesian coordsys */
    ray[0] = GLKVector4DivideScalar(ray[0], ray[0].w);
    ray[1] = GLKVector4DivideScalar(ray[1], ray[1].w);
    
    self.nearPos = GLKVector3Make(ray[0].x, ray[0].y, ray[0].z);
    self.farPos = GLKVector3Make(ray[1].x, ray[1].y, ray[1].z);
    
    /* direction of the ray */
    GLKVector4 rayDir = GLKVector4Subtract(ray[1], ray[0]);
    
    self.ray =  GLKVector3Make(rayDir.x, rayDir.y, rayDir.z);
}

- (void)resetRay
{
    self.ray = GLKVector3Make(0.0, 1.0, 0.0);
}

@end
