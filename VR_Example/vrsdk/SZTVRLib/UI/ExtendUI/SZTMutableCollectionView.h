//
//  SZTConfigurableButtonView.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/11.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTBaseMutableCollectionView.h"

@protocol SZTMutableCollectionViewTouchDelegate <NSObject>
- (void)willSelectMutableObject:(SZTBaseObject *)obj;
- (void)didSelectMutableObject:(SZTBaseObject *)obj;
- (void)willLeaveMutableObject:(SZTBaseObject *)obj;
@end

@interface SZTMutableCollectionView :SZTBaseMutableCollectionView

@property(nonatomic, weak) id <SZTMutableCollectionViewTouchDelegate> delegate;

/**
 * 索引 - 删除按钮
 */
- (void)removeChildObjectByIndex:(int)index;

/**
 * 添加子视图
 */
- (void)addChildObject:(SZTImageView *)obj;

@end
