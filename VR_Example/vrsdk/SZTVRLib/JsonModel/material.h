//
//  material.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/19.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface material : NSObject

@property(nonatomic, copy)NSString *materialID;

@property(nonatomic, copy)NSString *type;

@property(nonatomic, copy)NSString *url;

@property(nonatomic, assign)BOOL online;
@end
