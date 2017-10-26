//
//  SZTAlertView.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2017/1/11.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTAlertView.h"

@interface SZTAlertView()
{
    float _offsetZ;
}

@property(nonatomic, strong)SZTImageView *bg;

@property(nonatomic, strong)SZTLabel *title;

@property(nonatomic, strong)SZTLabel *message;

@property(nonatomic, strong)SZTImageView *cancelButton;
@property(nonatomic, strong)SZTLabel *cancelLabel;

@end

@implementation SZTAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtonTitles:(NSArray *)titlesStr
{
    self = [super init];
    
    if (self) {
        _offsetZ = 0.1;
        
        [self loadBackground];
        
        [self loadTitle:title];
        
        [self loadMessage:message];
        
        [self loadCancelButton:cancelTitle];
        
        [self setObjectSize:self.objSize.width Height:self.objSize.height];
    }
    
    return self;
}

- (void)loadBackground
{
    _bg = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    [_bg setupTextureWithImage:[UIImage imageNamed:@"modeUI_Background.png"]];
}

- (void)loadTitle:(NSString *)title
{
    if (title) {
        _title = [[SZTLabel alloc] init];
        [_title setText:title];
        _title.lineNumber = (int)[title length];
    }
}

- (void)loadMessage:(NSString *)message
{
    if (message) {
        _message = [[SZTLabel alloc] init];
        [_message setText:message];
        _message.lineNumber = (int)[message length] <= 6?(int)[message length]:6;
    }
}

- (void)loadCancelButton:(NSString *)cancelTitle
{
    if (cancelTitle) {
        _cancelLabel = [[SZTLabel alloc] init];
        [_cancelLabel setText:cancelTitle];
        _cancelLabel.lineNumber = (int)[cancelTitle length];
    }
    
    _cancelButton = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    [_cancelButton setupTextureWithImage:[UIImage imageNamed:@"button.png"]];

    SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:_cancelButton];
    
    [touch willTouchCallBack:^(GLKVector3 vec) {
        
    }];
    
    [touch didTouchCallback:^(GLKVector3 vec) {
        [self destory];
    }];
    
    [touch endTouchCallback:^(GLKVector3 vec) {
        
    }];
}

- (void)setObjectSize:(float)width Height:(float)height
{
    [_bg setObjectSize:width Height:height];
    
    [_title setObjectSize:width * 0.5 Height:height * 0.25];
    
    [_message setObjectSize:width * 0.9 Height:height * 0.5];
    
    [_cancelButton setObjectSize:width * 0.9 Height:height * 0.25];
    [_cancelLabel setObjectSize:width * 0.5 Height:height * 0.25];
}

- (void)setPosition:(float)x Y:(float)y Z:(float)z
{
    [_bg setPosition:x Y:y Z:z];
    
    [_title setPosition:x Y:y + (_bg.objSize.height - _title.objSize.height)/100.0 Z:z + _offsetZ];
    
    [_message setPosition:x Y:y Z:z + _offsetZ];
    
    [_cancelButton setPosition:x Y:y - (_bg.objSize.height - _cancelButton.objSize.height)/100.0 Z:z + _offsetZ];
    [_cancelLabel setPosition:x Y:y - (_bg.objSize.height - _cancelButton.objSize.height)/100.0 Z:z + _offsetZ + 0.1];
}

- (void)build
{
    [_bg build];
    
    [_title build];
    
    [_message build];
    
    [_cancelButton build];
    [_cancelLabel build];
}

- (void)destory
{
    if (_bg) {
        [_bg destory];
        _bg = nil;
    }
    
    if (_title) {
        [_title destory];
        _title = nil;
    }
    
    if (_message) {
        [_message destory];
        _message = nil;
    }
    
    if (_cancelButton) {
        [_cancelButton destory];
        _cancelButton = nil;
    }
    
    if (_cancelLabel) {
        [_cancelLabel destory];
        _cancelLabel = nil;
    }
}

- (void)dealloc
{
    SZTLog(@"SZTAlertView dealloc");
    
    [self destory];
}

@end
