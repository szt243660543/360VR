//
//  SZTWaveFrontObj.m
//  SZTVR_SDK
//
//  Created by SZT on 16/10/24.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTWaveFrontObj.h"

@implementation SZTWaveFrontObj

- (void)setupVBO_Render:(SZTModel *)objData
{
    self.isobj = YES;

    self.vertices = objData.vertices;
    self.elementCount = objData.elementCount;
    self.elements = objData.elements;
    self.textureCoords = objData.texCoords;
    self.elementType = objData.elementType;
    
    self.vectorArr = objData.vectorArr;
    
    [super setupVBO];
}

@end
