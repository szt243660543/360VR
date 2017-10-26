//
//  SZTKeyBoardBar.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/17.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KeyboardType) {
    LowerCase,      // 小写字母
    UpperCase,      // 大写字母
    NumberType,     // 数字键盘
};

@protocol KeyBoardDelegate <NSObject>

- (void)didTouchKeyString:(NSString *)string;

@end

@interface SZTKeyBoardBar : SZTRenderObject

@property(nonatomic, weak)id <KeyBoardDelegate> delegate;

- (void)setKeyCapsLook:(KeyboardType)type;

@property(nonatomic, assign)KeyboardType currentType;

@end
