//
//  ViewController.m
//  LearnOpenGLESWithGPUImage
//
//  Created by loyinglin on 16/5/10.
//  Copyright © 2016年 loyinglin. All rights reserved.
//
precision mediump float;

uniform sampler2D uSampler;
varying vec2 texCoordVarying;

void main()
{
    gl_FragColor = texture2D(uSampler, texCoordVarying);
}
