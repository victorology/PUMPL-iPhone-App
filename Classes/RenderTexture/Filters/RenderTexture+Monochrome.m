//
//  RenderTexture+Monochrome.m
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/9/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "RenderTexture+Monochrome.h"
#import "GLProgram.h"

static GLProgram* program;

@interface RenderTexture()
+(GLProgram*) loadStandardProgram:(NSString*)programName;
-(void) drawInRect:(CGRect)rect usingStandardProgram:(GLProgram*)standardProgram;
-(void) renderBegin;
-(void) renderEnd;
@end


@implementation RenderTexture (Monochrome)

+(void) loadMonochromeProgram 
{
    if(!program)
    {
        program = [[self loadStandardProgram:@"MonochromeShader"] retain];
    }
}

-(void) drawMonochromeInRect:(CGRect)rect
{
    [self drawInRect:rect usingStandardProgram:program];
}

-(void) applyMonochromeFilter
{    
    [self renderBegin];
    [self drawMonochromeInRect:CGRectMake(-1, 1, 2, -2)];
    [self renderEnd];
}

@end
