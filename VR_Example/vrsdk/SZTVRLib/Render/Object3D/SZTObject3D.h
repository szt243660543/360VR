//
//  SZTObject3D.h
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZTProgram.h"
#import "MathC.h"

@interface SZTObject3D : NSObject

@property (nonatomic, assign)float* mVertexBuffer;
@property (nonatomic, assign)float* mTextureBuffer;
@property (nonatomic, assign)short* mIndicesBuffer;
@property (nonatomic, assign)int mNumIndices;
@property (nonatomic, assign)int mNumVertes;
@property (nonatomic, assign)int mNumTextures;

@property (nonatomic, assign)GLfloat *vertices;
@property (nonatomic, assign)GLfloat *textureCoords;
@property (nonatomic, assign)BOOL isobj;
@property (nonatomic, strong)NSArray *groups;
@property (nonatomic, assign)GLuint elementCount;
@property (nonatomic, assign)void *elements;
@property (nonatomic, assign)GLenum elementType;

// md2
@property (nonatomic, assign)GLKVector3 *frameVertices;
@property (nonatomic, assign)GLKVector2 *frametextureCoords;
@property (nonatomic, assign)int num_triangles;
@property (nonatomic, assign)BOOL isMD2;

- (void)updateKeyFrame;

// 存放模型顶点数组
@property(nonatomic, strong)NSMutableArray *vectorArr;

- (void)setupVBO_Left;
- (void)setupVBO_Right;
- (void)setupVBO;

- (void)drawElements:(SZTProgram *)program;
- (void)drawElementsFBO:(SZTProgram *)program;

- (void)setVertexBuffer:(float*)buffer size:(int)size;
- (void)setIndicesBuffer:(short *)buffer size:(int)size;
- (void)setTextureBuffer:(float*)buffer size:(int)size;
- (void)setNumIndices:(int)value;

- (void)destroy;

@end
