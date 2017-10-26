//
//  SZTLabel.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 16/11/8.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTRenderObject.h"

@interface SZTLabel : SZTRenderObject

@property(nonatomic, strong)NSString *text;

@property(nonatomic, strong)UIColor *fontColor;

/** 每一行字的数量 ，超过数量自动换行*/
@property(nonatomic, assign)int lineNumber;

/** 是否右对齐 */
@property(nonatomic, assign)BOOL isRightAlign;

/** 是否背景不透明 */
@property(nonatomic, assign)BOOL isOpaque;

/** 清晰度 默认为2.0 值越大越清晰，效率越低*/
@property(nonatomic, assign)float definition;

@end
