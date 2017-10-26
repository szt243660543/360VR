//
//  SZTLabel.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 16/11/8.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTLabel.h"
#import "ImageTool.h"
#import "SZTBitmapTexture.h"

@interface SZTLabel()
{
    SZTTexture * _texture;
    
    NSMutableArray * _textArr;
}

@end

@implementation SZTLabel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _isOpaque = NO;
        _isRightAlign = NO;
        _fontColor = [UIColor whiteColor];
        _lineNumber = 5;
        _definition = 1.0;
        self.isFlip = YES;
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    _textArr = [NSMutableArray array];
    
    for (int i = 0 ; i < text.length; i++) {
        NSString * single = [_text substringWithRange:NSMakeRange(i, 1)];
        [_textArr addObject:single];
    }
    
    [self setupImage];
}

- (void)setupImage
{
    UIImage *image = [ImageTool imageWithText:_textArr fontSize:48.0 color:_fontColor lineNumber:_lineNumber rightAlign:_isRightAlign isOpaque:_isOpaque definition:_definition];
    
    [self setupTexture:image];
}

- (void)setupTexture:(UIImage *)image
{
    SZTBitmapTexture *texture = [[SZTBitmapTexture alloc] init];
    _texture = [texture createTextureWithImage:image TextureFilter:self.textureFilter];
}

- (void)renderToFbo:(int)index
{
    [super renderToFbo:index];
    
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
