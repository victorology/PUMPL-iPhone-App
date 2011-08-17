//
//  RenderTexture+Vintage.h
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/9/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderTexture.h"

@interface RenderTexture (Vintage)

+(void) loadVintageProgram;
-(void) drawVintageInRect:(CGRect)rect;
-(void) applyVintageFilter;

@end
