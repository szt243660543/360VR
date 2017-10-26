//
//  MathC.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/3.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "MathC.h"

@implementation MathC

void swapt(float* width, float *height){
    float temp = *width;
    if((*width)>(*height)){
        return;
    }else{
        (*width) = (*height);
        (*height) = temp;
    }
}

+ (objectSize)getFocusPointSizeByScreenCount:(int)_screenNumber
{
    objectSize size;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (_screenNumber == 2) {
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            size.width = 0.05 * 9.0;
            size.height = 0.05 * 8.0;
        }else{
            size.width = 0.05 * 8.0;
            size.height = 0.05 * 9.0;
        }
    }else{
        if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            size.width = 0.05 * 9.0;
            size.height = 0.05 * 16.0;
        }else{
            size.width = 0.05 * 16.0;
            size.height = 0.05 * 9.0;
        }
    }
    
    return size;
}

// 规格化
+ (GLKVector3)vector3Normalization:(GLKVector3)vec3
{
    float sqr = sqrt(vec3.x*vec3.x + vec3.y*vec3.y + vec3.z*vec3.z);
    float tempx = vec3.x/sqr;
    float tempy = vec3.y/sqr;
    float tempz = vec3.z/sqr;
    
    return GLKVector3Make(tempx, tempy, tempz);
}

+ (Point3D )pointOnCubicBezier:(Point3D)pointStart PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 ControlPoint2:(Point3D)point2 T:(float)t
{
    float ax, bx, cx;
    float ay, by, cy;
    float az, bz, cz;
    float tSquared, tCubed;
    Point3D result;
    
    /* 计算多项式系数 */
    cx = 3.0 * (point1.x - pointStart.x);
    bx = 3.0 * (point2.x - point1.x) - cx;
    ax = pointEnd.x - pointStart.x - cx - bx;
    
    cy = 3.0 * (point1.y - pointStart.y);
    by = 3.0 * (point2.y - point1.y) - cy;
    ay = pointEnd.y - pointStart.y - cy - by;
    
    cz = 3.0 * (point1.z - pointStart.z);
    bz = 3.0 * (point2.z - point1.z) - cz;
    az = pointEnd.z - pointStart.z - cz - bz;
    
    /* 计算t位置的点值 */
    tSquared = t * t;
    tCubed = tSquared * t;
    
    result.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + pointStart.x;
    result.y = (ay * tCubed) + (by * tSquared) + (cy * t) + pointStart.y;
    result.z = (az * tCubed) + (bz * tSquared) + (cz * t) + pointStart.z;
    
    return result;
}

+ (Point3D )pointOnCubicBezier:(Point3D)pointStart PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 T:(float)t
{
    float ax, bx;
    float ay, by;
    float az, bz;
    
    Point3D result;
    
    ax = pointStart.x + ( point1.x - pointStart.x ) * t;
    ay = pointStart.y + ( point1.y - pointStart.y ) * t;
    az = pointStart.z + ( point1.z - pointStart.z ) * t;
    
    bx = point1.x + ( pointEnd.x - point1.x ) * t;
    by = point1.y + ( pointEnd.y - point1.y ) * t;
    bz = point1.z + ( pointEnd.z - point1.z ) * t;

    result.x = ax + ( bx - ax ) * t;
    result.y = ay + ( by - ay ) * t;
    result.z = az + ( bz - az ) * t;
    
    return result;
}

+ (Point3D)CalPlaneLineIntersectPoint:(GLKVector3)planeVector PlanePoint:(Point3D)planePoint LineVector:(GLKVector3)lineVector LinePoint:(Point3D)linePoint
{
    Point3D returnResult;
    float vp1, vp2, vp3, n1, n2, n3, v1, v2, v3, m1, m2, m3, t,vpt;
    vp1 = planeVector.x;
    vp2 = planeVector.y;
    vp3 = planeVector.z;
    
    n1 = planePoint.x;
    n2 = planePoint.y;
    n3 = planePoint.z;
    
    v1 = lineVector.x;
    v2 = lineVector.y;
    v3 = lineVector.z;
    
    m1 = linePoint.x;
    m2 = linePoint.y;
    m3 = linePoint.z;
    
    vpt = v1 * vp1 + v2 * vp2 + v3 * vp3;
    
    // 首先判断直线是否与平面平行
    if (vpt == 0)
    {
        returnResult.x = returnResult.y = returnResult.z = 0.0;
    }
    else
    {
        t = ((n1 - m1) * vp1 + (n2 - m2) * vp2 + (n3 - m3) * vp3) / vpt;
        
        returnResult.x = m1 + v1 * t;
        returnResult.y = m2 + v2 * t;
        returnResult.z = m3 + v3 * t;
    }
    
    return returnResult;
}

+ (float)getYAngle:(GLKVector3)targetPoint pivotPoint:(GLKVector3)pivotPoint
{
    float yAngle = 0;
    
    // xz
    float xspan = pivotPoint.x - targetPoint.x;
    // zx
    float zspan = pivotPoint.z - targetPoint.z;
    
    if(zspan <= 0)
    {
        yAngle = 180+(float) GLKMathRadiansToDegrees(atan(xspan/zspan));
    }
    else
    {
        yAngle = (float) GLKMathRadiansToDegrees(atan(xspan/zspan));
    }
    
    return yAngle;
}

+ (float)getXAngle:(GLKVector3)targetPoint pivotPoint:(GLKVector3)pivotPoint
{
    float xAngle = 0;
    
    // yz
    float yspan = pivotPoint.y - targetPoint.y;
    // zy
    float zspan = pivotPoint.z - targetPoint.z;
    
    if(zspan <= 0)
    {
        xAngle = 180+(float) GLKMathRadiansToDegrees(atan(yspan/zspan));
    }
    else
    {
        xAngle = (float) GLKMathRadiansToDegrees(atan(yspan/zspan));
    }
    
    return -xAngle;
}

// 根据经纬度和深度值算出球面上的坐标点
+ (GLKVector3)CalculateSphereSurfacePointWithLat:(float)lat Lon:(float)lon Depth:(float)depth
{
    GLKVector3 X_Z;
    // 经
    X_Z.x = depth * sin(GLKMathDegreesToRadians(lon));
    X_Z.y = 0;
    X_Z.z = depth * - cos(GLKMathDegreesToRadians(lon));
    
    GLKVector3 Y_Z;
    // 纬
    Y_Z.x = 0;
    Y_Z.y = depth * sin(GLKMathDegreesToRadians(lat));
    Y_Z.z = depth * - cos(GLKMathDegreesToRadians(lat));
    
    if (lat == 0.0) {
        Y_Z = GLKVector3Make(0.0, 0.0, 0.0);
    }
    
    if (lon == 0.0) {
        X_Z = GLKVector3Make(0.0, 0.0, 0.0);
    }

    GLKVector3 dir = [MathC vector3Normalization:GLKVector3Add(X_Z, Y_Z)];
    if (lat == 0.0 && lon == 0.0) {
        dir = GLKVector3Make(0.0, 0.0, -1.0);
    }
    GLKVector3 point = GLKVector3MultiplyScalar(dir, depth);
    
    return point;
}

@end


@implementation point

@end


@implementation size

@end
