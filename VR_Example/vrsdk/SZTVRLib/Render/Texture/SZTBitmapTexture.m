//
//  SZTBitmapTexture.m
//  SZTVR_SDK
//
//  Created by SZT on 16/10/24.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTBitmapTexture.h"
#import "GLUtils.h"
#import "SZTPVRUtil.h"

#pragma mark - 图片纹理
@interface SZTBitmapTexture()

@end

@implementation SZTBitmapTexture

- (SZTTexture *)createTextureWithImage:(UIImage *)image TextureFilter:(SZTTextureFilter)textureFilter
{
    self.textureID = [GLUtils setupTextureWithImage:image TextureFilter:textureFilter];
    
    return self;
}

- (SZTTexture *)createTextureWithImage:(UIImage *)image TextureFilter:(SZTTextureFilter)textureFilter ByTextureID:(int)index
{
    textures[index] = [GLUtils setupTextureWithImage:image TextureFilter:textureFilter];
    return self;
}

- (SZTTexture *)createTextureWithFileName:(NSString *)fileName TextureFilter:(SZTTextureFilter)textureFilter
{
    NSString *extension = [fileName pathExtension];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    if ([extension isEqualToString:@"pvr"]) {
        self.textureID = [SZTPVRUtil SZGLLoadTexture:imagePath];
    }else{
        self.textureID = [GLUtils setupTextureWithFileName:fileName TextureFilter:textureFilter];
    }

    return self;
}

- (void)dealloc
{
    
}

@end


