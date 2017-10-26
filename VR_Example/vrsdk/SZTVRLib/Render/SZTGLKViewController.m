//
//  ViewController.h
//  simpleFBO
//
//  Created by SZTVR on 16/7/18.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTGLKViewController.h"
#import "SZTProgram.h"
#import "SZTTexture.h"
#import "SZTMotionManager.h"
#import "SZTRay.h"
#import "Picking.h"
#import "Shader_Fbo.h"

#define DEFAULT_OVERTURE 80.0

@interface SZTGLKViewController ()
{
    BOOL _touchMoved;
    
    float widthPx;
    float heightPx;
}

@property(nonatomic, strong)EAGLContext *glContext;
@property(nonatomic, strong)SZTProgram *fboProgram;
@property(nonatomic, strong)SZTMotionManager *motionManager;
@property(nonatomic, assign)CGFloat overture;
@property(nonatomic, assign)CGFloat fingerRotationX;
@property(nonatomic, assign)CGFloat fingerRotationY;

@end

@implementation SZTGLKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self setupContext];
    [self setupGLKView];
    [self setupGL];
    [self setupMotionManager];
}

- (void)initData
{
    float scale = [[UIScreen mainScreen] nativeScale];
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    widthPx = width *scale;
    heightPx = height*scale;
    swapt(&widthPx, &heightPx);
    
    [[SZTRay sharedSZTRay] resetRay];
    
    self.overture = DEFAULT_OVERTURE;
    
    // 默认
    self.fps = 60.0;
}

- (void)setupContext
{
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!_glContext) {
        SZTLog(@"Failed to create ES 2.0 context");
        exit(0);
    }else{
        [EAGLContext setCurrentContext:_glContext];
    }
}

- (void)setupGLKView
{
    GLKView *view = (GLKView *)self.view;
    view.context = _glContext;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.preferredFramesPerSecond = self.fps;
}

- (void)setFps:(int)fps
{
    _fps = fps;
    
    self.preferredFramesPerSecond = fps;
}

- (void)setupMotionManager
{
    self.motionManager = [[SZTMotionManager alloc] init];
}

- (void)setupGL
{
    self.fboProgram = [[SZTProgram alloc] init];
    
//    NSString * VPath = [[NSBundle mainBundle] pathForResource:@"FboV.vsh" ofType:nil];
//    NSString * FPath = [[NSBundle mainBundle] pathForResource:@"FboF.fsh" ofType:nil];
//    [self.fboProgram loadShaders:VPath FragShader:FPath isFilePath:YES];
    
    [self.fboProgram loadShaders:FboVertexShaderString FragShader:FboFragmentShaderString isFilePath:NO];
    [[SZTCamera sharedSZTCamera] setupMatrix];
    
    // 管理类
    self.manager = [[SZTManager alloc] init];
    self.manager.glContext = _glContext;
    self.manager.identifier = self.identifier;
    [self.manager setupFbosWithWidth:widthPx Height:heightPx];
}

- (void)setIsUsingMotion:(BOOL)isUsingMotion
{
    _isUsingMotion = isUsingMotion;
    
    if (_isUsingMotion) {
        [self.motionManager startMotion];
        
        // 重置
        self.fingerRotationX = 0;
        self.fingerRotationY = 0;
    }else{
        [self.motionManager stopDeviceMotion];
    }
    
    [SZTCamera sharedSZTCamera].isUsingMotion = _isUsingMotion;
}

- (void)setIsUsingTouch:(BOOL)isUsingTouch
{
    _isUsingTouch = isUsingTouch;
    
    [SZTCamera sharedSZTCamera].isUsingTouch = _isUsingTouch;
}

- (void)setIsUseingGvrGyro:(BOOL)isUseingGvrGyro
{
    _isUseingGvrGyro = isUseingGvrGyro;
    
    self.motionManager.isUseingGvrGyro = isUseingGvrGyro;
    [SZTCamera sharedSZTCamera].isUseingGvrGyro = isUseingGvrGyro;
}

- (void)setOrientation:(UIInterfaceOrientation)orientation
{
    _orientation = orientation;
    
    self.motionManager.orientation = orientation;
}

- (void)setScreenNumber:(int)screenNumber
{
    _screenNumber = screenNumber;
    
    [SZTCamera sharedSZTCamera].screenNumber = screenNumber;
}

- (void)setIsDistortion:(BOOL)isDistortion
{
    _isDistortion = isDistortion;
    
    self.manager.isDistortion = isDistortion;
}

- (void)setEarPhoneTarget:(BOOL)isopen
{
    if (isopen) {
        [self beginReceivingEvents];
    }else{
        [self resignReceivingEvents];
    }
}

- (void)setBlackEdgeValue:(float)blackEdgeValue
{
    _blackEdgeValue = blackEdgeValue;
    
    self.fboProgram.blackEdgeValue = blackEdgeValue;
}

- (void)beginReceivingEvents
{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)resignReceivingEvents
{
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:{
                SZTLog(@"Ear Play");
                [NotificationCenter postNotificationName:EventSubtypeRemoteControlPlay object:nil];
            }break;
            case UIEventSubtypeRemoteControlPause:{
                SZTLog(@"Ear Pause");
                [NotificationCenter postNotificationName:EventSubtypeRemoteControlPause object:nil];
            }break;
            case UIEventSubtypeRemoteControlStop:{
                SZTLog(@"Ear Stop");
                [NotificationCenter postNotificationName:EventSubtypeRemoteControlStop object:nil];
            }break;
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                SZTLog(@"单击暂停键");
                [NotificationCenter postNotificationName:EventSubtypeRemoteControlTogglePlayPause object:nil];
            }break;
            case UIEventSubtypeRemoteControlNextTrack:{
                SZTLog(@"双击暂停键");
                [NotificationCenter postNotificationName:EventSubtypeRemoteControlNextTrack object:nil];
            }break;
            case UIEventSubtypeRemoteControlPreviousTrack:{
                SZTLog(@"三击暂停键");
                [NotificationCenter postNotificationName:EventSubtypeRemoteControlPreviousTrack object:nil];
            }break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:{
                SZTLog(@"单击，再按下不放");
                [NotificationCenter postNotificationName:EventSubtypeRemoteControlBeginSeekingForward object:nil];
            }break;
            case UIEventSubtypeRemoteControlEndSeekingForward:{
                SZTLog(@"单击，再按下不放，松开时");
                [NotificationCenter postNotificationName:EventSubtypeRemoteControlEndSeekingForward object:nil];
            }break;
            default:
                break;
        }
    }
}

#pragma mark - GLKView and GLKViewController delegate methods
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    if (_screenNumber == 2) {
        // 渲染到FBO
        [self.manager renderToFbo];
        [((GLKView *) self.view) bindDrawable];
        
        // 清屏
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
        // FBO渲染到屏幕
        [self.manager renderFboToScreen:self.fboProgram];
    }else{
        glViewport(0.0, 0.0, widthPx, heightPx);
        
        // 渲染到屏幕
        [self.manager renderToScreen];
    }
    
    // 陀螺仪矩阵
    [[SZTCamera sharedSZTCamera] updateSensorMatrix:[self.motionManager lastHeadView]];
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!_isUsingTouch) return;

    _touchMoved = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!_isUsingTouch) return;
    
    UITouch *touch = [touches anyObject];
    float distX = [touch locationInView:touch.view].x - [touch previousLocationInView:touch.view].x;
    float distY = [touch locationInView:touch.view].y - [touch previousLocationInView:touch.view].y;
    
    distX *= -0.005;
    distY *= -0.005;
    
    self.fingerRotationX += distY * self.overture / 100;
    self.fingerRotationY -= distX * self.overture / 100;
    
    // 更新矩阵
    [[SZTCamera sharedSZTCamera] updateFingerRotation:self.fingerRotationX FingerRotationY:self.fingerRotationY];
    
    _touchMoved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([Picking sharedPicking].touchEventState) {
        UITouch *touch = [touches anyObject];
        CGPoint tPt = [touch locationInView:self.view];
        
        if (_screenNumber == 2 && tPt.x > self.view.bounds.size.width/2) {
            tPt.x = tPt.x - self.view.bounds.size.width/2;
        }
        
        GLKVector2 touchPoint = GLKVector2Make(tPt.x, tPt.y);
        
        [[SZTRay sharedSZTRay] calculateABPositionWithTouchPoint:touchPoint screenCount:_screenNumber];
    }
}

#pragma mark - dealloc
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [EAGLContext setCurrentContext:_glContext];
    
    if ([EAGLContext currentContext] == _glContext) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [self resignReceivingEvents];
    
    _glContext = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    if (self.motionManager) {
        [self.motionManager stopDeviceMotion];
        self.motionManager = nil;
    }

    SZTLog(@"SZTGLKViewController dealloc");
}

@end
