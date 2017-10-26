//
//  SZTRay.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 16/11/23.
//  Copyright © 2016年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface SZTRay : NSObject

SingletonH(SZTRay)

- (void)calculateABPosition:(float)x y:(float)y width:(float)w height:(float)h left:(float)left top:(float)top near:(float)near far:(float)far;

- (void)calculateABPositionWithTouchPoint:(GLKVector2)touch screenCount:(int)index;

- (void)resetRay;

@property(nonatomic, assign)GLKVector3 ray;

@property(nonatomic, assign)GLKVector3 nearPos;

@property(nonatomic, assign)GLKVector3 farPos;

@end
