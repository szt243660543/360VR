//
//  widget.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/19.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface widget : NSObject

@property(nonatomic, copy)NSString *widgetID;

@property(nonatomic, copy)NSString *groupID;

@property(nonatomic, copy)NSString *materialID;

@property(nonatomic, copy)NSString *activeMaterialID;

@property(nonatomic, copy)NSString *modelID;

@property(nonatomic, assign)BOOL isVR;

@property(nonatomic, assign)float lat;

@property(nonatomic, assign)float lon;

@property(nonatomic, assign)float depth;

@property(nonatomic, assign)float x;

@property(nonatomic, assign)float y;

@property(nonatomic, assign)float z;

@property(nonatomic, assign)float scaleX;

@property(nonatomic, assign)float scaleY;

@property(nonatomic, assign)float scaleZ;

@property(nonatomic, assign)BOOL zoom;

@property(nonatomic, assign)float opacity;

@property(nonatomic, assign)float start;

@property(nonatomic, assign)float end;

@property(nonatomic, assign)BOOL enable;

@property(nonatomic, assign)BOOL distortedLat;

@property(nonatomic, assign)BOOL distortedLon;

@property(nonatomic, assign)float rotateX;

@property(nonatomic, assign)float rotateY;

@property(nonatomic, assign)float rotateZ;

@property(nonatomic, assign)float quality;

@property(nonatomic, assign)float fadeInDuration;

@property(nonatomic, assign)float fadeOutDuration;

@property(nonatomic, assign)BOOL loop;

@property(nonatomic, strong)NSMutableArray *actions_start;

@property(nonatomic, strong)NSMutableArray *actions;

@property(nonatomic, strong)NSMutableArray *actions_end;

@property(nonatomic, assign)BOOL isExist;

@property(nonatomic, assign)float gaze_time;

@end
