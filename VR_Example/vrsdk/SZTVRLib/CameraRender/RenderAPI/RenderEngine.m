//
//  RenderEngine.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/20.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "RenderEngine.h"
#import "LocalCameraUtil.h"

@interface RenderEngine()

@property (nonatomic , strong)LocalCameraUtil *cameraUtil;

@end

@implementation RenderEngine
SingletonM(RenderEngine)

- (void)setRenderFrame:(CGRect)rect
{
    self.renderView.frame = rect;
}

- (UIView *)renderView:(CGRect)frame
{
    if (self.renderView == nil) {
        self.renderView = [[RenderGLView alloc] initWithFrame:frame];
    }
    
    return self.renderView;
}

- (void)startRender
{
    
}

- (void)stopRender
{
    
}

- (void)openLocalCamera
{
    if (!_cameraUtil) {
        _cameraUtil = [[LocalCameraUtil alloc] init];
    
        [_cameraUtil startRunning];
    }
    
    [self.renderView startRenderCameraData];
}

- (void)stopLocalCamera
{
    [self.renderView stopRenderCameraData];
}

- (void)takePhotosByIndex:(int)index screenDoneblock:(void (^)(NSString *))block
{
    if (_cameraUtil) {
        SZTLog(@"camera has not exist, please open the camera!");
        
        return;
    }

    [_cameraUtil takePhotosByIndex:index screenDoneblock:block];
}

void extracted(SZTBaseObject *object) {
    [object build];
}

- (void)addSubObject:(SZTBaseObject *)object
{
    extracted(object);
}

- (void)removeObject:(SZTBaseObject *)object
{
    [object removeObject];
}

@end
