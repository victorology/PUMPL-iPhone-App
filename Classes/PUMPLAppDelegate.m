//
//  PUMPLAppDelegate.m
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <OpenGLES/EAGL.h>

#import "PUMPLAppDelegate.h"
#import "LaunchViewController.h"
#import "DataManager.h"
#import "Appirater.h"
#import "PMNavigationController.h"

#import "RenderTexture+Filters.h"
#import "FBConnect.h"


@implementation PUMPLAppDelegate

@synthesize window;
@synthesize navController;
@synthesize eaglContext;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
    
    [[DataManager sharedDataManager] initializeSettingsDictionary];
    
    
    eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if(!eaglContext) 
    {
        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"This device does not support OpenGLES 2.0"
                                    delegate:nil cancelButtonTitle:nil otherButtonTitles:nil] autorelease] show];
    }
    
    [EAGLContext setCurrentContext:eaglContext];
	[RenderTexture loadFilterPrograms];
    [EAGLContext setCurrentContext:nil];
	
	LaunchViewController *viewController = [[LaunchViewController alloc] initWithNibName:@"LaunchViewController" bundle:nil];
	self.navController = [[[PMNavigationController alloc] initWithRootViewController:viewController] autorelease];
	navController.navigationBar.barStyle = UIBarStyleBlack;
	navController.navigationBarHidden = YES;
	[viewController release];
	
	
    [self.window addSubview:navController.view];
    [self.window makeKeyAndVisible];
	
	//TODO: Uncomment the Appirater code after we set the correct app id in the Appirator.h
	//[Appirater appLaunched:YES];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	
	//TODO: Uncomment the Appirater code after we set the correct app id in the Appirator.h
	//[Appirater appEnteredForeground:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

/*
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return [[[DataManager sharedDataManager] mFacebook] handleOpenURL:url];
}
*/

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [[DataManager sharedDataManager].facebook handleOpenURL:url];
}


- (void)dealloc {
	[navController release];
    [window release];
    [eaglContext release];
    [super dealloc];
}


@end
