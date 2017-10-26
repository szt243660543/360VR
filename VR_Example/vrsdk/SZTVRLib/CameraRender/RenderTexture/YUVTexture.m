//
//  YUVTexture.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/2.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "YUVTexture.h"
#import <OpenGLES/ES2/glext.h>

@interface YUVTexture()
{
    GLuint plane_textures[3];
}

@end

@implementation YUVTexture

- (void)renderTextureBuffer:(YUVData *)yuvData
{
    if (0 == plane_textures[0])
        glGenTextures(3, plane_textures);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, plane_textures[0]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, yuvData.width, yuvData.height, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, yuvData.data);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, plane_textures[1]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, yuvData.width/2, yuvData.height/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, yuvData.data + yuvData.width * yuvData.height);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, plane_textures[2]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, yuvData.width/2, yuvData.height/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, yuvData.data + yuvData.width * yuvData.height * 5 / 4);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    for (int i = 0; i < 3; ++i) {
        glActiveTexture(GL_TEXTURE0 + i);
        glBindTexture(GL_TEXTURE_2D, plane_textures[i]);
    }
}

@end
