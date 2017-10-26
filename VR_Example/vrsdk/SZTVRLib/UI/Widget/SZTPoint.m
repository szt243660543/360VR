//
//  SZTPoint.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/4.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTPoint.h"
#import "SZTBitmapTexture.h"
#import "SZTPlane3D.h"
#import "ImageTool.h"

@interface SZTPoint()
{
    SZTTexture * _texture;
}

@end

@implementation SZTPoint

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.mModelMatrix = GLKMatrix4Identity;
    }
    
    return self;
}

- (void)setupRenderObject
{
    [self changeDisplayMode:SZTVR_PLANE];
}

- (void)setupTextureWithColor:(UIColor *)color Rect:(CGRect)frameSize
{
    SZTBitmapTexture *bitmapTexture = [[SZTBitmapTexture alloc] init];
    UIImage *image = [ImageTool setImageFromColor:color Rect:frameSize];
    _texture = [bitmapTexture createTextureWithImage:image TextureFilter:self.textureFilter];
}

- (void)renderToFbo:(int)index
{
    [super renderToFbo:index];
    
    if (self.isRenderMonocular && index == 1) {
        return;
    }
    
    [_texture updateTexture:self.program.uSamplerLocal];
    
    [self drawElements:index];
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
}


@end
