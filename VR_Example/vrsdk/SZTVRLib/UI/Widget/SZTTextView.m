//
//  SZTTextView.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/17.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTTextView.h"
#import "SZTShineBar.h"

@interface SZTTextView()
{
    SZTImageView *_baseImage;
    
    SZTShineBar *_shineBar;
    
    NSMutableArray *_labelArr;
}

// 每个字符的宽度
@property(nonatomic, assign)float eachCharWidth;
// 每个字符的高度
@property(nonatomic, assign)float eachCharHeight;
// 当前字符位置标示
@property(nonatomic, assign)int currentCharTag;
// 控件最左边初始位置
@property(nonatomic, assign)float leftPosX;

@end

@implementation SZTTextView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _isShineBarHide = false;
        
        _currentCharTag = 0;
        
        _labelArr = [NSMutableArray array];
        
        [self loadBaseImage];
        
        [self loadShineBar];
        
        _leftPosX = _baseImage.pX - _baseImage.objSize.width/100.0;
    }
    
    return self;
}

- (void)loadBaseImage
{
    _baseImage = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    [_baseImage setupTextureWithImage:[UIImage imageNamed:@"inputbox.png"]];
    
    SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:_baseImage];
    
    __weak typeof(self) weakSelf = self;
    [touch willTouchCallBack:^(GLKVector3 vec) {
        
    }];
    
    [touch didTouchCallback:^(GLKVector3 vec) {
        [weakSelf setShineBarCurrentPos];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchTextView:)]) {
            [self.delegate didTouchTextView:self];
        }
    }];
    
    [touch endTouchCallback:^(GLKVector3 vec) {
        
    }];
}

-(void)loadShineBar
{
    _shineBar = [[SZTShineBar alloc] init];
//    [UIColor colorWithRed:246.0/255.0 green:195.0/255.0 blue:24.0/255.0 alpha:1.0]
    [_shineBar setupTextureWithColor:[UIColor colorWithRed:66/255.0 green:84/255.0 blue:185/255.0 alpha:1.0]];
    [_shineBar setObjectSize:_baseImage.objSize.width/100.0 Height:_baseImage.objSize.height*0.8];
}

- (void)setObjectSize:(float)width Height:(float)height
{
    [_baseImage setObjectSize:width Height:height];
    
    _eachCharWidth = width / ((_lineNumber + 1)  * 50);
    _eachCharHeight = height * 0.6/50.0;
    _leftPosX = _baseImage.pX - width/100.0;
    
    [_shineBar setObjectSize:width/100.0 Height:height*0.8];
}

- (void)setPosition:(float)x Y:(float)y Z:(float)z
{
    [_baseImage setPosition:x Y:y Z:z];
    
    if (_isShineBarHide) {
        [_shineBar setPosition:1000.0 Y:y Z:z + 0.11];
    }else{
        [_shineBar setPosition:_baseImage.pX + _leftPosX + _eachCharWidth * _currentCharTag + 0.3 Y:y Z:z + 0.11];
    }
}

- (void)inputText:(NSString *)text
{
    if (_currentCharTag >= _lineNumber) return;
    
    SZTLabel *label = [[SZTLabel alloc] init];
    label.lineNumber = 1;
    label.fontColor = [UIColor whiteColor];
    label.text = text;
    [label setObjectSize:_eachCharWidth * 50 Height:_eachCharHeight * 50];
    [label build];
    
    [_labelArr addObject:label];
    [label setPosition:_baseImage.pX + 0.2 +_leftPosX +_eachCharWidth * 0.5 + _eachCharWidth * _currentCharTag Y:_baseImage.pY Z:_baseImage.pZ + 0.1];
    
    _currentCharTag ++;
    [_shineBar setPosition:_baseImage.pX + _leftPosX + _eachCharWidth * _currentCharTag Y:_shineBar.pY Z:_shineBar.pZ];
}

- (void)removeLastText
{
    if (_currentCharTag <= 0)return;
    
    SZTLabel * obj = [_labelArr lastObject];
    [obj removeObject];
    
    _currentCharTag --;
    [self setShineBarCurrentPos];
    [_labelArr removeLastObject];
}

- (void)removeAllText
{
    [_labelArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SZTLabel * obj, NSUInteger idx, BOOL *stop) {
        [obj removeObject];
        [_labelArr removeObject:obj];
    }];
}

- (void)HiddenShineBar:(BOOL)isHide
{
    _isShineBarHide = isHide;
    
    if (isHide) {
        [_shineBar setPosition:1000.0 Y:_shineBar.pY Z:_shineBar.pZ];
    }else{
        [self setShineBarCurrentPos];
    }
}

- (void)setShineBarCurrentPos
{
    if (_currentCharTag == 0) {
        [_shineBar setPosition:_baseImage.pX + _leftPosX + _eachCharWidth * _currentCharTag + 0.3 Y:_shineBar.pY Z:_shineBar.pZ];
    }else{
        [_shineBar setPosition:_baseImage.pX + _leftPosX + _eachCharWidth * _currentCharTag Y:_shineBar.pY Z:_shineBar.pZ];
    }
}

- (void)build
{
    [_baseImage build];
    
    [_shineBar build];
    
    _eachCharWidth = _baseImage.objSize.width / ((_lineNumber + 1) * 50);
    _eachCharHeight = _baseImage.objSize.height * 0.6/ 50.0;
}

- (void)removeObject
{
    if (_baseImage) {
        [_baseImage removeObject];
        _baseImage = nil;
    }
    
    if (_shineBar) {
        [_shineBar removeObject];
        _shineBar = nil;
    }

    [self removeAllText];
    _labelArr = nil;
}

- (void)dealloc
{
    [self removeObject];
    
    SZTLog(@"SZTTextView dealloc");
}

@end
