//
//  Box.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/22.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "Box.h"

@implementation Box

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.vectorArr = [[NSMutableArray alloc] init];
        self.curPosArr = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (BOOL)intersect:(GLKMatrix4)modelMatrix
{
    return false;
}

@end
