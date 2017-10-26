//
//  Shader_Discretize.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Discretize_h
#define Shader_Discretize_h

NSString *const DiscretizeFragmentShaderString = @"precision mediump float;uniform sampler2D uSampler;varying mediump vec2 vTexCoord;float discretize(float f, float d){return floor(f * d + 0.5)/d;}vec4 discretize(vec4 v, float d){return vec4(discretize(v.x, d), discretize(v.y, d), discretize(v.z, d), discretize(v.w, d));}void main(){vec4 color = texture2D(uSampler, vTexCoord);gl_FragColor = discretize(color, 4.0);}";
//(
//    precision mediump float;
//
//    uniform sampler2D uSampler;
// 
//    varying mediump vec2 vTexCoord;
// 
//    float discretize(float f, float d)
//    {
//        return floor(f * d + 0.5)/d;
//    }
// 
//    vec4 discretize(vec4 v, float d)
//    {
//        return vec4(discretize(v.x, d), discretize(v.y, d), discretize(v.z, d), discretize(v.w, d));
//    }
// 
//    void main()
//    {
//        vec4 color = texture2D(uSampler, vTexCoord);
//        gl_FragColor = discretize(color, 4.0);
//    }
//);

#endif /* Shader_Discretize_h */
