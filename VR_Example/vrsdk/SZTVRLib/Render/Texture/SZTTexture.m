//
//  SZTTexture.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTTexture.h"
#import "GLUtils.h"

@implementation SZTTexture

- (SZTTexture *)setupTextureWithImage:(UIImage *)image TextureFilter:(SZTTextureFilter)textureFilter
{
    return self;
}

- (SZTTexture *)createTextureWithPath:(NSString *)path TextureFilter:(SZTTextureFilter)textureFilter
{
    return self;
}

- (GLuint)updateTexture:(GLuint)uSamplerLocal
{
    glActiveTexture(GL_TEXTURE0);
    
    glBindTexture(GL_TEXTURE_2D, self.textureID);
    
    glUniform1i(uSamplerLocal, 0);
    
    return self.textureID;
}

- (GLuint)updateTexture:(GLuint)uSamplerLocal ByTextureID:(int)index
{
    glActiveTexture(GL_TEXTURE0);
    
    glBindTexture(GL_TEXTURE_2D, textures[index]);
    
    glUniform1i(uSamplerLocal, 0);
    
    return textures[index];
}

- (CVPixelBufferRef)updateVideoTexture:(EAGLContext *)context
{
    return nil;
}

- (void)destory
{
    if (_textureID) glDeleteTextures(1, &(_textureID));
    
    if (textures) {
        for (int i = 0; i < 200; i++) {
            glDeleteTextures(1, &(textures[i]));
        }
    }
}

- (void)screenShotByIndex:(int)index VideoTag:(int)tag screenDoneblock:(void (^)(NSString *))block;
{
    
}

- (void)dealloc
{
    [self destory];
}

@end
