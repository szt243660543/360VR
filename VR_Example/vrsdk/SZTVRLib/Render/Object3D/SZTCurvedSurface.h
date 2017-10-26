//
//  SZTCurvedSurface.h
//  SZTVR_SDK
//
//  Created by szt on 2017/5/31.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTObject3D.h"

@interface SZTCurvedSurface : SZTObject3D

- (void)setupVBO_Render:(size *)objSize isStereo:(BOOL)isStereo isLeft:(BOOL)isleft isFilp:(BOOL)isflip;

@end
