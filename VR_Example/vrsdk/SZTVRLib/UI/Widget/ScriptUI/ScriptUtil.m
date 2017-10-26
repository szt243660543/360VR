//
//  ScriptUtil.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/26.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "ScriptUtil.h"

@interface ScriptUtil()
{
    vrkongfu *_data;
}

@end

@implementation ScriptUtil

SingletonM(ScriptUtil)

- (void)setJsonData:(vrkongfu *)data
{
    _data = data;
    
    if (self.actionKeyDic) {
        self.actionKeyDic = nil;
    }
    self.actionKeyDic = [[NSMutableDictionary alloc] initWithCapacity:0];
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

- (NSString *)getMainScene
{
    return _data.properties.main_scene;
}

- (NSString *)getMainSound
{
    return _data.properties.audio;
}

- (NSString *)getBgMaterialIDByProperties
{
    return _data.properties.bg;
}

- (float)getGazeTime
{
    return _data.properties.gaze_time;
}

- (material *)getMaterialByMaterialID:(NSString *)materialID
{
    for (material *material in _data.materialList) {
        if ([material.materialID isEqualToString:materialID]) {
            return material;
        }
    }
    
    SZTLog(@"materialID was no found!");
    
    return nil;
}

- (widget *)getWidgetByMaterialID:(NSString *)widgetID
{
    for (widget *widget in _data.widgetList) {
        if ([widget.widgetID isEqualToString:widgetID]) {
            return widget;
        }
    }
    
    SZTLog(@"widgetID was no found!");
    
    return nil;
}

- (action *)getActionByActionID:(NSString *)actionID
{
    for (action *action in _data.actionList) {
        if ([action.actionID isEqualToString:actionID]) {
            return action;
        }
    }
    
    SZTLog(@"actionID was no found!");
    
    return nil;
}

- (scene *)getSceneBySceneID:(NSString *)sceneID
{
    for (scene *scene in _data.sceneList) {
        if ([scene.sceneID isEqualToString:sceneID]) {
            return scene;
        }
    }
    
    SZTLog(@"sceneID was no found!");
    
    return nil;
}

- (NSString *)getLocalFilePath
{
    if (_isSandBoxPath) {
        return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    
    return @"";
}

@end
