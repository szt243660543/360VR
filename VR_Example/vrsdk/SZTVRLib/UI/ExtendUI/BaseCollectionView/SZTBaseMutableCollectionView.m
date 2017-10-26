//
//  SZTBaseMutableUIView.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/31.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTBaseMutableCollectionView.h"

@interface SZTBaseMutableCollectionView()
{
    dispatch_source_t _timer;
    int _offsetY;   // 偏移视角
}

@end

@implementation SZTBaseMutableCollectionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _offsetY = 25;
        [self update];
    }
    return self;
}

- (void)update
{
    __weak typeof(self) weakSelf = self;
    NSTimeInterval period = 0.5; // 设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        [weakSelf checkFilp];
    });
    
    dispatch_resume(_timer);
}

- (void)checkFilp
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.row > weakSelf.showRow) {
            int offset = weakSelf.row - weakSelf.showRow;
            if ([SZTCamera sharedSZTCamera].zTheta <= -_offsetY) { // 向上翻页
                if (weakSelf.moveY > 0) {
                    weakSelf.moveY --;
                    [weakSelf flipAnimation:0.2 X:0.0 Y:(weakSelf.height + weakSelf.spacingY) Z:0.0];
                }
            }else if ([SZTCamera sharedSZTCamera].zTheta >= _offsetY){ // 向下翻页
                if (weakSelf.moveY < offset) {
                    weakSelf.moveY ++;
                    [weakSelf flipAnimation:0.2 X:0.0 Y:-(weakSelf.height + weakSelf.spacingY) Z:0.0];
                }
            }
        }
    });
}

- (void)flipAnimation:(float)time X:(float)x Y:(float)y Z:(float)z
{
    __weak typeof(self) weakSelf = self;
    for (SZTImageView * imgv in self.buttonArr) {
        [imgv moveBy:time PosX:x posY:y posZ:z finishBlock:^{
            [weakSelf setPosition:self.mPX Y:self.mPY Z:self.mPZ];
            [weakSelf offsetObject];
        }];
    }
}

- (void)offsetObject
{

}

- (void)dealloc
{
    _timer = nil;
    SZTLog(@"SZTBaseMutableUIView dealloc");
}

@end
