//
//  EmitterTemplate.h
//  GLParticles1
//
//  Created by RRC on 5/2/13.
//  Copyright (c) 2013 Ricardo Rendon Cepeda. All rights reserved.
//

#define NUM_PARTICLES 1000

typedef struct Particles
{
    float       theta;
    float       shade[3];
}Particles;

typedef struct Emitter
{
    Particles   particles[NUM_PARTICLES];
    int         k;
    float       color[3];
}Emitter;

Emitter emitter = {0.0f};
