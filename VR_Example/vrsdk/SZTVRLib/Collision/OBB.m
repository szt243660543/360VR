//
//  OBBCollision.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 16/11/25.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "OBB.h"
#import "SZTRay.h"
#import "MathC.h"

@interface OBB()
{
    GLKVector3 min;
    GLKVector3 max;
    GLKVector3 m_pos;
    
    GLKVector3 mRayDir;
    GLKVector3 mRayStart;
    GLKVector3 mRayEnd;
    float mInterTime;
    
    GLKVector3 curDir;
    GLKVector3 curDirC;
    GLKVector3 obbPosition;
    GLKVector3 delta;
    
    GLKMatrix4 mRayTransformMatrix;
    
    BOOL _isInit;
}

@end

@implementation OBB

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // 初始化
        min = GLKVector3Make(max_n, max_n, max_n);
        max = GLKVector3Make(-max_n, -max_n, -max_n);
        
        mInterTime = 0;
    }
    
    return self;
}

- (BOOL)intersect:(GLKMatrix4)modelMatrix
{
    if (!_isInit) {
        _isInit = true;
        
        [self createOBBBox:modelMatrix];
    }
    
    return [self intersectResult:modelMatrix];
}

- (BOOL)intersectResult:(GLKMatrix4)modelMatrix
{
    BOOL res = false;
    mRayStart = [SZTRay sharedSZTRay].nearPos;
    mRayEnd = [SZTRay sharedSZTRay].farPos;
    mRayStart = [self fromWorldPostionToObjectPosition:modelMatrix Vec3:mRayStart];
    mRayEnd = [self fromWorldPostionToObjectPosition:modelMatrix Vec3:mRayEnd];
    mRayDir = GLKVector3Subtract(mRayEnd, mRayStart);
    mInterTime = [self intersectOBBByRay:mRayDir rayStart:mRayStart rayEnd:mRayEnd];
    if(mInterTime < 1.0 && mInterTime > 0.0){
        float radians = modelMatrix.m32;
        GLKVector3 rayNormalization = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray];
        float ratio = radians/rayNormalization.z;
        
        float x = rayNormalization.x * ratio;
        float y = rayNormalization.y * ratio;
        self.pickingPos = GLKVector3Make(x - m_pos.x, y - m_pos.y, 0.0);
        res = true;
    }
    
    return res;
}

- (float)intersectOBBByRay:(GLKVector3)rayDir rayStart:(GLKVector3)rayStart rayEnd:(GLKVector3)rayEnd
{
    float kNoIntersection = max_n;
    float xt;
    
    if(rayStart.x<min.x){
        xt = min.x - rayStart.x;
        if(xt>rayDir.x){ return kNoIntersection; }
        xt /= rayDir.x;
    }
    else if(rayStart.x>max.x){
        xt = max.x - rayStart.x;
        if(xt<rayDir.x){ return kNoIntersection; }
        xt /= rayDir.x;
    }
    else{
        xt = -1.0f;
    }
    
    float yt;
    if(rayStart.y<min.y){
        yt = min.y - rayStart.y;
        if(yt>rayDir.y){ return kNoIntersection; }
        yt /= rayDir.y;
    }
    else if(rayStart.y>max.y){
        yt = max.y - rayStart.y;
        if(yt<rayDir.y){ return kNoIntersection; }
        yt /= rayDir.y;
    }
    else{
        yt = -1.0f;
    }
    
    float zt;
    if(rayStart.z<min.z){
        zt = min.z - rayStart.z;
        if(zt>rayDir.z){ return kNoIntersection; }
        zt /= rayDir.z;
    }
    else if(rayStart.z>max.z){
        zt = max.z - rayStart.z;
        if(zt<rayDir.z){ return kNoIntersection; }
        zt /= rayDir.z;
    }
    else{
        zt = -1.0f;
    }
    
    int which = 0;
    float t = xt;
    if(yt>t){
        which = 1;
        t=yt;
    }
    if(zt>t){
        which = 2;
        t=zt;
    }
    switch(which){
        case 0:
        {
            float y=rayStart.y+rayDir.y*t;
            if(y<min.y||y>max.y){return kNoIntersection;}
            float z=rayStart.z+rayDir.z*t;
            if(z<min.z||z>max.z){return kNoIntersection;}
        }
            break;
        case 1:
        {
            float x=rayStart.x+rayDir.x*t;
            if(x<min.x||x>max.x){return kNoIntersection;}
            float z=rayStart.z+rayDir.z*t;
            if(z<min.z||z>max.z){return kNoIntersection;}
        }
            break;
        case 2:
        {
            float x=rayStart.x+rayDir.x*t;
            if(x<min.x||x>max.x){return kNoIntersection;}
            float y=rayStart.y+rayDir.y*t;
            if(y<min.y||y>max.y){return kNoIntersection;}
        }
            break;
    }
    
    return t;
}

- (GLKVector3)fromWorldPostionToObjectPosition:(GLKMatrix4)modelMatrix Vec3:(GLKVector3)vec
{
    bool inv;
    GLKMatrix4 invM = GLKMatrix4Invert(modelMatrix, &inv);
    GLKVector4 treP = GLKVector4Make(vec.x, vec.y, vec.z, 1.0);
    GLKVector4 preP = GLKMatrix4MultiplyVector4(invM, treP);
    
    return GLKVector3Make(preP.x, preP.y, preP.z);
}

- (void)computeOBB_X:(float)x Y:(float)y Z:(float)z
{
    if(x < min.x){min.x = x;};
    if(x > max.x){max.x = x;};
    if(y < min.y){min.y = y;};
    if(y > max.y){max.y = y;};
    if(z < min.z){min.z = z;};
    if(z > max.z){max.z = z;};
}

- (void)createOBBBox:(GLKMatrix4)modelMatrix
{
    for(int i = 0; i < self.vectorArr.count; i++){
        point *pos = self.vectorArr[i];
        
        [self computeOBB_X:pos.vertexPoint.x Y:pos.vertexPoint.y Z:pos.vertexPoint.z];
        
        point *worldPos = [[point alloc] init];
        worldPos.vertexPoint = GLKVector3Make(modelMatrix.m30 + pos.vertexPoint.x * modelMatrix.m00, modelMatrix.m31 + pos.vertexPoint.y * modelMatrix.m11, modelMatrix.m32 + pos.vertexPoint.z * modelMatrix.m22);
        [self.curPosArr insertObject:worldPos atIndex:i];
    }
    
    point *LBPos = self.curPosArr[0];
    m_pos = LBPos.vertexPoint;
}

@end
