//
//  UIImage+Redscale.m
//  ImageFilters
//
//  Created by Sergey Nikitenko on 6/12/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "UIImage+Redscale.h"
#import "Curve3d.h"


@implementation UIImage (Redscale)


static Curve3d* curve = nil;
+(void) loadRedscaleCurves
{
    if(!curve)
    {
        NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"redscale.c3d"];
        NSData* curveData = [NSData dataWithContentsOfFile:path];
        curve = [[Curve3d alloc] initWithData:curveData];
    }
}

-(void) applyRedscaleFilterToPixelsData:(void*)data ofImageSize:(CGSize)size
{
    [[self class] loadRedscaleCurves];
    
    int pixelCount = size.width*size.height;
    unsigned char* ptr = (unsigned char*) data;
    
    for(int i=0; i<pixelCount; i++, ptr+=4)
    {
        [curve mapPixel:ptr];
    }
}

-(UIImage*) imageByApplyingRedscaleFilter
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
    [self applyRedscaleFilterToPixelsData:data ofImageSize:CGSizeMake(width, height)];
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
	UIGraphicsPopContext();
	CGContextRelease(context);
	free(data);
    
    UIImage* img = [UIImage imageWithCGImage:cgImage];
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString* path = [documentsDirectory stringByAppendingPathComponent:@"result.png"];
    //NSData* imgData = UIImagePNGRepresentation(img);
    //[imgData writeToFile:path atomically:YES];
	return img;
}


@end
