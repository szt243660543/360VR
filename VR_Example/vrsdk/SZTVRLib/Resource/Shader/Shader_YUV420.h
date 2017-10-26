//
//  Shader_Fbo.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_YUV420_h
#define Shader_YUV420_h

NSString *const YUV420VertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
 
    varying vec2 texCoordVarying;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        gl_Position = modelViewProjectionMatrix * position;
        texCoordVarying = aTexCoord;
    }
);

NSString *const YUV420FragmentShaderString = SHADER_STRING
(
    precision mediump float;
 
    uniform sampler2D SamplerY;
    uniform sampler2D SamplerUV;
    uniform mat3 colorConversionMatrix;
 
    varying vec2 texCoordVarying;
 
    void main()
    {
        mediump vec3 yuv;
        lowp vec3 rgb;
    
        // Subtract constants to map the video range start at 0
        yuv.x = (texture2D(SamplerY, texCoordVarying).r);
        yuv.yz = (texture2D(SamplerUV, texCoordVarying).ra - vec2(0.5, 0.5));
    
        rgb = colorConversionMatrix * yuv;
    
        gl_FragColor = vec4(rgb, 1);
    }
);

#endif
