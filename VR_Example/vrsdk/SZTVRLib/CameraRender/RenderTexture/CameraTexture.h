//
//  CameraTexture.h
//  SZTVR_SDK
//
//  Created by szt on 2017/4/28.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraTexture : NSObject

- (void)textureCacheCreate:(EAGLContext *)context;

- (void)renderTextureBuffer:(CVPixelBufferRef)pixelBuffer;

- (void)cleanUpTextures;

@end
