//
//  vrkongfu.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/19.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "properties.h"

@interface vrkongfu : NSObject

@property(nonatomic, strong)properties *properties;

@property(nonatomic, strong)NSMutableArray *sceneList;

@property(nonatomic, strong)NSMutableArray *widgetList;

@property(nonatomic, strong)NSMutableArray *actionList;

@property(nonatomic, strong)NSMutableArray *materialList;

@end
