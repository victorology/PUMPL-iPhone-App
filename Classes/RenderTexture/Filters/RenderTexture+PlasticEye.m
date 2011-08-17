//
//  RenderTexture+PlasticEye.m
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/10/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "RenderTexture+PlasticEye.h"
#import "RenderTexture+Curve3d+Vignette.h"
#import "GLTexture.h"

static GLTexture* texColorMap;

@interface RenderTexture()
-(void) renderBegin;
-(void) renderEnd;
@end

@implementation RenderTexture (Vintage)

+(void) loadPlasticEyeProgram 
{
    [RenderTexture loadCurve3dVignetteProgram];
    
    if(!texColorMap) 
    {
        texColorMap = [[GLTexture alloc] initWithImage:[UIImage imageNamed:@"plasticeye_colormap.png"]];
    }
}

-(void) drawPlasticEyeInRect:(CGRect)rect
{
    [self drawInRect:rect withCurve3d:texColorMap andVignetteRadius:0.5 andVignetteIntensity:5.0];
}

-(void) applyPlasticEyeFilter
{    
    [self renderBegin];
    [self drawPlasticEyeInRect:CGRectMake(-1, 1, 2, -2)];
    [self renderEnd];
}

@end
