//
//
//  IF
//
//  Created by sxy
//
//低级水效果

precision highp float;
varying vec2 v_texCoord;

uniform float runTime;


void main()
{
    
    vec2 sinVec2 =(sin(v_texCoord*vec2(100.0,80.0) + vec2(runTime*3.0)))*0.001;
   
    vec2 offsetCoord = v_texCoord+sinVec2;
    vec4 texColor =texture2D(CC_Texture0, offsetCoord);
    gl_FragColor =vec4(texColor.rgb,texColor.r+texColor.g);
    
    
    
}