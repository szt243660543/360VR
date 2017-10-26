//
//  CameraOpenGLView.m
//  SZTVR_SDK
//
//  Created by szt on 2017/4/27.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "RenderGLView.h"
#import "SZTProgram.h"
#import "SZTSphere3D.h"
#import "LocalCamera.h"
#import "Camera.h"
#import "ImageTool.h"
#import "FileTool.h"
#import "MathC.h"
#import "Picking.h"

@interface RenderGLView ()
{
    VideoSetting _videoType;
 
    NSMutableArray *_object3DArray;             // 空间对象
    NSMutableArray *_object2DArray;             // 屏幕对象
    
    BOOL _isLockObject;
    
    CADisplayLink *_displayLink;
}

@property(nonatomic, strong)LocalCamera *localCamera;

@property(nonatomic, strong)SZTLabel *label;

@end

@implementation RenderGLView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [Picking sharedPicking].focusPickingState = true;
        
        _object3DArray              = [NSMutableArray array];
        _object2DArray              = [NSMutableArray array];
        
        [self addObserver];
        
        objectSize size = [MathC getFocusPointSizeByScreenCount:1];
        SZTPoint *_point = [[SZTPoint alloc] init];
        _point.isScreen = YES;
        _point.isRenderMonocular = [Picking sharedPicking].isRenderMonocular;
        UIColor * color = [UIColor colorWithRed:66/255.0 green:84/255.0 blue:185/255.0 alpha:1.0];
        [_point setupTextureWithColor:color Rect:CGRectMake(0, 0, 10, 10)];
        [_point setObjectSize:size.width Height:size.height];
        
        [_point build];
    }
    
    return self;
}

#pragma mark - Notice
- (void)addObserver
{
    [NotificationCenter addObserver:self selector:@selector(sztObjectAdd:) name:SZTObjectAddNotification object:nil];
    [NotificationCenter addObserver:self selector:@selector(sztObjectRemove:) name:SZTObjectRemoveNotification object:nil];
}

- (void)removeObserver
{
    [NotificationCenter removeObserver:self name:SZTObjectAddNotification object:nil];
    [NotificationCenter removeObserver:self name:SZTObjectRemoveNotification object:nil];
}

#pragma mark - Notice Selector
- (void)sztObjectAdd:(NSNotification *)info
{
    SZTRenderObject *object = info.userInfo[SZTObject];
    
    [object setContext:_context];
    
    // 加锁
    _isLockObject = true;
    if (object.isScreen) {
        [_object2DArray addObject:object];
    }else{
        [_object3DArray addObject:object];
    }
    // 解锁
    _isLockObject = false;
}

- (void)sztObjectRemove:(NSNotification *)info
{
    SZTRenderObject *object = info.userInfo[SZTObject];
    
    _isLockObject = true;
    if (object.isScreen) {
        if ([NSStringFromClass([object class]) isEqual: @"SZTPoint"]) {
            [_object2DArray removeObject:object];
        }
    }else{
        [_object3DArray removeObject:object];
    }
    _isLockObject = false;
}

- (void)setVideoSetting:(VideoSetting)type
{
    _videoType = type;
    
    [self stopRenderCameraData];
    
    [self startRenderCameraData];
}

#pragma mark - Local camera drawing
- (void)startRenderCameraData
{
    if (_localCamera) return;
    
    _localCamera = [[LocalCamera alloc] initWithContext:_context];
    
    [_localCamera setupObjectWithWidth:_captureWidth Height:_captureHeight];
}

- (void)stopRenderCameraData
{
    if (_localCamera){
        [_localCamera removeObject];
        _localCamera = nil;
    }
}

#pragma mark - OpenGLES drawing
- (void)displayCameraSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    if (_isLockObject) return;
    
    [super prepareToRener];
    
    if (self.screenNum == 1) {
        glViewport(0.0, 0.0, _backingWidth, _backingHeight);
        
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // 相机
        if (_localCamera) {
            [_localCamera render:pixelBuffer];
        }
        
        [self renderObjects];
    }else{
        glViewport(0.0, 0.0, _backingWidth, _backingHeight* 0.5);
        
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // 相机
        if (_localCamera) {
            [_localCamera render:pixelBuffer];
        }
        
        [self renderObjects];
        
        glViewport(0.0, _backingHeight* 0.5, _backingWidth, _backingHeight* 0.5);
        
        // 相机
        if (_localCamera) {
            [_localCamera render:pixelBuffer];
        }
        
        [self renderObjects];
    }
    
    [super didRener];
}

- (void)renderObjects
{
    glEnable(GL_DEPTH_TEST);
    
    if (_object3DArray.count > 0) {
        for (SZTBaseObject * obj in _object3DArray) {
            [obj renderToFbo:0];
        }
    }
    glDisable(GL_DEPTH_TEST);
    
    // 2d对象，不进行深度检测
    if (_object2DArray.count > 0) {
        for (SZTBaseObject * obj in _object2DArray) {
            [obj renderToFbo:0];
        }
    }
}

- (void)dealloc
{
    
}

@end
