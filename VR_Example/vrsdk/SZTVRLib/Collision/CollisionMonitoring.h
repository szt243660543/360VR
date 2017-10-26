//
//  CollisionMonitoring.h
//  SZTVR_SDK
//
//  Created by SZT on 16/10/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTGif.h"

@protocol CollisionObjectDelegate <NSObject>
- (void)willSelectCollisionObject;
- (void)didSelectCollisionObject;
- (void)didLeaveCollisionObject;
@end

@interface CollisionMonitoring : NSObject

- (instancetype)initWithCollisionObj:(SZTRenderObject *)obj;

- (void)collisionChecking;

- (void)removeObject;

@property(nonatomic, assign)GLKVector3 pickingVector;
@property(nonatomic, weak)id <CollisionObjectDelegate>delegate;
@property(nonatomic, assign)float selectTime;

@end
