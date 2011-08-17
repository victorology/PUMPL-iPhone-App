//
//  Shader.fsh
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 2/20/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

varying lowp vec2 varTexCoord;
uniform sampler2D tex;

void main()
{
    gl_FragColor = texture2D(tex, varTexCoord);
}








