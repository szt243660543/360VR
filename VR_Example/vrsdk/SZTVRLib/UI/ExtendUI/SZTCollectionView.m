//
//  SZTRecommendView.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/31.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTCollectionView.h"

@interface SZTCollectionView()
{
    int _distance; // 视图移动距离
}

@end

@implementation SZTCollectionView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _distance = -100;
    }
    
    return self;
}

- (void)addChildObjects:(NSArray *)urlArr isNet:(BOOL)isnet
{
    [self setChildUI:urlArr isNet:isnet];
}

- (void)setChildUI:(NSArray *)urlArr isNet:(BOOL)isnet
{
    int index = 0;
    for (int j = 0 ; j < self.row ; j++) {
        for (int i = 0 ; i < self.column; i ++) {
            if (index < urlArr.count){
                SZTImageView *obj = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
                
                if (isnet) {
                    [obj setupTextureWithUrl:urlArr[index] Paceholder:[UIImage imageNamed:@"paceholder.jpg"]];
                }else{
                    [obj setupTextureWithImage:[UIImage imageNamed:urlArr[index]]];
                }
                
                [obj setObjectSize:self.width * 50.0 Height:self.height * 50.0];
                [obj build];
                
                [self.buttonArr addObject:obj];
                [self setupChildsSecletCallBack:obj];
            }
            
            index ++;
        }
    }
    
    [self setPosition:self.mPX Y:self.mPY Z:self.mPZ];
    [self setRotate:self.mRadians X:self.mRX Y:self.mRY Z:self.mRZ];
}

- (void)setupChildsSecletCallBack:(SZTImageView *)obj
{
    __weak typeof(self) weakSelf = self;
    
    SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:obj];
    [touch willTouchCallBack:^(GLKVector3 vec) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(willSelectChildObject:)]) {
            [weakSelf.delegate willSelectChildObject:obj];
        }
    }];
    
    [touch didTouchCallback:^(GLKVector3 vec) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectChildObject:)]) {
            [weakSelf.delegate didSelectChildObject:obj];
        }
    }];
    
    [touch endTouchCallback:^(GLKVector3 vec) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(willLeaveChildObject:)]) {
            [weakSelf.delegate willLeaveChildObject:obj];
        }
    }];
}

- (void)dealloc
{
    SZTLog(@"SZTRecommendView dealloc");
}

@end
