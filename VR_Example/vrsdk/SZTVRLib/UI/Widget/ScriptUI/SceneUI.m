//
//  SceneUI.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/26.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SceneUI.h"
#import "WidgetUI.h"
#import "ScriptUtil.h"
#import "FileTool.h"
#import "ActionsManager.h"

#define MAX_NUM 1000000.0

@interface SceneUI()<SZTVideoDelegate,ActionsManagerDelegate>
{
    scene *_scene;
    
    NSMutableArray *_widgetArray;
    CADisplayLink *_displayLink;
}

@end

@implementation SceneUI

- (instancetype)initWithSceneData:(scene *)sceneData
{
    self = [super init];
    
    if (self) {
        _scene = sceneData;
        
        _widgetArray = [NSMutableArray array];
        
        [ActionsManager sharedActionsManager].delegate = self;
    }
    
    return self;
}

- (void)build
{
    [self loadScene];
}

- (void)loadScene
{
    if ([_scene.materialID isEqualToString:@""]){
        [self loadWidgets];
    }else{
        material *material = [[ScriptUtil sharedScriptUtil] getMaterialByMaterialID:_scene.materialID];
        
        if ([material.type isEqualToString:@"360Video"] || [material.type isEqualToString:@"3D180"]|| [material.type isEqualToString:@"3D360"]) {
            NSURL *url;
            
            if (material.online) {
                url = [NSURL URLWithString:material.url];
            }else{
                NSString *path = [NSString stringWithFormat:@"%@%@",[[ScriptUtil sharedScriptUtil] getLocalFilePath], material.url];
                url = [NSURL fileURLWithPath:path];
            }
            
            if ([material.type isEqualToString:@"360Video"]) {
                if ([ScriptUtil sharedScriptUtil].isUseIjkPlayer) {
                    _sceneVideo = [[SZTVideo alloc] initIJKPlayerVideoWithURL:url VideoMode:SZTVR_SPHERE isVideoToolBox:YES videoFrameMode:[self getVideoFrameMode]];
                }else{
                    _sceneVideo = [[SZTVideo alloc] initAVPlayerVideoWithURL:url VideoMode:SZTVR_SPHERE];
                }
            }else if([material.type isEqualToString:@"3D180"]){
                if ([ScriptUtil sharedScriptUtil].isUseIjkPlayer) {
                    _sceneVideo = [[SZTVideo alloc] initIJKPlayerVideoWithURL:url VideoMode:SZTVR_STEREO_HEMISPHERE isVideoToolBox:YES videoFrameMode:[self getVideoFrameMode]];
                }else{
                    _sceneVideo = [[SZTVideo alloc] initAVPlayerVideoWithURL:url VideoMode:SZTVR_STEREO_HEMISPHERE];
                }
            }else{
                if ([ScriptUtil sharedScriptUtil].isUseIjkPlayer) {
                    _sceneVideo = [[SZTVideo alloc] initIJKPlayerVideoWithURL:url VideoMode:SZTVR_STEREO_SPHERE isVideoToolBox:YES videoFrameMode:[self getVideoFrameMode]];
                }else{
                    _sceneVideo = [[SZTVideo alloc] initAVPlayerVideoWithURL:url VideoMode:SZTVR_STEREO_SPHERE];
                }
            }
            [_sceneVideo setRotate:0.0 radiansY:0.0 radiansZ:0.0];
            _sceneVideo.delegate = self;
            [_sceneVideo build];
            [self displayLink];
        }else if ([material.type isEqualToString:@"360Image"]){
            _sceneBg = [[SZTImageView alloc] initWithMode:SZTVR_SPHERE];
            
            if (material.online) {
                UIImage *paceholderImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"placeholderBack.jpg" ofType:nil]];
                [_sceneBg setupTextureWithUrl:material.url Paceholder:paceholderImg];
            }else{
                NSString *path = [NSString stringWithFormat:@"%@%@",[[ScriptUtil sharedScriptUtil] getLocalFilePath], material.url];
                [_sceneBg setupTextureWithFileName:path];
            }
            
            [_sceneBg build];
            [_sceneBg setRotate:0.0 radiansY:0.0 radiansZ:0.0];
            
            [self loadWidgets];
        }
    }
}

- (void)displayLink
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)update
{
    // 实时更新
    float time;
    
    time = _sceneVideo.currentTime;
    
    [self loadWidgetsAccordingTime:time];
}

- (void)loadWidgetsAccordingTime:(float)time
{
    for (NSString *widgetid in _scene.widgets) {
        widget * widget = [[ScriptUtil sharedScriptUtil] getWidgetByMaterialID:widgetid];
        widget.end = widget.end < 0.0?widget.end = MAX_NUM:widget.end;
        if (time > widget.start && time < widget.end) {
            if (!widget.isExist) {
                // add
                [self addWidgetUI:widget];
                
                widget.isExist = true;
            }
        }else{
            widget.isExist = false;
            // remove
            [self removeWidget:widget];
        }
    }
}

- (SZTVideoFrameMode)getVideoFrameMode
{
    SZTVideoFrameMode mode;
    
    NSString * phoneModel =  [FileTool deviceVersion];
    
    if ([phoneModel isEqualToString:@"iPhone 6"]||[phoneModel isEqualToString:@"iPhone 6 Plus"]) {
        mode = SZTVIDEO_FRAME_1440P;
    }else if([phoneModel isEqualToString:@"iPhone 5"]||[phoneModel isEqualToString:@"iPhone 5C"]||[phoneModel isEqualToString:@"iPhone 5S"]){
        mode = SZTVIDEO_FRAME_1080P;
    }else{
        mode = SZTVIDEO_FRAME_1920P;
    }
    
    return mode;
}

- (void)loadWidgets
{
    for (NSString *widgetid in _scene.widgets) {
        widget * widget = [[ScriptUtil sharedScriptUtil] getWidgetByMaterialID:widgetid];
        // add
        [self addWidgetUI:widget];
    }
}

- (void)addWidgetUI:(widget *)widget
{
    WidgetUI *widgetUI = [[WidgetUI alloc] initWithWidgetData:widget];
    [widgetUI loadActionStart];
    [_widgetArray addObject:widgetUI];
}

- (void)removeWidget:(widget *)widget
{
    [_widgetArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(WidgetUI * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.widgetID isEqualToString:widget.widgetID]) {
            [obj loadActionEnd];
            [obj destory];
            [_widgetArray removeObject:obj];
        }
    }];
}

- (void)videoDidPlayBcakFinished:(SZTVideo *)video
{
    if (![_scene.nextScene isEqualToString:@""]) {
        [self actionTypeChangeScene:_scene.nextScene];
    }
}

#pragma mark delegate
- (void)actionTypeSeek:(float)time
{
    [_sceneVideo seekToTime:time];
}

- (void)actionTypePlay
{
    [_sceneVideo play];
}

-(void)actionTypePause
{
    [_sceneVideo pause];
}

- (void)actionTypeAddGroup:(action *)action
{
    for (NSString *widgetid in _scene.widgets) {
        widget * widget = [[ScriptUtil sharedScriptUtil] getWidgetByMaterialID:widgetid];
        if ([widget.groupID isEqualToString:action.objectID]) {
            [self addWidgetUI:widget];
        }
    }
}

- (void)actionTypeRemoveGroup:(action *)action
{
    // 倒叙遍历删除
    [_widgetArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(WidgetUI * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.groupID isEqualToString:action.objectID]) {
            [obj destory];
            [_widgetArray removeObject:obj];
        }
    }];
}

- (void)actionTypeAddTarget:(action *)action
{
    widget * widget = [[ScriptUtil sharedScriptUtil] getWidgetByMaterialID:action.objectID];
    
    [self addWidgetUI:widget actionType:action.animationType];
}

- (void)addWidgetUI:(widget *)widget actionType:(NSString *)animationType
{
    WidgetUI *widgetUI = [[WidgetUI alloc] initWithWidgetData:widget];
    [widgetUI loadActionStart];
    [_widgetArray addObject:widgetUI];
    
    if ([animationType isEqualToString:@"animationShowLinear"]) {
        [widgetUI animationShowLinear];
    }else if ([animationType isEqualToString:@"animationHideLinear"]){
        [widgetUI animationHideLinear];
    }else if ([animationType isEqualToString:@"animationPop"]){
        [widgetUI animationPop];
    }else if ([animationType isEqualToString:@"animationRotateLoop"]){
        [widgetUI animationRotate:100];
    }
}

- (void)actionTypeRemoveTarget:(action *)action
{
    // 倒叙遍历删除
    [_widgetArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(WidgetUI * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.widgetID isEqualToString:action.objectID]) {
            [obj destory];
            [_widgetArray removeObject:obj];
        }
    }];
}

- (void)actionTypeChangeScene:(NSString *)secneID
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeSceneBySceneID:)]) {
        [self.delegate didChangeSceneBySceneID:secneID];
    }
    
    [self destory];
}

#pragma mark dealloc
- (void)destory
{
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    if (_sceneVideo) {
        [_sceneVideo removeObject];
        _sceneVideo = nil;
    }
    
    if (_sceneBg) {
        [_sceneBg removeObject];
        _sceneBg = nil;
    }
    
    [_widgetArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(WidgetUI * obj, NSUInteger idx, BOOL *stop) {
        [obj destory];
        [_widgetArray removeObject:obj];
    }];
    _widgetArray = nil;
}

- (void)dealloc
{
    SZTLog(@"SceneUI dealloc");
}


@end
