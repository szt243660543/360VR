//
//  Shader_GlassSphere.h
//  SZTVR_SDK
//
//  Created by szt on 2017/2/21.
//  Copyright © 2017年 szt. All rights reserved.
//

#ifndef Shader_GlassSphere_h
#define Shader_GlassSphere_h

NSString *const GlassSphereVertexShaderString = SHADER_STRING
(
    attribute vec4 position;
    attribute vec2 aTexCoord;
    uniform float radius;
    uniform float aspectRatio;
    uniform float refractiveIndex;
 
    varying lowp vec2 vTexCoord;
    varying lowp vec3 v_Position;
 
    varying float v_radius;
    varying float v_aspectRatio;
    varying float v_refractiveIndex;
 
    uniform mat4 modelViewProjectionMatrix;
 
    void main()
    {
        vTexCoord = aTexCoord;
        v_radius = radius;
        v_aspectRatio = aspectRatio;
        v_refractiveIndex = refractiveIndex;
    
        gl_Position = modelViewProjectionMatrix * position;
    }
);

NSString *const GlassSphereFragmentShaderString = @"precision mediump float;uniform sampler2D uSampler;varying mediump vec2 vTexCoord;vec2 center = vec2(0.5, 0.5);varying float v_radius;varying float v_aspectRatio;varying float v_refractiveIndex;const vec3 lightPosition = vec3(-0.5, 0.5, 1.0);const vec3 ambientLightPosition = vec3(0.0, 0.0, 1.0);void main(){vec2 textureCoordinateToUse = vec2(vTexCoord.x, (vTexCoord.y * v_aspectRatio + 0.5 - 0.5 * v_aspectRatio));float distanceFromCenter = distance(center, textureCoordinateToUse);float checkForPresenceWithinSphere = step(distanceFromCenter, v_radius);distanceFromCenter = distanceFromCenter / v_radius;float normalizedDepth = v_radius * sqrt(1.0 - distanceFromCenter * distanceFromCenter);vec3 sphereNormal = normalize(vec3(textureCoordinateToUse - center, normalizedDepth));vec3 refractedVector = 2.0 * refract(vec3(0.0, 0.0, -1.0), sphereNormal, v_refractiveIndex);refractedVector.xy = -refractedVector.xy;vec3 finalSphereColor = texture2D(uSampler, (refractedVector.xy + 1.0) * 0.5).rgb;float lightingIntensity = 2.5 * (1.0 - pow(clamp(dot(ambientLightPosition, sphereNormal), 0.0, 1.0), 0.25));finalSphereColor += lightingIntensity;lightingIntensity  = clamp(dot(normalize(lightPosition), sphereNormal), 0.0, 1.0);lightingIntensity  = pow(lightingIntensity, 15.0);finalSphereColor += vec3(0.8, 0.8, 0.8) * lightingIntensity;gl_FragColor = vec4(finalSphereColor, 1.0) * checkForPresenceWithinSphere;}";
//(
//    precision mediump float;
//
//    uniform sampler2D uSampler;
//
//    varying mediump vec2 vTexCoord;
// 
//    vec2 center = vec2(0.5, 0.5);
//    varying float v_radius;
//    varying float v_aspectRatio;
//    varying float v_refractiveIndex;
// 
//    const vec3 lightPosition = vec3(-0.5, 0.5, 1.0);
//    const vec3 ambientLightPosition = vec3(0.0, 0.0, 1.0);
// 
//    void main()
//    {
//        vec2 textureCoordinateToUse = vec2(vTexCoord.x, (vTexCoord.y * v_aspectRatio + 0.5 - 0.5 * v_aspectRatio));
//        float distanceFromCenter = distance(center, textureCoordinateToUse);
//        float checkForPresenceWithinSphere = step(distanceFromCenter, v_radius);
//    
//        distanceFromCenter = distanceFromCenter / v_radius;
//    
//        float normalizedDepth = v_radius * sqrt(1.0 - distanceFromCenter * distanceFromCenter);
//        vec3 sphereNormal = normalize(vec3(textureCoordinateToUse - center, normalizedDepth));
//    
//        vec3 refractedVector = 2.0 * refract(vec3(0.0, 0.0, -1.0), sphereNormal, v_refractiveIndex);
//        refractedVector.xy = -refractedVector.xy;
//    
//        vec3 finalSphereColor = texture2D(uSampler, (refractedVector.xy + 1.0) * 0.5).rgb;
//    
//        // Grazing angle lighting
//        float lightingIntensity = 2.5 * (1.0 - pow(clamp(dot(ambientLightPosition, sphereNormal), 0.0, 1.0), 0.25));
//        finalSphereColor += lightingIntensity;
//    
//        // Specular lighting
//        lightingIntensity  = clamp(dot(normalize(lightPosition), sphereNormal), 0.0, 1.0);
//        lightingIntensity  = pow(lightingIntensity, 15.0);
//        finalSphereColor += vec3(0.8, 0.8, 0.8) * lightingIntensity;
//    
//        gl_FragColor = vec4(finalSphereColor, 1.0) * checkForPresenceWithinSphere;
//    }
//);

#endif /* Shader_GlassSphere_h */
