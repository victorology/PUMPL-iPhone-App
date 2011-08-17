//
//  Shader.fsh
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 2/20/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#define kRedGain 0.20
#define kGreenGain 0.10
#define kBlueGain 0.80

varying lowp vec2 texCoordVarying;
uniform sampler2D texture;

void main()
{
    lowp vec4 clr = texture2D(texture, texCoordVarying);
    
    lowp float v = clr.r*kRedGain + clr.g*kGreenGain + clr.b*kBlueGain;
    if(v>1.0)
    {
        v = 1.0;
    }
    
    gl_FragColor = vec4(v,v,v,1.0);
}





