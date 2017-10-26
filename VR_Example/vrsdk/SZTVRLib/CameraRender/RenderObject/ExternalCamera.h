//
//  ExternalCamera.h
//  SZTVR_SDK
//
//  Created by szt on 2017/5/2.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YUVData.h"

@interface ExternalCamera : NSObject

- (void)render:(YUVData *)yuvData;

@end
