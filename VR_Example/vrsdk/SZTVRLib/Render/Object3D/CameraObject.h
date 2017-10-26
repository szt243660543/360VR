//
//  Vertex.h
//  simpleFBO
//
//  Created by SZTVR on 16/7/26.
//
//

#ifndef Vertex_h
#define Vertex_h

typedef struct {
    float Position[3];
    float TexCoord[2];
} Vertex;

// 左屏
Vertex gVertexDataLeftScreen[] =
{
    {{0.0f, 1.0f, 0.0f},{1.0f, 1.0f}},
    {{-1.0f, 1.0f, 0.0f},{0.0f, 1.0f}},
    {{0.0f, -1.0f, 0.0f},{1.0f, 0.0f}},
    {{-1.0f, -1.0f, 0.0f},{0.0f, 0.0f}}
};

// 右屏
Vertex gVertexDataRightScreen[] =
{
    {{1.0f, 1.0f, 0.0f},{1.0f, 1.0f}},
    {{0.0f, 1.0f, 0.0f},{0.0f, 1.0f}},
    {{1.0f, -1.0f, 0.0f},{1.0f, 0.0f}},
    {{0.0f, -1.0f, 0.0f},{0.0f, 0.0f}}
};

// 全屏幕
Vertex gVertexDataFullScreen[] =
{
    {{1.0f, 1.0f, 0.0f},{1.0f, 1.0f}},
    {{0.0f, 1.0f, 0.0f},{0.0f, 1.0f}},
    {{1.0f, -1.0f, 0.0f},{1.0f, 0.0f}},
    {{0.0f, -1.0f, 0.0f},{0.0f, 0.0f}}
};

GLubyte Indices[] = {
    0, 1, 2,
    2, 1, 3
};

#endif /* Vertex_h */
