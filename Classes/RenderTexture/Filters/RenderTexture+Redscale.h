//
//  RenderTexture+Redscale.h
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/10/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderTexture.h"

@interface RenderTexture (Redscale)

+(void) loadRedscaleProgram;
-(void) drawRedscaleInRect:(CGRect)rect;
-(void) applyRedscaleFilter;

@end
