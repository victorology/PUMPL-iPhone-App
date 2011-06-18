//
//  UIImage+Photochrom.m
//  ImageFilters
//
//  Created by Sergey Nikitenko on 4/17/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "UIImage+Photochrom.h"
#import "HSV.h"
#import "Curve3d.h"

@implementation UIImage (Photochrom)

static Curve3d* curve = nil;
+(void) loadPhotochromCurves
{
    if(!curve)
    {
        NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"photochrom.c3d"];
        NSData* curveData = [NSData dataWithContentsOfFile:path];
        curve = [[Curve3d alloc] initWithData:curveData];
        
        //curve = [[Curve3d alloc] initWithColormapImage:[UIImage imageNamed:@"colormap+photochrom.png"]];
    }
}

-(void) applyPhotochromFilterToPixelsData:(void*)data ofImageSize:(CGSize)size
{
    [[self class] loadPhotochromCurves];
    
    int pixelCount = size.width*size.height;
    unsigned char* ptr = (unsigned char*) data;
    
    for(int i=0; i<pixelCount; i++, ptr+=4)
    {
        // sepia
        [curve mapPixel:ptr];
  
        
        // contrast
        static const float k = 0.9;
        for(int ch=0; ch<3; ch++)
        {
            int v = ptr[ch]*k - (k-1.0)*255.0/2;
            if(v < 0)
            {
                ptr[ch] = 0;
            }
            else if (v > 255)
            {
                ptr[ch] = 255;
            }
            else
            {
                ptr[ch] = v;
            }
        }
                
    }
}

-(UIImage*) imageByApplyingPhotochromFilter
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	void* data = calloc(height*width, 4);
	CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width*4, colorSpace, kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);
    
	CGContextTranslateCTM(context, width/2, height/2);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	CGContextTranslateCTM(context, -width/2, -height/2);
	
	UIGraphicsPushContext(context);
    
 	[self drawInRect:CGRectMake(0, 0, width, height)];
    [self applyPhotochromFilterToPixelsData:data ofImageSize:CGSizeMake(width, height)];

    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {   1.0, 0.5, 0.0, 0.01,  // Start color
        1.0, 0.5, 0.0, 0.29 }; // End color    
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorSpace, components, locations, 2);    
    CGContextDrawLinearGradient (context, gradient, CGPointMake(0, 0), CGPointMake(0, height), 0);
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
	
	UIGraphicsPopContext();
	CGContextRelease(context);
	free(data);
    
    UIImage* img = [UIImage imageWithCGImage:cgImage];
	return img;
}


@end
