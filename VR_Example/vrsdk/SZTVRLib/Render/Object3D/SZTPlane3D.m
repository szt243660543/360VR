//
//  SZTPlane3D.m
//  SZTVR_SDK
//
//  Created by SZT on 16/10/24.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTPlane3D.h"

@interface SZTPlane3D()
{
    point * _position;
    size * _objSize;
}

@end

@implementation SZTPlane3D

- (void)setupVBO_Render:(size *)objSize isStereo:(BOOL)isStereo isLeft:(BOOL)isleft isFilp:(BOOL)isflip isUpDown:(BOOL)isUpDown isLeftRight:(BOOL)isLeftRight
{
    generatePlane(objSize, isStereo, isleft, isflip, self, isUpDown, isLeftRight);
    
    [super setupVBO];
}

void generatePlane(size * objSize, bool stereo, bool isLeft, bool isflip, SZTObject3D* object3D, bool isUpDown, bool isLeftRight)
{
    float *points = (float*) malloc(12*sizeof(float));
    
    float ratio = 50.0;
    float ratioWidth = objSize.width/(ratio*2.0);
    float ratioHeight = objSize.height/(ratio*2.0);
    
    float tpoints[12] = {
        - ratioWidth,  - ratioHeight, 0.0,
        ratioWidth,  - ratioHeight, 0.0,
        - ratioWidth, ratioHeight, 0.0,
        ratioWidth, ratioHeight, 0.0
    };
    
    point *pos1 = [[point alloc] init];
    pos1.vertexPoint = GLKVector3Make(- ratioWidth, - ratioHeight, 0.0);
    [object3D.vectorArr addObject:pos1];
    point *pos2 = [[point alloc] init];
    pos2.vertexPoint = GLKVector3Make(ratioWidth, - ratioHeight, 0.0);
    [object3D.vectorArr addObject:pos2];
    point *pos3 = [[point alloc] init];
    pos3.vertexPoint = GLKVector3Make(- ratioWidth, ratioHeight, 0.0);
    [object3D.vectorArr addObject:pos3];
    point *pos4 = [[point alloc] init];
    pos4.vertexPoint = GLKVector3Make(ratioWidth, ratioHeight, 0.0);
    [object3D.vectorArr addObject:pos4];
    
    memcpy(points, tpoints, 12*sizeof(float));
    
    float *texcoords = (float*)malloc(8*sizeof(float));
    if(stereo){
        if (isLeftRight) {
            if(isLeft){
                if(isflip){
                    float ttexcoords[8] ={0.0f, 1.0f, 0.5f, 1.0f, 0.0f, 0.0f, 0.5f, 0.0f};
                    memcpy(texcoords, ttexcoords, 8*sizeof(float));
                }else{
                    float ttexcoords[8] ={0.0f, 1.0f, 0.5f, 1.0f, 0.0f, 0.0f, 0.5f, 0.0f};
                    memcpy(texcoords, ttexcoords, 8*sizeof(float));
                }
            }else{
                if(isflip){
                    float ttexcoords[8] ={0.5f, 1.0f, 1.0f, 1.0f, 0.5f, 0.0f, 1.0f, 0.0f};
                    memcpy(texcoords, ttexcoords, 8*sizeof(float));
                }else{
                    float ttexcoords[8] ={0.5f, 1.0f, 1.0f, 1.0f, 0.5f, 0.0f, 1.0f, 0.0f};
                    memcpy(texcoords, ttexcoords, 8*sizeof(float));
                }
            }
        }
        
        if(isUpDown){
            if(isLeft){
                if(isflip){
                    float ttexcoords[8] ={0.0f, 0.5f, 1.0f, 0.5f, 0.0f, 1.0f, 1.0f, 1.0f};
                    memcpy(texcoords, ttexcoords, 8*sizeof(float));
                }else{
                    float ttexcoords[8] ={0.0f, 1.0f, 1.0f, 1.0f, 0.0f, 0.5f, 1.0f, 0.5f};
                    memcpy(texcoords, ttexcoords, 8*sizeof(float));
                }
            }else{
                if(isflip){
                    float ttexcoords[8] ={0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.5f, 1.0f, 0.5f};
                    memcpy(texcoords, ttexcoords, 8*sizeof(float));
                }else{
                    float ttexcoords[8] ={0.0f, 0.5f, 1.0f, 0.5f, 0.0f, 0.0f, 1.0f, 0.0f};
                    memcpy(texcoords, ttexcoords, 8*sizeof(float));
                }
            }
        }
    }else{
        if(isflip){
            float ttexcoords[8] ={0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f};
            memcpy(texcoords, ttexcoords, 8*sizeof(float));
        }else{
            float ttexcoords[8] ={0.0f, 1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f};
            memcpy(texcoords, ttexcoords, 8*sizeof(float));
        }
    }
    
    short* indices = (short*)malloc(6*sizeof(short));
    short tindices[6] = {2, 0, 1, 2, 1, 3};
    memcpy(indices, tindices, 6*sizeof(short));
    
    if(indices != NULL) [object3D setIndicesBuffer:indices size:6];
    if(texcoords != NULL) [object3D setTextureBuffer:texcoords size:8];
    if(points != NULL) [object3D setVertexBuffer:points size:12];
    [object3D setNumIndices:6];
    
    if(indices!=NULL)
    {
        free(indices);
        indices = NULL;
    }
    
    if(texcoords!=NULL){
        free(texcoords);
        texcoords = NULL;
    }
    
    if(points !=NULL){
        free(points);
        points = NULL;
    }
}

@end

