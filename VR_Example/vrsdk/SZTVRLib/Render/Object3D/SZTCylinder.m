//
//  SZTCylinder.m
//  SZTVR_SDK
//
//  Created by szt on 2017/5/31.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SZTCylinder.h"
#define ES_PI  (3.14159265f)

inline static double changeCircleX(double x, double y, double wd, double hd, double r1, double r2){
    double r, theta, xS;
    r = y/hd*(r2-r1) + r1;
    theta = x/wd*2.0*ES_PI;
    xS = r*cosf(theta);
    return xS;
}

inline static double changeCircleY(double x, double y, double wd, double hd, double r1, double r2){
    double r, theta, yS;
    r = y/hd*(r2-r1)+r1;
    theta = x/wd*2*ES_PI;
    yS = r*sinf(theta);
    return yS;
}

@interface SZTCylinder()
{
    float mLength;
    float mRadius;
    int   mSegmentsW;
    int   mSegmentsH;
    float mFactorW;
    float mFactorH;
    BOOL mMirrorTextureCoords;
    
    double mVerticalIndices;
    double mHorizontalIndices;
    
    int   mWidth, mHeight;
    double mLati, mLongti;
    double mContentRation;
    double mR1, mR2, mHd, mWd;
}

@end

@implementation SZTCylinder

- (void)setupVBO_Render:(float)radians
{
    [self CustomCylinder:120.0 Radius:150.0 segmentsW:150.0 segmentsH:75 factorW:2.0 factorH:0.67];
    
    [self build:1440.0 height:1440.0 contentRatio:1.0];
    
    [super setupVBO];
}

- (void)CustomCylinder:(float)length Radius:(float)radius segmentsW:(int)segmentsW segmentsH:(int)segmentsH factorW:(float)factorW factorH:(float)factorH
{
    if(factorH <0) factorH = 0;
    if(factorH >2) factorH = 2;
    
    if(factorW < 0) factorW = 0;
    if(factorW > 2) factorW = 2;
    
    mLength = length;
    mRadius = radius;
    mSegmentsW = segmentsW;
    mSegmentsH = segmentsH;
    mFactorW = factorW;
    mFactorH = factorH;
}

- (void)build:(float)width height:(float)height contentRatio:(float)ratio
{
    mWidth = width;
    mHeight = height;
    mContentRation = ratio;
    
    [self initParams];
    
    [self initCylinder];
}

- (void)initParams
{
    double dstWidth = mHeight * ES_PI;
    double dstHeight = mHeight/2.0;
    //将采样
    mLati = dstWidth/mSegmentsW;
    mLongti= dstHeight/mSegmentsH;
    
    mR1 = 0;
    mR2 = dstHeight;
    mHd = mR2 -mR1;
    mWd = 2*ES_PI*mR2;
}

- (void)customTextureCoords:(double *)vertex uv:(double *)uv
{
    double xx = mHorizontalIndices*mLati;
    double yy = mVerticalIndices*mLongti;
    
    yy = 0.7*yy + 0.3*mSegmentsH*mLongti;
    
    uv[0] = changeCircleX(xx, yy, mWd, mHd, mR1, mR2);
    uv[1] = changeCircleY(xx, yy, mWd, mHd, mR1, mR2);
    
    [self applyAspectRatio:uv];
    
    uv[0] /= (mWidth/2.0);
    uv[1] /= (mHeight/2.0);
    
    uv[0] = (uv[0]*mContentRation + 1)*0.5;
    uv[1] = (uv[1]*mContentRation + 1)*0.5;
}

- (void)applyAspectRatio:(double *)uv
{
    uv[0] /= 1.0;
}

- (double)customVerticalArc:(double)indice
{
    mVerticalIndices = indice;
    return ES_PI/2.0 -  ((indice/mSegmentsH + 0.0)*ES_PI)*mFactorH;
}

- (double)customHorizontalArc:(double)indice
{
    mHorizontalIndices = indice;
    return (indice/mSegmentsW*ES_PI)*mFactorW;
}

- (void)initCylinder
{
    int offset = 0;
    
    int numVertices = (mSegmentsW  - offset + 1) * (mSegmentsH+ 1);
    int numIndices = 2 *(mSegmentsW - offset )* (mSegmentsH) *3;
    
    int numPoints = numVertices * 3;
    int numTexcoords = numVertices * 2;
    
    float* points = malloc ( sizeof(float) *  numPoints);
    float* texcoords = malloc ( sizeof(float) *  numTexcoords);
    short* indices = malloc ( sizeof(short) * numIndices);
    
    double phi = ES_PI/2.0;
    double theta = -ES_PI/2.0;
    
    double uv[2];
    double vertex[3];
    
    int    vStep = 0;
    int    tStep = 0;
    int    iStep = 0;
    
    for(int i = 0 ;  i<= mSegmentsH; i++){
        phi = [self customVerticalArc:i];
        
        float ringRadius = -mRadius * (float)cosf(phi);
        
        float y = mLength/2.0f - mLength*((float)i/(float)(mSegmentsH));
        
        for(int j = 0; j <= mSegmentsW - offset; j++){
            theta = [self customHorizontalArc:j + offset];
            
            float v1 = ringRadius*(float)sinf(theta); //X - axis;
            float v2 = mRadius*(float)sinf(phi); //Y-axis;
            float v3 = ringRadius*(float)cosf(theta); //Z -axis;
            
            vertex[0] = v1;
            vertex[1] = v2;
            vertex[2] = v3;
            
            //Cylinder
            float verAngle = 2.0f*(float)M_PI*(float)j/(mSegmentsW-offset);
            float x = mRadius*(float)cosf(verAngle);
            float z = mRadius*(float)sinf(verAngle);
            
            points[vStep++] = x;
            points[vStep++] = y;
            points[vStep++] = z;
            
            [self customTextureCoords:vertex uv:uv];
            
            //For stereo just this has been changed
            texcoords[tStep++] = (float) uv[0];
            texcoords[tStep++] = (float) uv[1];
        }
    }
    
    for (int i = 0; i < mSegmentsH; i++){
        for (int j = 0; j < mSegmentsW; j++) {
            //first triangle
            indices[iStep++] = (short) (i * (mSegmentsW + 1) + j); //upper point
            indices[iStep++] = (short) ((i + 1) * (mSegmentsW + 1) + j); // lower point
            indices[iStep++] = (short) (i * (mSegmentsW + 1) + j + 1); // upper-right point
            
            //second triangle
            indices[iStep++] = (short) ((i + 1) * (mSegmentsW + 1) + j);
            indices[iStep++] = (short) ((i + 1) * (mSegmentsW + 1) + j + 1); // lower-right point
            indices[iStep++] = (short) (i * (mSegmentsW + 1) + j + 1);
        }
    }
    
    [self setIndicesBuffer:indices size:numIndices];
    [self setTextureBuffer:texcoords size:numTexcoords];
    [self setVertexBuffer:points size:numPoints];
    [self setNumIndices:numIndices];
}

@end
