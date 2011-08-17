//
//  Shader.fsh
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 2/20/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

varying highp vec4 positionVarying;
varying lowp vec2 texCoordVarying;

uniform sampler2D texImage;
uniform sampler2D texColormap;

highp float f(highp float x) 
{
    return 0.5/256.0 + (x/256.0)*255.0;
}

#define k 0.9
#define a 0.35

highp float bl(highp float x, highp float s)
{
    x = x*k - (k-1.0)/2.0;
    highp float A = a*(0.5-positionVarying.y/2.0);
    x = x*(1.0-A) + s*A;

    if (x < 0.0)
    {
        return 0.0;
    }
    if (x > 1.0)
    {
        return 1.0;
    }
    return x;
}

void main()
{
    highp vec4 clr = texture2D(texImage, texCoordVarying);
    highp float l = (clr.r + clr.g + clr.b)/3.0;
    l = f(l);
    
    highp vec2 rvp = vec2(l, f(clr.r));
    highp vec4 vr = texture2D(texColormap, rvp);
    
    highp vec2 gvp = vec2(l,  f(clr.g));
    highp vec4 vg = texture2D(texColormap, gvp);
    
    highp vec2 bvp = vec2(l,  f(clr.b));
    highp vec4 vb = texture2D(texColormap, bvp);
    
    gl_FragColor = vec4(bl(vr.r, 1.0), bl(vg.g, 0.5), bl(vb.b, 0.0), 1.0);
}





