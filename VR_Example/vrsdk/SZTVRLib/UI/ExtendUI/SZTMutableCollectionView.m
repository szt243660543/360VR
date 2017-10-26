//
//  SZTConfigurableButtonView.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/11.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTMutableCollectionView.h"

@interface SZTMutableCollectionView()

@end

@implementation SZTMutableCollectionView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}


- (void)setChildUI
{
    float cutMin = self.mPY - self.height * 0.5;
    float cutMax = self.mPY + self.height * (self.showRow - 1) + (self.spacingY * self.showRow);
    
    int _num = 0;  // 加载个数
    
    for (int i = 0; i < self.buttonArr.count; i++) {
        SZTImageView * obj = self.buttonArr[i];
        _num ++;
        [obj setObjectSize:self.width* 50.0 Height:self.height* 50.0];
        obj.cutMinY = cutMin;
        obj.cutMaxY = cutMax;
        [obj build];
        
        if (self.column * self.moveY == 0) {
            if (_num <= self.showRow * self.column) {
                obj.setTouchEnable = YES;
            }else{
                obj.setTouchEnable = NO;
            }
        }else{
            if (_num > self.column && _num <= (self.showRow +1) * self.column) {
                obj.setTouchEnable = YES;
            }else{
                obj.setTouchEnable = NO;
            }
        }
        
        [self setChildTargetBlock:obj];
    }
}

- (void)setChildTargetBlock:(SZTImageView *)imgv
{
    SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:imgv];
    __weak typeof(self) weakSelf = self;
    
    [touch willTouchCallBack:^(GLKVector3 vec) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(willSelectMutableObject:)]) {
            [weakSelf.delegate willSelectMutableObject:imgv];
        }
    }];
    
    [touch didTouchCallback:^(GLKVector3 vec) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectMutableObject:)]) {
            [weakSelf.delegate didSelectMutableObject:imgv];
        }
    }];
    
    [touch endTouchCallback:^(GLKVector3 vec) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(willLeaveMutableObject:)]) {
            [weakSelf.delegate willLeaveMutableObject:imgv];
        }
    }];
}

- (void)updateObject
{
    [self build];
    [self setChildUI];
    
    [self setPosition:self.mPX Y:self.mPY Z:self.mPZ];
    [self setRotate:self.mRadians X:self.mRX Y:self.mRY Z:self.mRZ];
}

- (void)offsetObject
{
    int _num = 0;  // 加载个数
    int _showi = self.column * self.moveY;
    if (_showi > 0) {  // 显示showRow ＋ 上下两列
        _showi -= self.column;
    }
    
    for (int i = _showi ; i < self.buttonArr.count; i++) {
        SZTImageView * obj = self.buttonArr[i];
        if (_num < (self.showRow + 2) * self.column) {
            _num ++;
        }
        
        if (self.column * self.moveY == 0) {
            if (_num <= self.showRow * self.column) {
                obj.setTouchEnable = YES;
            }else{
                obj.setTouchEnable = NO;
            }
        }else{
            if (_num > self.column && _num <= (self.showRow +1) * self.column) {
                obj.setTouchEnable = YES;
            }else{
                obj.setTouchEnable = NO;
            }
        }
    }
}

- (void)addChildObject:(SZTImageView *)obj
{    
    [self.buttonArr addObject:obj];
    self.row = [self getRow];
    
    [self removeAllObject];
    [self updateObject];
}

- (void)removeChildObjectByIndex:(int)index
{
    [self removeAllObject];
    [self removeObjectByIndex:index];

    self.row = [self getRow];
    [self updateObject];
}

- (void)dealloc
{
    SZTLog(@"SZTMutableCollectionView dealloc");
    [self removeAllObject];
    self.buttonArr = nil;
}

@end
