//
//  sceneList.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/19.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface scene : NSObject

@property(nonatomic, copy)NSString *sceneID;

@property(nonatomic, copy)NSString *title;

@property(nonatomic, copy)NSString *materialID;

@property(nonatomic, copy)NSString *nextScene;

@property(nonatomic, strong)NSMutableArray *widgets;

@end
