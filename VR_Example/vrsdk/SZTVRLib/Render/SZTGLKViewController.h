//
//  ViewController.h
//  simpleFBO
//
//  Created by SZTVR on 16/7/18.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "SZTManager.h"

@interface SZTGLKViewController : GLKViewController<UIGestureRecognizerDelegate>

@property(nonatomic, assign)int screenNumber;
@property(nonatomic, assign)BOOL isUsingMotion;
@property(nonatomic, assign)BOOL isUsingTouch;

@property(nonatomic, assign)BOOL isDistortion;
@property(nonatomic, assign)BOOL isUseingGvrGyro;
@property(nonatomic, assign)UIInterfaceOrientation orientation;

// 是否开启耳机点击事件
- (void)setEarPhoneTarget:(BOOL)isopen;

@property(nonatomic, assign)int fps;

@property(nonatomic, assign)float blackEdgeValue;

@property(nonatomic, strong)SZTManager *manager;

@property(nonatomic, copy)NSString *identifier;

@end
