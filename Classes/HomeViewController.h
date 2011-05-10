//
//  HomeViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 10/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "ASIFormDataRequest.h"
#import "DataManager.h"
#import "JSON.h"
#import "HomeViewThumbsDataSource.h"


@interface HomeViewController : TTThumbsViewController {

	UIActivityIndicatorView *mActivityIndicator;
}

@property (nonatomic, retain) UIActivityIndicatorView *mActivityIndicator;

- (void)fetchPhotosFromPUMPLServer;

- (void)configureTheView;
- (void)showActivity;
- (void)hideActivity;

@end
