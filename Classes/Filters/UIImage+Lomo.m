//
//  UIImage+Lomo.m
//  Lomo
//
//  Created by Sergey Nikitenko on 4/5/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "UIImage+Lomo.h"
#import "Curve.h"
#import "HSV.h"

#define kVignetteRadius 0.1
#define kVignetteIntensity 0.5


@implementation UIImage (Lomo)


static Curve* s_curve = nil;

+(void) loadLomoCurves
{
    if(!s_curve)
    {
        s_curve = [[Curve alloc] initWithSampleNamed:@"curve_s.txt"];
    }
}


-(void) applyLomoFilterToPixelsData:(void*)data ofImageSize:(CGSize)size
{
    [[self class] loadLomoCurves];
    
    //int pixelCount = size.width*size.height;
    unsigned char* ptr = (unsigned char*) data;

    
    CGFloat w2 = size.width*size.width/4;
    CGFloat h2 = size.height*size.height/4;
    CGFloat w4 = w2*w2;
    CGFloat h4 = h2*h2;
    
    
    for(int i=0; i<size.height; i++)
    {
        for(int j=0; j<size.width; j++)
        {
            
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
            
            
            for(int ch = 0; ch<3; ch++)
            {                
                ptr[ch] = [s_curve mapValue:ptr[ch]];
            }
            
            
            // desaturation
            RGB rgb;
            rgb.r = ptr[0]/255.0;
            rgb.g = ptr[1]/255.0;
            rgb.b = ptr[2]/255.0;
            
            HSV hsv;
            rgb_to_hsv(&rgb, &hsv);
            
            hsv.s *= 0.8;
            
            hsv_to_rgb(&hsv, &rgb);
            
            ptr[0] = 255.0*rgb.r;
            ptr[1] = 255.0*rgb.g;
            ptr[2] = 255.0*rgb.b;
            
            
            
            ptr+=4;
        }
    }
}


-(UIImage*) imageByApplyingLomoFilter
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
    [self applyLomoFilterToPixelsData:data ofImageSize:CGSizeMake(width, height)];
    
    
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	
	UIGraphicsPopContext();
	CGContextRelease(context);
	free(data);
    
	return [UIImage imageWithCGImage:cgImage];
}



@end
