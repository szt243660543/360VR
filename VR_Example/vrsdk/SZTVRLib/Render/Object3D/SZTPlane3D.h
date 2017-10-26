//
//  SZTPlane3D.h
//  SZTVR_SDK
//
//  Created by SZT on 16/10/24.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTObject3D.h"

@interface SZTPlane3D : SZTObject3D

- (void)setupVBO_Render:(size *)objSize isStereo:(BOOL)isStereo isLeft:(BOOL)isleft isFilp:(BOOL)isflip isUpDown:(BOOL)isUpDown isLeftRight:(BOOL)isLeftRight;

@end
