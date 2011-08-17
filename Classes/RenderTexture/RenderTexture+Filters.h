//
//  RenderTexture+Filters.h
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/17/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "RenderTexture.h"
#import "RenderTexture+Vintage.h"
#import "RenderTexture+Monochrome.h"
#import "RenderTexture+Redscale.h"
#import "RenderTexture+Polaroid.h"
#import "RenderTexture+PlasticEye.h"
#import "RenderTexture+Photochrom.h"
#import "RenderTexture+CrossProcess.h"
#import "RenderTexture+Lomo.h"


@interface RenderTexture (Filters)

+(void) loadFilterPrograms;

@end
