//
//  Shader_PolkaDotFilter.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_PolkaDotFilter_h
#define Shader_PolkaDotFilter_h

NSString *const PolkaDotFilterVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
    uniform float fractionalWidthOfPixel;
    uniform float aspectRatio;
    uniform float dotScaling;
 
    varying lowp vec2 vTexCoord;
    varying lowp vec3 v_Position;
    varying float v_fractionalWidthOfPixel;
    varying float v_aspectRatio;
    varying float v_dotScaling;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        vTexCoord = aTexCoord;
        v_fractionalWidthOfPixel = fractionalWidthOfPixel;
        v_aspectRatio = aspectRatio;
        v_dotScaling = dotScaling;
    
        gl_Position = modelViewProjectionMatrix * position;
    }
);

NSString *const PolkaDotFilterFragmentShaderString = SHADER_STRING
(
    precision mediump float;
 
    uniform sampler2D uSampler;
 
    varying mediump vec2 vTexCoord;
 
    varying float v_fractionalWidthOfPixel;
    varying float v_aspectRatio;
    varying float v_dotScaling;
 
    void main()
    {
        vec2 sampleDivisor = vec2(v_fractionalWidthOfPixel, v_fractionalWidthOfPixel / v_aspectRatio);
    
        vec2 samplePos = vTexCoord - mod(vTexCoord, sampleDivisor) + 0.5 * sampleDivisor;
        vec2 textureCoordinateToUse = vec2(vTexCoord.x, (vTexCoord.y * v_aspectRatio + 0.5 - 0.5 * v_aspectRatio));
        vec2 adjustedSamplePos = vec2(samplePos.x, (samplePos.y * v_aspectRatio + 0.5 - 0.5 * v_aspectRatio));
        float distanceFromSamplePoint = distance(adjustedSamplePos, textureCoordinateToUse);
        float checkForPresenceWithinDot = step(distanceFromSamplePoint, (v_fractionalWidthOfPixel * 0.5) * v_dotScaling);
    
        vec4 inputColor = texture2D(uSampler, samplePos);
    
        gl_FragColor = vec4(inputColor.rgb * checkForPresenceWithinDot, inputColor.a);
    }
);

#endif /* Shader_PolkaDotFilter_h */
