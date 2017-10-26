//
//  AABB.m
//  SZTVR_SDK
//
//  Created by szt on 2017/2/22.
//  Copyright © 2017年 szt. All rights reserved.
//

#import "AABB.h"
#import "SZTRay.h"

@interface AABB()
{
    GLKVector3 min;
    GLKVector3 max;
    GLKVector3 m_pos;
    
    BOOL _isOnce;
}

@end

@implementation AABB

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // 初始化
        min = GLKVector3Make(0.0, 0.0, 0.0);
        max = GLKVector3Make(0.0, 0.0, 0.0);
    }
    
    return self;
}

- (BOOL)intersect:(GLKMatrix4)modelMatrix
{
    float tmin = -max_n;
    float tmax =  max_n;
    
    [self createAABBBox:modelMatrix];
        
    point *LBPos = self.curPosArr[0];
    m_pos = LBPos.vertexPoint;
    [self resetBoxArr];
    
    //ray origin
    GLKVector3 origin = GLKVector3Make(0.0f, 0.0f, 0.0f);
    GLKVector3 ray = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray];
    GLKVector3 curDir = ray;
    
    // 点积
    float dot = GLKVector3DotProduct(GLKVector3Make(m_pos.x, m_pos.y, m_pos.z), ray);
    if (dot < 0) {
        return false;
    }
    
    if(fabs(curDir.v[0])< DELTA){
        if(origin.x < min.x || origin.x > max.x){
            return false;
        }
    }else{
        float ood = 1.0f/curDir.v[0];
        float t1 = (min.x - origin.x)*ood;
        float t2 = (max.x - origin.x)*ood;
        
        if(t1 > t2){
            float temp = t1;
            t1 = t2;
            t2 = temp;
        }
        
        if(t1 > tmin) tmin = t1;
        if(t2 < tmax) tmax =  t2;
        
        if(tmin > tmax) return false;
    }
    
    if(fabs(curDir.v[1])<DELTA){
        if(origin.y < min.y || origin.y > max.y){
            return false;
        }
    }else{
        float ood = 1.0f/curDir.v[1];
        float t1 = (min.y - origin.y)*ood;
        float t2 = (max.y - origin.y)*ood;
        
        if(t1 > t2){
            float temp = t1;
            t1 = t2;
            t2 = temp;
        }
        
        if(t1 >tmin) tmin = t1;
        if(t2 < tmax) tmax =  t2;
        
        if(tmin > tmax) return false;
    }
    
    if(fabs(curDir.v[2])<DELTA){
        if(origin.z < min.z || origin.z > max.z){
            return false;
        }
    }else{
        float ood = 1.0f/curDir.v[2];
        float t1 = (min.z - origin.z)*ood;
        float t2 = (max.z - origin.z)*ood;
        
        if(t1 > t2){
            float temp = t1;
            t1 = t2;
            t2 = temp;
        }
        
        if(t1 >tmin) tmin = t1;
        if(t2 < tmax) tmax =  t2;
        
        if(tmin > tmax) return false;
    }
    
    float radians = modelMatrix.m32;
    GLKVector3 rayNormalization = [MathC vector3Normalization:[SZTRay sharedSZTRay].ray];
    float ratio = radians/rayNormalization.z;
    
    float x = rayNormalization.x * ratio;
    float y = rayNormalization.y * ratio;
    self.pickingPos = GLKVector3Make(x - m_pos.x, y - m_pos.y, 0.0);
    
    return true;
}

- (void)createAABBBox:(GLKMatrix4)modelMatrix
{
    for(int i = 0; i < self.vectorArr.count; i++){
        point *pos = self.vectorArr[i];
        point *worldPos = [[point alloc] init];
        worldPos.vertexPoint = GLKVector3Make(modelMatrix.m30 + pos.vertexPoint.x * modelMatrix.m00, modelMatrix.m31 + pos.vertexPoint.y * modelMatrix.m11, modelMatrix.m32 + pos.vertexPoint.z * modelMatrix.m22);
        [self.curPosArr insertObject:worldPos atIndex:i];
    }
    
    [self computeAABB:self.curPosArr pointNum:(int)self.curPosArr.count];
}

- (void)resetBoxArr
{
    self.curPosArr = nil;
    self.curPosArr = [[NSMutableArray alloc] init];
}

- (void)computeAABB:(NSMutableArray *)vectors pointNum:(int)pointNum
{
    int minX = [self extrameMin:GLKVector3Make(1.0, 0.0, 0.0) Box:vectors pointNum:pointNum];
    int maxX = [self extrameMax:GLKVector3Make(1.0, 0.0, 0.0) Box:vectors pointNum:pointNum];
    point *_posi = vectors[minX];
    min.x = _posi.vertexPoint.x;
    point *_posj = vectors[maxX];
    max.x = _posj.vertexPoint.x;
    
    int minY = [self extrameMin:GLKVector3Make(0.0, 1.0, 0.0) Box:vectors pointNum:pointNum];
    int maxY = [self extrameMax:GLKVector3Make(0.0, 1.0, 0.0) Box:vectors pointNum:pointNum];
    point *_poss = vectors[minY];
    min.y = _poss.vertexPoint.y;
    point *_post = vectors[maxY];
    max.y = _post.vertexPoint.y;
    
    int minZ = [self extrameMin:GLKVector3Make(0.0, 0.0, 1.0) Box:vectors pointNum:pointNum];
    int maxZ = [self extrameMax:GLKVector3Make(0.0, 0.0, 1.0) Box:vectors pointNum:pointNum];
    point *_posu = vectors[minZ];
    min.z = _posu.vertexPoint.z;
    point *_posv = vectors[maxZ];
    max.z = _posv.vertexPoint.z;
    
    if (self.isObjModel) {
        [self createNewAABBBox];
    }
}

- (void)createNewAABBBox
{
    if (!_isOnce) {
        _isOnce = TRUE;
        
        self.vectorArr = nil;
        self.vectorArr = [[NSMutableArray alloc] init];
        
        // 将新的aabb包围盒8个点存起来
        point * vec1= [[point alloc] init];
        vec1.vertexPoint = GLKVector3Make(min.x, min.y, max.z);
        [self.vectorArr addObject:vec1];
        
        point * vec2= [[point alloc] init];
        vec2.vertexPoint = GLKVector3Make(max.x, min.y, max.z);
        [self.vectorArr addObject:vec2];
        
        point * vec3= [[point alloc] init];
        vec3.vertexPoint = GLKVector3Make(min.x, max.y, max.z);
        [self.vectorArr addObject:vec3];
        
        point * vec4= [[point alloc] init];
        vec4.vertexPoint = GLKVector3Make(max.x, max.y, max.z);
        [self.vectorArr addObject:vec4];
        
        point * vec5= [[point alloc] init];
        vec5.vertexPoint = GLKVector3Make(min.x, min.y, min.z);
        [self.vectorArr addObject:vec5];
        
        point * vec6= [[point alloc] init];
        vec6.vertexPoint = GLKVector3Make(max.x, min.y, min.z);
        [self.vectorArr addObject:vec6];
        
        point * vec7= [[point alloc] init];
        vec7.vertexPoint = GLKVector3Make(min.x, max.y, min.z);
        [self.vectorArr addObject:vec7];
        
        point * vec8= [[point alloc] init];
        vec8.vertexPoint = GLKVector3Make(max.x, max.y, min.z);
        [self.vectorArr addObject:vec8];
    }
}

- (int)extrameMax:(GLKVector3)dir Box:(NSMutableArray *)vectors pointNum:(int)pointNum
{
    int maxindex = 0;
    float maxProj = -max_n;
    
    for(int i = 0; i < pointNum; i++){
        float proj = 0.0f;
        point * pos = vectors[i];
        proj = GLKVector3DotProduct(dir, pos.vertexPoint);
        if(proj > maxProj){
            maxProj = proj;
            maxindex = i;
        }
    }
    
    return maxindex;
}

- (int)extrameMin:(GLKVector3)dir Box:(NSMutableArray *)vectors pointNum:(int)pointNum
{
    int minindex = 0;
    float minProj = max_n;
    
    for(int i = 0; i < pointNum; i++){
        float proj = 0.0f;
        point * pos = vectors[i];
        proj = GLKVector3DotProduct(dir, pos.vertexPoint);
        
        if(proj < minProj){
            minProj = proj;
            minindex = i;
        }
    }
    
    return minindex;
}

@end
