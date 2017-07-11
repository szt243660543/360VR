//
//  SZT_AVPlayerDemo.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/20.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZT_AVPlayerDemo.h"
#import "SZTLibrary.h"
#import "SZTVideo.h"

@interface SZT_AVPlayerDemo()<SZTVideoDelegate>
{
    int _modeTag;
    int _filterTag;
}

@property(nonatomic, strong)SZTLibrary *sztLibrary;
@property(nonatomic, strong)SZTVideo *sztVideo;

@end

@implementation SZT_AVPlayerDemo

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _modeTag = 0;
    _filterTag = 0;
    
    [self loadButton];
    
    [self loadSDK];
    
    [self loadVideo];
}

- (void)loadSDK
{
    // load sdk
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
}

- (void)loadVideo
{
    // add video to vr render
    NSString *itemPath = [[NSBundle mainBundle] pathForResource:@"skyrim360" ofType:@".mp4"];
    NSURL *url = [NSURL fileURLWithPath:itemPath];
    
    //    NSURL *url = [NSURL URLWithString:@"http://vrkongfu.oss-cn-hangzhou.aliyuncs.com/movie/111mobile.mp4"];
    
    self.sztVideo = [[SZTVideo alloc] initAVPlayerVideoWithURL:url VideoMode:SZTVR_SPHERE];
    self.sztVideo.delegate = self;
    [self.sztLibrary addSubObject:self.sztVideo];
}

- (void)loadButton
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 100, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"全景" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(110, self.view.frame.size.height - 50, 100, 50)];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitle:@"滤波器" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
}

- (void)click:(UIButton *)btn
{
    if (_modeTag == 2 || _modeTag == 4 || _modeTag == 1) {
        [self.sztVideo setObjectSize:512.0 Height:256.0];
        [self.sztVideo setPosition:0.0 Y:0.0 Z:-15.0];
    }else{
        [self.sztVideo setObjectSize:2.0 Height:2.0];
        [self.sztVideo setPosition:0.0 Y:0.0 Z:0.0];
    }
    
    if (_modeTag == 0) {
        [btn setTitle:@"3D180" forState:UIControlStateNormal];
        [self.sztVideo changeDisplayMode:SZTVR_STEREO_HEMISPHERE];
    }else if(_modeTag == 1){
        [btn setTitle:@"平面" forState:UIControlStateNormal];
        [self.sztVideo changeDisplayMode:SZTVR_PLANE];
    }else if(_modeTag == 2){
        [btn setTitle:@"平面左右" forState:UIControlStateNormal];
        [self.sztVideo changeDisplayMode:SZTVR_STEREO_PLANE_LEFT_RIGHT];
    }else if(_modeTag == 3){
        [btn setTitle:@"立体全景" forState:UIControlStateNormal];
        [self.sztVideo changeDisplayMode:SZTVR_STEREO_SPHERE];
    }else if(_modeTag == 4){
        [btn setTitle:@"平面上下" forState:UIControlStateNormal];
        [self.sztVideo changeDisplayMode:SZTVR_STEREO_PLANE_UP_DOWN];
    }else{
        [btn setTitle:@"全景" forState:UIControlStateNormal];
        [self.sztVideo changeDisplayMode:SZTVR_SPHERE];
        _modeTag = -1;
    }
    
    _modeTag ++;
}

- (void)click1:(UIButton *)btn
{
    if (_filterTag == 0) {
        [self.sztVideo changeFilter:SZTVR_LUMINANCE];
    }else if (_filterTag == 1){
        [self.sztVideo changeFilter:SZTVR_PIXELATE];
        self.sztVideo.particles = 64.0;
    }else if (_filterTag == 2){
        [self.sztVideo changeFilter:SZTVR_EXPOSURE];
        self.sztVideo.exposure = 0.5;
    }else if (_filterTag == 3){
        [self.sztVideo changeFilter:SZTVR_DISCRETIZE];
    }else if (_filterTag == 4){
        [self.sztVideo changeFilter:SZTVR_BLUR];
        self.sztVideo.radius = 0.02;
    }else if (_filterTag == 5){
        [self.sztVideo changeFilter:SZTVR_HUE];
        self.sztVideo.hueAdjust = 180.0;
    }else if (_filterTag == 6){
        [self.sztVideo changeFilter:SZTVR_POLKADOT];
        self.sztVideo.fractionalWidthOfPixel = 0.03;
        self.sztVideo.aspectRatio = 1.0;
        self.sztVideo.dotScaling = 0.90;
    }else if (_filterTag == 7){
        [self.sztVideo changeFilter:SZTVR_GAMMA];
        self.sztVideo.gamma = 0.5;
    }else if (_filterTag == 8){
        [self.sztVideo changeFilter:SZTVR_GLASSSPHERE];
        self.sztVideo.refractiveIndex = 0.71;
        self.sztVideo.aspectRatio = 9.0/16.0;
        self.sztVideo.radius = 0.25;
    }else if (_filterTag == 9){
        [self.sztVideo changeFilter:SZTVR_BILATERAL];
    }else if (_filterTag == 10){
        [self.sztVideo changeFilter:SZTVR_CROSSHATCH];
        self.sztVideo.crossHatchSpacing = 0.05;
        self.sztVideo.lineWidth = 0.005;
    }else{
        [self.sztVideo changeFilter:SZTVR_NORMAL];
        _filterTag = -1;
    }
    
    _filterTag ++;
}

- (void)videoIsReadyToPlay:(SZTVideo *)video
{
    
}

- (void)dealloc
{
    
}

@end
