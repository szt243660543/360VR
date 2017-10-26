//
//  Shader_Blur.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Blur_h
#define Shader_Blur_h

NSString *const BlurVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
    uniform float radius;
 
    varying lowp vec2 vTexCoord;
    varying lowp vec3 v_Position;
    varying lowp vec2 v_blurTexCoords[14];
 
    uniform mat4 modelViewMatrix;
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        vTexCoord = aTexCoord;
    
        gl_Position = modelViewProjectionMatrix * position;
    
        for (int i = 0; i < 7; ++ i) {
            vec2 c = vec2(0.0, radius/7.0 * (7.0 - float(i)));
            v_blurTexCoords[i] = vTexCoord - c;
            v_blurTexCoords[13 - i] = vTexCoord + c;
        }
    }
);

NSString *const BlurFragmentShaderString = SHADER_STRING
(
    precision mediump float;
 
    uniform sampler2D uSampler;
 
    varying mediump vec2 vTexCoord;
    varying mediump vec2 v_blurTexCoords[14];
 
    void main()
    {
        gl_FragColor = vec4(0.0);
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[ 0])*0.0044299121055113265;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[ 1])*0.00895781211794;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[ 2])*0.0215963866053;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[ 3])*0.0443683338718;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[ 4])*0.0776744219933;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[ 5])*0.115876621105;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[ 6])*0.147308056121;
        gl_FragColor += texture2D(uSampler, vTexCoord         )*0.159576912161;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[ 7])*0.147308056121;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[ 8])*0.115876621105;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[ 9])*0.0776744219933;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[10])*0.0443683338718;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[11])*0.0215963866053;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[12])*0.00895781211794;
        gl_FragColor += texture2D(uSampler, v_blurTexCoords[13])*0.0044299121055113265;
    }
);

#endif /* Shader_Blur_h */
