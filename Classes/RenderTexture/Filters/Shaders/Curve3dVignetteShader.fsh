//
//  Shader.fsh
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 2/20/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

varying lowp vec4 positionVarying;
varying lowp vec2 texCoordVarying;
varying lowp vec2 imageCoordVarying;

uniform sampler2D texImage;
uniform sampler2D texColormap;
uniform lowp float vignetteRadius;
uniform lowp float vignetteIntensity;

highp float f(highp float x) 
{
    return 0.5/256.0 + (x/256.0)*255.0;
}

void main()
{
    highp vec4 clr = texture2D(texImage, texCoordVarying);
    
    highp float l = (clr.r + clr.g + clr.b )/3.0;
    l = f(l);
    
    highp vec2 rvp = vec2(l, f(clr.r));
    highp vec4 vr = texture2D(texColormap, rvp);
    
    highp vec2 gvp = vec2(l,  f(clr.g));
    highp vec4 vg = texture2D(texColormap, gvp);
    
    highp vec2 bvp = vec2(l,  f(clr.b));
    highp vec4 vb = texture2D(texColormap, bvp);
    
    clr = vec4(vr.r, vg.g, vb.b, 1.0);
    
    highp vec2 p2 = imageCoordVarying*imageCoordVarying;
    highp vec2 p4 = p2*p2;
    highp float r = p4.x+p4.y;
    
    if(r > vignetteRadius)
    {
        highp float gamma = 1.0 + vignetteIntensity*(r-vignetteRadius);
        clr.r =  pow ( clr.r, gamma);
        clr.g =  pow ( clr.g, gamma);
        clr.b =  pow ( clr.b, gamma);
        
        //clr = vec4(0.0, 0.0, 0.0, 1.0);
    }
        
    gl_FragColor = clr;
}







