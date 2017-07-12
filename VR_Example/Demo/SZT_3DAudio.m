//
//  3DAudio.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/15.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZT_3DAudio.h"
#import "SZTLibrary.h"
#import "SZTAudio.h"
#import "Sound.h"

@interface SZT_3DAudio ()
{
    SZTAudio *audio;
    Sound *sounds;
}

@property(nonatomic, strong)SZTLibrary *sztlibrary;

@end

@implementation SZT_3DAudio

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sztlibrary = [[SZTLibrary alloc] initWithController:self];
    [self.sztlibrary setFocusPicking:YES];
    
    audio = [[SZTAudio alloc] init];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"mp3"];
    sounds = [[Sound alloc] initWithFilePath:path];
    [audio addSubAudio:sounds];
    [sounds setPosition:0.0 Y:0.0 Z:-50.0];
}

- (void)dealloc
{
    [audio destory];
    audio = nil;
    
    [sounds destory];
    sounds = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
