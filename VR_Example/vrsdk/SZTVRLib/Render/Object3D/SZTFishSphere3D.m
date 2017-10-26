//
//  SZTFishSphere3D.m
//  SZTVR_SDK
//
//  Created by SZT on 16/10/24.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTFishSphere3D.h"

@interface SZTFishSphere3D()
@property (nonatomic , strong)FishSpec *fishSpec;
@end

@implementation SZTFishSphere3D

- (void)setupVBO_Render:(float)radians isLeft:(BOOL)isleft isFlip:(BOOL)isflip
{
    self.fishSpec = [[FishSpec alloc]init];
    [self.fishSpec build:isleft Resolution:_resolution];
    
    generateFishSphere(radians, 75, 150, isleft, isflip, self, _fishSpec);
    
    [super setupVBO];
}

- (void)doubleMapUV:(BOOL)isLeft PointCam:(double*)pointCam PointUV:(double *)pointUV
{
    [self worldPMapUV:pointUV PointCam:pointCam FishSpec:_fishSpec];
    pointUV[0] /= _fishSpec.height;
    pointUV[1] /= (_fishSpec.width * 2);
    
    if(isLeft){
        pointUV[0] = (pointUV[0]>1.0)?1.0:((pointUV[0]<0)?0:pointUV[0]);
        pointUV[1] = (pointUV[1]>0.5)?0.5f:((pointUV[1]<0)?0:pointUV[1]);
    }else{
        pointUV[1]+=0.5;
        pointUV[0] = (pointUV[0]>1.0)?1.0:((pointUV[0]<0)?0:pointUV[0]);
        pointUV[1] = (pointUV[1]>1.0)?1.0:((pointUV[1]<0.5)?0.5:pointUV[1]);
    }
}

- (void)worldPMapUV:(double*)pointUV PointCam:(double*)pointCam FishSpec:(FishSpec*)fishSpec
{
    NSArray *invpol = fishSpec.invpol;
    double xc = fishSpec.xc;
    double yc = fishSpec.yc;
    double c = fishSpec.c;
    double d = fishSpec.d;
    double e = fishSpec.e;
    
    double length = sqrt(pointCam[0]*pointCam[0] + pointCam[1]*pointCam[1]);
    double theta = atan(pointCam[2]/length);
    
    double t, t_i;
    double rho, x, y;
    double invlength;
    
    if(length != 0){
        invlength = 1/length;
        t = theta;
        
        rho = [invpol[0] doubleValue];
        t_i = 1;
        
        for (int i = 1; i < invpol.count; i++) {
            t_i*=t;
            rho += t_i*[invpol[i] doubleValue];
        }
        
        x = pointCam[0]*invlength*rho;
        y = pointCam[1]*invlength*rho;
        
        pointUV[1] = (x*c + y*d + xc);
        pointUV[0] = (x*e + y+ yc);
        
    }else{
        pointUV[1] = xc/2.0;
        pointUV[0] = yc;
    }
}

void generateFishSphere(float radius, int rings, int sectors, bool isLeft, bool isflip, SZTFishSphere3D *object3D, FishSpec* fishSpec)
{
    float factor1 = fishSpec.factor1;
    float factor2 = fishSpec.factor2;
    
    float PI = ES_PI;
    float R = 1.0f/(float)(rings - 1);
    float S = 1.0f/(float)(sectors - 1);
    short r, s;
    float x, y, z;
    
    
    double *pointUV = malloc(sizeof(double)*2);
    double *pointCam = malloc(sizeof(double)*3);
    
    int numPoints = rings * sectors * 3;
    int numTexcoords = rings * sectors * 2;
    
    float* points = malloc(sizeof(float)* numPoints);
    float* texcoords = malloc(sizeof(float) *  numTexcoords);
    
    int t = 0, v = 0;
    
    float theta = 0.0f;
    float phi = 0.0f;
    for(r = 0; r < rings; r++) {
        phi = (-PI/2 + PI * r * R) * factor1;
        for(s = 0; s < sectors; s++) {
            theta = (PI/2 - PI * s * S) * factor2;
            float nr = -cosf(phi);
            
            x = nr * sinf(theta);
            y = sinf(phi);
            z = nr * cosf(theta);
            
            pointCam[0] = -x * radius;
            pointCam[1] = -y * radius;
            pointCam[2] = z * radius;
            
            if(isLeft){
                [object3D doubleMapUV:true PointCam:pointCam PointUV:pointUV];
            }else{
                [object3D doubleMapUV:false PointCam:pointCam PointUV:pointUV];
            }
            
            if (isflip) {
                texcoords[t++] = pointUV[1];
                texcoords[t++] = 1.0 - pointUV[0];
            }else{
                texcoords[t++] = 1.0 - pointUV[1];
                texcoords[t++] = pointUV[0];
            }
            
            points[v++] = x * radius;
            points[v++] = y * radius;
            points[v++] = z * radius;
        }
    }
    
    free(pointUV);
    free(pointCam);
    
    int counter = 0;
    int numIndices = rings * sectors * 6;
    short* indices = malloc(sizeof(short) * numIndices);
    for(r = 0; r < rings - 1; r++){
        for(s = 0; s < sectors-1; s++) {
            indices[counter++] = (short) (r * sectors + s);         //(a)
            indices[counter++] = (short) ((r+1) * sectors + (s+1)); //(c)
            indices[counter++] = (short) ((r+1) * sectors + s);     //(b)
            
            indices[counter++] = (short) (r * sectors + s);         //(a)
            indices[counter++] = (short) (r * sectors + (s+1));     //(d)
            indices[counter++] = (short) ((r+1) * sectors + (s+1)); //(c)
        }
    }
    
    [object3D setIndicesBuffer:indices size:numIndices];
    [object3D setTextureBuffer:texcoords size:numTexcoords];
    [object3D setVertexBuffer:points size:numPoints];
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

- (void)dealloc
{
    self.fishSpec = nil;
}

@end
