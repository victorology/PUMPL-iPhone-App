//
//  RenderTexture+Curve3d+Vignette.h
//  GLSLFilters
//
//  Created by Sergey Nikitenko on 8/17/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RenderTexture.h"

@interface RenderTexture (Curve3d_Vignette)

+(void) loadCurve3dVignetteProgram;
-(void) drawInRect:(CGRect)rect withCurve3d:(GLTexture*)curve3dTexture andVignetteRadius:(CGFloat)vignetteRadius andVignetteIntensity:(CGFloat)vignetteIntensity;

@end
