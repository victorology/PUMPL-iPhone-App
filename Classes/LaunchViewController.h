//
//  LaunchViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"


@interface LaunchViewController : UIViewController {

	UITabBarController *mTabBarController;
    
    UIButton *mSignUpButton;
    UIButton *mLoginButton;
    
    UIView *mBackgroundViewForRotatingImages;
    UIImageView *mMaskImageView;
    
    NSTimer *mTimerForBackgroundImageRotation;
    NSInteger mCurrentIndexForBackgroundImage;
    NSMutableArray *mBackgroundImageViewsArray;
}

@property (nonatomic, retain) IBOutlet UITabBarController *mTabBarController;
@property (nonatomic, retain) IBOutlet UIButton *mSignUpButton;
@property (nonatomic, retain) IBOutlet UIButton *mLoginButton;
@property (nonatomic, retain) IBOutlet UIView *mBackgroundViewForRotatingImages;
@property (nonatomic, retain) IBOutlet UIImageView *mMaskImageView;

- (void)launchTabBarControllerAnimated:(BOOL)animated withSelectedTabIndex:(NSInteger)selectedTabIndex;

- (IBAction)signUp:(id)sender;
- (IBAction)login:(id)sender;


@end
