//
//  SZTAlertView.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2017/1/11.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTRenderObject.h"

@interface SZTAlertView : SZTRenderObject

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSArray *)titlesStr;

@end
