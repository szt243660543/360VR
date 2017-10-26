//
//  MD2Model.m
//  SZTVR_SDK
//
//  Created by szt on 2017/7/5.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "MD2Model.h"

@implementation MD2Model

- (instancetype)initWithFile:(NSString *)fileName
{
    self = [super init];
    
    if (self) {
        [self loadFile:fileName];
        [self allocateMemory];
        
        [self generateVertices];
    }
    
    return self;
}

- (void)loadFile:(NSString *)fileName
{
    FILE *f;
    f = fopen([fileName cStringUsingEncoding:NSASCIIStringEncoding], "r");
    fread(&_header, sizeof(md2_t), 1, f);
    
    triangles = (triangle_t *) malloc(sizeof(triangle_t)*_header.num_triangles);
    frames = (frame_t *) malloc(sizeof(frame_t)*_header.num_frames);
    skins = (skin_t *) malloc(sizeof(skin_t)*_header.num_skins);
    texture_coords = (texture_coord_t *) malloc(sizeof(texture_coord_t)*_header.num_texture_coords);
    
    fseek(f, _header.offset_triangles, SEEK_SET);
    fread(triangles, sizeof(triangle_t), _header.num_triangles, f);
    
    fseek(f, _header.offset_frames, SEEK_SET);
    
    for (int i = 0; i < _header.num_frames; i++) {
        frames[i].vertices = (vertex_t *) malloc(sizeof(vertex_t)*_header.num_vertices);
        fread(&frames[i].scale, sizeof(GLKVector3), 1, f);
        fread(&frames[i].translation, sizeof(GLKVector3), 1, f);
        fread(&frames[i].name, sizeof(char), 16, f);
        fread(frames[i].vertices, sizeof(vertex_t), _header.num_vertices, f);
    }
    
    fseek(f, _header.offset_skins, SEEK_SET);
    fread(skins, sizeof(skin_t), _header.num_skins, f);
    
    fseek(f, _header.offset_texture_coords, SEEK_SET);
    fread(texture_coords, sizeof(texture_coord_t), _header.num_texture_coords, f);
    
    fclose(f);
}

- (void)allocateMemory
{
    _calculatedFrameVertices = malloc(sizeof(GLKVector3) * _header.num_triangles * 3);
    _calculatedTextureCoords = malloc(sizeof(GLKVector2) * _header.num_triangles * 3);
    baseVertices = malloc(sizeof(GLKVector3) * _header.num_frames * _header.num_vertices);
}

- (void)generateVertices
{
    for (int i = 0 ; i < _header.num_frames; i++) {
        GLKVector3 scale = frames[i].scale;
        GLKVector3 translation = frames[i].translation;
        for (int j = 0; j < _header.num_vertices; j++) {
            baseVertices[i*_header.num_vertices + j] = GLKVector3Make(frames[i].vertices[j].v[0] * scale.v[0] + translation.v[0],
                                                                     frames[i].vertices[j].v[1] * scale.v[1] + translation.v[1],
                                                                     frames[i].vertices[j].v[2] * scale.v[2] + translation.v[2]);
        }
    }
}

- (void)calculateFrameVerticesForFrame:(int)frameNum
{
    int offset = frameNum * _header.num_vertices;
    for (int i = 0; i < _header.num_triangles; i++) {
        triangle_t tTri = triangles[i];
        _calculatedFrameVertices[i*3]   = baseVertices[offset + tTri.vertex[0]];
        _calculatedFrameVertices[i*3+1] = baseVertices[offset + tTri.vertex[1]];
        _calculatedFrameVertices[i*3+2] = baseVertices[offset + tTri.vertex[2]];
        
        _calculatedTextureCoords[i*3]   = GLKVector2Make(texture_coords[triangles[i].st[0]].s / (float)_header.skinwidth,
                                                        texture_coords[triangles[i].st[0]].t / (float)_header.skinheight);
        _calculatedTextureCoords[i*3+1] = GLKVector2Make(texture_coords[triangles[i].st[1]].s / (float)_header.skinwidth,
                                                        texture_coords[triangles[i].st[1]].t / (float)_header.skinheight);
        _calculatedTextureCoords[i*3+2] = GLKVector2Make(texture_coords[triangles[i].st[2]].s / (float)_header.skinwidth,
                                                        texture_coords[triangles[i].st[2]].t / (float)_header.skinheight);
    }
}

- (void)animateFrameVerticesForFrame:(int)frameNum withInterpolation:(float)interp
{
    int offsetCurr = frameNum * _header.num_vertices;
    int offsetNext = (frameNum + 1) * _header.num_vertices;
    for (int i = 0; i < _header.num_triangles; i++) {
        triangle_t tTri = triangles[i];
        
        GLKVector3 vCurr[3], vNext[3];
        vCurr[0] = baseVertices[offsetCurr + tTri.vertex[0]];
        vCurr[1] = baseVertices[offsetCurr + tTri.vertex[1]];
        vCurr[2] = baseVertices[offsetCurr + tTri.vertex[2]];
        
        vNext[0] = baseVertices[offsetNext + tTri.vertex[0]];
        vNext[1] = baseVertices[offsetNext + tTri.vertex[1]];
        vNext[2] = baseVertices[offsetNext + tTri.vertex[2]];
        
        _calculatedFrameVertices[i*3]   = [self interpolateVertex:vCurr[0] with:vNext[0] atInterpolation:interp];
        _calculatedFrameVertices[i*3+1] = [self interpolateVertex:vCurr[1] with:vNext[1] atInterpolation:interp];
        _calculatedFrameVertices[i*3+2] = [self interpolateVertex:vCurr[2] with:vNext[2] atInterpolation:interp];
    }
}

- (GLKVector3)interpolateVertex:(GLKVector3)vCurr with:(GLKVector3)vNext atInterpolation:(float)interp
{
    GLKVector3 v;
    
    v.v[0] = vCurr.v[0] + interp * (vNext.v[0] - vCurr.v[0]);
    v.v[1] = vCurr.v[1] + interp * (vNext.v[1] - vCurr.v[1]);
    v.v[2] = vCurr.v[2] + interp * (vNext.v[2] - vCurr.v[2]);
    
    return v;
}

- (void)dealloc
{
    for (int i = 0; i < _header.num_frames; i++) {
        free(frames[i].vertices);
    }
    
    free(frames);
    free(triangles);
    free(baseVertices);
    free(_calculatedFrameVertices);
    free(_calculatedTextureCoords);
}

@end
