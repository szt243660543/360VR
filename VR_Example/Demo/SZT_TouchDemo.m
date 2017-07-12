//
//  SZT_TouchDemo.m
//  VR_Example
//
//  Created by szt on 2017/7/12.
//  Copyright © 2017年 VR. All rights reserved.
//

#import "SZT_TouchDemo.h"
#import "SZTLibrary.h"
#import "SZTTouch.h"
#import "SZTImageView.h"

@interface SZT_TouchDemo ()

@property(nonatomic, strong)SZTLibrary * sztLibrary;

@end

@implementation SZT_TouchDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
    
    // 要使用热点拾取功能，一定需要设置该接口
    [self.sztLibrary setFocusPicking:YES];
    
    
    SZTImageView *image = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    [image setupTextureWithImage:[UIImage imageNamed:@"pic.jpg"]];
    [image setObjectSize:200.0 Height:100.0];
    [self.sztLibrary addSubObject:image];
    [image setPosition:5.0 Y:0.0 Z:-20.0];
    
    
    // 热点拾取
    SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:image];
    
    [touch willTouchCallBack:^(GLKVector3 vec) {
        NSLog(@"will select");
    }];
    
    [touch didTouchCallback:^(GLKVector3 vec) {
        NSLog(@"select");
    }];
    
    [touch endTouchCallback:^(GLKVector3 vec) {
        NSLog(@"will leave");
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
