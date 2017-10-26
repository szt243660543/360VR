//
//  SZTDome3D.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2017/2/4.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTDome3D.h"

@interface SZTDome3D ()

@end

@implementation SZTDome3D

- (void)setupVBO_Render:(float)radians isLeft:(BOOL)isLeft
{
    generateDome(radians, 128, isLeft, self);
    
    [super setupVBO];
}

void generateDome (float radius, int numSlices, bool isLeft, SZTDome3D* object3D) {
    int i;
    int j;
    float percent = 180.0/360.0f;
    int numParallels = numSlices >> 1;
    int numVertices = ( numParallels + 1 ) * ( numSlices + 1 );
    int numParallelActual = numParallels * percent;
    int numIndices = numParallelActual * numSlices * 6;
    float angleStep = (2.0f * ES_PI) / ((float) numSlices);
    
    float* vertices = malloc ( sizeof(float) * 3 * numVertices );
    float* texCoords = malloc ( sizeof(float) * 2 * numVertices );
    short* indices = malloc ( sizeof(short) * numIndices );
    
//    int upper = object3D->mIsUpper ? 1 : -1;

    int upper = 1;
    
    for ( i = 0; i < numParallelActual + 1; i++ ) {
        for ( j = 0; j < numSlices + 1; j++ ) {
            int vertex = ( i * (numSlices + 1) + j ) * 3;
            
            if (vertices) {
                vertices[vertex + 0] = radius * sinf ( angleStep * (float)i ) * sinf ( angleStep * (float)j ) * upper;
                vertices[vertex + 1] = radius * sinf ( ES_PI/2 + angleStep * (float)i ) * upper;
                vertices[vertex + 2] = radius * sinf ( angleStep * (float)i ) * cosf ( angleStep * (float)j );
            }
            
            if (texCoords) {
                // (Math.cos( 2 * PI * s * S) * r * R / percent)/2.0f + 0.5f;
                int texIndex = ( i * (numSlices + 1) + j ) * 2;
                float a = cosf((float) j * angleStep) * (float)i / (numParallels + 1) / percent * 0.5f + 0.5f;
                float b = sinf((float) j * angleStep) * (float)i / (numParallels + 1) / percent * 0.5f + 0.5f;
            
                texCoords[texIndex + 0] = b;
                texCoords[texIndex + 1] = a;
            }
        }
    }
    
    float ratio = 1.77777778;
    float* texCoords1 = malloc (sizeof(float) * 2 * 2 * numVertices);
    for (int i = 0; i < 2 * numVertices; i += 2){
        texCoords1[i] = (texCoords[i] - 0.5f)/ratio + 0.5f;
        texCoords1[i+1] = texCoords[i + 1];
    }
    
    // Generate the indices
    if ( indices != NULL ) {
        short* indexBuf = indices;
        for ( i = 0; i < numParallelActual ; i++ ) {
            for ( j = 0; j < numSlices; j++ ) {
                *indexBuf++ = (short)(i * ( numSlices + 1 ) + j); // a
                *indexBuf++ = (short)(( i + 1 ) * ( numSlices + 1 ) + ( j + 1 )); // c
                *indexBuf++ = (short)(( i + 1 ) * ( numSlices + 1 ) + j); // b
                *indexBuf++ = (short)(i * ( numSlices + 1 ) + j); // a
                *indexBuf++ = (short)(i * ( numSlices + 1 ) + ( j + 1 )); // d
                *indexBuf++ = (short)(( i + 1 ) * ( numSlices + 1 ) + ( j + 1 )); // c
            }
        }
    }
    
    [object3D setIndicesBuffer:indices size:numIndices]; //object3D.setIndicesBuffer(indexBuffer);
    [object3D setTextureBuffer:texCoords1 size:2 * numVertices]; //object3D.setTexCoordinateBuffer(texBuffer);
    [object3D setVertexBuffer:vertices size: 3 * numVertices]; //object3D.setVerticesBuffer(vertexBuffer);
    [object3D setNumIndices:numIndices];
    
    free(indices);
    free(texCoords);
    free(vertices);
    free(texCoords1);
}

@end
