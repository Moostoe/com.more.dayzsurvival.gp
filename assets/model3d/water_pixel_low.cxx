//
//
//  IF
//
//  Created by sxy
//
//低级水效果

precision highp float;
varying vec2 v_texCoord;
 
varying vec2 v_texCoordBump;
 
uniform sampler2D bumpTex;
//uniform sampler2D shaderTex;

uniform float runTime;

vec3 LightColor(vec3 imageColor,vec3 normal  ,float blendF)
{
    
    float fullLight =pow(max (normal.r*2.5,0.0), 8.0) ;
    return   imageColor+vec3( fullLight*blendF);
}
void main()
{
   // vec4 shaderColor =texture2D(shaderTex, v_texCoord);
    
    
    vec2 sinValue =sin(v_texCoord*vec2(100.0,100.0) + vec2(runTime*4.0))*0.002;
    vec4 bumpColor =texture2D(bumpTex, v_texCoordBump+sinValue);
    vec3 bumpDir = (bumpColor.rgb-0.5)*2.0 ;
    
    
    vec2 bumpOffset=bumpDir.rg*0.008;
    vec2 offsetCoord = v_texCoord+bumpOffset;
    vec4 texColor =texture2D(CC_Texture0, offsetCoord);
    
    //vec3 lightLum =LightColor(texColor.rgb,bumpDir,1.0);
   // vec3 color =LightColor(texColor.rgb,normal,shaderColor.g);
    gl_FragColor =vec4(texColor.rgb,1.0);
    
    
    
}