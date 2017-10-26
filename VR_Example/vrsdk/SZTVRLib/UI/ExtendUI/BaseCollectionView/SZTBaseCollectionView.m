//
//  SZTBaseUIView.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/31.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTBaseCollectionView.h"

@interface SZTBaseCollectionView()

@end

@implementation SZTBaseCollectionView

- (NSMutableArray *)buttonArr
{
    if (!_buttonArr) {
        self.buttonArr = [NSMutableArray array];
    }
    
    return _buttonArr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _width = _height = 2.0; // 默认宽高
        _spacingX = _spacingY = _width * 0.25; // 默认间距
        
        _showRow = 10000;
        _moveY = 0;
        _mRY = 1.0;
        _showDistance = -10.0;
    }
    return self;
}

- (void)setBackgroundView:(float)width Height:(float)height
{
    _backGroundView = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    [_backGroundView setupTextureWithColor:_backgroundColor Rect:CGRectMake(0, 0, 10, 10)];
    [_backGroundView setObjectSize:width* 50.0 Height:height* 50.0];
    [_backGroundView build];
}

- (void)setPosition:(float)x Y:(float)y Z:(float)z
{
    _mPX = x;
    _mPY = y;
    _mPZ = z;
    
    [self setObjPosition:x Y:y - _moveY * (self.height+self.spacingY) Z:z];
    [self setBackViewPosition:x Y:y Z:z];
}

- (void)setObjPosition:(float)x Y:(float)y Z:(float)z
{
    if (_buttonArr.count == 0) return;
    
    int index = 0;
    for (int j = 0 ; j < _row ; j++) {
        for (int i = 0 ; i < _column; i ++) {
            if (index >= _buttonArr.count) return;
            
            SZTImageView * imgv = _buttonArr[index];
            index ++;
            [imgv setPosition:x + i * (_width + _spacingX) Y:y + j * (_height + _spacingY) Z:z + 0.5];
        }
    }
}

- (void)setBackViewPosition:(float)x Y:(float)y Z:(float)z
{
    int row = _row > _showRow?_showRow:_row;
    [_backGroundView setPosition:x + (_column - 1.0) * ((_width + _spacingX) * 0.5) Y:y + (row - 1.0) * ((_height + _spacingY) * 0.5) Z:z];
}

- (void)setRotate:(float)radians X:(float)x Y:(float)y Z:(float)z;
{
    _mRadians = radians;
    _mRX = x;
    _mRY = y;
    _mRZ = z;
    
//    [_backGroundView setRotate:radians X:x Y:y Z:z];
    
    if (_buttonArr.count == 0) return;
    
    int index = 0;
    for (int j = 0 ; j < _row ; j++) {
        for (int i = 0 ; i < _column; i ++) {
            if (index >= _buttonArr.count) return;
            
//            SZTImageView * imgv = _buttonArr[index];
//            index ++;
//            [imgv setRotate:radians X:x Y:y Z:z];
        }
    }
}

- (void)setScale:(float)x Y:(float)y Z:(float)z
{
    
}

- (void)setChildObjectRect:(float)width Height:(float)height
{
    _width = width;
    _height = height;
    
    _spacingX = _width * 0.25;
    _spacingY = _height * 0.25;
}

- (void)moveAnimate:(float)time X:(float)x Y:(float)y Z:(float)z noMoveObject:(SZTImageView *)obj block:(void (^)(void))block
{
    int index = 0;
    
    for (int j = 0 ; j < _row ; j++) {
        for (int i = 0 ; i < _column; i ++) {
            SZTImageView * imgv;
            if (index < _buttonArr.count) {
                imgv = _buttonArr[index];
                
                if (obj != imgv) {
                    [imgv moveTo:time PosX:x + i * (_width + _spacingX) posY:y - _moveY *(_height+_spacingY) + j * (_height + _spacingY) posZ:z + 0.5 finishBlock:^{}];
                }
            }
            index ++;
        }
    }
    
    __weak typeof(self) weakSelf = self;
    [self moveAnimateBackground:time X:x Y:y Z:z block:^{
        [weakSelf setPosition:x Y:y Z:z];
        block();
    }];
}

- (void)moveAnimateBackground:(float)time X:(float)x Y:(float)y Z:(float)z block:(void (^)(void))block
{
    int row = self.row > self.showRow?_showRow:self.row;
    
    [_backGroundView moveTo:time PosX:x + (_column - 1.0) * ((_width + _spacingX) * 0.5) posY:y+ (row - 1.0) * ((_height + _spacingY) * 0.5) posZ:z finishBlock:^{
        block();
    }];
}

- (void)build
{
    int row = _row > _showRow?_showRow:_row;
    float width = (self.width + self.spacingX) * self.column;
    float height = (self.height + self.spacingY) * row;
    
    [self setBackgroundView:width Height:height];
}

- (int)getRow
{
    int row;
    
    float v = self.buttonArr.count % self.column;
    if (v == 0) {
        row = (int)self.buttonArr.count/self.column;
    }else{
        row = (int)self.buttonArr.count/self.column + 1;
    }
    
    return row;
}

- (void)removeObjectByIndex:(int)index
{
    for (int i = 0; i < self.buttonArr.count; i++) {
        SZTImageView * imgv = self.buttonArr[i];
        if (imgv.tag == index) {
            [self.buttonArr removeObjectAtIndex:i];
        }
    }
}

- (void)removeAllObject
{
    [self.backGroundView removeObject];
    self.backGroundView = nil;
    
    for (SZTImageView * obj in _buttonArr) {
        [obj removeObject];
    }
}

- (void)dealloc
{
    [self removeAllObject];
    
    self.buttonArr = nil;
    self.backgroundColor = nil;
    
    SZTLog(@"SZTBaseUIView delloc");
}

@end
