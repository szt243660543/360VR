//
//  MD2Sprite.m
//  SZTVR_SDK
//
//  Created by szt on 2017/7/5.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "MD2Sprite.h"

@interface MD2Sprite()
{
    MD2Model *_model;
    
    BOOL isplay;
    
    float frameIndex;
}

@property(nonatomic, assign)int currentFrame;
@property(nonatomic, assign)int beginFrame;
@property(nonatomic, assign)int endFrame;

@end

@implementation MD2Sprite

- (instancetype)initWithFilePath:(NSString *)path
{
    self = [super init];
    
    if (self) {
        self.isMD2 = YES;
        self.isobj = YES;
        
        _model = [[MD2Model alloc] initWithFile:path];
        
        [self setupVBO_Render];
    }
    
    return self;
}

- (void)setupVBO_Render
{
    self.frameVertices = [_model calculatedFrameVertices];
    self.frametextureCoords = [_model calculatedTextureCoords];
    self.num_triangles = _model.header.num_triangles * 3;
    [_model calculateFrameVerticesForFrame:1];
    
    _beginFrame = 0;
    _currentFrame = 0;
    _endFrame = _model.header.num_frames;
    _frameInterval = 0.08;
    
    [super setupVBO];
}

- (void)updateKeyFrame
{
    if (!isplay) return;
    
    frameIndex += _frameInterval;
    
    if (frameIndex >= 1.0) {
        frameIndex = 0.0;
        
        _currentFrame ++;
    }
    
    if (_currentFrame > _endFrame - 1) {
        if (_isCycle) {
            _currentFrame = _beginFrame;
        }else{
            [self pause];
        }
    }
    
    [_model animateFrameVerticesForFrame:_currentFrame withInterpolation:frameIndex];
}

- (void)playFrameFrom:(int)beginFrame To:(int)endFrame
{
    _beginFrame = beginFrame;
    _endFrame = endFrame;
    
    _currentFrame = _beginFrame;
}

- (void)play
{
    isplay = true;
}

- (void)pause
{
    isplay = false;
}

- (void)dealloc
{
    if (_model) {
        _model = nil;
    }
}

@end
