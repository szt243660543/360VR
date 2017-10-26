//
//  WidgetUI.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/26.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "WidgetUI.h"
#import "ScriptUtil.h"
#import "ActionsManager.h"

@interface WidgetUI()<ActionsManagerDelegate>
{
    SZTImageView *_imageView;
    SZTGif *_gifView;
    SZTVideo *_videoView;
    SZTObjModel *_objModel;
    
    widget *_widget;
    material *_material;
    material *_activeMaterial;
}

@end

@implementation WidgetUI

- (instancetype)initWithWidgetData:(widget *)widgetData
{
    self = [super init];
    
    if (self) {
        self.groupID = widgetData.groupID;
        self.widgetID = widgetData.widgetID;
        _widget = widgetData;
        
        [self loadWidget];
    }
    
    return self;
}

- (void)loadWidget
{
    _material = [[ScriptUtil sharedScriptUtil] getMaterialByMaterialID:_widget.materialID];
    _activeMaterial = [_widget.activeMaterialID isEqualToString:@""]?nil:[[ScriptUtil sharedScriptUtil] getMaterialByMaterialID:_widget.activeMaterialID];
    
    if ([_material.url isEqual: @""]) return;
        
    if ([_material.type isEqualToString:@"Image"]) {
        _imageView = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
        [self setTextureImageByMaterial:_material];
        GLKVector3 point = [MathC CalculateSphereSurfacePointWithLat:_widget.lat Lon:_widget.lon Depth:_widget.depth];
        [_imageView setPosition:point.x Y:point.y Z:point.z];
        [self setRotation:_imageView radiansX:_widget.lat radiansY:-_widget.lon + _widget.rotateY radiansZ:0.0];
        [_imageView setScale:_widget.scaleX Y:_widget.scaleY Z:_widget.scaleZ];
        
        [_imageView build];
    }else if ([_material.type isEqualToString:@"Gif"]){
        _gifView = [[SZTGif alloc] init];
        
        if (_material.online) {
            [_gifView setupGifWithFileUrl:_material.url];
        }else{
            NSString *path = [NSString stringWithFormat:@"%@%@",[[ScriptUtil sharedScriptUtil] getLocalFilePath], _material.url];
            [_gifView setupGifWithGifPath:path];
        }
        _gifView.speed = 2.0;
        [_gifView gifDidFinishedCallback:^(SZTGif *gif) {
            
        }];
        GLKVector3 point = [MathC CalculateSphereSurfacePointWithLat:_widget.lat Lon:_widget.lon Depth:_widget.depth];
        [_gifView setPosition:point.x Y:point.y Z:point.z];
        [self setRotation:_gifView radiansX:_widget.lat radiansY:-_widget.lon radiansZ:0.0];
        [_gifView setScale:_widget.scaleX Y:_widget.scaleY Z:_widget.scaleZ];
        
        [_gifView build];
    }else if ([_material.type isEqualToString:@"Video"]){
        NSURL *url;
        
        if (_material.online) {
            url = [NSURL URLWithString:_material.url];
        }else{
            NSString *path = [NSString stringWithFormat:@"%@%@",[[ScriptUtil sharedScriptUtil] getLocalFilePath], _material.url];
            url = [NSURL fileURLWithPath:path];
        }
        
        if ([ScriptUtil sharedScriptUtil].isUseIjkPlayer) {
            _videoView = [[SZTVideo alloc] initAVPlayerVideoWithURL:url VideoMode:SZTVR_PLANE];
        }else{
            _videoView = [[SZTVideo alloc] initIJKPlayerVideoWithURL:url VideoMode:SZTVR_PLANE isVideoToolBox:YES videoFrameMode:SZTVIDEO_DEFAULT];
        }
        
        GLKVector3 point = [MathC CalculateSphereSurfacePointWithLat:_widget.lat Lon:_widget.lon Depth:_widget.depth];
        [_videoView setObjectSize:1920.0 Height:1080.0];
        [_videoView setPosition:point.x Y:point.y Z:point.z];
        [self setRotation:_videoView radiansX:_widget.lat + _widget.rotateX radiansY:-_widget.lon + _widget.rotateY radiansZ:+ _widget.rotateZ];
        [_videoView setScale:_widget.scaleX Y:_widget.scaleY Z:_widget.scaleZ];
        
        [_videoView build];
    }else if ([_material.type isEqualToString:@"3DModel"]){
        NSString *path;
        NSString *modelPath;
        material *modelMaterial = [[ScriptUtil sharedScriptUtil] getMaterialByMaterialID:_widget.modelID];
        if (_material.online) {
            _objModel = [[SZTObjModel alloc] initWithObjUrl:modelMaterial.url];
            [_objModel setupTextureWithUrl:_material.url];
        }else{
            path = [NSString stringWithFormat:@"%@%@",[[ScriptUtil sharedScriptUtil] getLocalFilePath], _material.url];
            modelPath = [NSString stringWithFormat:@"%@%@",[[ScriptUtil sharedScriptUtil] getLocalFilePath], modelMaterial.url];
            _objModel = [[SZTObjModel alloc] initWithPath:modelPath];
            [_objModel setupTextureWithFilePath:path];
        }
        
        GLKVector3 point = [MathC CalculateSphereSurfacePointWithLat:_widget.lat Lon:_widget.lon Depth:_widget.depth];
        [_objModel setPosition:point.x Y:point.y Z:point.z];
        [self setRotation:_objModel radiansX:_widget.lat + _widget.rotateX radiansY:-_widget.lon + _widget.rotateY radiansZ:0.0];
        [_objModel setScale:_widget.scaleX Y:_widget.scaleY Z:_widget.scaleZ];
        
        [_objModel build];
    }
    
    if (_widget.enable) {
        SZTTouch *touch;
        if (_imageView) {
            touch = [[SZTTouch alloc] initWithTouchObject:_imageView];
        }else if (_gifView){
            touch = [[SZTTouch alloc] initWithTouchObject:_gifView];
        }
        
        if (_widget.gaze_time) {
            [touch setSelectTime:_widget.gaze_time];
        }else{
            [touch setSelectTime:[[ScriptUtil sharedScriptUtil] getGazeTime]];
        }
        
        [touch willTouchCallBack:^(GLKVector3 vec) {
            [self willTouchActions];
        }];
        
        [touch didTouchCallback:^(GLKVector3 vec) {
            [self implementActions];
        }];
        
        [touch endTouchCallback:^(GLKVector3 vec) {
            [self endTouchActions];
        }];
    }
}

- (void)setRotation:(SZTRenderObject *)obj radiansX:(float)x radiansY:(float)y radiansZ:(float)z
{
    if (!_widget.distortedLon) {
        y = 0.0;
    }
    
    if (!_widget.distortedLat) {
        x = 0.0;
    }
    
    [obj setRotate:x radiansY:y radiansZ:0.0];
}

- (void)setTextureImageByMaterial:(material *)material
{
    if (material.online) {
        UIImage *paceholderImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"placeholder.png" ofType:nil]];
        [_imageView setupTextureWithUrl:material.url Paceholder:paceholderImg];
    }else{
        NSString *path = [NSString stringWithFormat:@"%@%@",[[ScriptUtil sharedScriptUtil] getLocalFilePath], material.url];
        [_imageView setupTextureWithFileName:path];
    }
}

#pragma mark Actions
- (void)loadActionStart
{
    SZTLog(@"actions_start!");
    [[ActionsManager sharedActionsManager] addActionsToLinkList:_widget.actions_start];
}

- (void)loadActionEnd
{
    SZTLog(@"actions_end!");
    [[ActionsManager sharedActionsManager] addActionsToLinkList:_widget.actions_end];
}

- (void)willTouchActions
{
    if (!_activeMaterial) return;
    [self setTextureImageByMaterial:_activeMaterial];
}

- (void)implementActions
{
    [[ActionsManager sharedActionsManager] addActionsToLinkList:_widget.actions];
}

- (void)endTouchActions
{
    [self setTextureImageByMaterial:_material];
}

- (void)animationShowLinear
{
    if (_imageView) {
        [_imageView setScale:0.0 Y:0.0 Z:0.0];
        [_imageView scaleTo:0.5 scaleX:1.0 scaleY:1.0 scaleZ:1.0 finishBlock:^{
            
        }];
    }
}

- (void)animationHideLinear
{
    if (_imageView) {
        [_imageView scaleTo:0.5 scaleX:0.0 scaleY:0.0 scaleZ:0.0 finishBlock:^{
            
        }];
    }
}

- (void)animationPop
{
    if (_imageView) {
        [_imageView setScale:0.0 Y:0.0 Z:0.0];
        [_imageView scaleTo:0.5 scaleX:1.2 scaleY:1.2 scaleZ:1.2 finishBlock:^{
            [_imageView scaleTo:0.2 scaleX:0.8 scaleY:0.8 scaleZ:0.8 finishBlock:^{
                [_imageView scaleTo:0.15 scaleX:1.0 scaleY:1.0 scaleZ:1.0 finishBlock:^{
                    
                }];
            }];
        }];
    }
}

- (void)animationRotate:(float)radians
{
    if (_objModel) {
        [_objModel rotateTo:15.0 * 360.0 radiansX:0.0 radiansY:360.0 * 360.0 radiansZ:0.0 finishBlock:^{
            
        }];
    }
}

#pragma mark destory
- (void)destory
{
    if (_imageView) {
        [_imageView removeObject];
        _imageView = nil;
    }
    
    if (_gifView) {
        [_gifView removeObject];
        _gifView = nil;
    }
    
    if (_videoView) {
        [_videoView removeObject];
        _videoView = nil;
    }
    
    if (_objModel) {
        [_objModel removeObject];
        _objModel = nil;
    }
}

- (void)dealloc
{
    [self destory];
}

@end
