//
//  Camera.h
//  SZTVR_SDK
//
//  Created by szt on 2017/5/15.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface Camera : NSObject
SingletonH(Camera)

@property(nonatomic, assign)float fov;

// ************ 处理本地相机对象的摄像机 **************
@property(nonatomic, assign)GLKMatrix4 cameraModelMatrix;
// 更新本地摄像机矩阵
- (void)updateLocalCameraMatrix;
// 渲染宽高
@property(nonatomic, assign)float renderWidth;
@property(nonatomic, assign)float renderHeight;

@end
