//
//  SZTParticle3D.m
//  SZTVR_SDK
//
//  Created by 苏宗涛 on 2016/12/9.
//  Copyright © 2016年 szt. All rights reserved.
//

#import "SZTParticle3D.h"
#import <OpenGLES/ES2/glext.h>
#import "EmitterTemplate.h"

@implementation SZTParticle3D

- (void)setupVBO_Render:(int)particleCount
{
    _particleCount = particleCount;
    
    for(int i = 0; i < particleCount; i++)
    {
        // Assign each particle its theta value (in radians)
        emitter.particles[i].theta = GLKMathDegreesToRadians(i);
        
        // Assign a random shade offset to each particle, for each RGB channel
        emitter.particles[i].shade[0] = [self randomFloatBetween:-0.25f and:0.25f];
        emitter.particles[i].shade[1] = [self randomFloatBetween:-0.25f and:0.25f];
        emitter.particles[i].shade[2] = [self randomFloatBetween:-0.25f and:0.25f];
    }
    
    glGenBuffers(1, &_particleBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _particleBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(emitter.particles), emitter.particles, GL_STATIC_DRAW);
}

- (float)randomFloatBetween:(float)min and:(float)max
{
    float range = max - min;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * range) + min;
}

- (void)drawElements:(SZTProgram *)program
{
    glBindBuffer(GL_ARRAY_BUFFER, _particleBuffer);
    
    [program addAttribute:@"aTheta"];
    [program addAttribute:@"aShade"];
    
    // Attributes
    glVertexAttribPointer([program attributeIndex:@"aTheta"], 1, GL_FLOAT, GL_FALSE, sizeof(Particles), (void*)(offsetof(Particles, theta)));
    glVertexAttribPointer([program attributeIndex:@"aShade"], 3, GL_FLOAT, GL_FALSE, sizeof(Particles), (void*)(offsetof(Particles, shade)));
    
    // Draw particles
    glDrawArrays(GL_POINTS, 0, _particleCount);
}

- (void)destroy
{
    glDeleteBuffers(1, &_particleBuffer);
}

-(void)dealloc
{
    [self destroy];
}

@end
