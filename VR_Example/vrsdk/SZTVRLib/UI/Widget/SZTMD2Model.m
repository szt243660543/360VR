//
//  SZTMD2Model.m
//  SZTVR_SDK
//
//  Created by szt on 2017/7/5.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTMD2Model.h"
#import "SZTObject3D.h"
#import "SZTBitmapTexture.h"
#import "MD2Sprite.h"
#import "FileTool.h"

@interface SZTMD2Model()
{
    SZTTexture * _texture;
    
    NSString *_path;
    NSString *_url;
    
    MD2Sprite *obj;
}

@end

@implementation SZTMD2Model

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    
    if (self) {
        _path = path;
        self.renderModel = SZTVR_3D_MODEL;
    }
    
    return self;
}

- (instancetype)initWithObjUrl:(NSString *)urlPath
{
    self = [super init];
    
    if (self) {
        _url = urlPath;
        self.renderModel = SZTVR_3D_MODEL;
        
        [self downloadMD2];
    }
    
    return self;
}

- (void)downloadMD2
{
    __weak typeof(self) weakSelf = self;
    [FileTool downLoadWithFileName:_url hasExist:^(NSString * name) {
        _path = name;
        [weakSelf setupRenderObject];
    }finishDownload:^(NSString * name) {
        _path = name;
        [weakSelf setupRenderObject];
    }];
}

- (void)setupRenderObject
{
    if (!_path) return;
    
    obj = [[MD2Sprite alloc] initWithFilePath:_path];
    self.obj_Left = self.obj_Right = obj;
    
    [self play];
    
    self.isCycle = true;
}

- (void)setupTextureWithImage:(UIImage *)image
{
    SZTBitmapTexture *bitmapTexture = [[SZTBitmapTexture alloc] init];
    _texture = [bitmapTexture createTextureWithImage:image TextureFilter:self.textureFilter];
}

- (void)setupTextureWithFilePath:(NSString *)filePath
{
    SZTBitmapTexture *texture = [[SZTBitmapTexture alloc] init];
    _texture = [texture createTextureWithFileName:filePath TextureFilter:self.textureFilter];
}

- (void)setupTextureWithUrl:(NSString *)fileUrl
{
    __weak typeof(self) weakSelf = self;
    [FileTool downLoadWithFileName:fileUrl hasExist:^(NSString * name) {
        [weakSelf setupTextureWithFilePath:name];
    }finishDownload:^(NSString * name) {
        [weakSelf destoryTexture];
        [weakSelf setupTextureWithFilePath:name];
    }];
}

- (void)playFrameFrom:(int)beginFrame To:(int)endFrame
{
    [obj playFrameFrom:beginFrame To:endFrame];
}

- (void)setFrameInterval:(float)frameInterval
{
    _frameInterval = frameInterval;
    
    obj.frameInterval = frameInterval;
}

- (void)pause
{
    [obj pause];
}

- (void)play
{
    [obj play];
}

- (void)setIsCycle:(BOOL)isCycle
{
    _isCycle = isCycle;
    obj.isCycle = isCycle;
}

- (void)renderToFbo:(int)index
{
    [super renderToFbo:index];
    
    [_texture updateTexture:self.program.uSamplerLocal];
    
    [self drawElements:index];
}

- (void)destoryTexture
{
    if (_texture) [_texture destory];
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
    SZTLog(@"SZTObjModel dealloc");
}

@end
