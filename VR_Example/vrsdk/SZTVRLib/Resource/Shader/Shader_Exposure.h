//
//  Shader_Exposure.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Exposure_h
#define Shader_Exposure_h

NSString *const ExposureVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
    uniform float exposure;
 
    varying lowp vec2 vTexCoord;
    varying lowp vec3 v_Position;
    varying float v_exposure;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        vTexCoord = aTexCoord;
        v_exposure = exposure;
    
        gl_Position = modelViewProjectionMatrix * position;
    }
);

NSString *const ExposureFragmentShaderString = @"precision mediump float;uniform sampler2D uSampler;varying mediump vec2 vTexCoord;varying float v_exposure;void main(){vec4 textureColor = texture2D(uSampler, vTexCoord);gl_FragColor = vec4(textureColor.rgb * pow(2.0, v_exposure), textureColor.w);}";
//SHADER_STRING
//(
//    precision mediump float;
//    uniform sampler2D uSampler;
//    varying mediump vec2 vTexCoord;
//    varying float v_exposure;
// 
//    void main()
//    {
//        vec4 textureColor = texture2D(uSampler, vTexCoord);
//        
//        gl_FragColor = vec4(textureColor.rgb * pow(2.0, v_exposure), textureColor.w);
//    }
//);

#endif /* Shader_Exposure_h */
