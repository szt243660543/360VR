//
//  BaseRenderView.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/2.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "BaseRenderView.h"
#import "SZTMotionManager.h"
#import "Camera.h"

@interface BaseRenderView()
{
    BOOL _touchMoved;
}

@property(nonatomic, strong)SZTMotionManager *motionManager;

@property (nonatomic, assign)CGFloat fingerRotationX;
@property (nonatomic, assign)CGFloat fingerRotationY;
@property (nonatomic, assign)CGFloat overture;

@end

@implementation BaseRenderView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initData];
        
        [self setupLayer];
        
        [self setupContext];
        
        [self setupBuffers];
        
        [self setupMotionManager];
    }
    
    return self;
}

- (void)initData
{
    _screenNum = 1;
    
    [[SZTCamera sharedSZTCamera] setupMatrix];
}

- (void)setupLayer
{
    self.contentScaleFactor = [[UIScreen mainScreen] scale];
    
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.opaque = TRUE;
    eaglLayer.drawableProperties = @{ kEAGLDrawablePropertyRetainedBacking :[NSNumber numberWithBool:NO],
                                      kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8};
}

- (void)setupContext
{
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!_context) {
        SZTLog(@"Failed to create ES 2.0 context");
        exit(0);
    }else{
        [EAGLContext setCurrentContext:_context];
    }
}

- (void)setupBuffers
{
    glGenFramebuffers(1, &m_framebuffer);
    glGenRenderbuffers(1, &m_colorRenderbuffer);
    glGenRenderbuffers(1, &m_depthRenderbuffer);
    
    glBindFramebuffer(GL_FRAMEBUFFER, m_framebuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, m_colorRenderbuffer);
    
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, m_colorRenderbuffer);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    
    glBindRenderbuffer(GL_RENDERBUFFER, m_depthRenderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _backingWidth, _backingHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, m_depthRenderbuffer);
    
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

#pragma mark - Motion Event
- (void)setupMotionManager
{
    self.motionManager = [[SZTMotionManager alloc] init];
    [self.motionManager setIsUseingGvrGyro:NO];
    self.motionManager.orientation = UIDeviceOrientationPortrait;
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
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(_isUsingMotion) return;
    
    _touchMoved = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!_isUsingMotion) return;
    
    UITouch *touch = [touches anyObject];
    float distX = [touch locationInView:touch.view].x - [touch previousLocationInView:touch.view].x;
    float distY = [touch locationInView:touch.view].y - [touch previousLocationInView:touch.view].y;
    
    distX *= -0.005;
    distY *= -0.005;
    
    self.fingerRotationX += distY * self.overture / 100;
    self.fingerRotationY -= distX * self.overture / 100;
    
    // 更新矩阵
    
    _touchMoved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!_isUsingMotion) return;
}

#pragma mark - render
- (void)prepareToRener
{
    [self setupCameraData];
    
    if ([EAGLContext currentContext] != _context) {
        [EAGLContext setCurrentContext:_context];
    }
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

- (void)render
{
    
}

- (void)didRener
{
    glBindRenderbuffer(GL_RENDERBUFFER, m_colorRenderbuffer);
    
    if ([EAGLContext currentContext] == _context) {
        [_context presentRenderbuffer:GL_RENDERBUFFER];
    }
}

- (void)setupCameraData
{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    [SZTCamera sharedSZTCamera].width = width;
    [SZTCamera sharedSZTCamera].height = height;
    if (_screenNum == 1) {
        [[SZTCamera sharedSZTCamera] setScreenNumber:1];
    }else{
        [[SZTCamera sharedSZTCamera] setScreenNumber:2];
    }
    [[SZTCamera sharedSZTCamera] updateSensorMatrix:[self.motionManager lastHeadView]];
    [[SZTCamera sharedSZTCamera] updateOrientation:UIInterfaceOrientationPortrait];
    [[SZTCamera sharedSZTCamera] updateMatrix:0];
    
    
    [Camera sharedCamera].renderWidth = _backingWidth;
    if (_screenNum == 1) {
        [Camera sharedCamera].fov = 85;
        [Camera sharedCamera].renderHeight = _backingHeight;
    }else{
        [Camera sharedCamera].fov = 50;
        [Camera sharedCamera].renderHeight = _backingHeight * 0.5;
    }
    [[Camera sharedCamera] updateLocalCameraMatrix];
}

@end
