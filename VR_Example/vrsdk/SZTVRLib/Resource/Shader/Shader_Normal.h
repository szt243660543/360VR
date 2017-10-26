//
//  Shader_Normal.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Normal_h
#define Shader_Normal_h

NSString *const NormalVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
 
    uniform vec4 cuttingRect;
    uniform mat4 modelMatrix;
    uniform mat4 modelViewMatrix;
    uniform mat4 modelViewProjectionMatrix;
 
    varying vec2 vTexCoord;
    varying vec4 vDs;
    varying vec4 vCuttingRect;

    void main()
    {
        vTexCoord = aTexCoord;
        gl_Position = modelViewProjectionMatrix * position;
    
        vDs = modelMatrix * vec4(position.xyz, 1.0);
    
        vCuttingRect = cuttingRect;
    }
);

NSString *const NormalFragmentShaderString = SHADER_STRING
(
    precision mediump float;
    uniform sampler2D uSampler;
    varying vec2 vTexCoord;
    varying vec4 vDs;
    varying vec4 vCuttingRect;
 
    void main()
    {
        if(vDs.y >= vCuttingRect[2] && vDs.y <= vCuttingRect[3] && vDs.x >= vCuttingRect[0] && vDs.x <= vCuttingRect[1]){
            vec4 pixel = texture2D(uSampler, vTexCoord);
            if (pixel.a <= 0.1) {
                discard;
            }else{
                gl_FragColor = pixel;
            }
        }else{
            discard;
        }
    }
);

//    //获取当前贴图的颜色
//    vec4 _texCol = texture2D( uSampler,  vTexCoord);
//    //获取附近贴图的颜色，偏移值为0.005,适当调节偏移值，获取合适的影响范围
//    vec4 _texCol1 = texture2D( uSampler,  vec2(vTexCoord.x+.01, vTexCoord.y));
//    vec4 _texCol2 = texture2D( uSampler,  vec2(vTexCoord.x-.01, vTexCoord.y));
//    vec4 _texCol3 = texture2D( uSampler,  vec2(vTexCoord.x, vTexCoord.y+.01));
//    vec4 _texCol4 = texture2D( uSampler,  vec2(vTexCoord.x, vTexCoord.y-.01));
//    vec4 _texCol5 = texture2D( uSampler,  vec2(vTexCoord.x+.01, vTexCoord.y+.01));
//    vec4 _texCol6 = texture2D( uSampler,  vec2(vTexCoord.x-.01, vTexCoord.y+.01));
//    vec4 _texCol7 = texture2D( uSampler,  vec2(vTexCoord.x-.01, vTexCoord.y+.01));
//    vec4 _texCol8 = texture2D( uSampler,  vec2(vTexCoord.x-.01, vTexCoord.y-.01));
//    //当前色的Alpha通道大于0 并且附近有小于0.01的Alpha的像素，我们认为他为边缘。
//    if (_texCol.a <= 0.1 && (_texCol1.a > .01 ||  _texCol2.a > .01 || _texCol3.a > .01 || _texCol4.a > .01 || _texCol5.a > .01 ||  _texCol6.a > .01 || _texCol7.a > .01 || _texCol8.a > .01))
//    {
//        //最终值
//        _texCol.rgba = vec4(0.1,1.0,1.0,1.0);
//    }
//    gl_FragColor = _texCol; //* v_vColour;

#endif /* Shader_Normal_h */
