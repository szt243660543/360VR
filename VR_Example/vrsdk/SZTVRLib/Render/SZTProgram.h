//
//  SZTProgram.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SZTProgram : NSObject
{
    NSMutableArray  *attributes;
    NSMutableArray  *uniforms;
}

@property(nonatomic, assign)GLuint program;

@property(nonatomic, assign)GLuint positionSlot;
@property(nonatomic, assign)GLuint texCoordSlot;
@property(nonatomic, assign)GLuint uSamplerLocal;

@property(nonatomic, assign)GLuint MMatrixHandle;
@property(nonatomic, assign)GLuint MVMatrixHandle;
@property(nonatomic, assign)GLuint MVPMatrixHandle;

@property(nonatomic, assign)float blackEdgeValue;

/**
 * 加载纹理
 * @param vertShader 顶点着色器
 * @param fragShader 片段着色器
 * @param isFilePath 是否是文本路径
 */
- (void)loadShaders:(NSString *)vertShader FragShader:(NSString *)fragShader isFilePath:(BOOL)isfile;

- (void)addAttribute:(NSString *)attributeName;

- (GLuint)uniformIndex:(NSString *)uniformName;

- (GLuint)attributeIndex:(NSString *)attributeName;

/**
 * 使用Program
 */
- (void)useProgram;

/**
 * 销毁
 */
- (void)destory;

@end
