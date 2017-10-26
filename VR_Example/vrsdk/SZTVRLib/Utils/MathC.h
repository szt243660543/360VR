//
//  MathC.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/3.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
    float x;
    float y;
    float z;
} Point3D;

typedef NS_ENUM(NSInteger, AXIS) {
    X,    // X轴
    Y,    // Y轴
    Z     // Z轴
};

typedef struct {
    GLfloat	x;
    GLfloat y;
    GLfloat z;
} Vertex3D, Vector3D, Rotation3D;

typedef struct {
    GLushort	v1;
    GLushort	v2;
    GLushort	v3;
} Face3D;

typedef struct {
    float width;
    float height;
} objectSize;

typedef Vertex3D Vector3D;

static inline GLfloat Vector3DMagnitude(Vector3D vector)
{
    return sqrt((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z));
}

static inline void Vector3DNormalize(Vector3D *vector)
{
    GLfloat vecMag = Vector3DMagnitude(*vector);
    if ( vecMag == 0.0 )
    {
        vector->x /= 1.0;
        vector->y /= 0.0;
        vector->z /= 0.0;
    }
    vector->x /= vecMag;
    vector->y /= vecMag;
    vector->z /= vecMag;
}

static inline Vector3D Vector3DMakeWithStartAndEndPoints(Vertex3D start, Vertex3D end)
{
    Vector3D ret;
    ret.x = end.x - start.x;
    ret.y = end.y - start.y;
    ret.z = end.z - start.z;
    Vector3DNormalize(&ret);
    return ret;
}

static inline Vector3D Vector3DAdd(Vector3D vector1, Vector3D vector2)
{
    Vector3D ret;
    ret.x = vector1.x + vector2.x;
    ret.y = vector1.y + vector2.y;
    ret.z = vector1.z + vector2.z;
    return ret;
}

static inline void Vector3DFlip (Vector3D *vector)
{
    vector->x = -vector->x;
    vector->y = -vector->y;
    vector->z = -vector->z;
}

#pragma mark Triangle3D
typedef struct {
    Vertex3D v1;
    Vertex3D v2;
    Vertex3D v3;
} Triangle3D;

static inline Triangle3D Triangle3DMake(Vertex3D inV1, Vertex3D inV2, Vertex3D inV3)
{
    Triangle3D ret;
    ret.v1 = inV1;
    ret.v2 = inV2;
    ret.v3 = inV3;
    return ret;
}

static inline Vector3D Triangle3DCalculateSurfaceNormal(Triangle3D triangle)
{
    Vector3D u = Vector3DMakeWithStartAndEndPoints(triangle.v2, triangle.v1);
    Vector3D v = Vector3DMakeWithStartAndEndPoints(triangle.v3, triangle.v1);
    
    Vector3D ret;
    ret.x = (u.y * v.z) - (u.z * v.y);
    ret.y = (u.z * v.x) - (u.x * v.z);
    ret.z = (u.x * v.y) - (u.y * v.x);
    return ret;
}

@interface MathC : NSObject

void swapt(float* width, float *height);

/**
 * 三次方贝塞尔曲线算法
 * pointStart為起始點
 * point1為第一個控制點
 * point2為第二個控制點
 * pointEnd為結束點
 * t為參數值，0 <= t <= 1
 *
 */
+ (Point3D )pointOnCubicBezier:(Point3D)pointStart PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 ControlPoint2:(Point3D)point2 T:(float)t;

/**
 * 二次方贝塞尔曲线算法
 * pointStart為起始點
 * point1為控制點
 * pointEnd為結束點
 * t為參數值，0 <= t <= 1
 *
 */
+ (Point3D )pointOnCubicBezier:(Point3D)pointStart PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 T:(float)t;

/**
 * 求一条直线与平面的交点
 * @param planeVector 平面的法线向量
 * @param planePoint 平面经过的一点坐标
 * @param lineVector 直线的方向向量
 * @param linePoint 直线经过的一点坐标
 * @returns 返回交点坐标
 *
 */
+ (Point3D)CalPlaneLineIntersectPoint:(GLKVector3)planeVector PlanePoint:(Point3D)planePoint LineVector:(GLKVector3)lineVector LinePoint:(Point3D)linePoint;

/**
 * targetPoint 绕着 pivotPoint 旋转，获取旋转的偏移角度
 */
+ (float)getYAngle:(GLKVector3)targetPoint pivotPoint:(GLKVector3)pivotPoint;

+ (float)getXAngle:(GLKVector3)targetPoint pivotPoint:(GLKVector3)pivotPoint;

/** 
 * Vector3 规格化 
 */
+ (GLKVector3)vector3Normalization:(GLKVector3)vec3;

+ (objectSize)getFocusPointSizeByScreenCount:(int)_screenNumber;

// 根据经纬度和深度值算出球面上的坐标点
+ (GLKVector3)CalculateSphereSurfacePointWithLat:(float)lat Lon:(float)lon Depth:(float)depth;

@end

@interface point : NSObject

@property(nonatomic, assign)GLKVector3 vertexPoint;

@end

@interface size : NSObject

@property(nonatomic, assign)float width;
@property(nonatomic, assign)float height;

@end


