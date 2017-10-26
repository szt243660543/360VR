//
//  SZTFboManager.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "SZTObject3D.h"
#import "SZTProgram.h"

@interface SZTManager : NSObject
{
    NSMutableArray *_fboArray;
    
    SZTObject3D *fboLeftObj;    // 左屏
    SZTObject3D *fboRightObj;   // 右屏
}

@property(nonatomic, weak)EAGLContext *glContext;

@property(nonatomic, weak)NSString *identifier;

@property(nonatomic, assign)BOOL isDistortion;

/**
 * 初始化fbo对象
 */
- (void)setupFbosWithWidth:(float)widthPx Height:(float)heightPx;

/**
 * 将对象到Fbo
 */
- (void)renderToFbo;

/**
 * FBO渲染到屏幕
 */
- (void)renderFboToScreen:(SZTProgram *)program;

/**
 * 将对象渲染到屏幕
 */
- (void)renderToScreen;

@end
