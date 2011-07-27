//
//  Curve3d.m
//  ImageFilters
//
//  Created by Sergey Nikitenko on 4/19/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "Curve3d.h"

@interface Curve3d()
@property (nonatomic, retain) NSData* colormapData;

@end

@implementation Curve3d
@synthesize colormapData=_colormapData;

#define CLAMP(x,l,u) ((x)<(l)?(l):((x)>(u)?(u):(x)))
#define CLAMP0255(a)  CLAMP(a,0,255)

-(id) initWithData:(NSData*) data
{
    self = [super init];
    if(self)
    {
        self.colormapData = data;
    }
    return  self;
}

-(void) dealloc
{
    [_colormapData release];
    [super dealloc];
}

-(void) setColormapData:(NSData*)colormapData
{
    if(_colormapData!=colormapData)
    {
        [_colormapData release];
        _colormapData = [colormapData retain];
        colormapPtr = [_colormapData bytes];
    }
}


static unsigned char rgb_max (const unsigned char* ptr)
{
    if (ptr[0] > ptr[1])
        return (ptr[0] > ptr[2]) ? ptr[0] : ptr[2];
    else
        return (ptr[1] > ptr[2]) ? ptr[1] : ptr[2];
}

static unsigned char rgb_min (const unsigned char* ptr)
{
    if (ptr[0] < ptr[1])
        return (ptr[0] < ptr[2]) ? ptr[0] : ptr[2];
    else
        return (ptr[1] < ptr[2]) ? ptr[1] : ptr[2];
}

-(void) mapPixel:(unsigned char*)p
{
    unsigned char min = rgb_min(p);
    unsigned char max = rgb_max(p);
    int l4 = ((min+max)/2)*4;
    
    p[0] = colormapPtr[p[0]*256*4 + l4];
    p[1] = colormapPtr[256*256*4 + p[1]*256*4 + l4 +1];
    p[2] = colormapPtr[256*256*4 + 256*256*4 + p[2]*256*4 + l4 +2];
}        
 

@end
