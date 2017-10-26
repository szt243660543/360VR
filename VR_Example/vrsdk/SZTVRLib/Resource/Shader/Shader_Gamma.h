//
//  Shader_Gamma.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Gamma_h
#define Shader_Gamma_h

NSString *const GammaVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
    uniform float gamma;
 
    varying lowp vec2 vTexCoord;
    varying lowp vec3 v_Position;
    varying float v_gamma;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        vTexCoord = aTexCoord;
        v_gamma = gamma;
    
        gl_Position = modelViewProjectionMatrix * position;
    }
);

NSString *const GammaFragmentShaderString = @"precision mediump float;uniform sampler2D uSampler;varying mediump vec2 vTexCoord;varying float v_gamma;void main(){vec4 textureColor = texture2D(uSampler, vTexCoord);gl_FragColor = vec4(pow(textureColor.rgb, vec3(v_gamma)), textureColor.w);}";
//(
//    precision mediump float;
// 
//    uniform sampler2D uSampler;
// 
//    varying mediump vec2 vTexCoord;
// 
//    varying float v_gamma;
// 
//    void main()
//    {
//        vec4 textureColor = texture2D(uSampler, vTexCoord);
//    
//        gl_FragColor = vec4(pow(textureColor.rgb, vec3(v_gamma)), textureColor.w);
//    }
//);

#endif /* Shader_Gamma_h */
