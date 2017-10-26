//
//  Shader_Fbo.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Fbo_h
#define Shader_Fbo_h

NSString *const FboVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
 
    uniform mat4 modelViewMatrix;
    uniform float barrelDistortion;
    uniform float blackEdgeValue;
 
    varying vec2 vTexCoord;
    varying float vbarrelDistortion;
    varying float vblackEdgeValue;
 
    void main()
    {
        vTexCoord = aTexCoord;
        vbarrelDistortion = barrelDistortion;
        vblackEdgeValue= blackEdgeValue;
        gl_Position = modelViewMatrix * position;
    }
);

NSString *const FboFragmentShaderString = SHADER_STRING
(
    precision mediump float;
    uniform sampler2D uSampler;
    varying vec2 vTexCoord;
    varying float vbarrelDistortion;
    varying float vblackEdgeValue;
 
    // 桶形畸变
    vec2 brownConradyDistortion(vec2 uv)
    {
        // 左右视窗缩小倍数设置
        float demoScale = 1.8 - vblackEdgeValue;
        uv *= demoScale;
    
        // positive values of K1 give barrel distortion, negative give pincushion（图像畸变程度设置）
        float barrelDistortion1 = -0.068; // 0.441 K1 in text books
        float barrelDistortion2 = 0.320000; // 0.156 K2 in text books
    
        float r2 = uv.x*uv.x + uv.y*uv.y;
        uv *= 1.0 + barrelDistortion1 * r2  + barrelDistortion2 * r2 * r2;
    
        return uv;
    }
 
    void main()
    {
        if (vbarrelDistortion <= 0.0) {
            gl_FragColor = texture2D(uSampler, vTexCoord);
        }else{
            // uv -> device-coordinate
            // 坐标范围（-1，+1）
            vec2 uv = vTexCoord;
            uv = uv * 2.0 - 1.0;
        
            // barrel distortion
            uv = brownConradyDistortion(uv);
        
            //  device-coordinate -> uv
            uv = 0.5 * (uv * 1.0 + 1.0);
        
            vec4 color;
            if(uv.x>1.0||uv.y>0.93||uv.x<0.0||uv.y<0.07){
                color = vec4(0.0,0.0,0.0,1.0); // 超出显示范围，设颜色为黑。
            }else{
                color = texture2D(uSampler, uv);
            }
        
            gl_FragColor = color;
        }
    }
);

#endif
