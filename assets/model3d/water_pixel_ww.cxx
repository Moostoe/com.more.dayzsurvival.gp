
//
//
//  IF
//
//  Created by sxy
//


precision highp float;


varying vec2 v_texCoord;
varying vec2 v_texCoordBump;
varying vec2 v_texCoordRef;
varying   vec2 v_texCoordWav;
varying   vec2 v_texCoord1;

uniform sampler2D shaderTex;
uniform sampler2D bumpTex;
uniform sampler2D wavTex;
uniform sampler2D refTex;

uniform float runTime;
void main()
{


    vec4 shaderColor =texture2D(shaderTex, v_texCoord);

    vec2 sinValue =sin(v_texCoord1*vec2(10.0,10.0) + vec2(runTime*4.0))*0.005;
    vec4 bumpColor = texture2D(bumpTex, v_texCoordBump+sinValue);
    vec2 coordOff =bumpColor.gb-0.5;



    vec4 waveColor=texture2D(wavTex, v_texCoordWav+coordOff*0.08);
    vec4 texColor =texture2D(CC_Texture0, v_texCoord);
    vec4 skyColor =texture2D(refTex, v_texCoordRef+coordOff*0.1);




    vec3 water = skyColor.rgb+waveColor.rgb;
    vec3 tcolor = water*shaderColor.r+texColor.rgb*(1.0-shaderColor.r );

    gl_FragColor =vec4(tcolor,texColor.a);
    
}
