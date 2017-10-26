//
//  SZTFboManager.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTManager.h"
#import "SZTFbo.h"
#import "ClassNameTool.h"
#import "ScriptUI.h"

@interface SZTManager()
{
    // 显示屏幕数
    int _screenNumber;
    
    NSMutableArray *_object3DArray;             // 空间对象
    NSMutableArray *_object2DArray;             // 屏幕对象
    ScriptUI *_ScriptUI;                        // 脚本对象
    
    // 对象锁
    BOOL _isLockObject;
}

@end

@implementation SZTManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _screenNumber               = 2; // 默认为分屏幕
        
        _object3DArray              = [NSMutableArray array];
        _object2DArray              = [NSMutableArray array];
    }
    
    return self;
}

- (void)setupFbosWithWidth:(float)widthPx Height:(float)heightPx
{
    _fboArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < _screenNumber; i++) {
        SZTFbo * fbo = [[SZTFbo alloc] initWithWidth:widthPx Height:heightPx];
        [_fboArray addObject:fbo];
    }

    [self addObserver];
    
    [self setupFboObject];
}

- (void)setupFboObject
{    
    fboLeftObj = [[SZTObject3D alloc] init];
    [fboLeftObj setupVBO_Left];
    
    fboRightObj = [[SZTObject3D alloc] init];
    [fboRightObj setupVBO_Right];
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
    if ([ClassNameTool sharedClassNameTool].className != self.identifier) return;
    SZTRenderObject *object = info.userInfo[SZTObject];

    [object setContext:_glContext];
    
    // 加锁
    _isLockObject = true;
    if (object.isScreen) {
        [_object2DArray addObject:object];
    }else if([NSStringFromClass([object class]) isEqual: @"ScriptUI"]){
        _ScriptUI = (ScriptUI *)object;
    }else{
        [_object3DArray addObject:object];
    }
    // 解锁
    _isLockObject = false;
}

- (void)sztObjectRemove:(NSNotification *)info
{
    if ([ClassNameTool sharedClassNameTool].className != self.identifier) return;
    SZTRenderObject *object = info.userInfo[SZTObject];

    _isLockObject = true;
    if (object.isScreen) {
        if ([NSStringFromClass([object class]) isEqual: @"SZTPoint"]) {
            [_object2DArray removeObject:object];
        }
    }else if([NSStringFromClass([object class]) isEqual: @"ScriptUI"]){
        if (_ScriptUI) {
            [_ScriptUI destory];
            _ScriptUI = nil;
        }
    }else{
        [_object3DArray removeObject:object];
    }
    _isLockObject = false;
}
    
#pragma mark - render
- (void)renderToFbo
{
    for (int i = 0; i < _fboArray.count; i++) {
        [[SZTCamera sharedSZTCamera] updateMatrix:i];
        SZTFbo * fbo = _fboArray[i];
        
        [fbo renderFBO];
        
        [self renderObjects:i];
        
        [fbo resetDefaultFBO];
    }
}

- (void)renderToScreen
{
    [[SZTCamera sharedSZTCamera] updateMatrix:0];
    [self renderObjects:0];
}

- (void)renderObjects:(int)index
{
    if ([ClassNameTool sharedClassNameTool].className != self.identifier) return;
    if (_isLockObject) return;
    
    // 背面剔除
    glEnable(GL_CULL_FACE);
    glFrontFace(GL_CCW);
    glCullFace(GL_BACK);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glEnable(GL_DEPTH_TEST);
    
    if (_object3DArray.count > 0) {
        for (SZTBaseObject * obj in _object3DArray) {
            if (!obj.hidden) {
                [obj renderToFbo:index];
            }
        }
    }

    glDisable(GL_DEPTH_TEST);
    
    // 2d对象，不进行深度检测
    if (_object2DArray.count > 0) {
        for (SZTBaseObject * obj in _object2DArray) {
            if (!obj.hidden) {
                [obj renderToFbo:index];
            }
        }
    }
    
    glDisable(GL_BLEND);
    glDisable(GL_CULL_FACE);
}

- (void)renderFboToScreen:(SZTProgram *)program
{
    [program useProgram];
    
    glUniform1f([program uniformIndex:@"barrelDistortion"], self.isDistortion);
    glUniform1f([program uniformIndex:@"blackEdgeValue"], program.blackEdgeValue);
    glUniformMatrix4fv(program.MVMatrixHandle, 1, 0, GLKMatrix4Identity.m);
    
    for (int i = 0; i < _fboArray.count; i++) {
        SZTFbo * fbo = _fboArray[i];
    
        [fbo updateTexture:program.uSamplerLocal];
       
        if (i == 0) {
            [fboLeftObj drawElementsFBO:program];
        }else{
            [fboRightObj drawElementsFBO:program];
        }
    }
}

- (void)removeAllObjects
{
    for (SZTRenderObject *obj in _object3DArray) {
        [obj.touch destory];
    }
    [_object3DArray removeAllObjects];
    _object3DArray = nil;
    
    
    for (SZTRenderObject *obj in _object2DArray) {
        [obj.touch destory];
    }
    [_object2DArray removeAllObjects];
    _object2DArray = nil;
    
    if (_ScriptUI) {
        [_ScriptUI destory];
        _ScriptUI = nil;
    }
}

- (void)dealloc
{
    SZTLog(@"SZTManager dealloc");
    
    [self removeAllObjects];
    [self removeObserver];
}

@end
