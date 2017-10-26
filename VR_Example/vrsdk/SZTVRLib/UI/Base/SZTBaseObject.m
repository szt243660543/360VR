//
//  SZTBaseObject.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/7/29.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTBaseObject.h"
#import "SZTAnimation3D.h"

@interface SZTBaseObject()
{
    BOOL _isAnimationScale;
    
    GLKVector3 _lastPos;
}

@end

@implementation SZTBaseObject

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _cutMinY = _cutMaxY = 0.0;
        _setTouchEnable = YES;
        
        _objSize = [[size alloc] init];
        _objSize.width = _objSize.height = 200.0;
        
        _m_sX = _m_sY = _m_sZ = 1.0;
        
        self.cutMaxY = 1000.0;
        self.cutMinY = -1000.0;
        self.cutMaxX = 1000.0;
        self.cutMinX = -1000.0;
        
        // 重置对象
        [self resetObject];
    }
    
    return self;
}

- (void)setContext:(EAGLContext *)context
{
    _glContext = context;
}

- (void)setPosition:(float)x Y:(float)y Z:(float)z
{
    self.mModelMatrix = GLKMatrix4Identity;
    
    [self setPos:x Y:y Z:z];
    [self setR:self.radiansX radiansY:self.radiansY radiansZ:self.radiansZ];
    [self setS:self.sX Y:self.sY Z:self.sZ];
    
    self.pX = x;
    self.pY = y;
    self.pZ = z;
}

- (void)setPositionForRelative:(float)x Y:(float)y Z:(float)z
{
    [self setPosition:self.pX + x Y:self.pY + y Z:self.pZ + z];
    
    [self setPos:x Y:y Z:z];
}

- (void)setPos:(float)x Y:(float)y Z:(float)z
{
    _mModelMatrix = GLKMatrix4TranslateWithVector3(_mModelMatrix, GLKVector3Make(x, y, z));
}

- (void)setScale:(float)x Y:(float)y Z:(float)z
{
    self.mModelMatrix = GLKMatrix4Identity;
    
    [self setPos:self.pX Y:self.pY Z:self.pZ];
    [self setR:self.radiansX radiansY:self.radiansY radiansZ:self.radiansZ];
    [self setS:x Y:y Z:z];
    
    self.sX = x;
    self.sY = y;
    self.sZ = z;
    
    if (!_isAnimationScale) {
        _m_sX = x;
        _m_sY = y;
        _m_sZ = z;
    }
}

- (void)setScaleForRelative:(float)x Y:(float)y Z:(float)z
{
    [self setScale:self.sX + (x - 1.0) Y:self.sY + (y - 1.0) Z:self.sZ + (z - 1.0)];
    
    [self setS:x Y:y Z:z];
}

- (void)setS:(float)x Y:(float)y Z:(float)z
{
    _mModelMatrix = GLKMatrix4ScaleWithVector3(_mModelMatrix, GLKVector3Make(x, y, z));
}

- (void)setRotate:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ
{
    self.mModelMatrix = GLKMatrix4Identity;
    
    [self setPos:self.pX Y:self.pY Z:self.pZ];
    [self setR:radiansX radiansY:radiansY radiansZ:radiansZ];
    [self setS:self.sX Y:self.sY Z:self.sZ];
    
    self.radiansX = radiansX;
    self.radiansY = radiansY;
    self.radiansZ = radiansZ;
}

- (void)setRotateForRelative:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ
{
    [self setRotate:self.radiansX + radiansX radiansY:self.radiansY + radiansY radiansZ:self.radiansZ + radiansZ];
}

- (void)setR:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ
{
    _mModelMatrix = GLKMatrix4RotateX(_mModelMatrix, GLKMathDegreesToRadians(radiansX));
    _mModelMatrix = GLKMatrix4RotateY(_mModelMatrix, GLKMathDegreesToRadians(radiansY));
    _mModelMatrix = GLKMatrix4RotateZ(_mModelMatrix, GLKMathDegreesToRadians(radiansZ));
}

- (void)resetObject
{
    _mModelMatrix = GLKMatrix4Identity;
    
    _pX = _pY = _pZ= 0.0;
    _sX = _sY = _sZ= 1.0;
    _m_sX = _m_sY = _m_sZ = 1.0;
    _radiansX = _radiansY = _radiansZ = 0.0;
}

- (void)setObjectSize:(float)width Height:(float)height
{
    self.objSize.width = width;
    self.objSize.height = height;
}

#pragma mark - Animation
- (void)moveTo:(float)time PosX:(float)x posY:(float)y posZ:(float)z finishBlock:(void(^)(void))block
{
    SZTAnimation3D *animate = [[SZTAnimation3D alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [animate moveTo:self Time:time PosX:x posY:y posZ:z finishBlock:^{
        [weakSelf setPosition:x Y:y Z:z];
        block();
    }];
}

- (void)moveBy:(float)time PosX:(float)x posY:(float)y posZ:(float)z finishBlock:(void(^)(void))block
{
    SZTAnimation3D *animate = [[SZTAnimation3D alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [animate moveBy:self Time:time PosX:x posY:y posZ:z finishBlock:^{
        [weakSelf setPositionForRelative:x Y:y Z:z];
        block();
    }];
}

- (void)scaleTo:(float)time scaleX:(float)x scaleY:(float)y scaleZ:(float)z finishBlock:(void(^)(void))block
{
    _isAnimationScale = true;
    
    SZTAnimation3D *animate = [[SZTAnimation3D alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [animate scaleTo:self Time:time scaleX:x scaleY:y scaleZ:z finishBlock:^{
        _isAnimationScale = false;
        [weakSelf setScale:x Y:y Z:z];
        
        block();
    }];
}

- (void)scaleBy:(float)time scaleX:(float)x scaleY:(float)y scaleZ:(float)z finishBlock:(void(^)(void))block
{
    _isAnimationScale = true;
    
    SZTAnimation3D *animate = [[SZTAnimation3D alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [animate scaleBy:self Time:time scaleX:x scaleY:y scaleZ:z finishBlock:^{
        _isAnimationScale = false;
        [weakSelf setScaleForRelative:x Y:y Z:z];
        
        block();
    }];
}

- (void)rotateTo:(float)time radiansX:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ finishBlock:(void(^)(void))block
{
    SZTAnimation3D *animate = [[SZTAnimation3D alloc] init];

    [animate rotateTo:self Time:time radiansX:radiansX radiansY:radiansY radiansZ:radiansZ finishBlock:^{
         block();
    }];
}

- (void)bezierTo:(float)time PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 ControlPoint2:(Point3D)point2 finishBlock:(void(^)(void))block
{
    __weak typeof(self) weakSelf = self;
    SZTAnimation3D *animate = [[SZTAnimation3D alloc] init];
    [animate bezierTo:self Time:time PointEnd:pointEnd ControlPoint1:point1 ControlPoint2:point2 finishBlock:^{
        block();
        [weakSelf setPosition:pointEnd.x Y:pointEnd.y Z:pointEnd.z];
    }];
}

- (void)bezierTo:(float)time PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 finishBlock:(void(^)(void))block
{
    __weak typeof(self) weakSelf = self;
    SZTAnimation3D *animate = [[SZTAnimation3D alloc] init];
    [animate bezierTo:self Time:time PointEnd:pointEnd ControlPoint1:point1 finishBlock:^{
         block();
        [weakSelf setPosition:pointEnd.x Y:pointEnd.y Z:pointEnd.z];
    }];
}

// 渐入效果
- (void)fadeIn:(float)time finishBlock:(void(^)(void))block
{
    
}

// 淡出效果
- (void)fadeOut:(float)time finishBlock:(void(^)(void))block
{
    
}

- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    
    if (hidden) {
        _lastPos = GLKVector3Make(self.pX, self.pY, self.pZ);
        [self setPosition:1000.0 Y:1000.0 Z:1000.0];
    }else{
        [self setPosition:_lastPos.x Y:_lastPos.y Z:_lastPos.z];
    }
}

#pragma mark - base
- (void)build
{
    [self setupProgram];
    
    [self setupRenderObject];
    
    [self setupTexture];
    
    [self addObserver];
}

- (void)setupProgram
{
    // base
}

- (void)setupRenderObject
{
    // base
}

- (void)setupTexture
{
    // base
}

- (void)addObserver
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self,SZTObject,nil];
    NSNotification *notice = [NSNotification notificationWithName:SZTObjectAddNotification object:nil userInfo:dict];
    [NotificationCenter postNotification:notice];
}

- (void)removeObject
{
    if (self.touch) {
        [self.touch destory];
        self.touch = nil;
    }
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self, SZTObject,nil];
    NSNotification *notice = [NSNotification notificationWithName:SZTObjectRemoveNotification object:nil userInfo:dict];
    [NotificationCenter postNotification:notice];
}

- (void)renderToFbo:(int)index
{
    // base
}

- (void)dealloc
{
    self.objSize = nil;
}

@end
