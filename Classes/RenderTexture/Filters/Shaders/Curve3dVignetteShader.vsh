//
//  Shader.vsh
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 2/20/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

attribute vec4 position;
attribute vec2 texCoord;
attribute vec2 imageCoord;

varying vec4 positionVarying;
varying vec2 texCoordVarying;
varying vec2 imageCoordVarying;

void main()
{
    positionVarying = position;
    texCoordVarying = texCoord;
    imageCoordVarying = imageCoord;
    gl_Position = position;
}
