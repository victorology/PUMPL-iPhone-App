//
//  UIImage+CrossProcess.m
//  CrossProcess
//
//  Created by Sergey Nikitenko on 3/28/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "UIImage+CrossProcess.h"
#import "Curve.h"

@implementation UIImage (CrossProcess)

static Curve* redCurve = nil;
static Curve* greenCurve = nil;
static Curve* blueCurve = nil;

+(void) loadCrossProcessCurves
{
    if(!redCurve)
    {
        redCurve = [[Curve alloc] initWithSampleNamed:@"cp_red_curve.txt"];
    }
    
    if(!greenCurve)
    {
        greenCurve = [[Curve alloc] initWithSampleNamed:@"cp_green_curve.txt"];
    }
    
    if(!blueCurve)
    {
        blueCurve = [[Curve alloc] initWithSampleNamed:@"cp_blue_curve.txt"];
    }
}

-(void) applyCrossProcessFilterToPixelsData:(void*)data pixelCount:(int)pixelCount
{
    [[self class] loadCrossProcessCurves];
    
    unsigned char* ptr = (unsigned char*) data;
    for(int i=0; i<pixelCount; i++)
    {
        ptr[0] = [redCurve mapValue:ptr[0]];
        ptr[1] = [greenCurve mapValue:ptr[1]];
        ptr[2] = [blueCurve mapValue:ptr[2]];
        ptr+=4;
    }
}


-(UIImage*) imageByApplyingCrossProcessFilter
{
    
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGRect imageRect = CGRectMake(0, 0, width, height);
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	void* data = calloc(height*width, 4);
	CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width*4, colorSpace, kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);

	CGContextTranslateCTM(context, width/2, height/2);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	CGContextTranslateCTM(context, -width/2, -height/2);
	
	UIGraphicsPushContext(context);
    
 	[self drawInRect:imageRect];
    [self applyCrossProcessFilterToPixelsData:data pixelCount:height*width];
    
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255.0 green:255.0 blue:0 alpha:0.01].CGColor);
	CGContextAddRect(context, imageRect);
	CGContextFillPath(context);
    
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	
	UIGraphicsPopContext();
	CGContextRelease(context);
	free(data);
    
	return [UIImage imageWithCGImage:cgImage];
}

@end
