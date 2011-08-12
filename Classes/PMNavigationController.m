//
//  PMNavigationController.m
//  PUMPL
//
//  Created by Sergey Nikitenko on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PMNavigationController.h"


@implementation PMNavigationController

-(id) initWithCoder:(NSCoder *)aDecoder 
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {

    }
    return self;
}

-(id) initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if(self)
    {

    }
    return self;
}


@end


@implementation UINavigationBar (CustomBack)

- (void)drawRect:(CGRect)rect {

    static UIImage* backImage = nil;
    if(!backImage)
    {
        backImage = [[UIImage imageNamed:@"NavBack.png"] retain];
    }
    
    [backImage drawInRect:self.bounds];
}

@end

