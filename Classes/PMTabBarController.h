//
//  PMTabBarController.h
//  PUMPL
//
//  Created by Sergey Nikitenko on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PMTabBarController : UITabBarController {
    
}

@end



@interface UITabBarController (extentions) 

+(UIBarButtonItem*) tabBarButtonWithImage:(UIImage*)buttonImage target:(id)target action:(SEL)action;

@end