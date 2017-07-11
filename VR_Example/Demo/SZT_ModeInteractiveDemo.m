//
//  SZT_ModeInteractiveDemo.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/20.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZT_ModeInteractiveDemo.h"
#import "SZTImageView.h"
#import "SZTLibrary.h"

@interface SZT_ModeInteractiveDemo()
{
    int _modeTag;
}

@property(nonatomic, strong)SZTLibrary *SZTLibrary;

@property(nonatomic, strong)SZTImageView * back;

@end

@implementation SZT_ModeInteractiveDemo

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _modeTag = 0;
    
    [self loadButton];
    
    self.SZTLibrary = [[SZTLibrary alloc] initWithController:self];
    
    _back = [[SZTImageView alloc] initWithMode:SZTVR_SPHERE];
    [_back setupTextureWithImage:[UIImage imageNamed:@"vrbackbround.jpg"]];
    [self.SZTLibrary addSubObject:_back];
}

- (void)loadButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 100, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"陀螺仪" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)click:(UIButton *)btn
{
    if (_modeTag == 0) {
        [btn setTitle:@"触摸" forState:UIControlStateNormal];
        [self.SZTLibrary interactiveMode:SZTModeInteractiveTouch];
    }else if(_modeTag == 1){
        [btn setTitle:@"陀螺仪" forState:UIControlStateNormal];
        [self.SZTLibrary interactiveMode:SZTModeInteractiveMotion];
    }else{
        [btn setTitle:@"陀A触" forState:UIControlStateNormal];
        [self.SZTLibrary interactiveMode:SZTModeInteractiveMotionWithTouch];
        _modeTag = -1;
    }
    
    _modeTag++;
}

@end
