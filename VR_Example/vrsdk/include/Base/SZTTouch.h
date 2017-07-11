//
//  SZTTouch.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 16/11/25.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SZTRenderObject;

typedef void(^willTouch)(GLKVector3);
typedef void(^didTouch)(GLKVector3);
typedef void(^endTouch)(GLKVector3);

@interface SZTTouch : NSObject
{
    willTouch willSelectblock;
    didTouch didSelectblock;
    endTouch willLeaveblock;
}

/** 实例化，传入要点击的对象*/
- (instancetype)initWithTouchObject:(SZTRenderObject *)obj;

/** 选中时间*/
- (void)setSelectTime:(float)time;

/** 不需要点击后，必须销毁，否则会内存泄漏*/
- (void)destory;

#pragma mark - block
/**
 * 将要拾取对象 － 刚进入选取区域
 */
- (void)willTouchCallBack:(willTouch)block;

/**
 * 进度条读完后选中对象
 */
- (void)didTouchCallback:(didTouch)block;

/**
 * 将要离开对象
 */
- (void)endTouchCallback:(endTouch)block;

@end
