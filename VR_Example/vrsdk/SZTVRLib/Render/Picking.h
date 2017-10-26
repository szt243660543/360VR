//
//  FocusPicking.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/10/9.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface Picking : NSObject

SingletonH(Picking)

/**
 * 焦点拾取状态
 */
@property(nonatomic, assign)BOOL focusPickingState;

/**
 * 点击拾取状态
 */
@property(nonatomic, assign)BOOL touchEventState;

/**
 * 开启单双目状态
 */
@property(nonatomic, assign)BOOL isRenderMonocular;

/**
 * 拾取方式 (Yes为OBB，否则为AABB)
 */
@property(nonatomic, assign)BOOL isObbPicking;

@end
