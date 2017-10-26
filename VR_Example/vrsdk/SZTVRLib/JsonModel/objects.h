//
//  objects.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/16.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface objects : NSObject

@property(nonatomic, assign)float min;

@property(nonatomic, assign)float max;

@property(nonatomic, copy)NSString *objectID;

@property(nonatomic, assign)BOOL clearKeyValue;

@end
