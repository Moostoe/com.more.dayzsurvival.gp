//
//
//  IF
//
//  Created by sxy
//
precision highp float;

attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec2 a_texCoord1;//direct


varying   vec2 v_texCoord;
varying   vec2 v_texCoordBump;
varying   vec2 v_texCoordWav;
varying   vec2 v_texCoordRef;
 varying   vec2 v_texCoord1;
uniform float runTime;

void main()
{

    gl_Position = CC_MVPMatrix * a_position;

    v_texCoord =a_texCoord;

    v_texCoordRef = a_texCoord1*0.2+runTime*0.005;
    v_texCoordWav =a_texCoord1+runTime*0.01;
    v_texCoordBump= a_texCoord1-runTime*0.03;
    v_texCoord1 =a_texCoord1;
    //v_texCoordRef = (CC_MVMatrix * a_position).xy*0.004-runTime*0.005;


}
