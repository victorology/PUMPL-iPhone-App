//
//  PMTabBarController.m
//  PUMPL
//
//  Created by Sergey Nikitenko on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PMTabBarController.h"


@implementation PMTabBarController

@end


@implementation UITabBarController (extentions) 

+(UIBarButtonItem*) tabBarButtonWithImage:(UIImage*)buttonImage target:(id)target action:(SEL)action
{
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:buttonImage forState:UIControlStateNormal];
    UIBarButtonItem* barButton = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    [button release];
    return  barButton;
}

@end