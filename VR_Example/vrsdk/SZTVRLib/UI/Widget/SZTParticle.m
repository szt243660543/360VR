//
//  SZTParticle.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/9.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTParticle.h"
#import "SZTParticle3D.h"
#import "SZTBitmapTexture.h"
#import "Shader_Emitter.h"

@interface SZTParticle()
{
    NSTimeInterval _startTime;
    
    SZTTexture * _texture;
}

@end

@implementation SZTParticle

- (instancetype)initWithParticleCount:(int)particleCount
{
    self = [super init];
    
    if (self) {
        self.isScreen = false;
        self.renderModel = SZTVR_3D_MODEL;
        _particleCount = particleCount;
    }
    
    return self;
}

- (void)setupTextureWithImage:(UIImage *)imageName
{
    [self setupTexture:imageName];
}

- (void)setupTexture:(UIImage *)image
{
    SZTBitmapTexture *texture = [[SZTBitmapTexture alloc] init];
    _texture = [texture createTextureWithImage:image TextureFilter:self.textureFilter];
}

- (void)changeDisplayMode:(SZTRenderModel)renderModel
{
    [self destoryObject3D];
    
    SZTParticle3D *objL = [[SZTParticle3D alloc] init];
    [objL setupVBO_Render:_particleCount];
    [self restart];
    self.obj_Left = self.obj_Right = objL;
}

-(void)restart {
    _startTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void)destoryObject3D
{
    if (self.obj_Left) [self.obj_Left destroy];
    if (self.obj_Right) [self.obj_Right destroy];
    self.obj_Right = self.obj_Left = nil;
}

- (void)changeFilter:(SZTFilterMode)filterMode
{
    self.filterMode = filterMode;
    [self resetProgram];
    
    self.program = [[SZTProgram alloc] init];
    [self.program loadShaders:EmitterVertexShaderString FragShader:EmitterFragmentShaderString isFilePath:NO];
}

- (void)resetProgram
{
    if (self.program) [self.program destory];
    self.program = nil;
}

- (void)renderToFbo:(int)index
{
    [super renderToFbo:index];
    
    [_texture updateTexture:self.program.uSamplerLocal];
    
    [self setupFilterMode];
    
    [self drawElements:index];
}

- (void)setupFilterMode
{
    glUniform1f([self.program uniformIndex:@"uK"], 4.0f);
    glUniform3f([self.program uniformIndex:@"uColor"], 1.0, 1.0, 1.0);
    glUniform1f([self.program uniformIndex:@"uTime"], [NSDate timeIntervalSinceReferenceDate] - _startTime);
}

- (void)destory
{
    [super destory];
    
    [self removeObject];
    
    if (_texture) [_texture destory];
}

- (void)dealloc
{
    [self destory];
    
    SZTLog(@"SZTParticle dealloc");
}

@end
