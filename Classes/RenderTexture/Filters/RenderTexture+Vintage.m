//
//  RenderTexture+Vintage.m
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/9/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "RenderTexture+Vintage.h"
#import "RenderTexture+Curve3d+Vignette.h"
#import "GLTexture.h"

static GLTexture* texColorMap;

@interface RenderTexture()
-(void) renderBegin;
-(void) renderEnd;
@end

@implementation RenderTexture (Vintage)

+(void) loadVintageProgram 
{
    [RenderTexture loadCurve3dVignetteProgram];
    
    if(!texColorMap) 
    {
        texColorMap = [[GLTexture alloc] initWithImage:[UIImage imageNamed:@"vintage_colormap.png"]];
    }
}

-(void) drawVintageInRect:(CGRect)rect
{
    [self drawInRect:rect withCurve3d:texColorMap andVignetteRadius:0.7 andVignetteIntensity:2.0];
}

-(void) applyVintageFilter
{    
    [self renderBegin];
    [self drawVintageInRect:CGRectMake(-1, 1, 2, -2)];
    [self renderEnd];
}

@end
