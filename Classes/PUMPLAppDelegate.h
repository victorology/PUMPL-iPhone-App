//
//  PUMPLAppDelegate.h
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EAGLContext;
@interface PUMPLAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
    
    EAGLContext* eaglContext;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic, readonly) EAGLContext* eaglContext;

@end

