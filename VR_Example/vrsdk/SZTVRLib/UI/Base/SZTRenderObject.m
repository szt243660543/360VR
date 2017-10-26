
//
//  SZTObjectFilter.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/9/9.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTRenderObject.h"
#import "SZTPlane3D.h"
#import "SZTSphere3D.h"
#import "SZTFishSphere3D.h"
#import "SZTDome3D.h"
#import "SZTCurvedSurface.h"
#import "SZTSector.h"
#import "SZTFrustum.h"
#import "SZTRay.h"
#import "SZTCamera.h"

#import "Shader_Normal.h"
#import "Shader_Luminance.h"
#import "Shader_Pixelate.h"
#import "Shader_Exposure.h"
#import "Shader_Discretize.h"
#import "Shader_Blur.h"
#import "Shader_Hue.h"
#import "Shader_PolkaDotFilter.h"
#import "Shader_Gamma.h"
#import "Shader_GlassSphere.h"
#import "Shader_Bilateral.h"
#import "Shader_Crosshatch.h"

@interface SZTRenderObject()
{
    float _initialX; // 初始X值
    float _initialY; // 初始Y值
    float _initialZ; // 初始z值
    
    BOOL _isOnce;
}

@property(nonatomic, strong)point *objPosition;
@property(nonatomic, strong)SZTFrustum *frustum;

@end

@implementation SZTRenderObject

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.textureFilter = SZT_LINEAR_MIPMAP_LINEAR;;
        self.frustum = [[SZTFrustum alloc] init];
        self.isInFrustum = true;
        self.renderModel = SZTVR_PLANE;
    }
    
    return self;
}

- (void)setupProgram
{
    [self changeFilter:SZTVR_NORMAL];
}

- (void)setupRenderObject
{
    [self changeDisplayMode:self.renderModel];
}

- (void)changeDisplayMode:(SZTRenderModel)renderModel
{
    self.renderModel = renderModel;
    [self destoryObject3D];
    
    if (!self.isScreen) {
        self.isScreen = NO;
    }

    switch (renderModel) {
        case SZTVR_SPHERE:{
            SZTSphere3D *objL = [[SZTSphere3D alloc] init];
            [objL setupVBO_Render:150 - self.zOrderForSphere isStereo:NO isLeft:NO isFilp:_isFlip isUpDown:NO isLeftRight:NO];
            _obj_Left = _obj_Right = objL;
        }
            break;
        case SZTVR_PLANE:{
            SZTPlane3D *objL = [[SZTPlane3D alloc] init];
            [objL setupVBO_Render:self.objSize isStereo:NO isLeft:NO isFilp:_isFlip isUpDown:NO isLeftRight:NO];
            _obj_Left = _obj_Right = objL;
        }
            break;
        case SZTVR_FISHSPHERE_HIGH:{
            [self setFishSphereObject:HIGH];
        }
            break;
        case SZTVR_FISHSPHERE_MEDIUM:{
            [self setFishSphereObject:MEDIUM];
        }
            break;
        case SZTVR_STEREO_SPHERE:{
            SZTSphere3D *objL = [[SZTSphere3D alloc] init];
            [objL setupVBO_Render:150 - self.zOrderForSphere isStereo:YES isLeft:YES isFilp:_isFlip isUpDown:YES isLeftRight:NO];
            _obj_Left = objL;
            
            SZTSphere3D *objR = [[SZTSphere3D alloc] init];
            [objR setupVBO_Render:150 - self.zOrderForSphere isStereo:YES isLeft:NO isFilp:_isFlip isUpDown:YES isLeftRight:NO];
            _obj_Right = objR;
        }
            break;
        case SZTVR_STEREO_HEMISPHERE:{
            SZTSphere3D *objL = [[SZTSphere3D alloc] init];
            [objL setupVBO_Render:148 - self.zOrderForSphere isStereo:YES isLeft:YES isFilp:_isFlip isUpDown:NO isLeftRight:YES];
            _obj_Left = objL;
            
            SZTSphere3D *objR = [[SZTSphere3D alloc] init];
            [objR setupVBO_Render:148 - self.zOrderForSphere isStereo:YES isLeft:NO isFilp:_isFlip isUpDown:NO isLeftRight:YES];
            _obj_Right = objR;
        }
            break;
        case SZTVR_STEREO_PLANE_UP_DOWN:{
            SZTPlane3D *objL = [[SZTPlane3D alloc] init];
            [objL setupVBO_Render:self.objSize isStereo:YES isLeft:YES isFilp:_isFlip isUpDown:YES isLeftRight:NO];
            _obj_Left = objL;
            
            SZTPlane3D *objR = [[SZTPlane3D alloc] init];
            [objR setupVBO_Render:self.objSize isStereo:YES isLeft:NO isFilp:_isFlip isUpDown:YES isLeftRight:NO];
            _obj_Right = objR;
        }
            break;
        case SZTVR_STEREO_PLANE_LEFT_RIGHT:{
            SZTPlane3D *objL = [[SZTPlane3D alloc] init];
            [objL setupVBO_Render:self.objSize isStereo:YES isLeft:YES isFilp:_isFlip isUpDown:NO isLeftRight:YES];
            _obj_Left = objL;
            
            SZTPlane3D *objR = [[SZTPlane3D alloc] init];
            [objR setupVBO_Render:self.objSize isStereo:YES isLeft:NO isFilp:_isFlip isUpDown:NO isLeftRight:YES];
            _obj_Right = objR;
        }
            break;
        case SZTVR_FISHSPHERE_RETINA_HIGH:{
            [self setFishSphereObject:RETINA_HIGH];
        }
            break;
        case SZTVR_FISHSPHERE_RETINA_MEDIUM:{
            [self setFishSphereObject:RETINA_MEDIUM];
        }
            break;
        case SZTVR_2D:{
            SZTPlane3D *objL = [[SZTPlane3D alloc] init];
            [objL setupVBO_Render:self.objSize isStereo:NO isLeft:NO isFilp:_isFlip isUpDown:NO isLeftRight:NO];
            _obj_Left = _obj_Right = objL;
            
            self.isScreen = YES;
        }
            break;
        case SZTVR_DOME180:{
            SZTDome3D *objL = [[SZTDome3D alloc] init];
            [objL setupVBO_Render:148 - self.zOrderForSphere isLeft:YES];
            _obj_Left = objL;
            
            SZTDome3D *objR = [[SZTDome3D alloc] init];
            [objR setupVBO_Render:148 - self.zOrderForSphere isLeft:NO];
            _obj_Right = objR;
        }
            break;
        case SZTVR_CURVEDSURFACE:{
            SZTCurvedSurface *objL = [[SZTCurvedSurface alloc] init];
            [objL setupVBO_Render:self.objSize isStereo:NO isLeft:NO isFilp:_isFlip];
            _obj_Left = _obj_Right = objL;
        }
            break;
        case SZTVR_SECTOR:{
            SZTSector *objL = [[SZTSector alloc] init];
            [objL setupVBO_Render:self.objSize isStereo:NO isLeft:NO isFilp:_isFlip];
            _obj_Left = _obj_Right = objL;
        }
            break;
        default:
            break;
    }
}

- (void)setFishSphereObject:(Resolution)resolution
{
    SZTFishSphere3D *objL = [[SZTFishSphere3D alloc] init];
    objL.resolution = resolution;
    [objL setupVBO_Render:148 - self.zOrderForSphere isLeft:YES isFlip:_isFlip];
    _obj_Left = objL;
    
    SZTFishSphere3D *objR = [[SZTFishSphere3D alloc] init];
    objR.resolution = resolution;
    [objR setupVBO_Render:148 - self.zOrderForSphere isLeft:NO isFlip:_isFlip];
    _obj_Right = objR;
}

- (void)setObjectSize:(float)width Height:(float)height
{
    [super setObjectSize:width Height:height];
    
    [self changeDisplayMode:self.renderModel];
}

- (void)changeFilter:(SZTFilterMode)filterMode
{
    self.filterMode = filterMode;
    
    [self destoryProgram];
    
    _program = [[SZTProgram alloc] init];
    
    switch (filterMode) {
        case SZTVR_NORMAL:{
            [_program loadShaders:NormalVertexShaderString FragShader:NormalFragmentShaderString isFilePath:NO];
        }
            break;
        case SZTVR_LUMINANCE:{
            [_program loadShaders:NormalVertexShaderString FragShader:LuminanceFragmentShaderString isFilePath:NO];
        }
            break;
        case SZTVR_PIXELATE:{
            [_program loadShaders:PixelateVertexShaderString FragShader:PixelateFragmentShaderString isFilePath:NO];
            _particles = 64;
        }
            break;
        case SZTVR_EXPOSURE:{
            [_program loadShaders:ExposureVertexShaderString FragShader:ExposureFragmentShaderString isFilePath:NO];
            _exposure = 0.0;
        }
            break;
        case SZTVR_DISCRETIZE:{
            [_program loadShaders:NormalVertexShaderString FragShader:DiscretizeFragmentShaderString isFilePath:NO];
        }
            break;
        case SZTVR_BLUR:{
            [_program loadShaders:BlurVertexShaderString FragShader:BlurFragmentShaderString isFilePath:NO];
            _radius = 0.02;
        }
            break;
        case SZTVR_HUE:{
            [_program loadShaders:HueVertexShaderString FragShader:HueFragmentShaderString isFilePath:NO];
            _hueAdjust = 90.0;
        }
            break;
        case SZTVR_POLKADOT:{
            [_program loadShaders:PolkaDotFilterVertexShaderString FragShader:PolkaDotFilterFragmentShaderString isFilePath:NO];
            _fractionalWidthOfPixel = 0.03;
            _aspectRatio = 1.0;
            _dotScaling = 0.90;
        }
            break;
        case SZTVR_GAMMA:{
            [_program loadShaders:GammaVertexShaderString FragShader:GammaFragmentShaderString isFilePath:NO];
            _gamma = 1.0;
        }
            break;
        case SZTVR_GLASSSPHERE:{
            [_program loadShaders:GlassSphereVertexShaderString FragShader:GlassSphereFragmentShaderString isFilePath:NO];
            _refractiveIndex = 0.71;
            _aspectRatio = 9.0/16.0;
            _radius = 0.25;
        }
            break;
        case SZTVR_BILATERAL:{
            [_program loadShaders:BilateralVertexShaderString FragShader:BilateralFragmentShaderString isFilePath:NO];
        }
            break;
        case SZTVR_CROSSHATCH:{
            [_program loadShaders:CrosshatchVertexShaderString FragShader:CrosshatchFragmentShaderString isFilePath:NO];
            _crossHatchSpacing = 0.05;
            _lineWidth = 0.005;
        }
            break;
        default:
            break;
    }
}

- (void)setupFilterMode
{
    if (self.filterMode == SZTVR_PIXELATE) {
        glUniform1f([_program uniformIndex:@"particles"], _particles);
    }
    
    if (self.filterMode == SZTVR_BLUR) {
        glUniform1f([_program uniformIndex:@"radius"], _radius);
    }
    
    if (self.filterMode == SZTVR_EXPOSURE) {
        glUniform1f([_program uniformIndex:@"exposure"], _exposure);
    }
    
    if (self.filterMode == SZTVR_HUE) {
        glUniform1f([_program uniformIndex:@"hueAdjust"], _hueAdjust);
    }
    
    if (self.filterMode == SZTVR_POLKADOT) {
        glUniform1f([_program uniformIndex:@"fractionalWidthOfPixel"], _fractionalWidthOfPixel);
        glUniform1f([_program uniformIndex:@"aspectRatio"], _aspectRatio);
        glUniform1f([_program uniformIndex:@"dotScaling"], _dotScaling);
    }
    
    if (self.filterMode == SZTVR_GAMMA) {
        glUniform1f([_program uniformIndex:@"gamma"], _gamma);
    }
    
    if (self.filterMode == SZTVR_GLASSSPHERE) {
        glUniform1f([_program uniformIndex:@"refractiveIndex"], _refractiveIndex);
        glUniform1f([_program uniformIndex:@"aspectRatio"], _aspectRatio);
        glUniform1f([_program uniformIndex:@"radius"], _radius);
    }
    
    if (self.filterMode == SZTVR_CROSSHATCH) {
        glUniform1f([_program uniformIndex:@"crossHatchSpacing"], _crossHatchSpacing);
        glUniform1f([_program uniformIndex:@"lineWidth"], _lineWidth);
    }
}

- (void)destoryProgram
{
    if (_program) [_program destory];
    _program = nil;
}

- (void)destoryObject3D
{
    if (_obj_Left) [_obj_Left destroy];
    if (_obj_Right) [_obj_Right destroy];
    _obj_Right = _obj_Left = nil;
}

- (void)renderToFbo:(int)index
{
    if ((self.renderModel == SZTVR_PLANE || self.renderModel == SZTVR_STEREO_PLANE_LEFT_RIGHT || self.renderModel == SZTVR_STEREO_PLANE_UP_DOWN) && !self.isScreen) {
        GLKMatrix4 MVP = GLKMatrix4Multiply([SZTCamera sharedSZTCamera].mModelViewProjectionMatrix, self.mModelMatrix);
        [self.frustum calculateFrustumPlanes:MVP];
        
        if ([self.frustum isPointsInFrustum:_obj_Left.vectorArr] || [self.frustum isPointInFrustum:self.pX Y:self.pY Z:self.pZ]) {
            self.isInFrustum = true;
        }else{
            self.isInFrustum = false;
        }
    }
        
    if (self.isInFrustum) {
        [self.program useProgram];
        [self setMVPMatrixToShader:index];
        [self setupFilterMode];
        [self setCuttingMark];
    }
}

- (void)setCuttingMark
{
    if (self.renderModel == SZTVR_PLANE || self.renderModel == SZTVR_STEREO_PLANE_LEFT_RIGHT || self.renderModel == SZTVR_STEREO_PLANE_UP_DOWN) {
        glUniformMatrix4fv(self.program.MMatrixHandle, 1, 0, self.mModelMatrix.m);
        float rect[] = {self.cutMinX, self.cutMaxX, self.cutMinY, self.cutMaxY};
        glUniform4fv([self.program uniformIndex:@"cuttingRect"], 1, rect);
    }
}

- (void)setMVPMatrixToShader:(int)index
{
    if(self.isScreen){
        GLKMatrix4 offsetModelMatrix = GLKMatrix4Identity;
        float offset = - [SZTCamera sharedSZTCamera].binocularDistance/13.0; // 偏移量
        
        if (index == 0) {
            offsetModelMatrix = GLKMatrix4Translate(self.mModelMatrix, -offset, 0.0, 0.0);
        }else{
            offsetModelMatrix = GLKMatrix4Translate(self.mModelMatrix, offset, 0.0, 0.0);
        }
        
        glUniformMatrix4fv(self.program.MVPMatrixHandle, 1, 0, offsetModelMatrix.m);
    }else{
        GLKMatrix4 MVP = GLKMatrix4Multiply([SZTCamera sharedSZTCamera].mModelViewProjectionMatrix, self.mModelMatrix);
        glUniformMatrix4fv(self.program.MVPMatrixHandle, 1, 0, MVP.m);
    }
}

- (void)drawElements:(int)index;
{
    if (!self.isInFrustum) return;
    
    // show
    if (index == 0) {
        [self.obj_Left updateKeyFrame];
        [self.obj_Left drawElements:self.program];
    }else{
        [self.obj_Right updateKeyFrame];
        [self.obj_Right drawElements:self.program];
    }
}

/** 开启物体跟随摄像机视角*/
- (void)openObjectFollowingCameraView
{
    if (!_isOnce) {
        _isOnce = true;
        _initialX = self.pX;
        _initialY = self.pY;
        _initialZ = self.pZ;
    }
    
    if (!self.isOpenObjectFollowingCameraView) return;
    
    if ((self.renderModel == SZTVR_PLANE || self.renderModel == SZTVR_STEREO_PLANE_LEFT_RIGHT || self.renderModel == SZTVR_STEREO_PLANE_UP_DOWN)&& !self.isScreen) {
        float x = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray].x * fabs(_initialZ);
        float y = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray].y * fabs(_initialZ);
        float z = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray].z * fabs(_initialZ);
        
        float yAngle = [MathC getYAngle:GLKVector3Make(x, y, z) pivotPoint:GLKVector3Make(0, 0, 0)];
        [self setRotate:0.0 radiansY:yAngle radiansZ:0.0];
        [self setPosition:x + _initialX Y:_initialY Z:z];
    }else{
        SZTLog(@"Waring: this object's renderModel is no a PLANE!");
    }
}

- (void)destory
{
    [self destoryProgram];
    [self destoryObject3D];
}

- (void)dealloc
{
    self.frustum = nil;
    self.objPosition = nil;
}

@end
