//
//  SZTObjModel.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/10/18.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTRenderObject.h"

@interface SZTObjModel : SZTRenderObject

/** 加载本地obj模型*/
- (instancetype)initWithPath:(NSString *)path;

- (void)setupTextureWithImage:(UIImage *)image;

- (void)setupTextureWithFilePath:(NSString *)filePath;

/** 加载网络obj模型*/
- (instancetype)initWithObjUrl:(NSString *)urlPath;

- (void)setupTextureWithUrl:(NSString *)fileUrl;

@end
