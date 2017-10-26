//
//  Consts.h
//  szt
//
//  Created by szt on 16/4/9.
//  Copyright © 2016年 szt. All rights reserved.
//
#include <Availability.h>

// __OBJC__这个宏,在所有的.m和.mm文件中默认就定义了这个宏
#ifdef __OBJC__
// 如果这个全局的头文件或者宏只需要在.m或者.mm文件中使用,
// 请把该头文件或宏写到#ifdef __OBJC__ 中
    #import <UIKit/UIKit.h>
    #import <GLKit/GLKit.h>
    #import <Foundation/Foundation.h>
    #import "UIView+Extension.h"

    #import "SZTLibrary.h"
    #import "SZTTouch.h"
    #import "SZTCamera.h"
    #import "Notice.h"
    #import "MathC.h"

    #import "SZTVideo.h"
    #import "SZTImageView.h"
    #import "SZTGif.h"
    #import "SZTPoint.h"
    #import "SZTObjModel.h"
    #import "SZTLabel.h"

// RGB颜色
#define ColorRBG(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define RandomColor ColorRBG(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))

// 生成随机数
#define RandomNumber(from, to) (int)(from + (arc4random() % (to - from + 1)))

// 获取版本号
#define DeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]

// 获取BundleID
#define BundleID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

// 获取App名字
#define AppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

// 通知
#define NotificationCenter [NSNotificationCenter defaultCenter]

// 圆周率
#define ES_PI  (3.14159265f)

// 使用ijkplayer
#define USE_IJK_PLAYER 1

// 预编译bundle
#define SZTBUNDLE_NAME @ "SZTLibResource.bundle"
#define SZTBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: SZTBUNDLE_NAME]
#define SZTBUNDLE [NSBundle bundleWithPath: SZTBUNDLE_PATH]

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

// 自定义打印
#ifdef DEBUG // 处于开发节点
#define SZTLog(...) NSLog(__VA_ARGS__)
#else  // 处于发布节点
#define SZTLog(...)
#endif

#ifdef DEBUG
#define LLSZTLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define LLSZTLog(format, ...)
#endif

// 查看执行时间
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

#endif
