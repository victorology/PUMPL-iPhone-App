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

@interface HomeScreenViewController ()
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)configureTheView;

@end

@implementation HomeScreenViewController

- (void)dealloc 
{
	
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
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPUMPLLogin:) name:kNotificationPUMPLUserDidLogin object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPUMPLLogout:) name:kNotificationPUMPLUserDidLogout object:nil];

	
	[self configureTheView];
	[self fetchPhotosFromPUMPLServer];
}


- (void)viewDidAppear:(BOOL)animated {
	
	[super viewDidAppear:animated];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	//self.navigationController.navigationBar.translucent = NO;
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
	self.title = @"Home";
	self.view.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
	
	
	
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];

	
	
	activityIndicatorView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicatorView_.frame = CGRectMake(150, 180, 20, 20);
	[activityIndicatorView_ setHidesWhenStopped:YES];
	[[self view] addSubview:activityIndicatorView_];
	
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)] autorelease];
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
	
	NSString *responseString = [request responseString];
	
	NSDictionary *responseDic = [responseString JSONValue];
	
	
	
	
	
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
		
		
		[images_ setImagesArray:mockPhotosArray];
		[images_ setTitlesArray:titlesArray];
		[self reloadThumbs];
		
	}
	else 
	{
		NSString *errorMessage = [responseDic valueForKey:@"error_message"];
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}



- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self hideActivityIndicator];
	
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Failed to connect to the server. Please try again later"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
}






#pragma mark -
#pragma mark Notification Response Methods


- (void)respondToPUMPLLogout:(NSNotification *)notificationObject
{
	[images_ setImagesArray:nil];
	[images_ setTitlesArray:nil];
	[self reloadThumbs];
}


- (void)respondToPUMPLLogin:(NSNotification *)notificationObject
{
	[self fetchPhotosFromPUMPLServer];
}




#pragma mark -
#pragma mark Action Methods

- (void)reload:(id)sender
{
	[images_ setImagesArray:nil];
	[images_ setTitlesArray:nil];
	[self reloadThumbs];
	
	[self fetchPhotosFromPUMPLServer];
}



@end
