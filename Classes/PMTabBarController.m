//
//  PMTabBarController.m
//  PUMPL
//
//  Created by Sergey Nikitenko on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


//  BaseViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//


#import "PMTabBarController.h"

@interface UITabBarController (private)
- (UITabBar *)tabBar;
@end


@implementation PMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if([self.tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        [self.tabBar setBackgroundImage:[UIImage imageNamed:@"NavBackForTabBar.png"]];
    }
    else
    {
        UIImage* backImage = [[UIImage imageNamed:@"NavBack.png"] retain];
        UIView* backView = [[UIImageView alloc] initWithImage:backImage];
        backView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 48);
        [[self tabBar] insertSubview:backView atIndex:0];
    }
    
    
    UIImage* cameraImage = [UIImage imageNamed:@"img-tab-camera.png"];
    [self addCenterButtonWithImage:cameraImage highlightImage:cameraImage];
}

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(onCameraTabBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    
    CGRect tabBarBounds = self.tabBar.bounds;
    CGPoint tabBarCenter = CGPointMake(CGRectGetMidX(tabBarBounds), CGRectGetMidY(tabBarBounds));
    CGFloat heightDifference = buttonImage.size.height - tabBarBounds.size.height;
    if (heightDifference < 0)
    {
        button.center = tabBarCenter;
    }
    else
    {
        button.center = CGPointMake(tabBarCenter.x, tabBarCenter.y - heightDifference/2.0);
    }
    
    [[self tabBar] addSubview:button];
}

-(void) onCameraTabBtn:(id)center
{
    int centerIndex = [[self viewControllers] count] / 2;
    [self setSelectedIndex:centerIndex];
}

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

