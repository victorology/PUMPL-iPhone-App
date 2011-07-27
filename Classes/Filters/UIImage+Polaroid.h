//
//  UIImage+Polaroid.h
//  ImageFilters
//
//  Created by Sergey Nikitenko on 6/16/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Polaroid)

+(void) loadPolaroidCurves;
-(UIImage*) imageByApplyingPolaroidFilter;

@end
