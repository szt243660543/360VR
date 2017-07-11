//
//  vrkongfu.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/19.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "vrkongfu.h"

@implementation vrkongfu

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"sceneList" : @"scene",
             @"widgetList" : @"widget",
             @"actionList" : @"action",
             @"materialList" : @"material"
             };
}

@end
