//
//  ActionsManager.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/23.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "SZTJson.h"

@protocol ActionsManagerDelegate <NSObject>
@optional
- (void)actionTypeSeek:(float)time;
- (void)actionTypePlay;
- (void)actionTypePause;

- (void)actionTypeAddGroup:(action *)action;
- (void)actionTypeRemoveGroup:(action *)action;
- (void)actionTypeAddTarget:(action *)action;
- (void)actionTypeRemoveTarget:(action *)action;
- (void)actionTypeChangeScene:(NSString *)sceneID;

@end

@interface ActionsManager : NSObject

SingletonH(ActionsManager)

// 往链表添加action
- (void)addActionsToLinkList:(NSMutableArray *)arr;

@property(nonatomic, weak)id <ActionsManagerDelegate> delegate;

@end
