//
//  SZTLibrary.m
//  SZTVR_SDK
//
//  Created by szt on 16/7/28.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTLibrary.h"
#import "SZTGLKViewController.h"
#import "Picking.h"
#import "ClassNameTool.h"
#import "SZTBaseObject.h"
#import "MathC.h"
#import "SDKLevel.h"

@interface SZTLibrary()
{
    SZTPoint *_point;
    
    SZTModeDisplay _displayMode;
    
    int _screenNumber;
    
    UIPinchGestureRecognizer *_pinch;
    float _lastScale;
}

@property(nonatomic, strong)SZTGLKViewController *sztGLKController;
@property(nonatomic, weak)UIViewController *parentViewController;
@property(nonatomic, weak)UIView *parentView;

@end

@implementation SZTLibrary

- (instancetype)initWithController:(UIViewController *)vc
{
    self = [super init];
    
    if (self) {
        
        self.parentViewController = vc;
        self.parentView = vc.view;
        
        // 设置渲染层
        [self setupGLKControllerWithParentController];
        
        // 初始化
        [self initData];
    }

    return self;
}

- (instancetype)initWithView:(UIView *)v
{
    self = [super init];
    
    if (self) {
        self.parentView = v;
        
        // 设置渲染层
        [self setupGLKControllerWithParentView];
        
        // 初始化
        [self initData];
    }
    
    return self;
}

- (void)initData
{
    [Picking sharedPicking].focusPickingState = NO;
    [Picking sharedPicking].isObbPicking = YES;
    
    [self dispalyMode:SZTModeDisplayGlass];
    
    [self interactiveMode:SZTModeInteractiveMotion];
    
    [self distortionMode:SZTDistortionNormal];
    
    [self setTouchEvent:false];
    
    [self setEarPhoneTarget:false];
    
    [self setSensorWithGvr:SZTSensorGvr];
    
    [self setPickingEyes:SZTbinoculusPicking];
    
    [self setBinocularDistance:0.0];
    
    [self isCheckSDKLevel:true];
    
    [self setPinchGestureRecognizer];
}

- (void)setPinchGestureRecognizer
{
    _lastScale = 1.0;
    
    _pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    _pinch.enabled = NO;
    [self.sztGLKController.view addGestureRecognizer:_pinch];
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
    CGFloat scale = recognizer.scale;
    
    float dis = 2.0;
    
    [[SZTCamera sharedSZTCamera] setCameraDistanceRatio:_lastScale > scale?dis:-dis];
    
    _lastScale = scale;
}

- (void)setupGLKControllerWithParentController
{
    self.sztGLKController = [[SZTGLKViewController alloc] init];
    
    self.sztGLKController.identifier = (NSString *)[self.parentViewController class];
    [ClassNameTool sharedClassNameTool].className = (NSString *)[self.parentViewController class];
    
    [SZTCamera sharedSZTCamera].width = self.parentView.width;
    [SZTCamera sharedSZTCamera].height = self.parentView.height;
    
    [self.parentView insertSubview:self.sztGLKController.view atIndex:0];
    
    if (self.parentViewController != nil) {
        [self.parentViewController addChildViewController:self.sztGLKController];
        [self.sztGLKController didMoveToParentViewController:self.parentViewController];
    }
}

- (void)setupGLKControllerWithParentView
{
    self.sztGLKController = [[SZTGLKViewController alloc] init];
    
    [ClassNameTool sharedClassNameTool].className = nil;
    
    [SZTCamera sharedSZTCamera].width = self.parentView.width;
    [SZTCamera sharedSZTCamera].height = self.parentView.height;
    self.sztGLKController.view.width = self.parentView.width;
    self.sztGLKController.view.height = self.parentView.height;
    
    [self.parentView insertSubview:self.sztGLKController.view atIndex:0];
}

- (void)setFps:(int)fps
{
    _fps = fps;
    
    self.sztGLKController.fps = fps;
}

- (void)dispalyMode:(SZTModeDisplay)mode
{
    switch (mode) {
        case SZTModeDisplayNormal: // 普通模式
            _displayMode = SZTModeDisplayNormal;
            _screenNumber = 1;
            self.sztGLKController.screenNumber = 1;
            
            break;
        case SZTModeDisplayGlass: // 分屏模式
            _displayMode = SZTModeDisplayGlass;
            _screenNumber = 2;
            self.sztGLKController.screenNumber = 2;
            
            break;
        default:
            break;
    }
    
    [self setFocusPicking:[Picking sharedPicking].focusPickingState];
}
 
- (void)distortionMode:(SZTDistortion)mode
{
    switch (mode) {
        case SZTDistortionNormal: // 无畸变
            self.sztGLKController.isDistortion = NO;
            
            break;
        case SZTBarrelDistortion: // 桶形畸变
            self.sztGLKController.isDistortion = YES;
            
            break;
        default:
            break;
    }
}

- (void)setPickingEyes:(SZTPickingEyes)mode
{
    switch (mode) {
        case SZTbinoculusPicking: //双目
            [Picking sharedPicking].isRenderMonocular = NO;
            break;
        case SZTMonocularPicking: //单目
            [Picking sharedPicking].isRenderMonocular = YES;
            break;
        default:
            break;
    }
    
    if (_point) {
        _point.isRenderMonocular = [Picking sharedPicking].isRenderMonocular;
    }
}

- (SZTModeDisplay)getDispalyMode
{
    return _displayMode;
}

- (void)interactiveMode:(SZTModeInteractive)mode
{
    switch (mode) {
        case SZTModeInteractiveMotion: // 陀螺仪
            self.sztGLKController.isUsingMotion = YES;
            self.sztGLKController.isUsingTouch = NO;
            break;
        case SZTModeInteractiveTouch: // 触摸模式
            self.sztGLKController.isUsingMotion = NO;
            self.sztGLKController.isUsingTouch = YES;
            break;
        case SZTModeInteractiveMotionWithTouch: // 触摸AND陀螺仪
            self.sztGLKController.isUsingMotion = YES;
            self.sztGLKController.isUsingTouch = YES;
            break;
        default:
            break;
    }
}

- (void)setFocusPicking:(BOOL)isopen
{
    if (_point) {
        [_point removeObject];
        _point = nil;
    }
    
    if (isopen) {
        [self setTouchEvent:!isopen];
        objectSize size = [MathC getFocusPointSizeByScreenCount:_screenNumber];
        _point = [[SZTPoint alloc] init];
        _point.isScreen = YES;
        _point.isRenderMonocular = [Picking sharedPicking].isRenderMonocular;
        UIColor * color = [UIColor colorWithRed:66/255.0 green:84/255.0 blue:185/255.0 alpha:1.0];
        [_point setupTextureWithColor:color Rect:CGRectMake(0, 0, 10, 10)];
        [_point setObjectSize:size.width Height:size.height];
        
        [_point build];
    }
    
    [Picking sharedPicking].focusPickingState = isopen;
}

- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    self.sztGLKController.orientation = orientation;
}

- (void)setTouchEvent:(BOOL)isopen
{
    if (isopen) {
        [self setFocusPicking:!isopen];
    }
    
    [Picking sharedPicking].touchEventState = isopen;
}

- (void)setEarPhoneTarget:(BOOL)isopen
{
    [self.sztGLKController setEarPhoneTarget:isopen];
}

- (void)setBinocularDistance:(float)value
{
    [SZTCamera sharedSZTCamera].binocularDistance = value;
}

- (void)setSensorWithGvr:(SZTSensorMode)mode;
{
    switch (mode) {
        case SZTSensorNormal:
            self.sztGLKController.isUseingGvrGyro = NO;
            break;
        case SZTSensorGvr:
            self.sztGLKController.isUseingGvrGyro = YES;
            break;
        default:
            break;
    }
}

- (void)isCheckSDKLevel:(BOOL)ischeck
{
    if (ischeck) {
        [[SDKLevel sharedSDKLevel] checkLevel];
    }
}

- (void)setValuesOfBlackEdge:(float)values
{
    self.sztGLKController.blackEdgeValue = values;
}

- (void)resetScreen
{
    [[SZTCamera sharedSZTCamera] resetScreen];
}

- (void)addSubObject:(SZTBaseObject *)object
{
    [object build];
}

- (void)removeObject:(SZTBaseObject *)object
{
    [object removeObject];
}

- (void)dealloc
{
    SZTLog(@"SZTLibrary dealloc");
    
    [SZTCamera sharedSZTCamera].orientation = -1;
    
    self.sztGLKController = nil;
}

@end
