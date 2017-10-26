//
//  ActionsManager.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/23.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "ActionsManager.h"
#import "ScriptUtil.h"

@implementation ActionsManager

SingletonM(ActionsManager)

- (void)addActionsToLinkList:(NSMutableArray *)arr
{
    for (NSString *actionID in arr)
    {
        [self loadActions:actionID];
    }
}

- (void)loadActions:(NSString *)actionID
{
    action *action = [[ScriptUtil sharedScriptUtil] getActionByActionID:actionID];
    
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(action.delay * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf prepareToPlayAction:action];
    });
}

- (void)prepareToPlayAction:(action *)action
{
    if ([action.objectID isEqualToString:@""]) {
        if (action.objects.count > 0) {
            for (objects *obj in action.objects) {
                NSNumber *tempV = [[ScriptUtil sharedScriptUtil].actionKeyDic valueForKey:action.key];
                if ([tempV floatValue] >= obj.min && [tempV floatValue] <= obj.max) {
                    action.objectID = obj.objectID;
                    
                    if (obj.clearKeyValue) {
                        [[ScriptUtil sharedScriptUtil].actionKeyDic setValue:[NSNumber numberWithFloat:0] forKey:action.key];
                    }
                    break;
                }
            }
        }
    }
    
    [self playAction:action];
}

- (void)playAction:(action *)action
{
    if ([action.type isEqualToString:@"seek"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionTypeSeek:)]){
            [self.delegate actionTypeSeek:action.value];
        }
    }else if ([action.type isEqualToString:@"play"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionTypePlay)]){
            [self.delegate actionTypePlay];
        }
    }else if ([action.type isEqualToString:@"pause"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionTypePause)]){
            [self.delegate actionTypePause];
        }
    }else if ([action.type isEqualToString:@"changeScene"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionTypeChangeScene:)]) {
            [self.delegate actionTypeChangeScene:action.objectID];
        }
    }else if ([action.type isEqualToString:@"addGroup"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionTypeAddGroup:)]) {
            [self.delegate actionTypeAddGroup:action];
        }
    }else if ([action.type isEqualToString:@"removeGroup"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionTypeRemoveGroup:)]) {
            [self.delegate actionTypeRemoveGroup:action];
        }
    }else if ([action.type isEqualToString:@"addTarget"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionTypeAddTarget:)]) {
            [self.delegate actionTypeAddTarget:action];
        }
    }else if ([action.type isEqualToString:@"removeTarget"]){
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionTypeRemoveTarget:)]) {
            [self.delegate actionTypeRemoveTarget:action];
        }
    }else if ([action.type isEqualToString:@"plus"]){
        [self actionTypePlus:action];
    }else if ([action.type isEqualToString:@"minus"]){
        [self actionTypeMinus:action];
    }else if ([action.type isEqualToString:@"multiply"]){
        [self actionTypeMultiply:action];
    }else if ([action.type isEqualToString:@"divide"]){
        [self actionTypeDivide:action];
    }else if ([action.type isEqualToString:@"setValue"]){
        [self actionTypeSetValue:action];
    }
}

- (void)actionTypePlus:(action *)action
{
    NSNumber *tempV = [[ScriptUtil sharedScriptUtil].actionKeyDic valueForKey:action.key];
    float value = action.value + [tempV floatValue];
    [[ScriptUtil sharedScriptUtil].actionKeyDic setValue:[NSNumber numberWithFloat:value] forKey:action.key];
}

- (void)actionTypeMinus:(action *)action
{
    NSNumber *tempV = [[ScriptUtil sharedScriptUtil].actionKeyDic valueForKey:action.key];
    float value = [tempV floatValue] - action.value;
    [[ScriptUtil sharedScriptUtil].actionKeyDic setValue:[NSNumber numberWithFloat:value] forKey:action.key];
}

- (void)actionTypeMultiply:(action *)action
{
    NSNumber *tempV = [[ScriptUtil sharedScriptUtil].actionKeyDic valueForKey:action.key];
    float value = action.value * [tempV floatValue];
    [[ScriptUtil sharedScriptUtil].actionKeyDic setValue:[NSNumber numberWithFloat:value] forKey:action.key];
}

- (void)actionTypeDivide:(action *)action
{
    NSNumber *tempV = [[ScriptUtil sharedScriptUtil].actionKeyDic valueForKey:action.key];
    float value = [tempV floatValue]/action.value;
    [[ScriptUtil sharedScriptUtil].actionKeyDic setValue:[NSNumber numberWithFloat:value] forKey:action.key];
}

- (void)actionTypeSetValue:(action *)action
{
    [[ScriptUtil sharedScriptUtil].actionKeyDic setValue:[NSNumber numberWithFloat:action.value] forKey:action.key];
}

@end
