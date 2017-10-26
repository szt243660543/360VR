//
//  SZTBitmapVideo.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTImageView.h"
#import "SZTBitmapTexture.h"
#import "GLUtils.h"
#import "SZTObject3D.h"
#import "ImageTool.h"
#import "FileTool.h"
#import "SZTRay.h"
#import "GLUtils.h"

@interface SZTImageView()
{
    SZTTexture * _texture;
    SZTTexture * _textureRight;
    BOOL _isBackgroundView;
    BOOL _isNetDownLoad;
}

@end

@implementation SZTImageView

- (instancetype)initWithMode:(SZTRenderModel)renderModel
{
    self = [super init];
    
    if (self) {
        self.renderModel = renderModel;
        self.isFlip = YES;
    }
    
    return self;
}

- (void)setupTextureWithImage:(UIImage *)imageName
{
    [self setupTexture:imageName];
}

- (void)setupTextureWithFileName:(NSString *)fileName
{
    if (!_isNetDownLoad) {
        UIImage * image = [UIImage imageNamed:fileName];
        CGImageRef cgImageRef = [image CGImage];
        [self setObjectSize:CGImageGetWidth(cgImageRef) Height:CGImageGetHeight(cgImageRef)];
    }
    
    SZTBitmapTexture *texture = [[SZTBitmapTexture alloc] init];
    _texture = [texture createTextureWithFileName:fileName TextureFilter:self.textureFilter];
}

- (void)setupTextureWithColor:(UIColor *)color Rect:(CGRect)frameSize
{
    UIImage *image = [ImageTool setImageFromColor:color Rect:frameSize];
    [self setupTexture:image];
}

- (void)setTextureWithLeftUrl:(NSString *)leftUrl RightUrl:(NSString *)rightUrl Paceholder_Left:(UIImage *)paceholder_left Paceholder_Right:(UIImage *)paceholder_right
{
    _isBackgroundView = true;
    [self setTextureWithLeftImage:paceholder_left RightImage:paceholder_right];
    _isNetDownLoad = true;
    
    __weak typeof(self) weakSelf = self;
    [FileTool downLoadWithFileName:leftUrl hasExist:^(NSString * name) {
        SZTBitmapTexture *leftTexture = [[SZTBitmapTexture alloc] init];
        _texture = [leftTexture createTextureWithImage:[UIImage imageWithContentsOfFile:name] TextureFilter:self.textureFilter];
    } finishDownload:^(NSString * name) {
        [weakSelf destoryTexture];
        [weakSelf setupTexture:[UIImage imageWithContentsOfFile:name]];
    }];
    
    [FileTool downLoadWithFileName:rightUrl hasExist:^(NSString * name) {
        SZTBitmapTexture *rightTexture = [[SZTBitmapTexture alloc] init];
        _textureRight = [rightTexture createTextureWithImage:[UIImage imageWithContentsOfFile:name] TextureFilter:self.textureFilter];
    } finishDownload:^(NSString * name) {
        [weakSelf destoryTextureRight];
        SZTBitmapTexture *rightTexture = [[SZTBitmapTexture alloc] init];
        _textureRight = [rightTexture createTextureWithImage:[UIImage imageWithContentsOfFile:name] TextureFilter:self.textureFilter];
    }];
}

- (void)setTextureWithLeftImage:(UIImage *)LeftImage RightImage:(UIImage *)rightImage
{
    [self destoryTexture];
    [self destoryTextureRight];
    
    _isBackgroundView = true;
    
    SZTBitmapTexture *leftexture = [[SZTBitmapTexture alloc] init];
    _texture = [leftexture createTextureWithImage:LeftImage TextureFilter:self.textureFilter];
    
    SZTBitmapTexture *rightTexture = [[SZTBitmapTexture alloc] init];
    _textureRight = [rightTexture createTextureWithImage:rightImage TextureFilter:self.textureFilter];
}

- (void)setupTextureWithUrl:(NSString *)fileUrl Paceholder:(UIImage *)paceholder
{
    // 占位图
    [self setupTexture:paceholder];
    
    _isNetDownLoad = true;
    
    __weak typeof(self) weakSelf = self;
    [FileTool downLoadWithFileName:fileUrl hasExist:^(NSString *name) {
        [self setupTexture:[UIImage imageWithContentsOfFile:name]];
    } finishDownload:^(NSString *name) {
        [weakSelf destoryTexture];
        [weakSelf setupTexture:[UIImage imageWithContentsOfFile:name]];
    }];
}

- (void)setupTexture:(UIImage *)image
{
    [self destoryTexture];
    
//    if (!_isNetDownLoad) {
    CGImageRef cgImageRef = [image CGImage];
    [self setObjectSize:CGImageGetWidth(cgImageRef) Height:CGImageGetHeight(cgImageRef)];
//    }
    
    SZTBitmapTexture *texture = [[SZTBitmapTexture alloc] init];
    _texture = [texture createTextureWithImage:image TextureFilter:self.textureFilter];
}

- (void)renderToFbo:(int)index
{
    [super renderToFbo:index];
    
    GLuint textureId = [self updateTexture:index];
    
    if (textureId == -1) return;

    [self openObjectFollowingCameraView];
    
    [self progressBarData];
    
    [self fadeData];
    
    [self drawElements:index];
}

- (void)progressBarData
{
    // base
}

- (void)fadeData
{
    // base
}

- (GLuint)updateTexture:(int)index
{
    if (_isBackgroundView) {
        if (index == 0) {
            return [_texture updateTexture:self.program.uSamplerLocal];
        }else{
            return [_textureRight updateTexture:self.program.uSamplerLocal];
        }
    }else{
        return [_texture updateTexture:self.program.uSamplerLocal];
    }
    
    return -1;
}

- (void)destory
{
    [super destory];
    
    [self removeObject];
    [self destoryTexture];
    [self destoryTextureRight];
}

- (void)destoryTexture
{
    if (_texture) {
        [_texture destory];
        _texture = nil;
    }
}

- (void)destoryTextureRight
{
    if (_textureRight) {
        [_textureRight destory];
        _textureRight = nil;
    }
}

- (void)dealloc
{
    [self destory];
}

@end
