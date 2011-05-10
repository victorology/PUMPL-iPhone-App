//
//  UIImage+Vintage.m
//  Vintage
//
//  Created by Sergey Nikitenko on 4/10/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "UIImage+Vintage.h"
#import "Curve.h"
#import "HSV.h"
#import "Curve3d.h"

#define kVignetteRadius 0.3
#define kVignetteIntensity 0.7

@implementation UIImage (Vintage)

static Curve3d* curve3d = nil;

+(void) loadVintageCurves
{
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"vintage.c3d"];
    NSData* curveData = [NSData dataWithContentsOfFile:path];
    curve3d = [[Curve3d alloc] initWithData:curveData];
}


-(void) applyVintageFilterToPixelsData:(void*)data ofImageSize:(CGSize)size
{
    [[self class] loadVintageCurves];
    
    unsigned char* ptr = (unsigned char*) data;
    
    CGFloat w2 = size.width*size.width/4;
    CGFloat h2 = size.height*size.height/4;
    CGFloat w4 = w2*w2;
    CGFloat h4 = h2*h2;
    
    
    for(int i=0; i<size.height; i++)
    {
        for(int j=0; j<size.width; j++, ptr+=4)
        {
            
            [curve3d mapPixel:ptr];
            
            
            // Vignette 
            CGFloat x = j - size.width/2;
            CGFloat y = i - size.height/2;
            CGFloat x2 = x*x;
            CGFloat y2 = y*y;
            
            CGFloat r = x2*x2/w4 + y2*y2/h4;
            if(r > kVignetteRadius)
            {
                float gamma = 1.0 + kVignetteIntensity*(r - kVignetteRadius);
                for(int ch = 0; ch<3; ch++)
                {                
                    ptr[ch] =  255.0 * pow ( ptr[ch]/255.0, gamma);
                }
            }
             
        }
    }
}


-(UIImage*) imageByApplyingVintageFilter
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
    [self applyVintageFilterToPixelsData:data ofImageSize:CGSizeMake(width, height)];
    
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:0.02].CGColor);
	CGContextAddRect(context, imageRect);
	CGContextFillPath(context);
    
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	
	UIGraphicsPopContext();
	CGContextRelease(context);
	free(data);
    
    UIImage* img = [UIImage imageWithCGImage:cgImage];
	return img;
}



@end
