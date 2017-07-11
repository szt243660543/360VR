//
//  SZT_DistortionDemo.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/15.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZT_DistortionDemo.h"
#import "SZTLibrary.h"
#import "SZTImageView.h"

@interface SZT_DistortionDemo ()
{
    int _modeTag;
}

@property(nonatomic, strong)SZTLibrary *SZTLibrary;

@end

@implementation SZT_DistortionDemo

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _modeTag = 0;
    
    [self loadButton];
    
    self.SZTLibrary = [[SZTLibrary alloc] initWithController:self];
    [self.SZTLibrary distortionMode:SZTDistortionNormal];
    
    SZTImageView * back = [[SZTImageView alloc] initWithMode:SZTVR_SPHERE];
    [back setupTextureWithImage:[UIImage imageNamed:@"vrbackbround.jpg"]];
    [self.SZTLibrary addSubObject:back];
}

- (void)loadButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 100, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"无畸变" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)click:(UIButton *)btn
{
    if (_modeTag == 0) {
        [btn setTitle:@"畸变" forState:UIControlStateNormal];
        [self.SZTLibrary distortionMode:SZTBarrelDistortion];
    }else{
        [btn setTitle:@"无畸变" forState:UIControlStateNormal];
        [self.SZTLibrary distortionMode:SZTDistortionNormal];
        _modeTag = -1;
    }
    
    _modeTag++;
}

@end
