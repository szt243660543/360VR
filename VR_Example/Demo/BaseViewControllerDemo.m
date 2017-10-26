//
//  BaseViewControllerDemo.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/15.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "BaseViewControllerDemo.h"

@interface BaseViewControllerDemo ()

@end

@implementation BaseViewControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self rotateView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self backBtn];
}

- (void)rotateView
{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    swapt(&width, &height);
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeRotation(M_PI*0.5);
        self.view.frame = CGRectMake(0, 0, width, height);
    }];
}

- (void)backBtn
{
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.height - 50, self.view.frame.size.width - 50, 50, 50)];
    back.backgroundColor = [UIColor redColor];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:back atIndex:999.0];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
