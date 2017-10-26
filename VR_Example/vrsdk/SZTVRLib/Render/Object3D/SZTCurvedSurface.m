//
//  SZTCurvedSurface.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/31.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTCurvedSurface.h"

@interface SZTCurvedSurface ()

@end

@implementation SZTCurvedSurface

- (void)setupVBO_Render:(size *)objSize isStereo:(BOOL)isStereo isLeft:(BOOL)isleft isFilp:(BOOL)isflip
{
    generateCurvedSurface(objSize, isStereo, isleft, isflip, self);
    
    [super setupVBO];
}

void generateCurvedSurface(size * objSize, bool stereo, bool isLeft, bool isflip, SZTObject3D* object3D)
{
    int count = 12;
    float *points = (float*) malloc(count * 3 *sizeof(float));
    
    float ratio = 50.0;
    float ratioWidth = objSize.width/(ratio*2.0);
    float ratioHeight = objSize.height/(ratio*2.0);

    float lenth = fabs(ratioWidth * 0.4);
    float theta = fabs(lenth * cos(65));
    float pi = fabs(lenth * sin(65));
    float theta1 = fabs(lenth * cos(82));
    float pi1 = fabs(lenth * sin(82));
    
    float tpoints[36] = {
        - ratioWidth,  - ratioHeight, 0.0,
        - ratioWidth + theta,  - ratioHeight, -pi,
        - ratioWidth + theta + theta1,  - ratioHeight, -(pi + pi1),
        - ratioWidth + theta + theta1 + lenth,  - ratioHeight, -(pi + pi1),
        - ratioWidth + theta + theta1 + lenth + theta1,  - ratioHeight, -pi,
        - ratioWidth + theta + theta1 + lenth + theta1 + theta,  - ratioHeight, 0.0,
        - ratioWidth, ratioHeight, 0.0,
        - ratioWidth + theta, ratioHeight, -pi,
        - ratioWidth + theta + theta1,  ratioHeight, -(pi + pi1),
        - ratioWidth + theta + theta1 + lenth,  ratioHeight, -(pi + pi1),
        - ratioWidth + theta + theta1 + lenth + theta1,  ratioHeight, -pi,
        - ratioWidth + theta + theta1 + lenth + theta1 + theta,  ratioHeight, 0.0,
    };

    memcpy(points, tpoints, count * 3 *sizeof(float));
    
    float *texcoords = (float*)malloc(count * 2 *sizeof(float));
    
    if(isflip){
        float ttexcoords[8] ={0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f};
        memcpy(texcoords, ttexcoords, 8*sizeof(float));
    }else{
        float ttexcoords[24] = {
            0.0f, 1.0f,
            0.2f, 1.0f,
            0.4f, 1.0f,
            0.6f, 1.0f,
            0.8f, 1.0f,
            1.0f, 1.0f,
            0.0f, 0.0f,
            0.2f, 0.0f,
            0.4f, 0.0f,
            0.6f, 0.0f,
            0.8f, 0.0f,
            1.0f, 0.0f,
        };
        memcpy(texcoords, ttexcoords, count * 2 * sizeof(float));
    }
    
    short* indices = (short*)malloc((count - 2) * 3 *sizeof(short));
    short tindices[30] = {
        6, 0, 1,
        6, 1, 7,
        7, 1, 2,
        7, 2, 8,
        8, 2, 3,
        8, 3, 9,
        9, 3, 4,
        9, 4, 10,
        10, 4, 5,
        10, 5, 11,
    };
    memcpy(indices, tindices, (count - 2) * 3 * sizeof(short));
    
    if(indices != NULL) [object3D setIndicesBuffer:indices size:(count - 2) * 3];
    if(texcoords != NULL) [object3D setTextureBuffer:texcoords size:count * 2];
    if(points != NULL) [object3D setVertexBuffer:points size:count * 3];
    [object3D setNumIndices:(count - 2) * 3];
    
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
