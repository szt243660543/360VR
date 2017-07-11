//
//  SZT_IJKPlayerDemo.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/20.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZT_IJKPlayerDemo.h"
#import "SZTLibrary.h"
#import "SZTVideo.h"

@interface SZT_IJKPlayerDemo()

@property(nonatomic, strong)SZTLibrary *sztLibrary;
@property(nonatomic, strong)SZTVideo *sztVideo;

@end

@implementation SZT_IJKPlayerDemo

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSDK];
    
    [self backBtn];
    
    [self loadVideo];
}

- (void)loadSDK
{
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
}

// 可以在场景中同时播放多个视频,只需要实例多个video对象
- (void)loadVideo
{
    NSString *itemPath = [[NSBundle mainBundle] pathForResource:@"skyrim360" ofType:@".mp4"];
    NSURL *url = [NSURL fileURLWithPath:itemPath];
//    NSURL *url = [NSURL URLWithString:@"rtmp://10.0.4.193:1935/live1/room1"];
    
    self.sztVideo = [[SZTVideo alloc] initIJKPlayerVideoWithURL:url VideoMode:SZTVR_SPHERE isVideoToolBox:YES videoFrameMode:SZTVIDEO_DEFAULT];
    /******* SZTVideoFrameMode  可以强制修改视频输出的大小 ******/
    [self.sztLibrary addSubObject:self.sztVideo];
}

@end
