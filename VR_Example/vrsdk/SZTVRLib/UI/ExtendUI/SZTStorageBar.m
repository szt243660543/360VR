//
//  SZTStorageBar.m
//  SZTVR_SDK
//  收纳盒效果
//  Created by SZTVR on 16/10/15.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTStorageBar.h"

@interface SZTStorageBar ()
{
    float _width;
    float _height;
    
    float _x;
    float _y;
    float _z;
    
    float _rx;
    float _ry;
    float _rz;
}

@property(nonatomic, strong)NSMutableArray *childsArr;
@property(nonatomic, assign)BOOL isOpen;

@end

@implementation SZTStorageBar

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _isOpen = false;
        _width = 2.0;
        _height = 2.0;
        
        self.childsArr = [NSMutableArray array];
                          
        [self loadMainButton];
    }
    
    return self;
}

- (void)loadMainButton
{
    self.mainButton = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    
    __weak typeof(self) weakSelf = self;
    SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:self.mainButton];
    
    [touch willTouchCallBack:^(GLKVector3 vec) {
        
    }];
    
    [touch didTouchCallback:^(GLKVector3 vec) {
        [weakSelf moveOut];
    }];
    
    [touch endTouchCallback:^(GLKVector3 vec) {
        
    }];
}

- (void)moveOut
{
    self.isOpen = true;
    
    for (int i = 0 ; i < self.childsArr.count; i++) {
        SZTImageView * imgv = self.childsArr[i];
        [imgv moveTo:0.5 PosX:_x posY:_y + _height/50.0 * (i + 1) posZ:_z - 0.1 * (i + 1) finishBlock:^{
            imgv.setTouchEnable = YES;
        }];
    }
}

- (void)moveIn
{
    self.isOpen = false;
    
    for (int i = 0 ; i < self.childsArr.count; i++) {
        SZTImageView * imgv = self.childsArr[i];
        imgv.setTouchEnable = NO;
        [imgv moveTo:0.5 PosX:_x posY:_y posZ:_z - 0.1 * (i + 1) finishBlock:^{
            
        }];
    }
}

- (void)setupTextureWithImage:(UIImage *)image
{
    [self.mainButton setupTextureWithImage:image];
}

- (void)addChildsWithImages:(NSMutableArray *)imageArr
{
    int tag = 0;
    
    for (UIImage *image in imageArr) {
        SZTImageView *btn = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
        btn.tag = tag++;
        [btn setObjectSize:_width Height:_height];
        [btn setupTextureWithImage:image];
        btn.setTouchEnable = NO;
        
        __weak typeof(self) weakSelf = self;
        SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:btn];
        
        [touch willTouchCallBack:^(GLKVector3 vec) {
            
        }];
        
        [touch didTouchCallback:^(GLKVector3 vec) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectObjectByIndex:)]) {
                [weakSelf.delegate didSelectObjectByIndex:btn.tag];
            }
            [weakSelf moveIn];
        }];
        
        [touch endTouchCallback:^(GLKVector3 vec) {
            
        }];
        
        [self.childsArr addObject:btn];
    }
}

- (void)setObjectSize:(float)width Height:(float)height
{
    _width = width;
    _height = height;
    
    [self.mainButton setObjectSize:width Height:height];
}

- (void)setPosition:(float)x Y:(float)y Z:(float)z
{
    _x = x;
    _y = y;
    _z = z;
    
    [self.mainButton setPosition:x Y:y Z:z];

    if (_isOpen) {
        for (int i = 0 ; i < self.childsArr.count; i++) {
            SZTImageView * imgv = self.childsArr[i];
            
            [imgv setPosition:x Y:y + _height/50.0 * (i + 1) Z:z - 0.1];
            [imgv setRotate:_rx radiansY:_ry radiansZ:_rz];
        }
    }else{
        for (int i = 0 ; i < self.childsArr.count; i++) {
            SZTImageView * imgv = self.childsArr[i];
            [imgv setPosition:x Y:y Z:z - 0.1];
        }
    }
}

- (void)setRotate:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ
{
    _rx = radiansX;
    _ry = radiansY;
    _rz = radiansZ;
    
    [_mainButton setRotate:radiansX radiansY:radiansY radiansZ:radiansZ];
}

- (void)build
{
    [self.mainButton build];
    
    for (SZTImageView *imgv in self.childsArr) {
        [imgv build];
    }
}

- (void)removeObject
{
    if (self.mainButton) {
        [self.mainButton removeObject];
        self.mainButton = nil;
    }
    
    if (self.childsArr) {
        for (SZTImageView *imgv in self.childsArr) {
            [imgv removeObject];
        }
        [self.childsArr removeAllObjects];
        self.childsArr = nil;
    }
}

- (void)dealloc
{
    SZTLog(@"SZTStorageBar dealloc");
}

@end
