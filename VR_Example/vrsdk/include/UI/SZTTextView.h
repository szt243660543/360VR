//
//  SZTTextView.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/17.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTRenderObject.h"

@class SZTTextView;
@protocol SZTTextViewDelegate <NSObject>

- (void)didTouchTextView:(SZTTextView *) textView;

@end

@interface SZTTextView : SZTRenderObject

/*** 使用注意事项:
    1、要先设置尺寸(objsize)才能设置坐标(pos),否则显示光标出错
    2、属性要在添加到library之前设置好
 */

@property(nonatomic, assign)int lineNumber; // 允许写多少个字符(18字符以内)

@property(nonatomic, assign)id <SZTTextViewDelegate> delegate;

@property(nonatomic, assign)BOOL isShineBarHide;

// 输入文字
- (void)inputText:(NSString *)text;

- (void)HiddenShineBar:(BOOL)isHide;

// 删除文字(只能从最后一个文字开始向前删除)
- (void)removeLastText;

// 删除所有文字
- (void)removeAllText;

@end
