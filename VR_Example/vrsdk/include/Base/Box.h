//
//  Box.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/22.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DELTA 0.0000001
#define max_n 1000000000

@interface Box : NSObject

@property(nonatomic, strong)NSMutableArray *vectorArr;
@property(nonatomic, strong)NSMutableArray *curPosArr;
@property(nonatomic, assign)GLKVector3 pickingPos;

@property(nonatomic, assign)BOOL isObjModel;

- (BOOL)intersect:(GLKMatrix4)modelMatrix;

@end
