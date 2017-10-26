//
//  LocalCamera.h
//  SZTVR_SDK
//
//  Created by szt on 2017/5/2.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalCamera : NSObject

- (instancetype)initWithContext:(EAGLContext *)context;

- (void)setupObjectWithWidth:(float)width Height:(float)height;

- (void)render:(CVPixelBufferRef)pixelBuffer;

- (void)removeObject;

@end
