//
//  SZTShineBar.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/17.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTShineBar.h"

@interface SZTShineBar()
{
    SZTImageView *_shineImage;
    dispatch_source_t _timer;
    BOOL _isShow;
}

@end

@implementation SZTShineBar

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self loadShineImage];
    }
    
    return self;
}

- (void)loadShineImage
{
    _shineImage = [[SZTImageView alloc] initWithMode:SZTVR_PLANE];
}

- (void)setupTextureWithColor:(UIColor *)color
{
    [_shineImage setupTextureWithColor:color Rect:CGRectMake(0.0, 0.0, 1.0, 1.0)];
}

- (void)setObjectSize:(float)width Height:(float)height
{
    [_shineImage setObjectSize:width Height:height];
}

- (void)setPosition:(float)x Y:(float)y Z:(float)z
{
    [_shineImage setPosition:x Y:y Z:z];
    
    self.pX = x;
    self.pY = y;
    self.pZ = z;
}

- (void)build
{
    [_shineImage build];
    
    [self loadTime];
}

- (void)loadTime
{
    NSTimeInterval period = 0.5; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (_isShow) {
            _isShow = false;
            [_shineImage setScale:1.0 Y:1.0 Z:1.0];
        }else{
            _isShow = true;
            [_shineImage setScale:0.0 Y:0.0 Z:0.0];
        }
    });
    dispatch_resume(_timer);
}

- (void)removeObject
{
    [_shineImage removeObject];
    _shineImage = nil;
    
    _timer = nil;
}

- (void)dealloc
{
    [self removeObject];
    
    SZTLog(@"SZTShineBar dealloc");
}

@end
