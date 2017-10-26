//
//  SZTModel.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/13.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTModel : NSObject

- (instancetype)initWithPath:(NSString *)path;

@property (nonatomic, assign) GLfloat *vertices;
@property (nonatomic, assign) GLfloat *texCoords;
@property (nonatomic, assign) GLfloat *normals;
@property (nonatomic, assign) void *elements;
@property (nonatomic, assign) GLuint componentCount;
@property (nonatomic, assign) GLuint vertexCount;
@property (nonatomic, assign) GLuint elementCount;
@property (nonatomic, assign) GLuint elementSize;
@property (nonatomic, assign) GLenum elementType;

@property(nonatomic, strong)NSMutableArray *vectorArr;

@end
