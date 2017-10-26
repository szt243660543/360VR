//
//  ScriptUI.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/21.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "ScriptUI.h"
#import "SZTJson.h"
#import "MJ2Extension.h"
#import "MathC.h"
#import "SceneUI.h"
#import "ScriptUtil.h"

@interface ScriptUI ()<SceneUIDelegate>
{
    vrkongfu *_result;
    SceneUI *_sceneUI;
    AVAudioPlayer *_avPlayer;
    SZTImageView *_mainBg;
}

@end

@implementation ScriptUI

- (instancetype)initWithJsonName:(NSString *)jsonName
{
    self = [super init];
    
    if (self) {
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:jsonName ofType:nil]];
        
        [self initData:data isSandBoxPath:NO];
    }
    
    return self;
}

- (instancetype)initWithSandboxPath:(NSString *)jsonPath
{
    self = [super init];
    
    if (self) {
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    
        [self initData:data isSandBoxPath:YES];
    }
    
    return self;
}

- (void)initData:(NSData *)data isSandBoxPath:(BOOL)isSandBox
{
    [self decodeJson:data];
    
    [[ScriptUtil sharedScriptUtil] setJsonData:_result];
    [ScriptUtil sharedScriptUtil].isSandBoxPath = isSandBox;
    
    [self setVideoPlayer:SZT_AVPlayer];
}

- (void)loadHotUpdateJson:(NSString *)jsonPath
{
    // 还没实现
}

- (void)setVideoPlayer:(VideoPLayerMode)playerMode
{
    switch (playerMode) {
        case SZT_AVPlayer:
            [ScriptUtil sharedScriptUtil].isUseIjkPlayer = false;
            break;
        case SZT_IJKPlayer:
            [ScriptUtil sharedScriptUtil].isUseIjkPlayer = true;
            break;
        default:
            break;
    }
}

- (void)decodeJson:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    _result = [vrkongfu mj_objectWithKeyValues:dic];
}

- (void)build
{
    [self addObserver];
    
    [self loadSceneBg];
    
    [self loadSceneSound];
    
    [self loadScene:[[ScriptUtil sharedScriptUtil] getMainScene]];
}

- (void)loadSceneBg
{
    _mainBg = [[SZTImageView alloc] initWithMode:SZTVR_SPHERE];
    
    NSString * bgMaterialID = [[ScriptUtil sharedScriptUtil] getBgMaterialIDByProperties];
    if ([bgMaterialID isEqualToString:@""]) {
        return;
    }
    
    material *material = [[ScriptUtil sharedScriptUtil] getMaterialByMaterialID:bgMaterialID];
    
    if (material.online) {
        UIImage *paceholderImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"placeholderBack.jpg" ofType:nil]];
        [_mainBg setupTextureWithUrl:material.url Paceholder:paceholderImg];
    }else{
        NSString *path = [NSString stringWithFormat:@"%@%@",[[ScriptUtil sharedScriptUtil] getLocalFilePath], material.url];
        [_mainBg setupTextureWithFileName:path];
    }
    
    [_mainBg setRotate:0.0 radiansY:0.0 radiansZ:0.0];
    [_mainBg build];
}

- (void)loadSceneSound
{
    NSString * soundID = [[ScriptUtil sharedScriptUtil] getMainSound];
    if ([soundID isEqualToString:@""]) {
        return;
    }
    
    material *material = [[ScriptUtil sharedScriptUtil] getMaterialByMaterialID:soundID];
    
    if (material.online) {
        
    }else{
        NSString *path = [NSString stringWithFormat:@"%@%@",[[ScriptUtil sharedScriptUtil] getLocalFilePath], material.url];
        NSURL *url = [NSURL fileURLWithPath:path];
        _avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    
    _avPlayer.volume = 0.05;
    _avPlayer.numberOfLoops = 100;
    [_avPlayer prepareToPlay];
    [_avPlayer play];
}

- (void)loadScene:(NSString *)sceneID
{
    if (_sceneUI) {
        [_sceneUI destory];
        _sceneUI = nil;
    }
    
    SZTLog(@"sceneID=====%@",sceneID);
    scene *scene = [[ScriptUtil sharedScriptUtil] getSceneBySceneID:sceneID];
    _sceneUI = [[SceneUI alloc] initWithSceneData:scene];
    _sceneUI.delegate = self;
    
    [_sceneUI build];
}

- (void)seekTime:(float)time
{
    [_sceneUI.sceneVideo seekToTime:time];
}

#pragma mark delegate
- (void)didChangeSceneBySceneID:(NSString *)sceneID
{
    SZTLog(@"sceneID=====%@",sceneID);
    [self loadScene:sceneID];
}

#pragma mark destory
- (void)destory
{
    if (_sceneUI) {
        [_sceneUI destory];
        _sceneUI = nil;
    }
    
    if (_mainBg) {
        [_mainBg destory];
        _mainBg = nil;
    }
    
    if (_avPlayer) {
        [_avPlayer stop];
        _avPlayer = nil;
    }
}

- (void)dealloc
{
    [self destory];
    SZTLog(@"ScriptUI dealloc");
}

@end
