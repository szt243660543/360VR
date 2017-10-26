//
//  ClassNameTool.h
//  SZTVR_SDK
//
//  Created by SZT on 16/11/3.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface ClassNameTool : NSObject

SingletonH(ClassNameTool)

@property(nonatomic, strong)NSString *className;

@end
