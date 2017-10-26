//
//  SZTProgram.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTProgram.h"
#import "GLUtils.h"

@implementation SZTProgram

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        attributes = [[NSMutableArray alloc] init];
        uniforms = [[NSMutableArray alloc] init];
        _blackEdgeValue = 0.9;
    }
    
    return self;
}

- (void)loadShaders:(NSString *)vertShader FragShader:(NSString *)fragShader isFilePath:(BOOL)isfile
{
    self.program = [GLUtils compileShaders:vertShader shaderFragment:fragShader isFilePath:isfile];
    
    self.positionSlot = glGetAttribLocation(self.program, "position");
    glEnableVertexAttribArray(self.positionSlot);
    self.texCoordSlot = glGetAttribLocation(self.program, "aTexCoord");
    glEnableVertexAttribArray(self.texCoordSlot);
    
    self.uSamplerLocal = glGetUniformLocation(self.program, "uSampler");
    
    // matrix
    self.MMatrixHandle = glGetUniformLocation(self.program, "modelMatrix");
    self.MVMatrixHandle = glGetUniformLocation(self.program, "modelViewMatrix");
    self.MVPMatrixHandle = glGetUniformLocation(self.program, "modelViewProjectionMatrix");
}

- (void)addAttribute:(NSString *)attributeName
{
    if (![attributes containsObject:attributeName])
    {
        [attributes addObject:attributeName];
        glBindAttribLocation(self.program, (GLuint)[attributes indexOfObject:attributeName], [attributeName UTF8String]);
    }
}

- (GLuint)uniformIndex:(NSString *)uniformName
{
    return glGetUniformLocation(self.program, [uniformName UTF8String]);
}

- (GLuint)attributeIndex:(NSString *)attributeName
{
    return (GLuint)[attributes indexOfObject:attributeName];
}

- (void)useProgram
{
    glUseProgram(self.program);
}

- (void)destory
{
    if (self.program) {
        glDeleteProgram(self.program);
        self.program = 0;
    }
}

-(void)dealloc
{
    [self destory];
}
@end
