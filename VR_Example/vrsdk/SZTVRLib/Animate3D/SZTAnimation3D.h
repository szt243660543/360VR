//
//  SZTAnimation3D.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/9.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTBaseObject.h"

typedef void(^didFinishBlock)();

@interface SZTAnimation3D : NSObject
{
    didFinishBlock didFinished;
}

- (void)moveTo:(SZTBaseObject *)object Time:(float)time PosX:(float)x posY:(float)y posZ:(float)z finishBlock:(didFinishBlock)block;

- (void)moveBy:(SZTBaseObject *)object Time:(float)time PosX:(float)x posY:(float)y posZ:(float)z finishBlock:(didFinishBlock)block;

- (void)scaleTo:(SZTBaseObject *)object Time:(float)time scaleX:(float)x scaleY:(float)y scaleZ:(float)z finishBlock:(didFinishBlock)block;

- (void)scaleBy:(SZTBaseObject *)object Time:(float)time scaleX:(float)x scaleY:(float)y scaleZ:(float)z finishBlock:(didFinishBlock)block;

- (void)rotateTo:(SZTBaseObject *)object Time:(float)time radiansX:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ finishBlock:(didFinishBlock)block;

// 贝塞尔曲线轨迹点
// 三次
- (void)bezierTo:(SZTBaseObject *)object Time:(float)time PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 ControlPoint2:(Point3D)point2 finishBlock:(didFinishBlock)block;
// 二次
- (void)bezierTo:(SZTBaseObject *)object Time:(float)time PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 finishBlock:(didFinishBlock)block;
@end
