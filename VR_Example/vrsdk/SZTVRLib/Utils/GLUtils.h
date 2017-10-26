//
//  GLUtils.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/18.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>

/** see {@link #remapCoordinateSystem} */
static const int AXIS_X = 1;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_Y = 2;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_Z = 3;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_MINUS_X = AXIS_X | 0x80;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_MINUS_Y = AXIS_Y | 0x80;
/** see {@link #remapCoordinateSystem} */
static const int AXIS_MINUS_Z = AXIS_Z | 0x80;

@interface GLUtils : NSObject

/**
 * 加载着色器
 * @type shader类型
 * @shaderFilepath sharder资源路径
 */
+ (GLuint)loadShader:(GLenum)type withFilepath:(NSString *)shaderFilepath;

/**
 * 加载program
 * @shaderVertex 顶点着色器
 * @shaderFragment 片段着色器
 * @return 返回program
 */
+ (GLuint)compileShaders:(NSString *)shaderVertex shaderFragment:(NSString *)shaderFragment isFilePath:(BOOL)isfile;

/**
 *  @传入图片的路径
 *  @return 返回纹理对象
 */
+ (GLuint)setupTextureWithFileName:(NSString *)fileName TextureFilter:(SZTTextureFilter) textureFilter;

/**
 *  @传入UIimage
 *  @return 返回纹理对象
 */
+ (GLuint)setupTextureWithImage:(UIImage *)image TextureFilter:(SZTTextureFilter) textureFilter;

/**
 *  @param quaternion
 *  @param orientation
 *  @return 返回偏移矩阵
 */
+ (GLKMatrix4)calculateMatrixFromQuaternion:(CMQuaternion*)quaternion orientation:(UIInterfaceOrientation)orientation;

+ (void)setGLTextureMinFilter:(SZTTextureFilter)textureFilter;

+ (int)NextPot:(int)n;

+ (GLKMatrix4)updateDeviceOrientation:(UIInterfaceOrientation)orientation;

+ (GLKMatrix4)GetRotateEulerMatrix:(float)x Y:(float)y Z:(float)z;
@end
