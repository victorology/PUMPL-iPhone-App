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
	
}

@property (nonatomic, retain) IBOutlet UITabBarController *mTabBarController;

- (void)launchTabBarControllerAnimated:(BOOL)animated withSelectedTabIndex:(NSInteger)selectedTabIndex;

- (IBAction)signUp:(id)sender;
- (IBAction)login:(id)sender;

@end
