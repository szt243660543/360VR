//
//  SZTFishSphere3D.h
//  SZTVR_SDK
//
//  Created by SZT on 16/10/24.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTObject3D.h"
#import "FishSpec.h"

@interface SZTFishSphere3D : SZTObject3D

@property (nonatomic , assign)Resolution resolution;

- (void)setupVBO_Render:(float)radians isLeft:(BOOL)isleft isFlip:(BOOL)isflip;

@end
