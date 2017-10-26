//
//  SceneTransitionTool.m
//  SZTVR_SDK
//
//  Created by szt on 2017/4/25.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "SceneTransitionTool.h"
#import "Shader_FadeInOut.h"

@interface SceneTransitionTool()
{
    float _alpha;
    BOOL _isFadeIn;
    BOOL _isFadeOut;
}

@property(nonatomic, assign)float fadeTime;

@end

@implementation SceneTransitionTool

- (instancetype)init
{
    self = [super initWithMode:SZTVR_SPHERE];
    
    if (self) {
        [self setupTextureWithColor:[UIColor blackColor] Rect:CGRectMake(0.0, 0.0, 1.0, 1.0)];
        self.zOrderForSphere = 149.0;
        _alpha = 0.0;
    }
    
    return self;
}

- (instancetype)initWithMode:(SZTRenderModel)renderModel
{
    self = [super initWithMode:SZTVR_SPHERE];
    
    if (self) {
        [self setupTextureWithColor:[UIColor blackColor] Rect:CGRectMake(0.0, 0.0, 1.0, 1.0)];
        self.zOrderForSphere = 149.0;
        _alpha = 0.0;
    }
    
    return self;
}

- (void)changeFilter:(SZTFilterMode)filterMode
{
    self.filterMode = filterMode;
    
    [self resetProgram];
    
    self.program = [[SZTProgram alloc] init];
    
    [self.program loadShaders:FadeInOutVertexShaderString FragShader:FadeInOutFragmentShaderString isFilePath:NO];
}

- (void)resetProgram
{
    if (self.program) [self.program destory];
    self.program = nil;
}

- (void)fadeInScene:(float)time complete:(void (^)(void))isComplete
{
    _alpha = 0.0;
    self.fadeTime = time;
    _isFadeIn = true;
    _isFadeOut = false;
    
    completed = isComplete;
}

- (void)fadeOutScene:(float)time complete:(void (^)(void))isComplete
{
    _alpha = 1.0;
    self.fadeTime = time;
    _isFadeIn = false;
    _isFadeOut = true;
    
    completed = isComplete;
}

- (void)fadeData
{
    float eachValue = _isFadeIn?1.0/(_fadeTime * 60.0):-1.0/(_fadeTime * 60.0);
    _alpha = _alpha + eachValue;
        
    if (_alpha <= 0.0) {
        _alpha = 0.0;
        completed();
    }
        
    if (_alpha >= 1.0 ) {
        _alpha = 1.0;
        completed();
    }
    
    glUniform1f([self.program uniformIndex:@"alpha"], _alpha);
}

@end
