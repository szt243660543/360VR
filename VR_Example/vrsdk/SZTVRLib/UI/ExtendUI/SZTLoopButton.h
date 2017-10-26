//
//  SZTLoopButton.h
//  SZTVR_SDK
//  环形按钮
//  Created by SZTVR on 16/8/1.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTImageView.h"
#import "SZTGif.h"

@protocol LoopButtonTouchDelegate <NSObject>
/**
 * 选中按钮
 */
- (void)didSelectButtonAtIndex:(int)index;

/**
 * 将要拾取 － 刚进入选取区域
 */
- (void)willSelectButtonAtIndex:(int)index;

@end

@interface SZTLoopButton : NSObject

@property(nonatomic, weak) id <LoopButtonTouchDelegate> delegate;

/**
 * 控件半径
 */
@property(nonatomic, assign)float radius;

/**
 * 控件上按钮数量
 */
@property(nonatomic, assign)int buttonCount;

/**
 * 创建环形控件 - 不同的图片
 * @bitmapArray 传入UIImage图片数组
 */
- (void)buildButtonsWithArray:(NSMutableArray *)array;

/**
 * 创建环形控件 - 相同的图片
 * @bitmapArray 传入UIImage图片
 */
- (void)buildButtonsWithImage:(UIImage *)image;


/**
 * 创建环形控件 - 相同的gif图片
 * @gifName 传入gif名字
 */
- (void)buildButtonsWithGifName:(NSString *)gifName;

/**
 * 环形控件 围绕哪个轴布局
 * @axis 枚举
 */
- (void)setRotationAroundAxis:(AXIS)axis;

@end
