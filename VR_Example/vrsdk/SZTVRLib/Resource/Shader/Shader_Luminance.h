//
//  Shader_Luminance.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Luminance_h
#define Shader_Luminance_h

NSString *const LuminanceFragmentShaderString = SHADER_STRING
(
    precision mediump float;
 
    uniform sampler2D uSampler;
 
    varying mediump vec2 vTexCoord;
 
    void main()
    {
        vec4 color = texture2D(uSampler, vTexCoord);
        float gray = dot(color.rgb, vec3(0.3, 0.59, 0.11));
        gl_FragColor = vec4(gray, gray, gray , color.a);
    }
);

#endif /* Shader_Luminance_h */
