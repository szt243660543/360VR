//
//  Shader_Crosshatch.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Crosshatch_h
#define Shader_Crosshatch_h

NSString *const CrosshatchVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
    uniform float crossHatchSpacing;
    uniform float lineWidth;
 
    varying lowp vec2 vTexCoord;
    varying lowp vec3 v_Position;
 
    varying float v_crossHatchSpacing;
    varying float v_lineWidth;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        vTexCoord = aTexCoord;
        v_crossHatchSpacing = crossHatchSpacing;
        v_lineWidth = lineWidth;
    
        gl_Position = modelViewProjectionMatrix * position;
    }
);

NSString *const CrosshatchFragmentShaderString = SHADER_STRING
(
    precision mediump float;
 
    uniform sampler2D uSampler;
    varying mediump vec2 vTexCoord;
 
    varying float v_crossHatchSpacing;
    varying float v_lineWidth;
 
    const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);
 
    void main()
    {
        highp float luminance = dot(texture2D(uSampler, vTexCoord).rgb, W);
    
        lowp vec4 colorToDisplay = vec4(1.0, 1.0, 1.0, 1.0);
        if (luminance < 1.00)
        {
            if (mod(vTexCoord.x + vTexCoord.y, v_crossHatchSpacing) <= v_lineWidth)
            {
                colorToDisplay = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }
        if (luminance < 0.75)
        {
            if (mod(vTexCoord.x - vTexCoord.y, v_crossHatchSpacing) <= v_lineWidth)
            {
                colorToDisplay = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }
        if (luminance < 0.50)
        {
            if (mod(vTexCoord.x + vTexCoord.y - (v_crossHatchSpacing / 2.0), v_crossHatchSpacing) <= v_lineWidth)
            {
                colorToDisplay = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }
        if (luminance < 0.3)
        {
            if (mod(vTexCoord.x - vTexCoord.y - (v_crossHatchSpacing / 2.0), v_crossHatchSpacing) <= v_lineWidth)
            {
                colorToDisplay = vec4(0.0, 0.0, 0.0, 1.0);
            }
        }
    
        gl_FragColor = colorToDisplay;
    }
);

#endif /* Shader_Crosshatch_h */
