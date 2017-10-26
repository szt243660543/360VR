//
//  CollisionMonitoring.m
//  SZTVR_SDK
//
//  Created by SZT on 16/10/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "CollisionMonitoring.h"
#import "Picking.h"
#import "SZTRay.h"
#import "Box.h"
#import "AABB.h"
#import "OBB.h"

@interface CollisionMonitoring()
{
    BOOL _selectObject;
    BOOL _willSelectObject;
    BOOL _didLeaveObject;
    float _selectSpeed;
    
    SZTRenderModel _renderModel;
}

@property(nonatomic, weak)SZTRenderObject *collisionObj;
@property(nonatomic, strong)SZTGif *progressRing;
@property(nonatomic, strong)Box *box;

@end

@implementation CollisionMonitoring

- (instancetype)initWithCollisionObj:(SZTRenderObject *)obj
{
    self = [super init];
    
    if (self) {
        self.collisionObj = obj;
    
        // 设置碰撞检测盒子
        [self setupCollisionBox];
        
        _selectObject = false;
        _willSelectObject = false;
        _didLeaveObject = false;
        
        _renderModel = obj.renderModel;
        _selectSpeed = 2.0;
        _selectTime = 2.0;
        
        [self setProgressWithGif];
        
        // 单击耳机键
        [NotificationCenter addObserver:self selector:@selector(earPhoneOneTarget) name:EventSubtypeRemoteControlTogglePlayPause object:nil];
    }
    
    return self;
}

- (void)setupCollisionBox
{
    if ([Picking sharedPicking].isObbPicking) {
        OBB *obb = [[OBB alloc] init];
        self.box = obb;
    }else{
        AABB *aabb = [[AABB alloc] init];
        self.box = aabb;
    }
    self.box.vectorArr = _collisionObj.obj_Left.vectorArr;
    self.box.isObjModel = _collisionObj.obj_Left.isobj;
}

- (void)earPhoneOneTarget
{
    if ([self.box intersect:self.collisionObj.mModelMatrix]) {
        [self didSelectObjectCallBack];
    
        if (_progressRing) {
            [_progressRing setPosition:10.0 Y:0.0 Z:0.0];
            [_progressRing pause];
        }
    }
}

- (void)collisionChecking
{
    if ([Picking sharedPicking].focusPickingState)
    {
        if ([self.box intersect:self.collisionObj.mModelMatrix]) {
            if (!_collisionObj.setTouchEnable) return;
            
            // 将要拾取状态
            [self willSelectObjectCallBack];
        }else{
            // 移开选中
            [self didLeaveObjectCallBack];
            
            // 未拾取
            _selectObject = false;
            _willSelectObject = false;

            if (_progressRing) {
                [_progressRing setPosition:10.0 Y:0.0 Z:0.0];
                [_progressRing pause];
            }
        }
        
        self.pickingVector = self.box.pickingPos;
    }
    
    if ([Picking sharedPicking].touchEventState) {
        if (!_collisionObj.setTouchEnable) return;
    
        if ([self.box intersect:self.collisionObj.mModelMatrix]) {
            [[SZTRay sharedSZTRay] resetRay];
            self.pickingVector = self.box.pickingPos;
            
            [self.delegate didSelectCollisionObject];
        }
    }
}

- (void)willSelectObjectCallBack
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willSelectCollisionObject)] && !_willSelectObject) {
        [self setProgressRing];
        _didLeaveObject = true;
        _willSelectObject = true;
        [self.delegate willSelectCollisionObject];
    }
}

- (void)didSelectObjectCallBack
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCollisionObject)]) {
        [self.delegate didSelectCollisionObject];
    }
}

- (void)didLeaveObjectCallBack
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLeaveCollisionObject)] && _didLeaveObject) {
        _didLeaveObject = false;
        [self.delegate didLeaveCollisionObject];
    }
}

- (void)setProgressRing
{
    [_progressRing setPosition:0.0 Y:0.0 Z:0.0];
    [_progressRing resume];
}

- (void)setProgressWithGif
{
    _progressRing = [[SZTGif alloc] init];
    _progressRing.isScreen = YES;
    _progressRing.speed = _selectSpeed;
    _progressRing.isRenderMonocular = [Picking sharedPicking].isRenderMonocular;
    NSString * gifPath = [[NSBundle mainBundle] pathForResource:@"focus_loading.png" ofType:nil];
    [_progressRing setupApngWithApngPath:gifPath playTime:_selectTime];
    objectSize size = [MathC getFocusPointSizeByScreenCount:[SZTCamera sharedSZTCamera].screenNumber];
    [_progressRing setObjectSize:size.width * 10.0 Height:size.height * 10.0];
    [_progressRing build];
    [_progressRing pause];
    
    __weak typeof(self) weakSelf = self;
    [_progressRing gifDidFinishedCallback:^(SZTGif *gif) {
        if (!weakSelf.collisionObj.setTouchEnable) {
            
        }else{
            [weakSelf didSelectObjectCallBack];
        }
    }];
}

- (void)removeObject
{
    if (_progressRing) {
        [_progressRing removeObject];
        _progressRing = nil;
    }
}

- (void)dealloc
{
    [self removeObject];
    self.box = nil;
    [NotificationCenter removeObserver:self name:EventSubtypeRemoteControlTogglePlayPause object:nil];
}

@end
