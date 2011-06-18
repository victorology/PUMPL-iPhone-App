//
//  HomeScreenViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 16/06/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTThumbsViewController.h"
#import "ASIFormDataRequest.h"
#import "DataManager.h"
#import "JSON.h"


@class HomeScreenDataSource;

@interface HomeScreenViewController : KTThumbsViewController {

@private
	HomeScreenDataSource *images_;
	UIActivityIndicatorView *activityIndicatorView_;
	UIWindow *window_;
}

- (void)fetchPhotosFromPUMPLServer;

@end
