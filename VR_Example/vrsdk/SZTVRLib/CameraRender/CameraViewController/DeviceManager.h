//
//  DeviceManager.h
//  SZTVR_SDK
//
//  Created by szt on 2017/5/15.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceManager : NSObject

+ (AVCaptureDevice *)backCamera;

+ (AVCaptureDevice *)frontCamera;

@end
