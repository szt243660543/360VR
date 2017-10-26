//
//  SZTObjModel.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/10/18.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTObjModel.h"
#import "SZTObject3D.h"
#import "SZTBitmapTexture.h"
#import "SZTWaveFrontObj.h"
#import "SZTModel.h"
#import "FileTool.h"

@interface SZTObjModel()
{
    SZTTexture * _texture;
    
    NSString *_path;
    NSString *_url;
    
    SZTModel *objData;
}

@end

@implementation SZTObjModel

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
        
        [self downloadObj];
    }
    
    return self;
}

- (void)downloadObj
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
    
    objData = [[SZTModel alloc] initWithPath:_path];
    
    SZTWaveFrontObj *obj = [[SZTWaveFrontObj alloc] init];
    [obj setupVBO_Render:objData];
    self.obj_Left = self.obj_Right = obj;
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
