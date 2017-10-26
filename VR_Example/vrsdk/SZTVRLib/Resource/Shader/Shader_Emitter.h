//
//  Shader_Emitter.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Emitter_h
#define Shader_Emitter_h

NSString *const EmitterVertexShaderString = @"attribute float aTheta;attribute vec3 aShade;uniform mat4 modelViewProjectionMatrix;uniform float uK;uniform float uTime;varying vec3 vShade;void main(){float x = uTime * cos(uK*aTheta)*sin(aTheta);float y = uTime * cos(uK*aTheta)*cos(aTheta);gl_Position = modelViewProjectionMatrix * vec4(x, y, 0.0, 1.0);gl_PointSize = 16.0;vShade = aShade;}";

//(
//    // Attributes
//    attribute float aTheta;
//    attribute vec3 aShade;
// 
//    // Uniforms
//    uniform mat4 modelViewProjectionMatrix;
//    uniform float uK;
//    uniform float uTime;
// 
//    // Output to Fragment Shader
//    varying vec3 vShade;
// 
//    void main()
//    {
//        float x = uTime * cos(uK*aTheta)*sin(aTheta);
//        float y = uTime * cos(uK*aTheta)*cos(aTheta);
//    
//        gl_Position = modelViewProjectionMatrix * vec4(x, y, 0.0, 1.0);
//        gl_PointSize = 16.0;
//    
//        vShade = aShade;
//    }
//);

NSString *const EmitterFragmentShaderString = SHADER_STRING
(
    precision mediump float;
 
    varying vec3 vShade;
 
    // Uniforms
    uniform vec3 uColor;
    uniform sampler2D uSampler;
 
    void main()
    {
        vec4 texture = texture2D(uSampler, gl_PointCoord);
    
        if (texture.a <= 0.1) {
            discard;
        }else{
            vec4 color = vec4((uColor+vShade), 1.0);
        
            color.rgb = clamp(color.rgb, vec3(0.0), vec3(1.0));
        
            gl_FragColor = texture * color;
        }
    }
);

#endif /* Shader_Emitter_h */
