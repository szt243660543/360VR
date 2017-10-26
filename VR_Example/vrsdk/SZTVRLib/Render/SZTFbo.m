//
//  SZTFbo.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/27.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTFbo.h"
#import <OpenGLES/ES2/glext.h>

@interface SZTFbo ()
{
    BOOL _isOpenMultisample;  // 开启抗锯齿
}

@property(nonatomic, assign)GLint defaultFBO;

@end

@implementation SZTFbo

- (instancetype)initWithWidth:(float)width Height:(float)height
{
    self = [super init];
    
    if (self) {
        _isOpenMultisample = NO;
        
        self.fbo_height = height;
        self.fbo_width = width;

        [self createFboData];
    }
    
    return self;
}

- (void)createFboData
{
    [self bindingTextures:self.fbo_width Height:self.fbo_height];
    
    if (!_isOpenMultisample) {
        [self setupFBOs:self.fbo_width Height:self.fbo_height];
    }else{
        [self setupMultisample:self.fbo_width Height:self.fbo_height];
    }
}

- (void)bindingTextures:(int)width Height:(int)height
{
    // frame buffer object
    glGenFramebuffers(1, &_fboHandle);
    glBindFramebuffer(GL_FRAMEBUFFER, _fboHandle);
    
    // Build the texture that will serve as the color attachment for the framebuffer.
    glGenTextures(1, &_fboTexture);
    glBindTexture(GL_TEXTURE_2D, _fboTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _fboTexture, 0);
}

- (void)setupFBOs:(int)width Height:(int)height
{
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_defaultFBO);
    
    glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    // depth buffer with render buffer object
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _fbo_width, _fbo_height);
    // Attach depth buffer to FBO
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
    
    // FBO status check
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFBO);
}

- (void)setupMultisample:(int)width Height:(int)height
{
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_defaultFBO);

    // Multisample
    glGenFramebuffers(2, &_fboHandle);
    glBindFramebuffer(GL_FRAMEBUFFER, _fboHandle);
    
    glGenRenderbuffers(1, &_colorBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorBuffer);
    glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_RGBA8_OES, width, height);
    
    glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, 4, GL_DEPTH_COMPONENT16, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFBO);
}

- (void)renderFBO
{
    glBindFramebuffer(GL_FRAMEBUFFER, _fboHandle);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//    glClear(GL_DEPTH_BUFFER_BIT);
    
    glViewport(0, 0, self.fbo_width, self.fbo_height);
}

- (void)updateTexture:(GLuint)uSamplerLocal
{
    glActiveTexture(GL_TEXTURE0);
    
    glBindTexture(GL_TEXTURE_2D, _fboTexture);
    
    glUniform1i(uSamplerLocal, 0);
}

- (void)resetDefaultFBO
{
    if (!_isOpenMultisample) {
        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFBO);
    }else{
        glBindFramebuffer(GL_FRAMEBUFFER, _defaultFBO);
        glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, _fboHandle);
        glResolveMultisampleFramebufferAPPLE();
    }
    
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (void)dealloc
{
    
}

@end
