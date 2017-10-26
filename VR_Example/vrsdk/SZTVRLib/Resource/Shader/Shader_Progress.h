//
//  Shader_Progress.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Progress_h
#define Shader_Progress_h

NSString *const ProgressVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
 
    uniform mat4 modelMatrix;
    uniform mat4 modelViewProjectionMatrix;
 
    uniform float uLpos;
    uniform float uisDirX;
    uniform float uStartPosition;
    uniform vec4 cuttingRect;
 
    varying float vStartPosition;
    varying vec2 vTexCoord;
    varying vec4 vPosition;
    varying float lpos;
    varying float visDirX;
 
    varying vec4 vDs;
    varying vec4 vCuttingRect;
 
    void main()
    {
        vStartPosition = uStartPosition;
        visDirX = uisDirX;
        lpos = uLpos;
        vTexCoord.xy = (aTexCoord).xy;
    
        gl_Position = modelViewProjectionMatrix * position;
    
        vPosition = position;
        vDs = modelMatrix * vec4(position.xyz, 1.0);
    
        vCuttingRect = cuttingRect;
    }
);

NSString *const ProgressFragmentShaderString = SHADER_STRING
(
    precision mediump float;
 
    uniform sampler2D uSampler;
    varying mediump vec2 vTexCoord;
 
    varying float vStartPosition;
    varying vec4 vPosition;
    varying float lpos;
    varying float visDirX;
 
    varying vec4 vDs;
    varying vec4 vCuttingRect;
 
    void main()
    {
        float rdq = lpos - 0.3;
        float value;
        vec4 color;
        vec4 tcolor;
        tcolor = texture2D(uSampler, vTexCoord);
    
        if (visDirX <= 1.0) {
            value = vPosition.x;
        }else{
            value = vPosition.y;
        }
    
        if(vDs.y >= vCuttingRect[2] && vDs.y <= vCuttingRect[3] && vDs.x >= vCuttingRect[0] && vDs.x <= vCuttingRect[1]){
            if(value <= lpos){
                if(value >= rdq){
//                    color = vec4(1.0,0.0,0.0,0.5);
//                    color = vec4(34.0/255.0,79.0/255.0,1.0,1.0);
                    color = vec4(0.0,0.0,1.0,1.0);
                }else{
                    float disO = distance(vStartPosition, lpos);
                    float disC = distance(vStartPosition, value);
                    float ratio = disC / disO;
                    if(ratio < 0.3){
                        ratio = 0.25;
                    }
//                    color = vec4(0.6,0.0,0.0,0.5) * ratio;
                    color = vec4(0.0,0.0,1.0,1.0) * ratio;
                }
            
                gl_FragColor = tcolor * 0.8 + color;
            }else{
                gl_FragColor = tcolor;
            }
        }else{
            discard;
        }
    }
);

#endif /* Shader_Progress_h */
