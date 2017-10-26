//
//  Shader_Bilateral.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_Bilateral_h
#define Shader_Bilateral_h

NSString *const BilateralVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
 
    const int GAUSSIAN_SAMPLES = 9;
 
    varying lowp vec3 v_Position;
    varying vec2 blurCoordinates[GAUSSIAN_SAMPLES];
 
    float texelWidthOffset = 1.0;
    float texelHeightOffset = 1.0;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        gl_Position = modelViewProjectionMatrix * position;
    
        // Calculate the positions for the blur
        int multiplier = 0;
        vec2 blurStep;
        vec2 singleStepOffset = vec2(texelWidthOffset, texelHeightOffset);
    
        for (int i = 0; i < GAUSSIAN_SAMPLES; i++)
        {
            multiplier = (i - ((GAUSSIAN_SAMPLES - 1) / 2));
            // Blur in x (horizontal)
            blurStep = float(multiplier) * singleStepOffset;
            blurCoordinates[i] = aTexCoord + blurStep;
        }
    }
);

NSString *const BilateralFragmentShaderString = SHADER_STRING
(
    precision mediump float;
 
    uniform sampler2D uSampler;
 
    const lowp int GAUSSIAN_SAMPLES = 9;
 
    varying vec2 blurCoordinates[GAUSSIAN_SAMPLES];
 
    float distanceNormalizationFactor = 8.0;
 
    void main()
    {
        lowp vec4 centralColor;
        lowp float gaussianWeightTotal;
        lowp vec4 sum;
        lowp vec4 sampleColor;
        lowp float distanceFromCentralColor;
        lowp float gaussianWeight;
    
        centralColor = texture2D(uSampler, blurCoordinates[4]);
        gaussianWeightTotal = 0.18;
        sum = centralColor * 0.18;
    
        sampleColor = texture2D(uSampler, blurCoordinates[0]);
        distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
        gaussianWeight = 0.05 * (1.0 - distanceFromCentralColor);
        gaussianWeightTotal += gaussianWeight;
        sum += sampleColor * gaussianWeight;
    
        sampleColor = texture2D(uSampler, blurCoordinates[1]);
        distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
        gaussianWeight = 0.09 * (1.0 - distanceFromCentralColor);
        gaussianWeightTotal += gaussianWeight;
        sum += sampleColor * gaussianWeight;
    
        sampleColor = texture2D(uSampler, blurCoordinates[2]);
        distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
        gaussianWeight = 0.12 * (1.0 - distanceFromCentralColor);
        gaussianWeightTotal += gaussianWeight;
        sum += sampleColor * gaussianWeight;
    
        sampleColor = texture2D(uSampler, blurCoordinates[3]);
        distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
        gaussianWeight = 0.15 * (1.0 - distanceFromCentralColor);
        gaussianWeightTotal += gaussianWeight;
        sum += sampleColor * gaussianWeight;
    
        sampleColor = texture2D(uSampler, blurCoordinates[5]);
        distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
        gaussianWeight = 0.15 * (1.0 - distanceFromCentralColor);
        gaussianWeightTotal += gaussianWeight;
        sum += sampleColor * gaussianWeight;
    
        sampleColor = texture2D(uSampler, blurCoordinates[6]);
        distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
        gaussianWeight = 0.12 * (1.0 - distanceFromCentralColor);
        gaussianWeightTotal += gaussianWeight;
        sum += sampleColor * gaussianWeight;
    
        sampleColor = texture2D(uSampler, blurCoordinates[7]);
        distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
        gaussianWeight = 0.09 * (1.0 - distanceFromCentralColor);
        gaussianWeightTotal += gaussianWeight;
        sum += sampleColor * gaussianWeight;
    
        sampleColor = texture2D(uSampler, blurCoordinates[8]);
        distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
        gaussianWeight = 0.05 * (1.0 - distanceFromCentralColor);
        gaussianWeightTotal += gaussianWeight;
        sum += sampleColor * gaussianWeight;
    
        gl_FragColor = sum / gaussianWeightTotal;
    }
);

#endif /* Shader_Bilateral_h */
