//
//  SceneUI.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/26.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "scene.h"

@class SceneUI;
@protocol SceneUIDelegate <NSObject>

- (void)didChangeSceneBySceneID:(NSString *)sceneID;

@end

@interface SceneUI : NSObject

- (instancetype)initWithSceneData:(scene *)sceneData;

@property(nonatomic, strong)SZTVideo *sceneVideo;

@property(nonatomic, strong)SZTImageView *sceneBg;

@property(nonatomic, weak)id <SceneUIDelegate> delegate;

- (void)build;

- (void)destory;

@end
