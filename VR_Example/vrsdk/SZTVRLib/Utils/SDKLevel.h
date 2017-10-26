//
//  SDKLevel.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2017/2/8.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface SDKLevel : NSObject<NSURLConnectionDataDelegate>
SingletonH(SDKLevel)

- (void)checkLevel;

@end
