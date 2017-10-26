//
//  SZTLoopButton.m
//  SZTVR_SDK
//  
//  Created by SZTVR on 16/8/1.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTLoopButton.h"

#define INDEX_ID 10000

@interface SZTLoopButton()
{

}

@property(nonatomic, assign)AXIS axis;
@property(nonatomic, strong)NSMutableArray *buttonArray;

@end

@implementation SZTLoopButton

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.buttonArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)buildButtonsWithArray:(NSMutableArray *)array
{
    float angle = 360/self.buttonCount;
    
    for(int i = 0; i < self.buttonCount; i++)
    {
        SZTImageView *imageView = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
        [imageView setupTextureWithImage:[array objectAtIndex:i]];
        imageView.tag = INDEX_ID + i;
        
        __weak typeof(self) weakSelf = self;
        SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:imageView];
        [touch willTouchCallBack:^(GLKVector3 vec) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(willSelectButtonAtIndex:)]) {
                [weakSelf.delegate willSelectButtonAtIndex:imageView.tag - INDEX_ID];
            }
        }];
        
        [touch didTouchCallback:^(GLKVector3 vec) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectButtonAtIndex:)]) {
                [weakSelf.delegate didSelectButtonAtIndex:imageView.tag - INDEX_ID];
            }
        }];
        
        [touch endTouchCallback:^(GLKVector3 vec) {
            
        }];

        [self.buttonArray addObject:imageView];
        
        float displacement1 = self.radius*sin(2*ES_PI/self.buttonCount*i);
        float displacement2 = self.radius*cos(2*ES_PI/self.buttonCount*i);
        
        if (self.axis == X) {
            [imageView setPosition:0.0 Y:displacement1 Z:displacement2];
            [imageView setRotate:-i *angle radiansY:0.0 radiansZ:0.0];
        }else if (self.axis == Y){
            [imageView setPosition:displacement1 Y:0.0 Z:displacement2];
            [imageView setRotate:0.0 radiansY:-i *angle radiansZ:0.0];
        }else if (self.axis == Z){
            [imageView setPosition:displacement1 Y:displacement2 Z:-5.5];
        }
        
        [imageView setObjectSize:self.radius Height:self.radius];
    
        
        [imageView build];
    }
}

- (void)buildButtonsWithImage:(UIImage *)image
{
    float angle = 360/self.buttonCount;
    
    for(int i = 0; i < self.buttonCount; i++)
    {
        SZTImageView *imageView = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
        [imageView setupTextureWithImage:image];
        imageView.tag = INDEX_ID + i;
        
        __weak typeof(self) weakSelf = self;
        SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:imageView];
        [touch willTouchCallBack:^(GLKVector3 vec) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(willSelectButtonAtIndex:)]) {
                [weakSelf.delegate willSelectButtonAtIndex:imageView.tag - INDEX_ID];
            }
        }];
        
        [touch didTouchCallback:^(GLKVector3 vec) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSelectButtonAtIndex:)]) {
                [weakSelf.delegate didSelectButtonAtIndex:imageView.tag - INDEX_ID];
            }
        }];
        
        [touch endTouchCallback:^(GLKVector3 vec) {
            
        }];
        
        [self.buttonArray addObject:imageView];
        
        float displacement1 = self.radius*sin(2*ES_PI/self.buttonCount*i);
        float displacement2 = self.radius*cos(2*ES_PI/self.buttonCount*i);
        
        if (self.axis == X) {
            [imageView setPosition:0.0 Y:displacement1 Z:displacement2];
            [imageView setRotate:-i *angle radiansY:0.0 radiansZ:0.0];
        }else if (self.axis == Y){
            [imageView setPosition:displacement1 Y:0.0 Z:displacement2];
            [imageView setRotate:0.0 radiansY:-i *angle radiansZ:0.0];
        }else if (self.axis == Z){
            [imageView setPosition:displacement1 Y:displacement2 Z:-15.5];
        }
        
        [imageView setObjectSize:self.radius/2 Height:self.radius/2];
        
        [imageView build];
    }
}

- (void)buildButtonsWithGifName:(NSString *)gifName
{
    float angle = 360/self.buttonCount;
    
    for(int i = 0; i<self.buttonCount; i++)
    {
        SZTGif *gif = [[SZTGif alloc] init];
        [gif setupGifWithGifName:gifName];
        
        [self.buttonArray addObject:gif];
        
        float displacement1 = self.radius*sin(2*ES_PI/self.buttonCount*i);
        float displacement2 = self.radius*cos(2*ES_PI/self.buttonCount*i);
        
        if (self.axis == X) {
            [gif setPosition:0.0 Y:displacement1 Z:displacement2];
            [gif setRotate:-i *angle radiansY:0.0 radiansZ:0.0];
        }else if (self.axis == Y){
            [gif setPosition:displacement1 Y:0.0 Z:displacement2];
            [gif setRotate:0.0 radiansY:-i *angle radiansZ:0.0];
        }else if (self.axis == Z){
            [gif setPosition:displacement1 Y:displacement2 Z:-5.5];
        }
        
        [gif setObjectSize:self.radius Height:self.radius];
        
        [gif build];
    }
}

- (void)setRotationAroundAxis:(AXIS)axis
{
    self.axis = axis;
}

- (void)dealloc
{
    
}

@end
