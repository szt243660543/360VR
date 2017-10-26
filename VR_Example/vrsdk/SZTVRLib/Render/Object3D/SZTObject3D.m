//
//  SZTObject3D.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/26.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTObject3D.h"
#import <GLKit/GLKit.h>
#import "Vertex.h"

@interface SZTObject3D()
{
    GLuint _vertexBuffer;
    GLuint _texCoordBuffer;
    GLuint _indexBuffer;
    
    int vertexs;
}

@end

@implementation SZTObject3D

- (NSMutableArray *)vectorArr
{
    if (!_vectorArr) {
        _vectorArr = [NSMutableArray array];
    }
    
    return _vectorArr;
}

#pragma mark - FBO对象
- (void)setupVBO_Left
{
    [self setupVBO];
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(gVertexDataLeftScreen), gVertexDataLeftScreen, GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}

- (void)setupVBO_Right
{
    [self setupVBO];
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(gVertexDataRightScreen), gVertexDataRightScreen, GL_STATIC_DRAW);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}

- (void)setupVBO
{
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    
    glGenBuffers(1, &_texCoordBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
}

- (void)drawElementsFBO:(SZTProgram *)program
{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(program.texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    glVertexAttribPointer(program.positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

- (void)drawElements:(SZTProgram *)program
{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    if (_isobj) {
        if (_isMD2) {
            glVertexAttribPointer(program.texCoordSlot, 2, GL_FLOAT, 0, 0, self.frametextureCoords);
            glVertexAttribPointer(program.positionSlot, 3, GL_FLOAT, 0, 0, self.frameVertices);
            
            glDrawArrays(GL_TRIANGLES, 0, _num_triangles);
        }else{
            glVertexAttribPointer(program.texCoordSlot, 2, GL_FLOAT, 0, 0, self.textureCoords);
            glVertexAttribPointer(program.positionSlot, 3, GL_FLOAT, 0, 0, self.vertices);
            
            glDrawElements(GL_TRIANGLES, self.elementCount, self.elementType, self.elements);
        }
    }else{
        glVertexAttribPointer(program.texCoordSlot, 2, GL_FLOAT, 0, 0, self.mTextureBuffer);
        glVertexAttribPointer(program.positionSlot, 3, GL_FLOAT, 0, 0, self.mVertexBuffer);
        
        glDrawElements(GL_TRIANGLES, _mNumIndices, GL_UNSIGNED_SHORT, self.mIndicesBuffer);
    }
}

- (void)updateKeyFrame
{
    
}

- (void)setVertexBuffer:(float*)buffer size:(int)size
{
    [self destroyVertexBuffer];
    
    int size_t = sizeof(float)*size;
    _mVertexBuffer = malloc(size_t);
    memcpy(_mVertexBuffer, buffer, size_t);
    
    self.mNumVertes = size;
}

- (void)setIndicesBuffer:(short *)buffer size:(int)size
{
    [self destroyIndicesBuffer];
    
    int size_t = sizeof(short)*size;
    _mIndicesBuffer = malloc(size_t);
    memcpy(_mIndicesBuffer, buffer, size_t);
}

- (void)setTextureBuffer:(float*)buffer size:(int)size
{
    [self destroyTextureBuffer];
    
    int size_t = sizeof(float)*size;
    _mTextureBuffer = malloc(size_t);
    memcpy(_mTextureBuffer, buffer, size_t);
    
    self.mNumTextures = size;
}

- (void)setNumIndices:(int)value
{
    _mNumIndices = value;
}

- (void)destroy
{
    [self destroyVertexBuffer];
    
    [self destroyTextureBuffer];
    
    [self destroyIndicesBuffer];
}

- (void)destroyVertexBuffer
{
    if (_mVertexBuffer != NULL){
        free(_mVertexBuffer);
        _mVertexBuffer = nil;
    }
}

- (void)destroyTextureBuffer
{
    if (_mTextureBuffer != NULL){
        free(_mTextureBuffer);
        _mTextureBuffer = nil;
    };
}

- (void)destroyIndicesBuffer
{
    if (_mIndicesBuffer != NULL){
        free(_mIndicesBuffer);
        _mIndicesBuffer = nil;
    };
}

-(void)dealloc
{
    [self destroy];
}

@end

