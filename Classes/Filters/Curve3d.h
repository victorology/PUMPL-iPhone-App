//
//  Curve3d.h
//  ImageFilters
//
//  Created by Sergey Nikitenko on 4/19/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Curve3d : NSObject
{
    const unsigned char* colormapPtr;
}

-(id) initWithData:(NSData*)data;
-(void) mapPixel:(unsigned char*)p;

@end
