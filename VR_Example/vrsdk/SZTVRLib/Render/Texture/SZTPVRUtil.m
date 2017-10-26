//
//  SZTPVRUtil.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTPVRUtil.h"
#import <UIKit/UIKit.h>

#pragma mark PVRTC Support
#define PVR_TEXTURE_FLAG_TYPE_MASK	0xff

static char gPVRTexIdentifier[4] = "PVR!";

enum
{
	kPVRTextureFlagTypePVRTC_2 = 24,
	kPVRTextureFlagTypePVRTC_4
};

typedef struct _PVRTexHeader
{
    uint32_t headerLength;
    uint32_t height;
    uint32_t width;
    uint32_t numMipmaps;
    uint32_t flags;
    uint32_t dataLength;
    uint32_t bpp;
    uint32_t bitmaskRed;
    uint32_t bitmaskGreen;
    uint32_t bitmaskBlue;
    uint32_t bitmaskAlpha;
    uint32_t pvrTag;
    uint32_t numSurfs;
} PVRTexHeader;

static GLuint SZTGLLoadTextureImpl_PVR(NSString *imagePath)
{
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    if (!data) {
        return GL_INVALID_VALUE;
    }
    
    NSMutableArray *dataParts = [[NSMutableArray alloc] initWithCapacity:10];
    
    PVRTexHeader *header = (PVRTexHeader *)[data bytes];
	uint32_t pvrTag = CFSwapInt32LittleToHost(header->pvrTag);
    
    if (gPVRTexIdentifier[0] != ((pvrTag >>  0) & 0xff) ||
		gPVRTexIdentifier[1] != ((pvrTag >>  8) & 0xff) ||
		gPVRTexIdentifier[2] != ((pvrTag >> 16) & 0xff) ||
		gPVRTexIdentifier[3] != ((pvrTag >> 24) & 0xff))
	{
        NSLog(@"PVR Tag Error");
		return GL_INVALID_VALUE;
	}
    
    uint32_t flags = CFSwapInt32LittleToHost(header->flags);
	uint32_t formatFlags = flags & PVR_TEXTURE_FLAG_TYPE_MASK;
    
	if (formatFlags != kPVRTextureFlagTypePVRTC_4 && formatFlags != kPVRTextureFlagTypePVRTC_2) {
        NSLog(@"PVR Texture Format Flag Error");
        return GL_INVALID_VALUE;
    }
    
    GLenum internalFormat = (formatFlags == kPVRTextureFlagTypePVRTC_4)? GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG: GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG;
    
    uint32_t width = CFSwapInt32LittleToHost(header->width);
    uint32_t height = CFSwapInt32LittleToHost(header->height);
    
    uint32_t the_width = width;
    uint32_t the_height = height;
    
//    BOOL hasAlpha = (CFSwapInt32LittleToHost(header->bitmaskAlpha)? YES: NO);
    
    uint32_t dataLength = CFSwapInt32LittleToHost(header->dataLength);
    uint8_t *bytes = ((uint8_t *)[data bytes]) + sizeof(PVRTexHeader);
    uint32_t dataOffset = 0;
    
    uint32_t bpp = (formatFlags == kPVRTextureFlagTypePVRTC_4)? 4: 2;
    uint32_t blockSize = (formatFlags == kPVRTextureFlagTypePVRTC_4)? 4*4: 8*4;
    
    while (dataOffset < dataLength) {
        uint32_t widthBlocks = width / ((formatFlags == kPVRTextureFlagTypePVRTC_4)? 4: 8);
        uint32_t heightBlocks = height / 4;
        
        // Clamp to minimum number of blocks
        if (widthBlocks < 2) {
            widthBlocks = 2;
        }
        if (heightBlocks < 2) {
            heightBlocks = 2;
        }
        
        uint32_t dataSize = widthBlocks * heightBlocks * ((blockSize  * bpp) / 8);
        
        [dataParts addObject:[NSData dataWithBytes:bytes+dataOffset length:dataSize]];
        
        dataOffset += dataSize;
        
        width = MAX(width >> 1, 1);
        height = MAX(height >> 1, 1);
    }
    
    GLuint textureID;
    {
        int width = the_width;
        int height = the_height;
        
        if ([dataParts count] > 0) {
            glEnable(GL_TEXTURE_2D);
            glGenTextures(1, &textureID);
            glBindTexture(GL_TEXTURE_2D, textureID);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            
            GLenum err = GL_NO_ERROR;
            
            for (int i = 0; i < [dataParts count]; i++) {
                NSData *data = [dataParts objectAtIndex:i];
                glCompressedTexImage2D(GL_TEXTURE_2D, i, internalFormat, width, height, 0, (GLsizei)[data length], [data bytes]);
                
                err = glGetError();
                if (err != GL_NO_ERROR) {
                    NSLog(@"PVR Decompress Error!!");
                    break;
                }
                
                width = MAX(width >> 1, 1);
                height = MAX(height >> 1, 1);
            }
        }
    }
    
    return textureID;
}

#pragma mark Texture Loading Interface
@implementation SZTPVRUtil

+ (GLuint)SZGLLoadTexture:(NSString*)imagePath
{
    return SZTGLLoadTextureImpl_PVR(imagePath);
}

@end

