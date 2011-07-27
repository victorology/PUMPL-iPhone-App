//
//  PMNavigationController.m
//  PUMPL
//
//  Created by Sergey Nikitenko on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PMNavigationController.h"


@implementation PMNavigationController

-(void) initNavBar
{
    static UIImage* backImage = nil;
    if(!backImage)
    {
        backImage = [[UIImage imageNamed:@"NavBack.png"] retain];
    }
    
    UIImageView* backImageView = [[[UIImageView alloc] initWithImage:backImage] autorelease];
    [self.navigationBar addSubview:backImageView];
}

-(id) initWithCoder:(NSCoder *)aDecoder 
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initNavBar];
    }
    return self;
}

-(id) initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if(self)
    {
        [self initNavBar];
    }
    return self;
}


@end
