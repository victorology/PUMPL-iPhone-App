//
//  RenderTexture+Filters.m
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/17/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "RenderTexture+Filters.h"

@implementation RenderTexture (Filters)

+(void) loadFilterPrograms 
{
    [RenderTexture loadBaseProgram];
    [RenderTexture loadVintageProgram];
    [RenderTexture loadMonochromeProgram];
    [RenderTexture loadRedscaleProgram];
    [RenderTexture loadPolaroidProgram];
    [RenderTexture loadPlasticEyeProgram];
    [RenderTexture loadPhotochromProgram];
    [RenderTexture loadCrossProcessProgram];
    [RenderTexture loadLomoProgram];
}


@end
