//
//  SZTRecommendView.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/31.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTBaseCollectionView.h"

@protocol SZTCollectionViewTouchDelegate <NSObject>

- (void)willSelectChildObject:(SZTBaseObject *)obj;
- (void)didSelectChildObject:(SZTBaseObject *)obj;
- (void)willLeaveChildObject:(SZTBaseObject *)obj;

@end

@interface SZTCollectionView : SZTBaseCollectionView

@property(nonatomic, weak) id <SZTCollectionViewTouchDelegate> delegate;

/**
 * 传入url集合
 * isnet 网络地址／本地地址
 */
- (void)addChildObjects:(NSArray *)urlArr isNet:(BOOL)isnet;

@end
