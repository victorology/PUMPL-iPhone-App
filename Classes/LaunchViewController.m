//
//  LaunchViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "LaunchViewController.h"
#import "SignupViewController.h"
#import "LoginViewController.h"
#import "PUMPLAppDelegate.h"


@implementation LaunchViewController

@synthesize mTabBarController;
@synthesize mSignUpButton;
@synthesize mLoginButton;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];


    //Configure the buttons
    
    [mSignUpButton setTitle:nil forState:UIControlStateNormal];
    UIImage *signUpImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageLaunchScreenRegisterButtonKey", @"") ofType:@"png"]];
    [mSignUpButton setBackgroundImage:signUpImage forState:UIControlStateNormal];
    [signUpImage release];
    
    
    [mLoginButton setTitle:nil forState:UIControlStateNormal];
    UIImage *loginImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageLaunchScreenLoginButtonKey", @"") ofType:@"png"]];
    [mLoginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
    [loginImage release];
    
    

    
    UIViewController *firstTabController = [[mTabBarController viewControllers] objectAtIndex:0];
    firstTabController.tabBarItem.title = NSLocalizedString(@"MyPhotosKey", @"");
    
    UIViewController *thirdTabController = [[mTabBarController viewControllers] objectAtIndex:2];
    thirdTabController.tabBarItem.title = NSLocalizedString(@"SettingsKey", @"");
    
	if([[DataManager sharedDataManager] isUserLoggedIn])
	{
		[self launchTabBarControllerAnimated:NO withSelectedTabIndex:0];
	}
    
    
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.mSignUpButton = nil;
    self.mLoginButton = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [mSignUpButton release];
    [mLoginButton release];
	[mTabBarController release];
    [super dealloc];
}



#pragma mark -
#pragma mark Action Methods


- (IBAction)signUp:(id)sender
{
	SignupViewController *viewController = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}


- (IBAction)login:(id)sender
{
	LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}




#pragma mark -
#pragma mark MIscellenous Methods

- (void)launchTabBarControllerAnimated:(BOOL)animated withSelectedTabIndex:(NSInteger)selectedTabIndex
{
	for(UINavigationController *navController in [mTabBarController viewControllers])
	{
		navController.navigationBar.barStyle = UIBarStyleBlack;
	}
	
	[mTabBarController setSelectedIndex:selectedTabIndex];
	[self presentModalViewController:mTabBarController animated:animated];
}




#pragma mark -
#pragma mark UITabBarController Delegate Methods


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	if(tabBarController.selectedIndex != 1)
	{
		[[DataManager sharedDataManager] setMLastSelectedTabBarIndex:tabBarController.selectedIndex];
	}
	else
	{
		UINavigationController *navController = (UINavigationController *)viewController;
		[navController popToRootViewControllerAnimated:YES];
	}
}



@end
