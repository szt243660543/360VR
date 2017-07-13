//
//  SZT_ProgressDemo.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/16.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZT_ProgressDemo.h"
#import "SZTPrograssBar.h"
#import "SZTLibrary.h"
#import "SZTTouch.h"

@interface SZT_ProgressDemo ()

@property(nonatomic, strong)SZTLibrary * sztLibrary;

@end

@implementation SZT_ProgressDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backBtn];
    
    // 创建SDK
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
    [self.sztLibrary distortionMode:SZTDistortionNormal]; // 无畸变
    [self.sztLibrary dispalyMode:SZTModeDisplayGlass]; // 分屏模式
    [self.sztLibrary interactiveMode:SZTModeInteractiveMotion]; //陀螺仪
    [self.sztLibrary setFocusPicking:YES]; // 开启热点交互
    [self.sztLibrary setSensorWithGvr:SZTSensorGvr];
    
    SZTImageView *back = [[SZTImageView alloc] initWithMode:SZTVR_SPHERE];
    [back setupTextureWithImage:[UIImage imageNamed:@"vrbackbround.jpg"]];
    [self.sztLibrary addSubObject:back];
    
    SZTPrograssBar * bar = [[SZTPrograssBar alloc] initWithMode:SZTVR_PLANE];
    [bar setupTextureWithImage:[UIImage imageNamed:@"inputbox.png"]];
    [self.sztLibrary addSubObject:bar];
    [bar setPosition:0.0 Y:0.0 Z:-25.0];
    
    SZTTouch *touch = [[SZTTouch alloc] initWithTouchObject:bar];
    
    [touch willTouchCallBack:^(GLKVector3 vec) {
        
    }];
    
    [touch didTouchCallback:^(GLKVector3 vec) {
        [bar seekTo:vec.x/bar.objSize.width*50.0 Dir:X];
    }];
    
    [touch endTouchCallback:^(GLKVector3 vec) {
        
    }];
}

@end
