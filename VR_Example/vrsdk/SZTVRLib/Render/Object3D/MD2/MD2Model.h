//
//  MD2Model.h
//  SZTVR_SDK
//
//  Created by szt on 2017/7/5.
//  Copyright © 2017年 szt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MD2Helper.h"

@interface MD2Model : NSObject
{
    frame_t*            frames;
    triangle_t*         triangles;
    skin_t*             skins;
    texture_coord_t*    texture_coords;
    GLKVector3*         baseVertices;
}

@property (readonly, assign) md2_t              header;
@property (readonly, assign) GLKVector3*        calculatedFrameVertices;
@property (readonly, assign) GLKVector2*        calculatedTextureCoords;

- (instancetype)initWithFile:(NSString*) fileName;
- (void)loadFile:(NSString*) fileName;
- (void)allocateMemory;
- (void)generateVertices;
- (void)calculateFrameVerticesForFrame:(int)frameNum;
- (void)animateFrameVerticesForFrame:(int)frameNum withInterpolation:(float) interp;
- (GLKVector3)interpolateVertex:(GLKVector3) vCurr with:(GLKVector3) vNext atInterpolation:(float) interp;

@end
