//
//  Shader_Pixelate.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Pixelate_h
#define Shader_Pixelate_h

NSString *const PixelateVertexShaderString =SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
    uniform float particles;
 
    varying lowp vec2 vTexCoord;
    varying lowp vec3 v_Position;
    varying float v_particles;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        vTexCoord = aTexCoord;
        v_particles = particles;
    
        gl_Position = modelViewProjectionMatrix * position;
    }
);

NSString *const PixelateFragmentShaderString = @"precision mediump float;uniform sampler2D uSampler;varying mediump vec2 vTexCoord;varying float v_particles;float discretize(float f, float d){return floor(f * d + 0.5)/d;}vec2 discretize(vec2 v, float d){return vec2(discretize(v.x, d), discretize(v.y, d));}void main(){vec2 texCood = discretize(vTexCoord, v_particles);gl_FragColor = texture2D(uSampler, texCood);}";
//(
//    precision mediump float;
//    uniform sampler2D uSampler;
//    varying mediump vec2 vTexCoord;
//    varying float v_particles;
// 
//    float discretize(float f, float d)
//    {
//        return floor(f * d + 0.5)/d;
//    }
// 
//    vec2 discretize(vec2 v, float d)
//    {
//        return vec2(discretize(v.x, d), discretize(v.y, d));
//    }
// 
//    void main()
//    {
//        vec2 texCood = discretize(vTexCoord, v_particles);
//        gl_FragColor = texture2D(uSampler, texCood);
//    }
//);

#endif /* Shader_Pixelate_h */
