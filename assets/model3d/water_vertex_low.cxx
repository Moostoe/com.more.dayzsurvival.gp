//
//
//  IF
//
//  Created by sxy
//
//低级水
precision highp float;
attribute vec4 a_position;
attribute vec2 a_texCoord;

varying   vec2 v_texCoord;
 
varying   vec2 v_texCoordBump;

uniform float runTime;
void main()
{
    
    gl_Position = CC_MVPMatrix * a_position;
    v_texCoord =vec2( a_texCoord.x,1.0-a_texCoord.y);
    v_texCoordBump=a_position.xy*0.002+runTime*0.01;
    
}