//
//  SZTBaseObject.h
//  SZTVR_SDK
//  对象基类型
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MathC.h"
#import "SZTTouch.h"

@interface SZTBaseObject : NSObject

/**
 * 设置坐标 -- 绝对系数
 */
- (void)setPosition:(float)x Y:(float)y Z:(float)z;
// 相对系数
- (void)setPositionForRelative:(float)x Y:(float)y Z:(float)z;

/**
 * 缩放系数
 */
- (void)setScale:(float)x Y:(float)y Z:(float)z;
- (void)setScaleForRelative:(float)x Y:(float)y Z:(float)z;

/**
 * 旋转
 * @param radiansX/radiansY/radiansZ 旋转角度
 */
- (void)setRotate:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ;
- (void)setRotateForRelative:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ;

/**
 * 设置绘制区域大小.
 */
- (void)setObjectSize:(float)width Height:(float)height;

/**
 * 对象索引 Tag
 */
@property (nonatomic , assign)int tag;

/**
 * 裁剪标志位
 * 裁剪区域 {minY,maxY} 可视区域
 * 裁剪区域 {minX,maxX} 可视区域
 */
@property (nonatomic , assign)float cutMaxY;
@property (nonatomic , assign)float cutMinY;
@property (nonatomic , assign)float cutMaxX;
@property (nonatomic , assign)float cutMinX;

/** 设置是否可以点击 默认为可拾取状态 - YES */
@property (nonatomic , assign)BOOL setTouchEnable;

/** onject size w/h*/
@property(nonatomic, strong)size *objSize;

/**
 * 创建对象
 */
- (void)build;

/**
 * 销毁对象
 */
- (void)removeObject;

/**
 * 重置对象
 */
- (void)resetObject;

/**
 * 渲染到FBO
 * @param index 记录id，根据id判断左右图
 */
- (void)renderToFbo:(int)index;

// 对象的模型矩阵
@property(nonatomic, assign)GLKMatrix4 mModelMatrix;

#pragma mark - 属性
@property(nonatomic, assign)float pX;
@property(nonatomic, assign)float pY;
@property(nonatomic, assign)float pZ;

@property(nonatomic, assign)float sX;
@property(nonatomic, assign)float sY;
@property(nonatomic, assign)float sZ;

@property(nonatomic, assign)float m_sX;
@property(nonatomic, assign)float m_sY;
@property(nonatomic, assign)float m_sZ;

@property(nonatomic, assign)float radiansX;
@property(nonatomic, assign)float radiansY;
@property(nonatomic, assign)float radiansZ;

@property(nonatomic, assign)BOOL hidden;

#pragma mark - Animation
- (void)moveTo:(float)time PosX:(float)x posY:(float)y posZ:(float)z finishBlock:(void(^)(void))block;

- (void)moveBy:(float)time PosX:(float)x posY:(float)y posZ:(float)z finishBlock:(void(^)(void))block;

- (void)scaleTo:(float)time scaleX:(float)x scaleY:(float)y scaleZ:(float)z finishBlock:(void(^)(void))block;

- (void)scaleBy:(float)time scaleX:(float)x scaleY:(float)y scaleZ:(float)z finishBlock:(void(^)(void))block;

- (void)rotateTo:(float)time radiansX:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ finishBlock:(void(^)(void))block;

/**
 * 三次方贝塞尔曲线动画
 * @param pointEnd 终点
 * @param point1 控制点1
 * @param point2 控制点2
 * @param pointStart 默认起始点为对象当前处的position
 */
- (void)bezierTo:(float)time PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 ControlPoint2:(Point3D)point2 finishBlock:(void(^)(void))block;
/**
 * 二次方贝塞尔曲线动画
 * @param pointEnd 终点
 * @param point1 控制点1
 * @param pointStart 默认起始点为对象当前处的position
 */
- (void)bezierTo:(float)time PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 finishBlock:(void(^)(void))block;

#pragma mark - 私有
@property(nonatomic, weak)EAGLContext *glContext;

@property(nonatomic, weak)SZTTouch *touch;

/**
 * 设置上下文
 */
- (void)setContext:(EAGLContext *)context;

- (void)addObserver;

@end
