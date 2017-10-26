//
//  SZTDome3D.h
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2017/2/4.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTObject3D.h"

@interface SZTDome3D : SZTObject3D

- (void)setupVBO_Render:(float)radians isLeft:(BOOL)isLeft;

@end
