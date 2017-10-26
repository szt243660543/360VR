//
//  SZTSector.h
//  SZTVR_SDK
//
//  Created by szt on 2017/6/1.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTObject3D.h"

@interface SZTSector : SZTObject3D

- (void)setupVBO_Render:(size *)objSize isStereo:(BOOL)isStereo isLeft:(BOOL)isleft isFilp:(BOOL)isflip;

@end
