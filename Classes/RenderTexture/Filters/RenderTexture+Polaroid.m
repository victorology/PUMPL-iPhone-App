//
//  RenderTexture+Polaroid.m
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/10/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "RenderTexture+Polaroid.h"
#import "RenderTexture+Curve.h"
#import "GLTexture.h"

static GLTexture* texColorMap;

@interface RenderTexture()
-(void) renderBegin;
-(void) renderEnd;
@end


@implementation RenderTexture (Polaroid)

+(void) loadPolaroidProgram 
{
    [RenderTexture loadCurveProgram];
    
    if(!texColorMap)
    {
        texColorMap = [[GLTexture alloc] initWithImage:[UIImage imageNamed:@"polaroid_curve.png"]];
    }
}

-(void) drawPolaroidInRect:(CGRect)rect
{
    [self drawInRect:rect withCurve:texColorMap];
}

-(void) applyPolaroidFilter
{    
    [self renderBegin];
    [self drawPolaroidInRect:CGRectMake(-1, 1, 2, -2)];
    [self renderEnd];
}

@end
