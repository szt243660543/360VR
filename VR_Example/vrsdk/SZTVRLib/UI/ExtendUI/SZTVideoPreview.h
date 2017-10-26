//
//  SZTVideoPreview.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/23.
//  Copyright © 2016年 SZTVR. All rights reserved.

/***************************************************************************/
/*****************************  只针对IJKPlayer *****************************/
/***************************************************************************/

#import <UIKit/UIKit.h>
#import "SZTVideo.h"
#import "SZTBaseMutableCollectionView.h"

@protocol SZTVideoPreviewTouchDelegate <NSObject>
- (void)willSelectVideoPreviewChildObject:(SZTBaseObject *)obj;
- (void)didSelectVideoPreviewChildObject:(SZTBaseObject *)obj;
- (void)didLeaveVideoPreviewChildObject:(SZTBaseObject *)obj;
@end

@interface SZTVideoPreview : SZTBaseMutableCollectionView

@property(nonatomic, weak) id <SZTVideoPreviewTouchDelegate> delegate;

/**
 * 索引 - 删除按钮
 */
- (void)removeChildObjectByIndex:(int)index;

/**
 * 添加子视图
 */
- (void)addChildObject:(SZTVideo *)obj;

/**
 * 添加子视图集
 */
- (void)addChildObjectsWithURL:(NSMutableArray *)urlArr;

@end
