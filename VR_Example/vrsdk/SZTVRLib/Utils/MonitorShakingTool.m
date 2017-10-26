//
//  MonitorShakingTool.m
//  ANTVR_SDK
//
//  Created by SZT on 16/10/25.
//  Copyright © 2016年 ANTVR. All rights reserved.
//

#import "MonitorShakingTool.h"

@interface MonitorShakingTool()
{
    CADisplayLink *_displayLink;
    
    BOOL _isLeft;
    BOOL _isRight;
    
    BOOL _isLetfFitstIn;
    BOOL _isRightFitstIn;
}

@end

@implementation MonitorShakingTool

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _isLetfFitstIn = true;
        _isRightFitstIn = true;
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return self;
}

- (void)update
{
    // 从左摇
    [self shakingFromLeft];

    // 从右摇
    // [self shakingFromRight];
    
    if (_isLeft && _isRight) {
        [self resetData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didShakingCallback)]) {
            [self.delegate didShakingCallback];
        }
    }
}

- (void)shakingFromLeft
{
    if ([SZTCamera sharedSZTCamera].rotationX > 2.0 && _isLetfFitstIn) {
        _isLetfFitstIn = false;
        _isLeft = true;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resetData];
        });
    }
    
    if ([SZTCamera sharedSZTCamera].rotationX < -2.0 && !_isLetfFitstIn) {
        _isRight = true;
    }else{
        _isRight = false;
    }
}

- (void)shakingFromRight
{
    if ([SZTCamera sharedSZTCamera].rotationX < -3.0 && _isRightFitstIn) {
        _isRightFitstIn = false;
        _isRight = true;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resetData];
        });
    }
    
    
    if ([SZTCamera sharedSZTCamera].rotationX > 3.0 && !_isRightFitstIn) {
        _isLeft = true;
    }else{
        _isLeft = false;
    }
}

- (void)resetData
{
    _isLeft = false;
    _isRight = false;
    _isLetfFitstIn = true;
    _isRightFitstIn = true;
}

- (void)destory
{
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)dealloc
{
    SZTLog(@"MonitorShakingTool dealloc");
}

@end
