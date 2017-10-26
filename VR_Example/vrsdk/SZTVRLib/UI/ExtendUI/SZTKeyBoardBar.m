//
//  SZTKeyBoardBar.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/17.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTKeyBoardBar.h"

@interface SZTKeyBoardBar ()
{
    SZTImageView *_background;
    
    NSMutableArray *_keyArrs;
}

@end

@implementation SZTKeyBoardBar

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _keyArrs = [NSMutableArray array];
        
        [self loadBackground];
        
        self.currentType = LowerCase;
        
        [self loadKeys];
    }
    
    return self;
}

- (void)loadBackground
{
    _background = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    [_background setupTextureWithImage:[UIImage imageNamed:@"background.png"]];
    [_background setObjectSize:1125.0 Height:648.0];
}

- (void)loadKeys
{
    for (int i = 0; i < 31; i++) {
        SZTImageView *key = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
        [key setupTextureWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"s_%d.png",i]]];
        if (i == 19 || i == 27) {
            [key setObjectSize:126.0 Height:129.0];
        }else if (i == 28) {
            [key setObjectSize:120.0 Height:129.0];
        }else if (i == 29) {
            [key setObjectSize:687.0 Height:129.0];
        }else if (i == 30) {
            [key setObjectSize:264.0 Height:129.0];
        }else{
            [key setObjectSize:96.0 Height:129.0];
        }
        
        SZTTouch * touch = [[SZTTouch alloc] initWithTouchObject:key];
        __weak typeof(self) weakSelf = self;
        [touch willTouchCallBack:^(GLKVector3 vec) {
            if (i == 29 || i == 30) {
                [key setScale:1.0 Y:1.2 Z:1.2];
            }else{
                [key setScale:1.2 Y:1.2 Z:1.2];
            }
        }];
        
        [touch didTouchCallback:^(GLKVector3 vec) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didTouchKeyString:)]) {
                [weakSelf.delegate didTouchKeyString:[weakSelf getStringByIndex:i]];
            }
        }];
        
        [touch endTouchCallback:^(GLKVector3 vec) {
            [key setScale:1.0 Y:1.0 Z:1.0];
        }];
        
        [_keyArrs addObject:key];
    }
}

- (void)setKeyCapsLook:(KeyboardType)type
{
    self.currentType = type;
    switch (type) {
        case LowerCase:{
            for (int i = 0; i < _keyArrs.count; i++) {
                SZTImageView *key = _keyArrs[i];
                [key setupTextureWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"s_%d.png",i]]];
            }
        }
            break;
        case UpperCase:{
            for (int i = 0; i < _keyArrs.count; i++) {
                SZTImageView *key = _keyArrs[i];
                [key setupTextureWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"b_%d.png",i]]];
            }
        }
            break;
        case NumberType:{
            for (int i = 0; i < _keyArrs.count; i++) {
                SZTImageView *key = _keyArrs[i];
                [key setupTextureWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"n_%d.png",i]]];
            }
        }
            break;
        default:
            break;
    }
}

- (void)setPosition:(float)x Y:(float)y Z:(float)z
{
    [_background setPosition:x Y:y Z:z];
    
    // q ~ p
    for (int i = 0; i < 10; i++) {
        SZTImageView *key = _keyArrs[i];
        [key setPosition:x - _background.objSize.width/100.0 + key.objSize.width/100.0 + (key.objSize.width/50.0 + 0.3) * i + 0.3 Y:y + _background.objSize.height/100.0 - key.objSize.height/100.0 - 0.8 Z:z + 0.1];
    }
    
    // a ~ l
    for (int i = 10; i < 19; i++) {
        SZTImageView *key = _keyArrs[i];
        [key setPosition:x - _background.objSize.width/100.0 + key.objSize.width/100.0 + (key.objSize.width/50.0 + 0.3) * (i - 10) + 0.3 + key.objSize.width/100.0 Y:y + _background.objSize.height/100.0 - key.objSize.height/100.0 - 0.8 - key.objSize.height/50.0 - 0.3 Z:z + 0.1];
    }
    
    // z ~ m
    for (int i = 19; i < 28; i++) {
        SZTImageView *key = _keyArrs[i];
        
        float m_y = y + _background.objSize.height/100.0 - key.objSize.height/100.0 - 0.8 - (key.objSize.height/50.0 + 0.3) * 2.0;
        
        if (i == 19) {
            [key setPosition:x - _background.objSize.width/100.0 + key.objSize.width/100.0 + 0.3 Y:m_y Z:z + 0.1];
        }else if (i == 27){
            [key setPosition:x + _background.objSize.width/100.0 - key.objSize.width/100.0 - 0.3 Y:m_y Z:z + 0.1];
        }else{
            [key setPosition:x - _background.objSize.width/100.0 + key.objSize.width/100.0 + (key.objSize.width/50.0 + 0.3) * (i - 19) + 0.6 + key.objSize.width/100.0 Y:m_y Z:z + 0.1];
        }
    }
    
    for (int i = 28; i < 31; i++) {
        SZTImageView *key = _keyArrs[i];
        
        float m_y = y + _background.objSize.height/100.0 - key.objSize.height/100.0 - 0.8 - (key.objSize.height/50.0 + 0.3) * 3.0;
        
        if (i == 28) {
            [key setPosition:x - _background.objSize.width/100.0 + key.objSize.width/100.0 + 0.3 Y:m_y Z:z + 0.1];
        }else if (i == 30){
            [key setPosition:x + _background.objSize.width/100.0 - key.objSize.width/100.0 - 0.3 Y:m_y Z:z + 0.1];
        }else{
            [key setPosition:x - 1.6 Y:m_y Z:z + 0.1];
        }
    }
}

- (void)setRotate:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ
{
    for (SZTImageView * img in _keyArrs) {
        [img setRotate:radiansX radiansY:radiansY radiansZ:radiansZ];
    }
    
    [_background setPosition:_background.pX Y:_background.pY Z:_background.pZ - 3.0];
    [_background setScale:1.1 Y:1.1 Z:1.1];
    [_background setRotate:radiansX radiansY:radiansY radiansZ:radiansZ];
}

- (void)build
{
    [_background build];
    
    for (SZTImageView * key in _keyArrs) {
        [key build];
    }
}


- (NSString *)getStringByIndex:(int)index
{
    NSString *key;
    
    if (index == 0) {
        key = self.currentType == LowerCase?@"q":(self.currentType == UpperCase?@"Q":@"0");
    }else if (index == 1){
        key = self.currentType == LowerCase?@"w":(self.currentType == UpperCase?@"W":@"1");
    }else if (index == 2){
        key = self.currentType == LowerCase?@"e":(self.currentType == UpperCase?@"E":@"2");
    }else if (index == 3){
        key = self.currentType == LowerCase?@"r":(self.currentType == UpperCase?@"R":@"3");
    }else if (index == 4){
        key = self.currentType == LowerCase?@"t":(self.currentType == UpperCase?@"T":@"4");
    }else if (index == 5){
        key = self.currentType == LowerCase?@"y":(self.currentType == UpperCase?@"Y":@"5");;
    }else if (index == 6){
        key = self.currentType == LowerCase?@"u":(self.currentType == UpperCase?@"U":@"6");
    }else if (index == 7){
        key = self.currentType == LowerCase?@"i":(self.currentType == UpperCase?@"I":@"7");
    }else if (index == 8){
        key = self.currentType == LowerCase?@"o":(self.currentType == UpperCase?@"O":@"8");
    }else if (index == 9){
        key = self.currentType == LowerCase?@"p":(self.currentType == UpperCase?@"P":@"9");
    }else if (index == 10){
        key = self.currentType == LowerCase?@"a":(self.currentType == UpperCase?@"A":@"-");
    }else if (index == 11){
        key = self.currentType == LowerCase?@"s":(self.currentType == UpperCase?@"S":@"/");
    }else if (index == 12){
        key = self.currentType == LowerCase?@"d":(self.currentType == UpperCase?@"D":@"*");
    }else if (index == 13){
        key = self.currentType == LowerCase?@"f":(self.currentType == UpperCase?@"F":@":");
    }else if (index == 14){
        key = self.currentType == LowerCase?@"g":(self.currentType == UpperCase?@"G":@"(");
    }else if (index == 15){
        key = self.currentType == LowerCase?@"h":(self.currentType == UpperCase?@"H":@")");
    }else if (index == 16){
        key = self.currentType == LowerCase?@"j":(self.currentType == UpperCase?@"J":@"?");
    }else if (index == 17){
        key = self.currentType == LowerCase?@"k":(self.currentType == UpperCase?@"K":@"@");
    }else if (index == 18){
        key = self.currentType == LowerCase?@"l":(self.currentType == UpperCase?@"L":@"+");
    }else if (index == 19){
        key = self.currentType == LowerCase?@"s_shift":(self.currentType == UpperCase?@"b_shift":@";");
    }else if (index == 20){
        key = self.currentType == LowerCase?@"z":(self.currentType == UpperCase?@"Z":@".");
    }else if (index == 21){
        key = self.currentType == LowerCase?@"x":(self.currentType == UpperCase?@"X":@"‘");
    }else if (index == 22){
        key = self.currentType == LowerCase?@"c":(self.currentType == UpperCase?@"C":@"“");
    }else if (index == 23){
        key = self.currentType == LowerCase?@"v":(self.currentType == UpperCase?@"V":@"`");
    }else if (index == 24){
        key = self.currentType == LowerCase?@"b":(self.currentType == UpperCase?@"B":@"。");
    }else if (index == 25){
        key = self.currentType == LowerCase?@"n":(self.currentType == UpperCase?@"N":@"!");
    }else if (index == 26){
        key = self.currentType == LowerCase?@"m":(self.currentType == UpperCase?@"M":@"，");
    }else if (index == 27){
        key = @"delete";
    }else if (index == 28){
        key = self.currentType == LowerCase?@"123":(self.currentType == UpperCase?@"123":@"abc");
    }else if (index == 29){
        key = @" ";
    }else if (index == 30){
        key = @"return";
    }
    
    return key;
}

- (void)removeObject
{
    if (_background) {
        [_background removeObject];
        _background = nil;
    }
    
    if (_keyArrs) {
        [_keyArrs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SZTImageView * obj, NSUInteger idx, BOOL *stop) {
            [obj removeObject];
            [_keyArrs removeObject:obj];
        }];
        _keyArrs = nil;
    }
}

- (void)dealloc
{
    [self removeObject];
    
    SZTLog(@"SZTKeyBoardBar dealloc");
}
@end
