//
//  ScriptUtil.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/26.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTJson.h"
#import "Singleton.h"

@interface ScriptUtil : NSObject

SingletonH(ScriptUtil)

- (void)setJsonData:(vrkongfu *)data;

- (NSString *)getMainScene;

- (NSString *)getMainSound;

- (NSString *)getBgMaterialIDByProperties;

- (material *)getMaterialByMaterialID:(NSString *)materialID;

- (widget *)getWidgetByMaterialID:(NSString *)widgetID;

- (action *)getActionByActionID:(NSString *)actionID;

- (scene *)getSceneBySceneID:(NSString *)sceneID;

- (NSString *)getLocalFilePath;

- (float)getGazeTime;

@property(nonatomic, assign)BOOL isSandBoxPath;

@property(nonatomic, assign)BOOL isUseIjkPlayer;

@property(nonatomic, strong)NSDictionary *actionKeyDic;

@end
