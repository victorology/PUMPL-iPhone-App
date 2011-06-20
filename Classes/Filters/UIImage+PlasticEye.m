//
//  UIImage+PlasticEye.m
//  ImageFilters
//
//  Created by Sergey Nikitenko on 6/19/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "UIImage+PlasticEye.h"
#import "Curve3d.h"

#define kVignetteRadius 0.1
#define kVignetteIntensity 8.5

@implementation UIImage (PlasticEye)


static Curve3d* curve = nil;
+(void) loadPlasticEyeCurves
{
    if(!curve)
    {
        NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PlasticEye.c3d"];
        NSData* curveData = [NSData dataWithContentsOfFile:path];
        curve = [[Curve3d alloc] initWithData:curveData];
    }
}

-(void) applyPlasticEyeFilterToPixelsData:(void*)data ofImageSize:(CGSize)size
{
    [[self class] loadPlasticEyeCurves];
    
    unsigned char* ptr = (unsigned char*) data;
    
    CGFloat w2 = size.width*size.width/4;
    CGFloat h2 = size.height*size.height/4;
    CGFloat w4 = w2*w2;
    CGFloat h4 = h2*h2;
    
    for(int i=0; i<size.height; i++)
    {
        for(int j=0; j<size.width; j++)
        {

            [curve mapPixel:ptr];
            
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
            
            ptr+=4;
        }
    }

}

-(UIImage*) imageByApplyingPlasticEyeFilter
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
    [self applyPlasticEyeFilterToPixelsData:data ofImageSize:CGSizeMake(width, height)];
    
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.5 green:1.0 blue:0.0 alpha:0.08].CGColor);
	CGContextAddRect(context, CGRectMake(0, 0, width, height));
	CGContextFillPath(context);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
	UIGraphicsPopContext();
	CGContextRelease(context);
	free(data);
    
    UIImage* img = [UIImage imageWithCGImage:cgImage];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"result.png"];
    NSData* imgData = UIImagePNGRepresentation(img);
    [imgData writeToFile:path atomically:YES];
    
    return img;
}



@end
