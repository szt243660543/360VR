//
//  MonitorShakingTool.h
//  SZTVR_SDK
//
//  Created by SZT on 16/10/25.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MonitorShakingToolDelegate <NSObject>

- (void)didShakingCallback;

@end

@interface MonitorShakingTool : NSObject

@property(nonatomic, weak)id <MonitorShakingToolDelegate> delegate;

/**
 * 退出后必须调用销毁，否则会内存泄漏
 */
- (void)destory;

@end
