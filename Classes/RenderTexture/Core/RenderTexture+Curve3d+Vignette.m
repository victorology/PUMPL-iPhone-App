//
//  RenderTexture+Curve3d+Vignette.m
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/17/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "RenderTexture+Curve3d+Vignette.h"
#import "GLProgram.h"
#import "GLTexture.h"

static GLProgram* program;

@implementation RenderTexture (Curve3dVignette)

+(void) loadCurve3dVignetteProgram
{
    if(!program)
    {
        program = [[GLProgram alloc] initWithVertexShaderFilename:@"Curve3dVignetteShader" fragmentShaderFilename:@"Curve3dVignetteShader"];
        [program addAttribute:@"position"];
        [program addAttribute:@"texCoord"];
        [program addAttribute:@"imageCoord"];
        [program link];
    }
}

-(void) drawInRect:(CGRect)rect withCurve3d:(GLTexture*)curve3dTexture andVignetteRadius:(CGFloat)vignetteRadius andVignetteIntensity:(CGFloat)vignetteIntensity
{
    GLfloat w = rect.size.width;
    GLfloat h = rect.size.height;
    CGPoint pt = rect.origin;
	GLfloat vertices[] = {pt.x,	pt.y, 0, pt.x+w, pt.y, 0, pt.x, pt.y+h, 0, pt.x+w, pt.y+h, 0};
	GLfloat coordinates[] = { 0, texRender.maxT, texRender.maxS, texRender.maxT, 0, 0, texRender.maxS, 0};
    GLfloat imageCoord[] = {-1,-1,1,-1,-1,1,1,1};
    
    [program use];
    
    GLuint texColormapUniform = [program uniformIndex:@"texColormap"];
    GLuint texVintageUniform = [program uniformIndex:@"texVintage"];
    GLuint vignetteRadiusUniform = [program uniformIndex:@"vignetteRadius"];
    GLuint vignetteIntensityUniform = [program uniformIndex:@"vignetteIntensity"];
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, curve3dTexture.textureName);
    glUniform1i(texColormapUniform, 1);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texOriginal.textureName);
    glUniform1i(texVintageUniform, 0);
    
    GLfloat r4 = vignetteRadius*vignetteRadius*vignetteRadius*vignetteRadius;
    glUniform1f(vignetteRadiusUniform, r4);
    glUniform1f(vignetteIntensityUniform, vignetteIntensity);
    
    int positionAttrIntex = [program attributeIndex:@"position"];
    int texCoordAttrIndex = [program attributeIndex:@"texCoord"];
    int imageCoordAttrIndex = [program attributeIndex:@"imageCoord"];
    
    glVertexAttribPointer(positionAttrIntex, 3, GL_FLOAT, 0, 0, vertices);
    glEnableVertexAttribArray(positionAttrIntex);
    glVertexAttribPointer(texCoordAttrIndex, 2, GL_FLOAT, 0, 0, coordinates);
    glEnableVertexAttribArray(texCoordAttrIndex);
    glVertexAttribPointer(imageCoordAttrIndex, 2, GL_FLOAT, 0, 0, imageCoord);
    glEnableVertexAttribArray(imageCoordAttrIndex);
    
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

@end

