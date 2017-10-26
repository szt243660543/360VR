//
//  LocalCamera.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/2.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "LocalCamera.h"
#import "CameraTexture.h"
#import "SZTPlane3D.h"
#import "SZTSphere3D.h"
#import "GLUtils.h"
#import "Camera.h"
#import "Shader_YUV420.h"

// BT.601, which is the standard for SDTV.
const GLfloat kColorConversion601[] = {
    1.164,  1.164,  1.164,
    0.0,    -0.392, 2.017,
    1.596,  -0.813,   0.0,
};

// BT.601 full range
const GLfloat kColorConversion601FullRange[] = {
    1.0,    1.0,    1.0,
    0.0,    -0.343, 1.765,
    1.4,    -0.711, 0.0,
};

@interface LocalCamera()
{
    BOOL _isRGBA;
}

@property(nonatomic, strong)CameraTexture *texture;
@property(nonatomic, strong)SZTProgram *program;
@property(nonatomic, strong)SZTObject3D *object;

@property(nonatomic, weak)EAGLContext *context;

@end

@implementation LocalCamera

- (instancetype)initWithContext:(EAGLContext *)context
{
    self = [super init];
    
    if (self) {
        _context = context;
        _isRGBA  = true;
        
        [self setupProgram];
        
        [self setupTexture];
    }
    
    return self;
}

- (void)setupProgram
{
    _program = [[SZTProgram alloc] init];
    
    if (_isRGBA) {
        NSString * vPath = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
        NSString * fPath = [[NSBundle mainBundle] pathForResource:@"Shader.fsh" ofType:nil];
        [_program loadShaders:vPath FragShader:fPath isFilePath:YES];
    }else{
        [_program loadShaders:YUV420VertexShaderString FragShader:YUV420FragmentShaderString isFilePath:NO];
    }
}

- (void)setupObjectWithWidth:(float)width Height:(float)height
{
    size *_objSize = [[size alloc] init];
    _objSize.width = width * 7.5;
    _objSize.height = height * 7.5;
    
    SZTPlane3D *obj = [[SZTPlane3D alloc] init];
    [obj setupVBO_Render:_objSize isStereo:NO isLeft:NO isFilp:false isUpDown:NO isLeftRight:NO];
    _object = obj;
}

- (void)setupTexture
{
    _texture = [[CameraTexture alloc] init];
    [_texture textureCacheCreate:_context];
}

- (void)render:(CVPixelBufferRef)pixelBuffer
{
    [_program useProgram];
    
    [_texture renderTextureBuffer:pixelBuffer];
    
    if (_isRGBA) {
        glUniform1i(_program.uSamplerLocal, 0);
    }else{
        glUniform1i([_program uniformIndex:@"SamplerY"], 0);
        glUniform1i([_program uniformIndex:@"SamplerUV"], 1);
        glUniformMatrix3fv([_program uniformIndex:@"colorConversionMatrix"], 1, GL_FALSE, kColorConversion601FullRange);
    }
    
    glUniformMatrix4fv(_program.MVPMatrixHandle, 1, GL_FALSE, [Camera sharedCamera].cameraModelMatrix.m);

    [_object drawElements:_program];
}

- (void)removeObject
{
    if (_program) {
        [_program destory];
        _program = nil;
    }
    
    if (_texture) {
        _texture = nil;
    }
    
    if (_object) {
        [_object destroy];
        _object = nil;
    }
}

- (void)dealloc
{
    [self removeObject];
}

@end
