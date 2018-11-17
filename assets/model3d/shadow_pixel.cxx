//
//
//  IF
//
//  Created by sxy
//
//龙影子

precision highp float;
varying vec2 v_texCoord;
 

void main()
{
    vec4 color = vec4(0);
    float count = 0.0;
    vec4 col = vec4(0);
    float r = 3.0;
    float dt = 1.5;
    float sigma2 = 2.0 * dt * dt;
    float sigmap = sigma2 * 3.1415926535;
    for(float x = -r; x <= r; x++)
    {
        for(float y = -r; y <= r; y++)
        {
            float weight = exp(-1.0 * (x*x + y*y)/sigma2)/sigmap;
            col += texture2D(CC_Texture0, v_texCoord + vec2(x / 128.0, y / 128.0)) * weight;
            count += weight;
        }
    }
    color = col / count;
    
    gl_FragColor =  color;
    
    
}
