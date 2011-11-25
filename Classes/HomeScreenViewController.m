//
//  HomeScreenViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 16/06/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "HomeScreenDataSource.h"
#import "Constants.h"
#import "WelcomeScreenViewController.h"
#import "PMNavigationController.h"


#define kOverlayCameraTabXCoord 49
#define kOverlayCameraTabYCoord 271


@interface HomeScreenViewController ()
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)configureTheView;
- (UIView *)overlayViewForCameraButton;
- (void)showOverlayViewForCameraButtonAnimated:(BOOL)animated;
- (void)removeOverlayViewForCameraButtonAnimated:(BOOL)animated;

@end

@implementation HomeScreenViewController

- (void)dealloc 
{
    [mOverlayCameraButtonView release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[activityIndicatorView_ release], activityIndicatorView_ = nil;
	[images_ release], images_ = nil;
	[super dealloc];
}

- (void)loadView
{
	images_ = [[HomeScreenDataSource alloc] init];
	[self setDataSource:images_];
    
	[super loadView];
}



- (void)viewDidLoad 
{
	[super viewDidLoad];
	
    
    
	
    //Set the delegate for PullToRefreshScrollView 
    [scrollView_ setDelegate1:self];
    
    
    //Login And Logout Notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPUMPLLogin:) name:kNotificationPUMPLUserDidLogin object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPUMPLLogout:) name:kNotificationPUMPLUserDidLogout object:nil];

	
    
    //Make the view ready for launch
	[self configureTheView];
    

    
    
    

    // We have to write this code because the kNotificationPUMPLUserDidLogin notification wont work in this controller because this controller
    // has not even registered itself to NotificationCenter for that notifiation when the app has launched and user has not logged in or signed up.
    BOOL presentWelcomeScreen = NO;
    if([[NSUserDefaults standardUserDefaults] valueForKey:kShouldUserBePresentedWithWelcomeScreen])
    {
        presentWelcomeScreen = [[[NSUserDefaults standardUserDefaults] valueForKey:kShouldUserBePresentedWithWelcomeScreen] boolValue];
    }
    
    
    if(presentWelcomeScreen)
    {
        mShouldPresentWelcomeScreen = YES;
    }
    else
    {
        //Fetch the photos from server to display
        [self fetchPhotosFromPUMPLServer];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
//    if([[images_ imagesArray] count] == 0 && _isFirstTimeAfterLogin)
//    {
//        _isFirstTimeAfterLogin = NO;
//        
//        // Add Overlay here
//        
//        [self showOverlayViewForCameraButtonAnimated:YES];
        
//        if(!mEmptyPhotosView)
//            [self createEmptyPhotosView];
//        
//        [scrollView_ addSubview:mEmptyPhotosView];
//    }
    
    
    if(![[DataManager sharedDataManager] hasUserPostedAnyPhoto])
    {
        [self showOverlayViewForCameraButtonAnimated:YES];
    }
    
    
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if(self.navigationController.navigationBar.frame.origin.y < 20)
    {
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
    }

}


- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
    
    
    
    //Tweak for KTPhotoBrowser for Top Navigation bar to be black.
//	[[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    
    if(mShouldPresentWelcomeScreen)
    {
        WelcomeScreenViewController *viewController = [[WelcomeScreenViewController alloc] initWithNibName:@"WelcomeScreenViewController" bundle:nil];
        UINavigationController *navController = [[PMNavigationController alloc] initWithRootViewController:viewController];
        [viewController release];
        navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [self presentModalViewController:navController animated:YES];
        [navController release];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:kShouldUserBePresentedWithWelcomeScreen];
        mShouldPresentWelcomeScreen = NO;
    }
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)willLoadThumbs 
{
	[self showActivityIndicator];
}

- (void)didLoadThumbs 
{
	[self hideActivityIndicator];
}



- (void)configureTheView
{
    
	self.navigationItem.title = NSLocalizedString(@"HomeKey", @"");
    
    
    
    UIColor *backgroundColor = [[UIColor alloc] initWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
	self.view.backgroundColor = backgroundColor;
    [backgroundColor release];
	
	
	
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];

	
	
	activityIndicatorView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicatorView_.frame = CGRectMake(150, 180, 20, 20);
	[activityIndicatorView_ setHidesWhenStopped:YES];
	[[self view] addSubview:activityIndicatorView_];
	
    
    
    
    
//	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)] autorelease];
     
}



#pragma mark -
#pragma mark Data Methods

- (void)fetchPhotosFromPUMPLServer
{
	if([activityIndicatorView_ isAnimating])
	{
		return;
	}
	
	
	[self showActivityIndicator];
	
	
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];

	NSString *urlString = [NSString stringWithFormat:@"%@?id=%@&session_api=%@", kURLForFetchPhotos, idString, session_api];
	ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];
	request.delegate = self;
	request.requestMethod = @"GET";
	[request startAsynchronous];
	
}





#pragma mark -
#pragma mark Activity Indicator



- (void)showActivityIndicator 
{
	[activityIndicatorView_ startAnimating];
}

- (void)hideActivityIndicator 
{
	[activityIndicatorView_ stopAnimating];
}





#pragma mark -
#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[self hideActivityIndicator];
    [scrollView_ stopLoading];
	
	NSString *responseString = [request responseString];
	
	NSDictionary *responseDic = [responseString JSONValue];
	
	
    if(responseDic)
    {
        NSInteger code = [[responseDic valueForKey:@"code"] integerValue];
        if(code == 0)
        {
            NSArray *photos = [responseDic valueForKey:@"value"];
            
            NSMutableArray *mockPhotosArray = [NSMutableArray array];
            NSMutableArray *titlesArray = [NSMutableArray array];
            
            for(NSDictionary *photoDic in photos)
            {
                BOOL retina = NO;
                
                if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
                    retina = [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;
                
                
                
                NSString *smallUrl = nil;
                
                if(retina)
                {
                    smallUrl = [photoDic valueForKey:@"thumbnail_url_retina"];
                }
                else 
                {
                    smallUrl = [photoDic valueForKey:@"thumbnail_url"];
                }
                
                
                
                NSString *bigUrl = [photoDic valueForKey:@"original_url"];
                NSString *titleString = [photoDic valueForKey:@"title"];
                
                NSInteger imageHeight;
                NSNumber *heightNumber = [photoDic valueForKey:@"original_height"];
                if([heightNumber isKindOfClass:[NSNull class]])
                {
                    imageHeight = 480;
                }
                else 
                {
                    imageHeight = [heightNumber integerValue];
                }
                
                
                NSInteger imageWidth;
                NSNumber *widthNumber = [photoDic valueForKey:@"original_width"];
                if([widthNumber isKindOfClass:[NSNull class]])
                {
                    imageWidth = 320;
                }
                else 
                {
                    imageWidth = [widthNumber integerValue];
                }
                
                
                
                if([titleString isKindOfClass:[NSNull class]])
                {
                    titleString = @"";
                }
                
                
                NSMutableArray *imageAndThumbnailArray = [NSMutableArray arrayWithObjects:bigUrl, smallUrl, nil];
                [mockPhotosArray addObject:imageAndThumbnailArray];
                
                [titlesArray addObject:titleString];
                
            }
            
            
            if([mockPhotosArray count] == 0)
            {
                // Now since we got Zero photos, we need to check the settings whether user had earlier posted an pic
                // If not, then we shall show tutorial overlay
                
                if(![[DataManager sharedDataManager] hasUserPostedAnyPhoto])
                {
                    [self showOverlayViewForCameraButtonAnimated:YES];
                }
            }
            else
            {
                [[DataManager sharedDataManager] setThatCurrentUserHasPostedPhotosEarlier];
                [self removeOverlayViewForCameraButtonAnimated:YES];
            }
            
            [images_ setImagesArray:mockPhotosArray];
            [images_ setTitlesArray:titlesArray];
            [self reloadThumbs];
            
            
            
        }
        else if(code == 1) // Code 1 has only been reserved for the situation where user has no photos on the server. So no alert view.
        {
            // Now since we got Zero photos, we need to check the settings whether user had earlier posted an pic
            // If not, then we shall show tutorial overlay
            
            if(![[DataManager sharedDataManager] hasUserPostedAnyPhoto])
            {
                [self showOverlayViewForCameraButtonAnimated:YES];
            }
            
        }
        else 
        {
            NSString *errorMessage = [responseDic valueForKey:@"error_message"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"UnknownServerResponseKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
    }
	
	
	
	
}



- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self hideActivityIndicator];
	[scrollView_ stopLoading];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"FailedToConnectToTheServerPleaseTryAgainLaterKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
}






#pragma mark -
#pragma mark Notification Response Methods


- (void)respondToPUMPLLogout:(NSNotification *)notificationObject
{
    [self removeOverlayViewForCameraButtonAnimated:NO];
    
	[images_ setImagesArray:nil];
	[images_ setTitlesArray:nil];
	[self reloadThumbs];
    
}


- (void)respondToPUMPLLogin:(NSNotification *)notificationObject
{
    
    _isFirstTimeAfterLogin = YES;

        
    
    BOOL presentWelcomeScreen = NO;
    if([[NSUserDefaults standardUserDefaults] valueForKey:kShouldUserBePresentedWithWelcomeScreen])
    {
        presentWelcomeScreen = [[[NSUserDefaults standardUserDefaults] valueForKey:kShouldUserBePresentedWithWelcomeScreen] boolValue];
    }
    
    
    if(presentWelcomeScreen)
    {
        mShouldPresentWelcomeScreen = YES;
    }
    else
    {
        [self fetchPhotosFromPUMPLServer];
    }
    
	
}






#pragma mark -
#pragma mark PullToRefreshScrollView Delegate Methods


-(void)refreshScrollView
{
	//[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];	
    //[images_ setImagesArray:nil];
	//[images_ setTitlesArray:nil];
	//[self reloadThumbs];
	
	[self fetchPhotosFromPUMPLServer];
}

-(void)stopLoading
{
	[scrollView_ stopLoading];
}





#pragma mark -
#pragma mark UI Methods


- (UIView *)overlayViewForCameraButton
{
    if(mOverlayCameraButtonView == nil)
    {
        UIImage *overlayImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OverlayForCameraButton" ofType:@"png"]];
        
        UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                      0,
                                                                                      overlayImage.size.width,
                                                                                      overlayImage.size.height)];
        overlayImageView.image = overlayImage;
        [overlayImage release];
        
        mOverlayCameraButtonView = [[UIView alloc] initWithFrame:CGRectMake(kOverlayCameraTabXCoord,
                                                                            kOverlayCameraTabYCoord,
                                                                            overlayImageView.frame.size.width,
                                                                            overlayImageView.frame.size.height)];
        mOverlayCameraButtonView.alpha = 0.0;
        mOverlayCameraButtonView.backgroundColor = [UIColor clearColor];
        [mOverlayCameraButtonView addSubview:overlayImageView];
        [overlayImageView release];
    }
    
    return mOverlayCameraButtonView;
}


- (void)showOverlayViewForCameraButtonAnimated:(BOOL)animated
{
    UIView *overlayViewForCameraTab = [self overlayViewForCameraButton];
    [scrollView_ addSubview:overlayViewForCameraTab];
    
    if(animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             
                             overlayViewForCameraTab.alpha = 1.0;
                         } 
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else
    {
        overlayViewForCameraTab.alpha = 1.0;
    }
    
}

- (void)removeOverlayViewForCameraButtonAnimated:(BOOL)animated
{
    UIView *overlayViewForCameraTab = [self overlayViewForCameraButton];
    
    
    if(animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             
                             overlayViewForCameraTab.alpha = 0.0;
                         } 
                         completion:^(BOOL finished) {
                             
                             [overlayViewForCameraTab removeFromSuperview];
                         }]; 
    }
    else
    {
        overlayViewForCameraTab.alpha = 0.0;
        [overlayViewForCameraTab removeFromSuperview];
    }
    
}



@end
