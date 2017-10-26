//
//  WidgetUI.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/26.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTJson.h"

@interface WidgetUI : NSObject

- (instancetype)initWithWidgetData:(widget *)widgetData;

@property (nonatomic , copy)NSString *groupID;
@property (nonatomic , copy)NSString *widgetID;

- (void)loadActionStart;
- (void)loadActionEnd;

- (void)animationShowLinear;
- (void)animationHideLinear;
- (void)animationPop;
- (void)animationRotate:(float)radians;

- (void)destory;

@end
