//
//  SZTFbo.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/27.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SZTFbo : NSObject

@property(nonatomic, assign)GLuint fboHandle;
@property(nonatomic, assign)GLuint depthBuffer;
@property(nonatomic, assign)GLuint colorBuffer;

@property(nonatomic, assign)GLuint fboTexture;

@property(nonatomic, assign)int fbo_width;
@property(nonatomic, assign)int fbo_height;

- (instancetype)initWithWidth:(float)width Height:(float)height;

- (void)renderFBO;

- (void)resetDefaultFBO;

- (void)updateTexture:(GLuint)uSamplerLocal;

@end
