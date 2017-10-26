//
//  SZTBitmapTexture.h
//  SZTVR_SDK
//
//  Created by SZT on 16/10/24.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTTexture.h"

@interface SZTBitmapTexture : SZTTexture

/**
 * 创建图片纹理
 * @param image UIImage
 * @return 纹理对象
 */
- (SZTTexture *)createTextureWithImage:(UIImage *)image TextureFilter:(SZTTextureFilter)textureFilter;

- (SZTTexture *)createTextureWithFileName:(NSString *)fileName TextureFilter:(SZTTextureFilter)textureFilter;

- (SZTTexture *)createTextureWithImage:(UIImage *)image TextureFilter:(SZTTextureFilter)textureFilter ByTextureID:(int)index;
@end
