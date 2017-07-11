//
//  action.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/19.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface action : NSObject

@property(nonatomic, copy)NSString *actionID;

@property(nonatomic, copy)NSString *type;

@property(nonatomic, assign)float delay;

@property(nonatomic, assign)float keepTime;

@property(nonatomic, copy)NSString *objectID;

@property(nonatomic, copy)NSString *key;

@property(nonatomic, assign)float value;

@property(nonatomic, copy)NSString *animationType;
    
@property(nonatomic, strong)NSMutableArray *objects;

@end
