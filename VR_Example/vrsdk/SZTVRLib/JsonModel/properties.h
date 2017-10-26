//
//  properties.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/19.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface properties : NSObject

@property(nonatomic, copy)NSString *ID;

@property(nonatomic, copy)NSString *author;

@property(nonatomic, assign)NSTimeInterval timestamp;

@property(nonatomic, assign)float width;

@property(nonatomic, assign)float height;

@property(nonatomic, copy)NSString *title;

@property(nonatomic, copy)NSString *des;

@property(nonatomic, copy)NSString *keywords;

@property(nonatomic, assign)float version;

@property(nonatomic, copy)NSString *bg;

@property(nonatomic, copy)NSString *main_scene;

@property(nonatomic, copy)NSString *audio;

@property(nonatomic, assign)float gaze_time;

@end
