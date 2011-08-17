//
//  RenderTexture+Lomo.m
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/12/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "RenderTexture+Lomo.h"
#import "RenderTexture+Curve3d+Vignette.h"
#import "GLTexture.h"

static GLTexture* texColorMap;

@interface RenderTexture()
-(void) renderBegin;
-(void) renderEnd;
@end

@implementation RenderTexture (Vintage)

+(void) loadLomoProgram 
{
    [RenderTexture loadCurve3dVignetteProgram];
    
    if(!texColorMap) 
    {
        texColorMap = [[GLTexture alloc] initWithImage:[UIImage imageNamed:@"lomo_colormap.png"]];
    }
}

-(void) drawLomoInRect:(CGRect)rect
{
    [self drawInRect:rect withCurve3d:texColorMap andVignetteRadius:0.5 andVignetteIntensity:1.0];
}

-(void) applyLomoFilter
{    
    [self renderBegin];
    [self drawLomoInRect:CGRectMake(-1, 1, 2, -2)];
    [self renderEnd];
}

@end
