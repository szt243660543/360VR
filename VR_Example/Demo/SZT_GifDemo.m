//
//  SZT_GifDemo.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/20.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZT_GifDemo.h"
#import "SZTLibrary.h"
#import "SZTGif.h"
#import "SZTImageView.h"

@interface SZT_GifDemo()

@property(nonatomic, strong)SZTLibrary *sztLibrary;

@property(nonatomic, strong)SZTGif *gif_local;

@property(nonatomic, strong)SZTGif *gif_net;

@end

@implementation SZT_GifDemo

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadButton];
    
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
    
    // 背景图
    SZTImageView * back = [[SZTImageView alloc] initWithMode:SZTVR_SPHERE];
    [back setupTextureWithImage:[UIImage imageNamed:@"vrbackbround.jpg"]];
    [self.sztLibrary addSubObject:back];
}

- (void)loadButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 80, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"网络gif" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addButton1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(90, self.view.frame.size.height - 50, 80, 50)];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"本地gif" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(addButton2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

- (void)addButton1
{
    _gif_net = [[SZTGif alloc] init];
    _gif_net.repeatTimes = 1;
    NSURL * gif_url = [NSURL URLWithString:@"http://www.gifs.net/Animation11/Food_and_Drinks/Fruits/Apple_jumps.gif"];
    NSString *gifPath = [gif_url absoluteString];
    [_gif_net setupGifWithFileUrl:gifPath];
    [_gif_net setPosition:-5.0 Y:-3.0 Z:-15];
    [_gif_net gifDidFinishedCallback:^(SZTGif *gif) {
        NSLog(@"gif - 播放完毕回调");
    }];
    [self.sztLibrary addSubObject:_gif_net];
}

- (void)addButton2
{
    _gif_local = [[SZTGif alloc] init];
    _gif_local.repeatTimes = 1;
    [_gif_local setupGifWithGifName:@"gifTest.gif"];
    [_gif_local setObjectSize:600.0 Height:300.0];
    [_gif_local setPosition:4.0 Y:-3.0 Z:-15];
    [_gif_local gifDidFinishedCallback:^(SZTGif *gif) {
        NSLog(@"gif1 - 播放完毕回调");
    }];
    [self.sztLibrary addSubObject:_gif_local];
}

@end
