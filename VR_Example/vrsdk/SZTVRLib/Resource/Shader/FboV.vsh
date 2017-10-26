precision highp float;

attribute vec4 position;
attribute vec2 aTexCoord;

float FXAA_SUBPIX_SHIFT = 1.0/8.0;
float rt_w = 1920.0; // GeeXLab built-in
float rt_h = 1080.0; // GeeXLab built-in

varying vec2 vTexCoord;
varying vec4 vPosition;

uniform mat4 modelViewProjectionMatrix;

void main()
{
    gl_Position = modelViewProjectionMatrix * position;
    vTexCoord = aTexCoord;
    
    vec2 rcpFrame = vec2(1.0/rt_w, 1.0/rt_h);
    vPosition.xy = aTexCoord.xy;
    vPosition.zw = aTexCoord.xy - (rcpFrame * (0.5 + FXAA_SUBPIX_SHIFT));
}
