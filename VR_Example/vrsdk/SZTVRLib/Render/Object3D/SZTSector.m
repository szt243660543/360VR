//
//  SZTSector.m
//  SZTVR_SDK
//
//  Created by szt on 2017/6/1.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTSector.h"

#define AngleToRadian(angle) (M_PI/180.0f)*angle

@interface SZTSector ()

@end

@implementation SZTSector

- (void)setupVBO_Render:(size *)objSize isStereo:(BOOL)isStereo isLeft:(BOOL)isleft isFilp:(BOOL)isflip
{
    generateSector(objSize, isStereo, isleft, isflip, self);
    
    [super setupVBO];
}

void generateSector(size * objSize, bool stereo, bool isLeft, bool isflip, SZTObject3D* object3D)
{
    float currentAdius = 100;   // 半径
    float angle = 180;          // 圆心角
    int lon_count = 20;         // 纵向分割成多少面，越大越平滑
    if (isflip) {
        lon_count = 4;
    }
    int lat_count = 2;          // 横向
    float l = angle * ES_PI * currentAdius/180;
    float height = l * objSize.height/objSize.width;
    
    int numPoints = lon_count * lat_count * 3;
    int numTexcoords = lon_count * lat_count * 2;
    int numIndices = (lon_count - 1) * lat_count * 3;
    
    float* points = malloc ( sizeof(float) * numPoints);
    float* texcoords = malloc ( sizeof(float) * numTexcoords);
    short* indices = malloc ( sizeof(short) * numIndices);
    
    int v = 0, t = 0, counter = 0;
    
    for (int i = 0; i < lat_count; i++) {
        for (int j = 0; j < lon_count ; j++) {
            float each_angle = angle/ lon_count;
            float radian = AngleToRadian(each_angle * j);
            
            float x = sinf(radian)*currentAdius;
            float y = i == 1? -height/2.0:height/2.0;
            float z = -cosf(radian)*currentAdius;
            
            points[v++] = x;
            points[v++] = y;
            points[v++] = z;
            
            texcoords[t++] = 1.0/(lon_count-1)*j;
            if (isflip) {
                texcoords[t++] = i == 1? 0.0:1.0;
            }else{
                texcoords[t++] = i == 1? 1.0:0.0;
            }
        }
    }
    
    float c_index = lon_count - 1;
    for(int j= 0; j<c_index; j++)
    {
        //first triangle
        indices[counter++] = (short) j; //upper point
        indices[counter++] = (short) (j+1+c_index); // lower point
        indices[counter++] = (short) (j+1); // upper-right point
            
        //second triangle
        indices[counter++] = (short) (j+1);
        indices[counter++] = (short) (j+1+c_index); // lower-right point
        indices[counter++] = (short) (j+1+c_index+1);
    }
    
    [object3D setIndicesBuffer:indices size:numIndices];
    [object3D setTextureBuffer:texcoords size:numTexcoords];
    [object3D setVertexBuffer:points size:numPoints];
    [object3D setNumIndices:numIndices];
    
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
