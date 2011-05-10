//
//  Curve.h
//  CrossProcess
//
//  Created by Sergey Nikitenko on 3/28/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSampleSize 256

@interface Curve : NSObject
{
    CGFloat samples[kSampleSize];
}

-(id) initWithSampleNamed:(NSString*)fileName;
-(int)mapValue:(int)colorValue;


@end
