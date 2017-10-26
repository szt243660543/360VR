//
//  SZTTouch.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 16/11/25.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTTouch.h"
#import "CollisionMonitoring.h"

@interface SZTTouch()<CollisionObjectDelegate>
{
    SZTRenderObject *_obj;
    NSTimer *_timer;
}

@property(nonatomic, strong)CollisionMonitoring *collisionHandle;

@end

@implementation SZTTouch

- (instancetype)initWithTouchObject:(SZTRenderObject *)obj;
{
    self = [super init];
    
    if (self) {
        obj.touch = self;
        _obj = obj;
        
        _collisionHandle = [[CollisionMonitoring alloc] initWithCollisionObj:obj];
        _collisionHandle.delegate = self;
        
        _timer = [NSTimer timerWithTimeInterval:1.0/10.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode: NSDefaultRunLoopMode];
    }
    
    return self;
}

- (void)update
{
    [_collisionHandle collisionChecking];
}

- (void)setSelectTime:(float)time
{
    _collisionHandle.selectTime = time;
}

#pragma mark CollisionObjectDelegate
- (void)willSelectCollisionObject
{
    if (willSelectblock) {
        willSelectblock(_collisionHandle.pickingVector);
    }
}

- (void)didSelectCollisionObject
{
    if (didSelectblock) {
        didSelectblock(_collisionHandle.pickingVector);
    }
}

- (void)didLeaveCollisionObject
{
    if (willLeaveblock) {
        willLeaveblock(_collisionHandle.pickingVector);
    }
}

- (void)willTouchCallBack:(willTouch)block
{
    willSelectblock = block;
}

- (void)didTouchCallback:(didTouch)block
{
    didSelectblock = block;
}

- (void)endTouchCallback:(endTouch)block
{
    willLeaveblock = block;
}

- (void)destory
{
    if (_collisionHandle) {
        [_collisionHandle removeObject];
        _collisionHandle = nil;
    }
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)dealloc
{
    [self destory];
}

@end
