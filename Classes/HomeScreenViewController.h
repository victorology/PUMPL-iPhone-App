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
#import "PullToRefreshScrollView.h"


@class HomeScreenDataSource;

@interface HomeScreenViewController : KTThumbsViewController <PullToRefreshScrollViewDelegate> {

    BOOL mShouldPresentWelcomeScreen;
    UIView *mEmptyPhotosView;
    
@private
	HomeScreenDataSource *images_;
	UIActivityIndicatorView *activityIndicatorView_;
}

- (void)fetchPhotosFromPUMPLServer;
- (void)createEmptyPhotosView;

@end
