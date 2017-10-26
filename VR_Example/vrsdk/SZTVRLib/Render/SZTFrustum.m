//
//  SZTFrustum.m
//  SZTVR_SDK
//
//  Created by szt on 16/11/20.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTFrustum.h"
#import "MathC.h"

@implementation SZTFrustum

- (void)calculateFrustumPlanes:(GLKMatrix4)mvMatrix
{
    float t;
    //
    // Extract the frustum's right clipping plane and normalize it.
    //
    g_frustumPlanes[0][0] = mvMatrix.m03 - mvMatrix.m00;
    g_frustumPlanes[0][1] = mvMatrix.m13 - mvMatrix.m10;
    g_frustumPlanes[0][2] = mvMatrix.m23 - mvMatrix.m20;
    g_frustumPlanes[0][3] = mvMatrix.m33 - mvMatrix.m30;
    
    t = (float) sqrt( g_frustumPlanes[0][0] * g_frustumPlanes[0][0] +
                     g_frustumPlanes[0][1] * g_frustumPlanes[0][1] +
                     g_frustumPlanes[0][2] * g_frustumPlanes[0][2]);
    
    g_frustumPlanes[0][0] /= t;
    g_frustumPlanes[0][1] /= t;
    g_frustumPlanes[0][2] /= t;
    g_frustumPlanes[0][3] /= t;
    
    //
    // Extract the frustum's left clipping plane and normalize it.
    //
    g_frustumPlanes[1][0] = mvMatrix.m03 + mvMatrix.m00;
    g_frustumPlanes[1][1] = mvMatrix.m13 + mvMatrix.m10;
    g_frustumPlanes[1][2] = mvMatrix.m23 + mvMatrix.m20;
    g_frustumPlanes[1][3] = mvMatrix.m33 + mvMatrix.m30;
    
    t = (float) sqrt( g_frustumPlanes[1][0] * g_frustumPlanes[1][0] +
                     g_frustumPlanes[1][1] * g_frustumPlanes[1][1] +
                     g_frustumPlanes[1][2] * g_frustumPlanes[1][2] );
    
    g_frustumPlanes[1][0] /= t;
    g_frustumPlanes[1][1] /= t;
    g_frustumPlanes[1][2] /= t;
    g_frustumPlanes[1][3] /= t;
    

    //
    // Extract the frustum's bottom clipping plane and normalize it.
    //
    g_frustumPlanes[2][0] = mvMatrix.m03 + mvMatrix.m01;
    g_frustumPlanes[2][1] = mvMatrix.m13 + mvMatrix.m11;
    g_frustumPlanes[2][2] = mvMatrix.m23 + mvMatrix.m21;
    g_frustumPlanes[2][3] = mvMatrix.m33 + mvMatrix.m31;
    
    t = (float) sqrt( g_frustumPlanes[2][0] * g_frustumPlanes[2][0] +
                     g_frustumPlanes[2][1] * g_frustumPlanes[2][1] +
                     g_frustumPlanes[2][2] * g_frustumPlanes[2][2] );
    
    g_frustumPlanes[2][0] /= t;
    g_frustumPlanes[2][1] /= t;
    g_frustumPlanes[2][2] /= t;
    g_frustumPlanes[2][3] /= t;
    
    //
    // Extract the frustum's top clipping plane and normalize it.
    //
    g_frustumPlanes[3][0] = mvMatrix.m03 - mvMatrix.m01;
    g_frustumPlanes[3][1] = mvMatrix.m13 - mvMatrix.m11;
    g_frustumPlanes[3][2] = mvMatrix.m23 - mvMatrix.m21;
    g_frustumPlanes[3][3] = mvMatrix.m33 - mvMatrix.m31;
    
    t = (float) sqrt( g_frustumPlanes[3][0] * g_frustumPlanes[3][0] +
                     g_frustumPlanes[3][1] * g_frustumPlanes[3][1] +
                     g_frustumPlanes[3][2] * g_frustumPlanes[3][2] );
    
    g_frustumPlanes[3][0] /= t;
    g_frustumPlanes[3][1] /= t;
    g_frustumPlanes[3][2] /= t;
    g_frustumPlanes[3][3] /= t;
    
    //
    // Extract the frustum's far clipping plane and normalize it.
    //
    g_frustumPlanes[4][0] = mvMatrix.m03 - mvMatrix.m02;
    g_frustumPlanes[4][1] = mvMatrix.m13 - mvMatrix.m12;
    g_frustumPlanes[4][2] = mvMatrix.m23 - mvMatrix.m22;
    g_frustumPlanes[4][3] = mvMatrix.m33 - mvMatrix.m32;
    
    t = (float) sqrt( g_frustumPlanes[4][0] * g_frustumPlanes[4][0] +
                     g_frustumPlanes[4][1] * g_frustumPlanes[4][1] +
                     g_frustumPlanes[4][2] * g_frustumPlanes[4][2] );
    
    g_frustumPlanes[4][0] /= t;
    g_frustumPlanes[4][1] /= t;
    g_frustumPlanes[4][2] /= t;
    g_frustumPlanes[4][3] /= t;
    
    //
    // Extract the frustum's near clipping plane and normalize it.
    //
    g_frustumPlanes[5][0] = mvMatrix.m03 + mvMatrix.m02;
    g_frustumPlanes[5][1] = mvMatrix.m13 + mvMatrix.m12;
    g_frustumPlanes[5][2] = mvMatrix.m23 + mvMatrix.m22;
    g_frustumPlanes[5][3] = mvMatrix.m33 = mvMatrix.m32;
    
    t = (float) sqrt( g_frustumPlanes[5][0] * g_frustumPlanes[5][0] +
                     g_frustumPlanes[5][1] * g_frustumPlanes[5][1] +
                     g_frustumPlanes[5][2] * g_frustumPlanes[5][2] );
    
    g_frustumPlanes[5][0] /= t;
    g_frustumPlanes[5][1] /= t;
    g_frustumPlanes[5][2] /= t;
    g_frustumPlanes[5][3] /= t;
}

- (BOOL)isPointInFrustum:(float)x Y:(float)y Z:(float)z
{
    for( int i = 0; i < 6; ++i )
    {
        if(g_frustumPlanes[i][0] * x + g_frustumPlanes[i][1] * y + g_frustumPlanes[i][2] * z + g_frustumPlanes[i][3] <= 0){
            return false;
        }
    }
    
    return true;
}

- (BOOL)isPointsInFrustum:(NSArray *)points
{
    for (point *pos in points) {
        if ([self isPointInFrustum:pos.vertexPoint.x Y:pos.vertexPoint.y Z:pos.vertexPoint.z]) {
            return true;
        }
    }
    
    return false;
}

/**
- (void)calculateFrustumPlanes:(GLKMatrix4)mvMatrix
{
    float p[16];   // projection matrix
    float mv[16];  // model-view matrix
    float mvp[16]; // model-view-projection matrix
    
    float t;
    
    GLKMatrix4 tempP = [SZTDirector sharedSZTDirector].mProjectionMatrix;
    p[0] = tempP.m00;
    p[1] = tempP.m01;
    p[2] = tempP.m02;
    p[3] = tempP.m03;
    
    p[4] = tempP.m10;
    p[5] = tempP.m11;
    p[6] = tempP.m12;
    p[7] = tempP.m13;
    
    p[8] = tempP.m20;
    p[9] = tempP.m21;
    p[10] = tempP.m22;
    p[11] = tempP.m23;
    
    p[12] = tempP.m30;
    p[13] = tempP.m31;
    p[14] = tempP.m32;
    p[15] = tempP.m33;
    
    
    GLKMatrix4 tempMV = mvMatrix;
    mv[0] = tempMV.m00;
    mv[1] = tempMV.m01;
    mv[2] = tempMV.m02;
    mv[3] = tempMV.m03;
    
    mv[4] = tempMV.m10;
    mv[5] = tempMV.m11;
    mv[6] = tempMV.m12;
    mv[7] = tempMV.m13;
    
    mv[8] = tempMV.m20;
    mv[9] = tempMV.m21;
    mv[10] = tempMV.m22;
    mv[11] = tempMV.m23;
    
    mv[12] = tempMV.m30;
    mv[13] = tempMV.m31;
    mv[14] = tempMV.m32;
    mv[15] = tempMV.m33;
    
    //
    // Concatenate the projection matrix and the model-view matrix to produce
    // a combined model-view-projection matrix.
    //
    mvp[ 0] = mv[ 0] * p[ 0] + mv[ 1] * p[ 4] + mv[ 2] * p[ 8] + mv[ 3] * p[12];
    mvp[ 1] = mv[ 0] * p[ 1] + mv[ 1] * p[ 5] + mv[ 2] * p[ 9] + mv[ 3] * p[13];
    mvp[ 2] = mv[ 0] * p[ 2] + mv[ 1] * p[ 6] + mv[ 2] * p[10] + mv[ 3] * p[14];
    mvp[ 3] = mv[ 0] * p[ 3] + mv[ 1] * p[ 7] + mv[ 2] * p[11] + mv[ 3] * p[15];
    
    mvp[ 4] = mv[ 4] * p[ 0] + mv[ 5] * p[ 4] + mv[ 6] * p[ 8] + mv[ 7] * p[12];
    mvp[ 5] = mv[ 4] * p[ 1] + mv[ 5] * p[ 5] + mv[ 6] * p[ 9] + mv[ 7] * p[13];
    mvp[ 6] = mv[ 4] * p[ 2] + mv[ 5] * p[ 6] + mv[ 6] * p[10] + mv[ 7] * p[14];
    mvp[ 7] = mv[ 4] * p[ 3] + mv[ 5] * p[ 7] + mv[ 6] * p[11] + mv[ 7] * p[15];
    
    mvp[ 8] = mv[ 8] * p[ 0] + mv[ 9] * p[ 4] + mv[10] * p[ 8] + mv[11] * p[12];
    mvp[ 9] = mv[ 8] * p[ 1] + mv[ 9] * p[ 5] + mv[10] * p[ 9] + mv[11] * p[13];
    mvp[10] = mv[ 8] * p[ 2] + mv[ 9] * p[ 6] + mv[10] * p[10] + mv[11] * p[14];
    mvp[11] = mv[ 8] * p[ 3] + mv[ 9] * p[ 7] + mv[10] * p[11] + mv[11] * p[15];
    
    mvp[12] = mv[12] * p[ 0] + mv[13] * p[ 4] + mv[14] * p[ 8] + mv[15] * p[12];
    mvp[13] = mv[12] * p[ 1] + mv[13] * p[ 5] + mv[14] * p[ 9] + mv[15] * p[13];
    mvp[14] = mv[12] * p[ 2] + mv[13] * p[ 6] + mv[14] * p[10] + mv[15] * p[14];
    mvp[15] = mv[12] * p[ 3] + mv[13] * p[ 7] + mv[14] * p[11] + mv[15] * p[15];
    
    //
    // Extract the frustum's right clipping plane and normalize it.
    //
    g_frustumPlanes[0][0] = mvp[ 3] - mvp[ 0];
    g_frustumPlanes[0][1] = mvp[ 7] - mvp[ 4];
    g_frustumPlanes[0][2] = mvp[11] - mvp[ 8];
    g_frustumPlanes[0][3] = mvp[15] - mvp[12];
    
    t = (float) sqrt( g_frustumPlanes[0][0] * g_frustumPlanes[0][0] +
                     g_frustumPlanes[0][1] * g_frustumPlanes[0][1] +
                     g_frustumPlanes[0][2] * g_frustumPlanes[0][2]);
    
    g_frustumPlanes[0][0] /= t;
    g_frustumPlanes[0][1] /= t;
    g_frustumPlanes[0][2] /= t;
    g_frustumPlanes[0][3] /= t;
    
    //
    // Extract the frustum's left clipping plane and normalize it.
    //
    g_frustumPlanes[1][0] = mvp[ 3] + mvp[ 0];
    g_frustumPlanes[1][1] = mvp[ 7] + mvp[ 4];
    g_frustumPlanes[1][2] = mvp[11] + mvp[ 8];
    g_frustumPlanes[1][3] = mvp[15] + mvp[12];
    
    
    t = (float) sqrt( g_frustumPlanes[1][0] * g_frustumPlanes[1][0] +
                     g_frustumPlanes[1][1] * g_frustumPlanes[1][1] +
                     g_frustumPlanes[1][2] * g_frustumPlanes[1][2] );
    
    g_frustumPlanes[1][0] /= t;
    g_frustumPlanes[1][1] /= t;
    g_frustumPlanes[1][2] /= t;
    g_frustumPlanes[1][3] /= t;
    
    
    //
    // Extract the frustum's bottom clipping plane and normalize it.
    //
    g_frustumPlanes[2][0] = mvp[ 3] + mvp[ 1];
    g_frustumPlanes[2][1] = mvp[ 7] + mvp[ 5];
    g_frustumPlanes[2][2] = mvp[11] + mvp[ 9];
    g_frustumPlanes[2][3] = mvp[15] + mvp[13];
    
    t = (float) sqrt( g_frustumPlanes[2][0] * g_frustumPlanes[2][0] +
                     g_frustumPlanes[2][1] * g_frustumPlanes[2][1] +
                     g_frustumPlanes[2][2] * g_frustumPlanes[2][2] );
    
    g_frustumPlanes[2][0] /= t;
    g_frustumPlanes[2][1] /= t;
    g_frustumPlanes[2][2] /= t;
    g_frustumPlanes[2][3] /= t;
    
    //
    // Extract the frustum's top clipping plane and normalize it.
    //
    g_frustumPlanes[3][0] = mvp[ 3] - mvp[ 1];
    g_frustumPlanes[3][1] = mvp[ 7] - mvp[ 5];
    g_frustumPlanes[3][2] = mvp[11] - mvp[ 9];
    g_frustumPlanes[3][3] = mvp[15] - mvp[13];
    
    t = (float) sqrt( g_frustumPlanes[3][0] * g_frustumPlanes[3][0] +
                     g_frustumPlanes[3][1] * g_frustumPlanes[3][1] +
                     g_frustumPlanes[3][2] * g_frustumPlanes[3][2] );
    
    g_frustumPlanes[3][0] /= t;
    g_frustumPlanes[3][1] /= t;
    g_frustumPlanes[3][2] /= t;
    g_frustumPlanes[3][3] /= t;
    
    //
    // Extract the frustum's far clipping plane and normalize it.
    //
    g_frustumPlanes[4][0] = mvp[ 3] - mvp[ 2];
    g_frustumPlanes[4][1] = mvp[ 7] - mvp[ 6];
    g_frustumPlanes[4][2] = mvp[11] - mvp[10];
    g_frustumPlanes[4][3] = mvp[15] - mvp[14];
    
    t = (float) sqrt( g_frustumPlanes[4][0] * g_frustumPlanes[4][0] +
                     g_frustumPlanes[4][1] * g_frustumPlanes[4][1] +
                     g_frustumPlanes[4][2] * g_frustumPlanes[4][2] );
    
    g_frustumPlanes[4][0] /= t;
    g_frustumPlanes[4][1] /= t;
    g_frustumPlanes[4][2] /= t;
    g_frustumPlanes[4][3] /= t;
    
    //
    // Extract the frustum's near clipping plane and normalize it.
    //
    g_frustumPlanes[5][0] = mvp[ 3] + mvp[ 2];
    g_frustumPlanes[5][1] = mvp[ 7] + mvp[ 6];
    g_frustumPlanes[5][2] = mvp[11] + mvp[10];
    g_frustumPlanes[5][3] = mvp[15] + mvp[14];
    
    t = (float) sqrt( g_frustumPlanes[5][0] * g_frustumPlanes[5][0] +
                     g_frustumPlanes[5][1] * g_frustumPlanes[5][1] +
                     g_frustumPlanes[5][2] * g_frustumPlanes[5][2] );
    
    g_frustumPlanes[5][0] /= t;
    g_frustumPlanes[5][1] /= t;
    g_frustumPlanes[5][2] /= t;
    g_frustumPlanes[5][3] /= t;
}*/

@end
