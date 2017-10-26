//
//  SZTSphere3D.m
//  SZTVR_SDK
//
//  Created by SZT on 16/10/24.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTSphere3D.h"

#pragma mark - 球
@interface SZTSphere3D()

@end

@implementation SZTSphere3D

- (void)setupVBO_Render:(float)radians isStereo:(BOOL)isStereo isLeft:(BOOL)isleft isFilp:(BOOL)isflip isUpDown:(BOOL)isUpDown isLeftRight:(BOOL)isLeftRight
{
    generateSphere(radians, 75, 150, isStereo, isleft, isflip, self, isUpDown, isLeftRight);
    
    [super setupVBO];
}

void generateSphere(float radius, int longtitude, int latitude, bool stereo, bool isLeft, bool isflip, SZTObject3D* object3D, bool isUpDown, bool isLeftRight) {
    float PI = ES_PI;
    
    int numPoints = longtitude * (latitude+1) * 3;
    int numTexcoords = longtitude * (latitude+1) * 2;
    int numIndices = (longtitude-1) * latitude * 6;
    
    float* points = malloc ( sizeof(float) * numPoints);
    float* texcoords = malloc ( sizeof(float) * numTexcoords);
    short* indices = malloc ( sizeof(short) * numIndices);
    
    int t = 0, v = 0, counter = 0;;
    float theta = 0.0f, phi = 0.0f;
    float longtiRatio = 1.0;
    float latiRatio = isLeftRight?1.0:2.0;
    
    for(int i = 0; i < longtitude; i++) {
        phi =(PI/2-i/(longtitude-1+0.0)*PI)*longtiRatio;
        
        for(int j = 0; j < latitude+1; j++) {

            theta =(j/(latitude+0.0)*PI-PI/2)*latiRatio;
            float r = -radius *(float)cosf(phi);
            
            float x = r * (float)sinf(theta);
            float y = radius * (float)sinf(phi);
            float z = r * (float)cosf(theta);
            
            points[v++] = x;  // X-axis
            points[v++] = y;  // Y-axis;
            points[v++] = z; // Z-axis
            
            point *pos = [[point alloc] init];
            pos.vertexPoint = GLKVector3Make(x, y, z);
            [object3D.vectorArr addObject:pos];
            
            if (isLeftRight) { // 半球3D180
                if(isLeft){
                    texcoords[t++] = 0.5f - ((float) ((j + 0.0) / (latitude - 1.0)) * 0.5f); // x-axis
                }else{
                    texcoords[t++] = 1.5f - (0.5f + (float) ((j + 0.0) / (latitude - 1.0)) * 0.5f); // x-axis
                }
                
                texcoords[t++] = (float) ((i + 0.0) / (longtitude - 1.0));
            }else{
                texcoords[t++] = 1.0f-(float) ((j + 0.0) / (latitude + 0.0));//:((float) ((j + 0.0) / (latitude + 0.0))); // x-axis
                if (isUpDown) { // 立体全景
                    if(isLeft){
                        if (isflip) {
                            texcoords[t++] =1.0f - (float) ((i + 0.0) / (longtitude - 1.0)) * 0.5f; // y-axis
                        }else{
                            texcoords[t++] =(float) ((i + 0.0) / (longtitude - 1.0)) * 0.5f; // y-axis
                        }
                    }else{
                        if (isflip) {
                            texcoords[t++] = 0.5f - (float) ((i + 0.0) / (longtitude - 1.0)) * 0.5f; // y-axis
                        }else{
                            texcoords[t++] = 0.5f + (float) ((i + 0.0) / (longtitude - 1.0)) * 0.5f; // y-axis
                        }
                    }
                }else{ // 普通全景
                    if (isflip) {
                        texcoords[t++] = 1.0f-(float)((i+0.0)/(longtitude-1.0)); //y-axis
                    }else{
                        texcoords[t++] = (float)((i+0.0)/(longtitude-1.0)); //y-axis
                    }
                }
            }
        }
    }

    for(int i = 0; i<longtitude-1; i++){
        for(int j= 0; j<latitude; j++)
        {
            //first triangle
            indices[counter++] = (short)(i*(latitude+1)+ j); //upper point
            indices[counter++] = (short) (i*(latitude+1)+j+1); // upper-right point
            indices[counter++] = (short) ((i+1)*(latitude+1) +j); // lower point
            
            //second triangle
            indices[counter++] = (short) ((i+1)*(latitude+1) +j);
            indices[counter++] = (short) (i*(latitude+1)+j+1);
            indices[counter++] = (short) ((i+1)*(latitude+1)+j+1); // lower-right point
        }
    }

    [object3D setIndicesBuffer:indices size:numIndices]; //object3D.setIndicesBuffer(indexBuffer);
    [object3D setTextureBuffer:texcoords size:numTexcoords]; //object3D.setTexCoordinateBuffer(texBuffer);
    [object3D setVertexBuffer:points size:numPoints]; //object3D.setVerticesBuffer(vertexBuffer);
    [object3D setNumIndices:numIndices];
    
    if (indices != NULL) {
        free(indices);
        indices = nil;
    }
    
    if (texcoords != NULL) {
        free(texcoords);
        texcoords = nil;
    }
    
    if (points != NULL) {
        free(points);
        points = nil;
    }
}

@end
