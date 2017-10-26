//
//  ExternalCamera.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/2.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "ExternalCamera.h"
#import "SZTFishDome3D.h"
#import "YUVTexture.h"
#import "Shader_YUV.h"

// BT.709, which is the standard for HDTV.
static const GLfloat kColorConversion709[] = {
    1.164,  1.164,  1.164,
    0.0,    -0.213, 2.112,
    1.793,  -0.533,   0.0,
};

@interface ExternalCamera()

@property(nonatomic, strong)YUVTexture *texture;
@property(nonatomic, strong)SZTProgram *program;
@property(nonatomic, strong)SZTObject3D *object;

@end

@implementation ExternalCamera

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupProgram];
        
        [self setupObject];
        
        [self setupTexture];
    }
    
    return self;
}

- (void)setupProgram
{
    _program = [[SZTProgram alloc] init];
    [_program loadShaders:YUVVertexShaderString FragShader:YUVFragmentShaderString isFilePath:NO];
}

- (void)setupObject
{
    size *_objSize = [[size alloc] init];
    _objSize.width = _objSize.height = 100.0;
    
    SZTFishDome3D *fishDome = [[SZTFishDome3D alloc] init];
    [fishDome setupVBO_Render:150.0];
    _object = fishDome;
}

- (void)setupTexture
{
    _texture = [[YUVTexture alloc] init];
}

- (void)render:(YUVData *)yuvData
{
    [_program useProgram];
    
    [_texture renderTextureBuffer:yuvData];
    
    glUniform1i([_program uniformIndex:@"SamplerY"], 0);
    glUniform1i([_program uniformIndex:@"SamplerU"], 1);
    glUniform1i([_program uniformIndex:@"SamplerV"], 2);
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), 16/9, 0.1f, 1000.0f);
    glUniformMatrix4fv(_program.MVPMatrixHandle, 1, GL_FALSE, projectionMatrix.m);
    glUniformMatrix3fv([_program uniformIndex:@"colorConversionMatrix"], 1, GL_FALSE, kColorConversion709);
    
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
