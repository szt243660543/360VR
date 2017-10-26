//
//  DeviceManager.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/15.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceManager

+ (AVCaptureDevice *)videoCaputreDevice:(AVCaptureDevicePosition)position
{
    NSArray *cameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in cameraDevices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

+ (AVCaptureDevice *)backCamera
{
    return [DeviceManager videoCaputreDevice:AVCaptureDevicePositionBack];
}

+ (AVCaptureDevice *)frontCamera
{
    return [DeviceManager videoCaputreDevice:AVCaptureDevicePositionFront];
}

@end
