//
//  RenderTexture+Curve.m
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/17/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "RenderTexture+Curve.h"
#import "GLProgram.h"
#import "GLTexture.h"

static GLProgram* program;

@implementation RenderTexture (Curve)

+(void) loadCurveProgram
{
    if(!program)
    {
        program = [[GLProgram alloc] initWithVertexShaderFilename:@"CurveShader" fragmentShaderFilename:@"CurveShader"];
        [program addAttribute:@"position"];
        [program addAttribute:@"texCoord"];
        [program link];
    }
}

-(void) drawInRect:(CGRect)rect withCurve:(GLTexture*)curve3dTexture
{
    GLfloat w = rect.size.width;
    GLfloat h = rect.size.height;
    CGPoint pt = rect.origin;
	GLfloat vertices[] = {pt.x,	pt.y, 0, pt.x+w, pt.y, 0, pt.x, pt.y+h, 0, pt.x+w, pt.y+h, 0};
	GLfloat coordinates[] = { 0, texRender.maxT, texRender.maxS, texRender.maxT, 0, 0, texRender.maxS, 0};
    
    [program use];
    
    GLuint texColormapUniform = [program uniformIndex:@"texColormap"];
    GLuint texVintageUniform = [program uniformIndex:@"texVintage"];
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, curve3dTexture.textureName);
    glUniform1i(texColormapUniform, 1);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texOriginal.textureName);
    glUniform1i(texVintageUniform, 0);
        
    int positionAttrIntex = [program attributeIndex:@"position"];
    int texCoordAttrIndex = [program attributeIndex:@"texCoord"];
    
    glVertexAttribPointer(positionAttrIntex, 3, GL_FLOAT, 0, 0, vertices);
    glEnableVertexAttribArray(positionAttrIntex);
    glVertexAttribPointer(texCoordAttrIndex, 2, GL_FLOAT, 0, 0, coordinates);
    glEnableVertexAttribArray(texCoordAttrIndex);
    
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end

