//
//  Shader_Fbo.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_YUV_h
#define Shader_YUV_h

NSString *const YUVVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
 
    varying vec2 vTexCoord;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main() {
        vTexCoord = aTexCoord;
     
        gl_Position = modelViewProjectionMatrix * position;
    }
);

NSString *const YUVFragmentShaderString = SHADER_STRING
(
    precision mediump float;
 
    uniform sampler2D SamplerY;
    uniform sampler2D SamplerU;
    uniform sampler2D SamplerV;
 
    varying vec2 vTexCoord;
 
    uniform mat3 colorConversionMatrix;
 
    void main() {
     
        float y = texture2D(SamplerY, vTexCoord).r ;
        float u = texture2D(SamplerU, vTexCoord).r - 0.5;
        float v = texture2D(SamplerV, vTexCoord).r - 0.5;
     
        float r = y +            1.402 * v;
        float g = y - 0.344 * u -0.714 * v;
        float b = y + 1.772 * u;
     
        gl_FragColor = vec4(r,g,b,1.0);
    }
);

#endif
