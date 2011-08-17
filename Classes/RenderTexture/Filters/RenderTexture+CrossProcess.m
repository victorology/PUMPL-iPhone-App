//
//  RenderTexture+CrossProcess.m
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/12/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "RenderTexture+CrossProcess.h"
#import "RenderTexture+Curve.h"
#import "GLTexture.h"

static GLTexture* texColorMap;

@interface RenderTexture()
-(void) renderBegin;
-(void) renderEnd;
@end


@implementation RenderTexture (CrossProcess)

+(void) loadCrossProcessProgram 
{
    [RenderTexture loadCurveProgram];
    
    if(!texColorMap)
    {
        texColorMap = [[GLTexture alloc] initWithImage:[UIImage imageNamed:@"crossprocess_curve.png"]];
    }
}

-(void) drawCrossProcessInRect:(CGRect)rect
{
    [self drawInRect:rect withCurve:texColorMap];
}


-(void) applyCrossProcessFilter
{    
    [self renderBegin];
    [self drawCrossProcessInRect:CGRectMake(-1, 1, 2, -2)];
    [self renderEnd];
}

@end
