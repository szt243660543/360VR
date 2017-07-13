//
//  SZT_ModeDisplayDemo.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/20.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZT_ModeDisplayDemo.h"
#import "SZTLibrary.h"
#import "SZTImageView.h"

@interface SZT_ModeDisplayDemo()
{
    int _modeTag;
}

@property(nonatomic, strong)SZTLibrary *SZTLibrary;

@end

@implementation SZT_ModeDisplayDemo

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _modeTag = 0;
    
    [self loadButton];
    
    self.SZTLibrary = [[SZTLibrary alloc] initWithController:self];
    
    SZTImageView * back = [[SZTImageView alloc] initWithMode:SZTVR_SPHERE];
    [back setupTextureWithImage:[UIImage imageNamed:@"placeholderBack.jpg"]];
    [self.SZTLibrary addSubObject:back];
}

- (void)loadButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 100, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"双屏" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)click:(UIButton *)btn
{
    if (_modeTag == 0) {
        [btn setTitle:@"单屏" forState:UIControlStateNormal];
        [self.SZTLibrary dispalyMode:SZTModeDisplayNormal];
    }else{
        [btn setTitle:@"双屏" forState:UIControlStateNormal];
        [self.SZTLibrary dispalyMode:SZTModeDisplayGlass];
        _modeTag = -1;
    }
    
    _modeTag++;
}

@end
