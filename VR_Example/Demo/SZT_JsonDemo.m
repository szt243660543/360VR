//
//  SZT_JsonDemo.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/15.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZT_JsonDemo.h"
#import "SZTLibrary.h"
#import "ScriptUI.h"

#define SANDBOXPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface SZT_JsonDemo ()
{
    ScriptUI *script;
}

@property(nonatomic, strong)SZTLibrary * sztLibrary;

@end

@implementation SZT_JsonDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backBtn];
    
    // 创建SDK
    self.sztLibrary = [[SZTLibrary alloc] initWithController:self];
    [self.sztLibrary setFocusPicking:YES]; // 开启热点交互
    
    /*** json 脚本****/
    NSString *path = [NSString stringWithFormat:@"%@/%@",SANDBOXPATH, @"supermarket.json"];
    
    script = [[ScriptUI alloc] initWithSandboxPath:path];
    [script setVideoPlayer:SZT_IJKPlayer];
    [self.sztLibrary addSubObject:script];
}

@end
