//
//  MD2Helper.h
//  SZTVR_SDK
//
//  Created by szt on 2017/7/5.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Q2MD2Modeler_MD2Helper_h
#define Q2MD2Modeler_MD2Helper_h

#import <GLKit/GLKit.h>

typedef struct
{
    unsigned char       manufacturer;
    unsigned char       version;
    unsigned char       encoding;
    unsigned char       bitsperpixel;
    short               window[4];
    short               dpi[2];
    unsigned char       colormap[48];
    unsigned char       reserved;
    unsigned char       nplanes;
    short               bytesperline;
    short               paletteinfo;
    short               screensize[2];
    unsigned char       filler[54];
} pcx_header_t;

typedef struct
{
    int     ident;              // magic number. must be equal to "IDP2"
    int     version;            // md2 version. must be equal to 8
    
    int     skinwidth;          // width of the texture
    int     skinheight;         // height of the texture
    int     framesize;          // size of one frame in bytes
    
    int     num_skins;          // number of textures
    int     num_vertices;            // number of vertices
    int     num_texture_coords;             // number of texture coordinates
    int     num_triangles;           // number of triangles
    int     num_gl_commands;         // number of opengl commands
    int     num_frames;         // total number of frames
    
    int     offset_skins;          // offset to skin names (64 bytes each)
    int     offset_texture_coords;             // offset to s-t texture coordinates
    int     offset_triangles;           // offset to triangles
    int     offset_frames;         // offset to frame data
    int     offset_gl_commands;         // offset to opengl commands
    int     offset_end;            // offset to end of file
    
} md2_t;

typedef struct
{
    char name[64];
} skin_t;

typedef struct
{
    unsigned char   v[3];            // compressed vertex (x, y, z) coordinates
    unsigned char   normal_index;    // index to a normal vector for the lighting
} vertex_t;

typedef struct
{
    short s;
    short t;
} texture_coord_t;

typedef struct
{
    GLKVector3  scale;
    GLKVector3  translation;
    char        name[16];
    vertex_t    *vertices;
} frame_t;

typedef struct
{
    unsigned short vertex[3];
    unsigned short st[3];
} triangle_t;

#endif
