 //
//  SZTVideoTexture.m
//  SZTVR_SDK
//
//  Created by SZT on 16/10/24.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTVideoTexture.h"
#import "SZTVideoData.h"
#import <OpenGLES/ES2/glext.h>
#import <CoreVideo/CVOpenGLESTextureCache.h>
#import "ImageTool.h"
#import "FileTool.h"

typedef void(^screenDoneBlock)(NSString *);

@interface SZTVideoTexture()
{
    BOOL _isScreenShot;
    int _index;
    int _tag;
    NSString *_pngPath;
    
    screenDoneBlock screenDone;
    CVOpenGLESTextureCacheRef ref;
}

@property (nonatomic, strong) SZTVideoData *mDataAdatper;

@end

@implementation SZTVideoTexture

#pragma mark - AVPlayer
- (SZTTexture *)createWithAVPlayerItem:(AVPlayerItem *)playeritem
{
    _isScreenShot = false;
    _index = 0;
    _tag = 0;
    
    self.mDataAdatper = [[SZTVideoData alloc] initWithPlayerItem:playeritem];
    
    return self;
}

#if USE_IJK_PLAYER
- (SZTTexture *)createWithIJKPlayer:(id<IJKMediaPlayback>)player
{
    _isScreenShot = false;
    _index = 0;
    _tag = 0;
    
    self.mDataAdatper = [[SZTVideoData alloc] initWithIJKPlayer:player];
    
    return self;
}
#endif

- (CVOpenGLESTextureCacheRef)textureCache:(EAGLContext*)context{
    if (ref == NULL){
        CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, (__bridge CVEAGLContext _Nonnull)((__bridge void *)context), NULL, &ref);
        if (err) NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreate");
    }
    return ref;
}

- (CVPixelBufferRef)updateVideoTexture:(EAGLContext *)context
{
    CVPixelBufferRef pixelBuffer;
    
    // ijk
    if (self.mDataAdatper.isijkPlayer) {
        pixelBuffer = [self renderIJKPlayerTexture:context];
    }else{
        pixelBuffer = [self renderNormalVideoTexture:context];
    }
    
    return pixelBuffer;
}

- (CVPixelBufferRef)renderIJKPlayerTexture:(EAGLContext *)context
{
    CVPixelBufferRef pixelBuffer = [self.mDataAdatper copyPixelBuffer];
    
    if (pixelBuffer == NULL) return nil;
    
    [self.mDataAdatper lockPixelBuffer];
    self.textureID = [self renderTextureBuffer:pixelBuffer Context:context];
    [self.mDataAdatper unlockPixelBuffer];
    
    return pixelBuffer;
}

- (CVPixelBufferRef)renderNormalVideoTexture:(EAGLContext *)context
{
    CVPixelBufferRef pixelBuffer = [self.mDataAdatper copyPixelBuffer];
        
    if (pixelBuffer == NULL) return nil;
    
    self.textureID = [self renderTextureBuffer:pixelBuffer Context:context];
    
    return pixelBuffer;
}

- (void)screenShotByIndex:(int)index VideoTag:(int)tag screenDoneblock:(void (^)(NSString *))block;
{
    _isScreenShot = true;
    _index = index;
    _tag = tag;
    screenDone = block;
}

- (void)screenShot:(CVPixelBufferRef)pixelBuffer
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [ImageTool imageFromCVPixelBufferRef:pixelBuffer];
        NSString *imageName = [NSString stringWithFormat:@"video_%d_%d.png", _tag, _index];
        NSString *pngPath = [[FileTool createFilePathWithName:@"Downloaded"] stringByAppendingPathComponent:imageName];
        [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            screenDone(pngPath);
        });
    });
}

- (GLuint )renderTextureBuffer:(CVPixelBufferRef)pixelBuffer Context:(EAGLContext *)context
{
    if (_isScreenShot) {
        _isScreenShot = false;
        [self screenShot:pixelBuffer];
    }
 
    if (!self.mDataAdatper.isijkPlayer) {
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    }
    GLsizei bufferHeight = (GLsizei)CVPixelBufferGetHeight(pixelBuffer);
    GLsizei bufferWidth = (GLsizei)CVPixelBufferGetWidth(pixelBuffer);
    
    CVOpenGLESTextureCacheRef textureCache = [self textureCache:context];
    CVOpenGLESTextureRef texture = NULL;
    
    CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, NULL, GL_TEXTURE_2D, GL_RGBA, bufferWidth, bufferHeight, GL_BGRA, GL_UNSIGNED_BYTE, 0, &texture);
    
    if (texture == NULL || err){
        NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreateTextureFromImage:%d",err);
    }
    
    GLuint textureid = CVOpenGLESTextureGetName(texture);
    glBindTexture(GL_TEXTURE_2D, textureid);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    if (!self.mDataAdatper.isijkPlayer) {
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    }
    CVOpenGLESTextureCacheFlush(textureCache, 0);
    if (!self.mDataAdatper.isijkPlayer) {
        CFRelease(pixelBuffer);
    }
    
    glBindTexture(GL_TEXTURE_2D, 0);
    
    CFRelease(texture);
    
    return textureid;
}

- (void)destory
{
    [super destory];
    
    if (ref != NULL) {
        CFRelease(ref);
    }
    ref = NULL;
}

- (void)dealloc
{
    [self destory];
    SZTLog(@"SZTVideoTexture dealloc");
}

@end
