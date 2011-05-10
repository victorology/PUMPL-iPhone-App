//
//  Curve.m
//  CrossProcess
//
//  Created by Sergey Nikitenko on 3/28/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import "Curve.h"


@implementation Curve

-(id) initWithSampleNamed:(NSString*)fileName
{
    if(self=[super init])
    {
        NSString* filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        NSError* error = nil;
        NSString* sampleString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        if(error!=nil)
        {
            NSLog(@"[Curve initWithSampleNamed:%@] failed with error:%@", fileName, error);
            [self release];
            return nil;
        }
        
        NSArray* sampleArray = [sampleString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([sampleArray count]!=kSampleSize)
        {
            NSLog(@"[Curve initWithSampleNamed:%@] failed. Error: Invalid sample size (%d). Samples size must be equal to %d", fileName, [sampleArray count], kSampleSize);
            [self release];
            return nil;
        }
        
        NSLog(@"[Curve initWithSampleNamed:%@]", fileName);
        for(int i=0; i<kSampleSize; i++)
        {
            samples[i] = [[sampleArray objectAtIndex:i] floatValue];
        }
    }
    return self;
}

-(int)mapValue:(int)value
{
    return (kSampleSize-1)*samples[value];
}



@end
