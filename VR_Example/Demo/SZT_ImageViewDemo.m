//
//  SZT_ImageViewDemo.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/20.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZT_ImageViewDemo.h"
#import "SZTLibrary.h"
#import "SZTImageView.h"

@interface SZT_ImageViewDemo()

@property(nonatomic, strong)SZTLibrary *sztLibrary;

@end

@implementation SZT_ImageViewDemo

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadButton];
    
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
    
    // 创建全景图
    SZTImageView *back = [[SZTImageView alloc] initWithMode:SZTVR_SPHERE];
    [back setupTextureWithImage:[UIImage imageNamed:@"vrbackbround.jpg"]];
    [self.sztLibrary addSubObject:back];
}

- (void)loadButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 80, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"网络图" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addButton1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(180, self.view.frame.size.height - 50, 80, 50)];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"本地图" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(addButton2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

- (void)addButton1
{
    SZTImageView *image = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    NSURL * url = [NSURL URLWithString:@"http://h.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=d8d47aee8435e5dd9079add946f68bd7/f31fbe096b63f624fc76a3bf8644ebf81a4ca367.jpg"];
    NSString *urlPath = [url absoluteString];
    [image setupTextureWithUrl:urlPath Paceholder:[UIImage imageNamed:@"paceholder.jpg"]];
    [self.sztLibrary addSubObject:image];
    [image setPosition:-5.0 Y:0.0 Z:-20.0];
    [image setObjectSize:200.0 Height:100.0]; // 强制设置图片大小
}

- (void)addButton2
{
    SZTImageView *image = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
    [image setupTextureWithImage:[UIImage imageNamed:@"pic.jpg"]];
    [image setObjectSize:200.0 Height:100.0];
    [self.sztLibrary addSubObject:image];
    [image setPosition:5.0 Y:0.0 Z:-20.0];
}

@end
