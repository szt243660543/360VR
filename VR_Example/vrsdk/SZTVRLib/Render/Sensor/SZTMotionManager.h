//
//  SZTMotionManager.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 16/11/25.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTMotionManager : NSObject

@property(nonatomic, assign)BOOL isUseingGvrGyro;

@property(nonatomic, assign)UIInterfaceOrientation orientation;

- (void)startMotion;

- (void)stopDeviceMotion;

- (GLKMatrix4)lastHeadView;

@end
