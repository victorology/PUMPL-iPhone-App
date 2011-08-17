//
//  Shader.fsh
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 2/20/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

varying lowp vec2 texCoordVarying;

uniform sampler2D texImage;
uniform sampler2D texColormap;

highp float f(highp float x) 
{
    return 0.5/256.0 + (x/256.0)*255.0;
}

void main()
{
    highp vec4 clr = texture2D(texImage, texCoordVarying);
    
    highp vec2 rvp = vec2(0.25, f(clr.r));
    highp vec4 vr = texture2D(texColormap, rvp);
    
    highp vec2 gvp = vec2(0.25,  f(clr.g));
    highp vec4 vg = texture2D(texColormap, gvp);
    
    highp vec2 bvp = vec2(0.25,  f(clr.b));
    highp vec4 vb = texture2D(texColormap, bvp);
    
    gl_FragColor = vec4(vr.r, vg.g, vb.b, 1.0);
}





