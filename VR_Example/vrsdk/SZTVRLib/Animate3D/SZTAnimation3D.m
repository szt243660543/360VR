//
//  SZTAnimation3D.m
//  SZTVR_SDK
//
//  Created by SZTVR on 16/8/9.
//  Copyright © 2016年 SZTVR. All rights reserved.
//

#import "SZTAnimation3D.h"

@interface SZTAnimation3D()
{
    CADisplayLink *_displayLink;
    
    UInt64 _lastTime;
    BOOL _isFirstIn;
    
    SZTBaseObject* _object;
    
    float _radiansX;
    float _radiansY;
    float _radiansZ;
    
    float _useTime;
    
    float _lenthX;
    float _lenthY;
    float _lenthZ;
    
    Point3D _pointStart;
    Point3D _pointEnd;
    Point3D _point1;
    Point3D _point2;
    int i;
    
    int _scaleTime;
    
    BOOL _isThreeBesselCurve; // 是否是三次贝塞尔
    
    float _fps;
}

@end

@implementation SZTAnimation3D

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _isFirstIn = true;
        _scaleTime = 1;
        _fps = 60.0;
    }
    
    return self;
}

- (void)moveTo:(SZTBaseObject *)object Time:(float)time PosX:(float)x posY:(float)y posZ:(float)z finishBlock:(didFinishBlock)block
{
    [self setMoveData:object Time:time LenthX:x - object.pX LenthY:y - object.pY LenthZ:z - object.pZ];
    
    didFinished = block;
}

- (void)moveBy:(SZTBaseObject *)object Time:(float)time PosX:(float)x posY:(float)y posZ:(float)z finishBlock:(didFinishBlock)block
{
    [self setMoveData:object Time:time LenthX:x LenthY:y LenthZ:z];
    
    didFinished = block;
}

- (void)setMoveData:(SZTBaseObject *)object Time:(float)time LenthX:(float)x LenthY:(float)y LenthZ:(float)z
{
    _object = object;
    _useTime = time;

    _lenthX = x;
    _lenthY = y;
    _lenthZ = z;
    
    [self setupDisplayLinkMove];
}

- (void)scaleTo:(SZTBaseObject *)object Time:(float)time scaleX:(float)x scaleY:(float)y scaleZ:(float)z finishBlock:(didFinishBlock)block
{
    float scalex = x - object.sX;
    float scaley = y - object.sY;
    float scalez = z - object.sZ;
    
    [self setScaleData:object Time:time LenthX:scalex LenthY:scaley LenthZ:scalez];
    
    didFinished = block;
}

- (void)scaleBy:(SZTBaseObject *)object Time:(float)time scaleX:(float)x scaleY:(float)y scaleZ:(float)z finishBlock:(didFinishBlock)block
{
    [self setScaleData:object Time:time LenthX:x LenthY:y LenthZ:z];
    
    didFinished = block;
}

- (void)setScaleData:(SZTBaseObject *)object Time:(float)time LenthX:(float)x LenthY:(float)y LenthZ:(float)z
{
    _object = object;
    _useTime = time;
    
    _lenthX = x;
    _lenthY = y;
    _lenthZ = z;
    
    [self setupDisplayLinkScale];
}

- (void)rotateTo:(SZTBaseObject *)object Time:(float)time radiansX:(float)radiansX radiansY:(float)radiansY radiansZ:(float)radiansZ finishBlock:(didFinishBlock)block
{
    _object = object;
    _useTime = time;
    _radiansX = radiansX;
    _radiansY = radiansY;
    _radiansZ = radiansZ;
    
    didFinished = block;
    
    [self setupDisplayLinkRotate];
}

- (void)bezierTo:(SZTBaseObject *)object Time:(float)time PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 ControlPoint2:(Point3D)point2 finishBlock:(didFinishBlock)block
{
    _object = object;
    _useTime = time;
    _point1 = point1;
    _point2 = point2;
    _pointEnd = pointEnd;
    
    _pointStart.x = _object.pX;
    _pointStart.y = _object.pY;
    _pointStart.z = _object.pZ;
    
    didFinished = block;
    
    _isThreeBesselCurve = true;
    
    [self setupDisplayLinkBezier];
}

- (void)bezierTo:(SZTBaseObject *)object Time:(float)time PointEnd:(Point3D)pointEnd ControlPoint1:(Point3D)point1 finishBlock:(didFinishBlock)block
{
    _object = object;
    _useTime = time;
    _point1 = point1;
    _pointEnd = pointEnd;
    
    _pointStart.x = _object.pX;
    _pointStart.y = _object.pY;
    _pointStart.z = _object.pZ;
    
    didFinished = block;
    
    _isThreeBesselCurve = false;
    
    [self setupDisplayLinkBezier];
}

- (void)setupDisplayLinkMove
{
    float theInterval = _fps/60.0;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkMove)];
    _displayLink.frameInterval = theInterval;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)setupDisplayLinkScale
{
    float theInterval = _fps/60.0;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkScale)];
    _displayLink.frameInterval = theInterval;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)setupDisplayLinkRotate
{
    float theInterval = _fps/60.0;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkRotate)];
    _displayLink.frameInterval = theInterval;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)setupDisplayLinkBezier
{
    float theInterval = _fps/60.0;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkBezier)];
    _displayLink.frameInterval = theInterval;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

// 1/60秒刷新一次
- (void)displayLinkMove
{
    // 获取到毫秒 0.001
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    if (_isFirstIn) {
        _isFirstIn = false;
        _lastTime = recordTime;
    }
    
    UInt64 delayTimes = (recordTime - _lastTime);
    
    if (delayTimes <= _useTime * 1000) {
        [_object setPositionForRelative:_lenthX/(_fps * _useTime) Y:_lenthY/(_fps * _useTime) Z:_lenthZ/(_fps * _useTime)];
    }else{
        didFinished();
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)displayLinkScale
{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    if (_isFirstIn) {
        _isFirstIn = false;
        _lastTime = recordTime;
    }
    
    UInt64 delayTimes = (recordTime - _lastTime);
    float cutTime = _fps * _useTime;
    
    if (delayTimes <= _useTime * 1000) {
        [_object setScale:_object.m_sX + _lenthX/cutTime*_scaleTime Y:_object.m_sY + _lenthY/cutTime*_scaleTime Z:_object.m_sZ + _lenthZ/cutTime*_scaleTime];
        _scaleTime ++;
    }else{
        didFinished();
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)displayLinkRotate
{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    if (_isFirstIn) {
        _isFirstIn = false;
        _lastTime = recordTime;
    }
    
    UInt64 delayTimes = (recordTime - _lastTime);
    
    if (delayTimes <= _useTime * 1000) {
        [_object setRotateForRelative:_radiansX/(_fps*_useTime) radiansY:_radiansY/(_fps*_useTime) radiansZ:_radiansZ/(_fps*_useTime)];
    }else{
        didFinished();
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)displayLinkBezier
{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    
    if (_isFirstIn) {
        _isFirstIn = false;
        _lastTime = recordTime;
    }
    
    UInt64 delayTimes = (recordTime - _lastTime);
    
    if (delayTimes <= _useTime * 1000) {
        float dt;
        dt = 1.0 / (_fps * _useTime);
        i ++ ;
        Point3D pos;
        // get Bezier point
        if (_isThreeBesselCurve) {
            pos = [MathC pointOnCubicBezier:_pointStart PointEnd:_pointEnd ControlPoint1:_point1 ControlPoint2:_point2 T:i*dt];
        }else{
            pos = [MathC pointOnCubicBezier:_pointStart PointEnd:_pointEnd ControlPoint1:_point1 T:i*dt];
        }
        
        [_object setPosition:pos.x Y:pos.y Z:pos.z];
    }else{
        didFinished();
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)dealloc
{
    [_displayLink invalidate];
    _displayLink = nil;
}

@end
