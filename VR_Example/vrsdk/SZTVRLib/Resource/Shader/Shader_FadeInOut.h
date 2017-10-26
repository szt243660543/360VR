//
//  Shader_FadeInOut.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_FadeInOut_h
#define Shader_FadeInOut_h

NSString *const FadeInOutVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
 
    uniform mat4 modelViewProjectionMatrix;

    uniform float alpha;
 
    varying vec2 vTexCoord;
 
    varying float vAlpha;
 
    void main()
    {
        vTexCoord = aTexCoord;
        gl_Position = modelViewProjectionMatrix * position;
        
        vAlpha = alpha;
    }
);

NSString *const FadeInOutFragmentShaderString = SHADER_STRING
(
    precision mediump float;
    uniform sampler2D uSampler;
    varying vec2 vTexCoord;
 
    varying float vAlpha;
 
    void main()
    {
        vec4 pixel = texture2D(uSampler, vTexCoord);
        if (pixel.a <= 0.1) {
            discard;
        }else{
            gl_FragColor = vec4(pixel.r, pixel.g, pixel.b, vAlpha);
        }
    }
);

#endif /* Shader_FadeInOut_h */
