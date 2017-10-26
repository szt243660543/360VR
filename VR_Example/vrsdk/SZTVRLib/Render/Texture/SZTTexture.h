//
//  SZTTexture.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTTexture : NSObject
{
    GLuint textures[200];
}

@property(nonatomic, assign)GLuint textureID;

/**
 * 设置纹理ID
 * @param image 图片
 */
- (SZTTexture *)setupTextureWithImage:(UIImage *)image TextureFilter:(SZTTextureFilter)textureFilter;

- (SZTTexture *)createTextureWithPath:(NSString *)path TextureFilter:(SZTTextureFilter)textureFilter;

/**
 * 更新纹理
 * @param context 上下文
 * @param uSamplerLocal
 */
- (GLuint)updateTexture:(GLuint)uSamplerLocal;

- (GLuint)updateTexture:(GLuint)uSamplerLocal ByTextureID:(int)index;

- (CVPixelBufferRef)updateVideoTexture:(EAGLContext *)context;

// 截屏
- (void)screenShotByIndex:(int)index VideoTag:(int)tag screenDoneblock:(void (^)(NSString *))block;

/**
 * 销毁
 */
- (void)destory;

@end
