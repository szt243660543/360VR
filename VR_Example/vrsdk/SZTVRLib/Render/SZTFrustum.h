//
//  SZTFrustum.h
//  SZTVR_SDK
//
//  Created by szt on 16/11/20.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTFrustum : NSObject
{
    float g_frustumPlanes[6][4];
}

// 计算视角的平截体
- (void)calculateFrustumPlanes:(GLKMatrix4)mvMatrix;

/** 点是否在视角内部 */
- (BOOL)isPointInFrustum:(float)x Y:(float)y Z:(float)z;

/** 顶点集是否在视角内部 */
- (BOOL)isPointsInFrustum:(NSArray *)points;

@end
