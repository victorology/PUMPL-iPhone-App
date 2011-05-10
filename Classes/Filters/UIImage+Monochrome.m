//
//  UIImage+Monochrome.m
//  ImageFilters
//
//  Created by Sergey Nikitenko on 4/11/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "UIImage+Monochrome.h"

#define kRedGain 0.20
#define kGreenGain 0.10
#define kBlueGain 0.80

@implementation UIImage (Monochrome)

-(void) applyMonochromeFilterToPixelsData:(void*)data ofImageSize:(CGSize)size
{
    int pixelCount = size.width*size.height;
    unsigned char* ptr = (unsigned char*) data;
    
    for(int i=0; i<pixelCount; i++)
    {
        CGFloat value = ptr[0]*kRedGain + ptr[1]*kGreenGain + ptr[2]* kBlueGain;
        if(value>255.0)
            value = 255;
        
        ptr[0] = value;
        ptr[1] = value;
        ptr[2] = value;
        
        ptr+=4;
    }
}


-(UIImage*) imageByApplyingMonochromeFilter
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
    [self applyMonochromeFilterToPixelsData:data ofImageSize:CGSizeMake(width, height)];
    
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	
	UIGraphicsPopContext();
	CGContextRelease(context);
	free(data);
    
	return [UIImage imageWithCGImage:cgImage];
}



@end
