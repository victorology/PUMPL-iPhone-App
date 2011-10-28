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


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    // This is to change the background of navigation Bar for the iOS 5.0 and above
    if([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBack.png"] forBarMetrics:UIBarMetricsDefault];
    }
}




@end


@implementation UINavigationBar (CustomBack)

- (void)drawRect:(CGRect)rect {

    
    // This is to change the background of navigation Bar for below iOS 5.0
    // In iOS 5.0 and above, this method doesnt gets called.
    
    static UIImage* backImage = nil;
    if(!backImage)
    {
        backImage = [[UIImage imageNamed:@"NavBack.png"] retain];
    }
    
    [backImage drawInRect:self.bounds];
}

@end

