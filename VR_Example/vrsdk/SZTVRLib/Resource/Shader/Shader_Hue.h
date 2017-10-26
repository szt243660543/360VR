//
//  Shader_Hue.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Hue_h
#define Shader_Hue_h

NSString *const HueVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
    uniform float hueAdjust;
 
    varying lowp vec2 vTexCoord;
    varying lowp vec3 v_Position;
    varying float v_hueAdjust;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        vTexCoord = aTexCoord;
        v_hueAdjust = hueAdjust;
    
        gl_Position = modelViewProjectionMatrix * position;
    }
);

NSString *const HueFragmentShaderString = @"precision mediump float;uniform sampler2D uSampler;varying mediump vec2 vTexCoord;varying float v_hueAdjust;void main(){const vec4  kRGBToYPrime = vec4 (0.299, 0.587, 0.114, 0.0);const vec4  kRGBToI     = vec4 (0.595716, -0.274453, -0.321263, 0.0);const vec4  kRGBToQ     = vec4 (0.211456, -0.522591, 0.31135, 0.0);const vec4  kYIQToR   = vec4 (1.0, 0.9563, 0.6210, 0.0);const vec4  kYIQToG   = vec4 (1.0, -0.2721, -0.6474, 0.0);const vec4  kYIQToB   = vec4 (1.0, -1.1070, 1.7046, 0.0);vec4 color   = texture2D(uSampler, vTexCoord);float   YPrime = dot (color, kRGBToYPrime);float   I      = dot (color, kRGBToI);float   Q      = dot (color, kRGBToQ);float   hue     = atan (Q, I);float chroma  = sqrt (I * I + Q * Q);hue += (-v_hueAdjust);Q = chroma * sin (hue);I = chroma * cos (hue);vec4 yIQ   = vec4 (YPrime, I, Q, 0.0);color.r = dot (yIQ, kYIQToR);color.g = dot (yIQ, kYIQToG);color.b = dot (yIQ, kYIQToB);gl_FragColor = color;}";
//(
//    precision mediump float;
//
//    uniform sampler2D uSampler;
//
//    varying mediump vec2 vTexCoord;
//
//    varying float v_hueAdjust;
// 
//    void main()
//    {
//        const vec4  kRGBToYPrime = vec4 (0.299, 0.587, 0.114, 0.0);
//        const vec4  kRGBToI     = vec4 (0.595716, -0.274453, -0.321263, 0.0);
//        const vec4  kRGBToQ     = vec4 (0.211456, -0.522591, 0.31135, 0.0);
//    
//        const vec4  kYIQToR   = vec4 (1.0, 0.9563, 0.6210, 0.0);
//        const vec4  kYIQToG   = vec4 (1.0, -0.2721, -0.6474, 0.0);
//        const vec4  kYIQToB   = vec4 (1.0, -1.1070, 1.7046, 0.0);
//    
//        vec4 color   = texture2D(uSampler, vTexCoord);
//    
//        // Convert to YIQ
//        float   YPrime = dot (color, kRGBToYPrime);
//        float   I      = dot (color, kRGBToI);
//        float   Q      = dot (color, kRGBToQ);
//    
//        // Calculate the hue and chroma
//        float   hue     = atan (Q, I);
//        float   chroma  = sqrt (I * I + Q * Q);
//    
//        // Make the user's adjustments
//        hue += (-v_hueAdjust); //why negative rotation?
//    
//        // Convert back to YIQ
//        Q = chroma * sin (hue);
//        I = chroma * cos (hue);
//    
//        // Convert back to RGB
//        vec4 yIQ   = vec4 (YPrime, I, Q, 0.0);
//        color.r = dot (yIQ, kYIQToR);
//        color.g = dot (yIQ, kYIQToG);
//        color.b = dot (yIQ, kYIQToB);
//    
//        // Save the result
//        gl_FragColor = color;
//    }
//);

#endif /* Shader_Hue_h */
