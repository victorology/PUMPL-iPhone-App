//
//  HomeViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 10/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "HomeViewController.h"
#import "MockPhotoSource.h"

@implementation HomeViewController

@synthesize mActivityIndicator;


- (void)loadView
{
	[super loadView];
	
	self.tableView.rowHeight = 105;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPUMPLLogin:) name:kNotificationPUMPLUserDidLogin object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPUMPLLogout:) name:kNotificationPUMPLUserDidLogout object:nil];
	
	
	
	[self configureTheView];
	[self fetchPhotosFromPUMPLServer];
	
	/*
	self.photoSource = [[MockPhotoSource alloc]
						initWithType:MockPhotoSourceNormal
						//initWithType:MockPhotoSourceDelayed
						// initWithType:MockPhotoSourceLoadError
						// initWithType:MockPhotoSourceDelayed|MockPhotoSourceLoadError
						title:@"Home"
						photos:[[NSArray alloc] initWithObjects:
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3246/2957580101_33c799fc09_o.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3246/2957580101_d63ef56b15_t.jpg"
								  size:CGSizeMake(960, 1280)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3444/3223645618_13fe36887a_o.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3444/3223645618_f5e2fa7fea_t.jpg"
								  size:CGSizeMake(320, 480)
								  caption:@"These are the wood tiles that we had installed after the accident."] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123.jpg?v=0"
								  smallURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123_t.jpg"
								  size:CGSizeMake(320, 480)
								  caption:@"A hike."] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e.jpg"
								  smallURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e_t.jpg"
								  size:CGSizeMake(383, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41_t.jpg"
								  size:CGSizeMake(391, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4_t.jpg"
								  size:CGSizeMake(407, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889_t.jpg"
								  size:CGSizeMake(500, 406)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7.jpg"
								  smallURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7_t.jpg"
								  size:CGSizeMake(500, 372)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4.jpg"
								  smallURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4_t.jpg"
								  size:CGSizeMake(391, 500)] autorelease],
								
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3246/2957580101_33c799fc09_o.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3246/2957580101_d63ef56b15_t.jpg"
								  size:CGSizeMake(960, 1280)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3444/3223645618_13fe36887a_o.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3444/3223645618_f5e2fa7fea_t.jpg"
								  size:CGSizeMake(320, 480)
								  caption:@"These are the wood tiles that we had installed after the accident."] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123.jpg?v=0"
								  smallURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123_t.jpg"
								  size:CGSizeMake(320, 480)
								  caption:@"A hike."] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e.jpg"
								  smallURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e_t.jpg"
								  size:CGSizeMake(383, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41_t.jpg"
								  size:CGSizeMake(391, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4_t.jpg"
								  size:CGSizeMake(407, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889_t.jpg"
								  size:CGSizeMake(500, 406)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7.jpg"
								  smallURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7_t.jpg"
								  size:CGSizeMake(500, 372)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4.jpg"
								  smallURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4_t.jpg"
								  size:CGSizeMake(391, 500)] autorelease],
								
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3246/2957580101_33c799fc09_o.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3246/2957580101_d63ef56b15_t.jpg"
								  size:CGSizeMake(960, 1280)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3444/3223645618_13fe36887a_o.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3444/3223645618_f5e2fa7fea_t.jpg"
								  size:CGSizeMake(320, 480)
								  caption:@"These are the wood tiles that we had installed after the accident."] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123.jpg?v=0"
								  smallURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123_t.jpg"
								  size:CGSizeMake(320, 480)
								  caption:@"A hike."] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e.jpg"
								  smallURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e_t.jpg"
								  size:CGSizeMake(383, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41_t.jpg"
								  size:CGSizeMake(391, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4_t.jpg"
								  size:CGSizeMake(407, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889_t.jpg"
								  size:CGSizeMake(500, 406)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7.jpg"
								  smallURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7_t.jpg"
								  size:CGSizeMake(500, 372)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4.jpg"
								  smallURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4_t.jpg"
								  size:CGSizeMake(391, 500)] autorelease],
								
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3246/2957580101_33c799fc09_o.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3246/2957580101_d63ef56b15_t.jpg"
								  size:CGSizeMake(960, 1280)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3444/3223645618_13fe36887a_o.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3444/3223645618_f5e2fa7fea_t.jpg"
								  size:CGSizeMake(320, 480)
								  caption:@"These are the wood tiles that we had installed after the accident."] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123.jpg?v=0"
								  smallURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123_t.jpg"
								  size:CGSizeMake(320, 480)
								  caption:@"A hike."] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e.jpg"
								  smallURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e_t.jpg"
								  size:CGSizeMake(383, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41_t.jpg"
								  size:CGSizeMake(391, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4_t.jpg"
								  size:CGSizeMake(407, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889_t.jpg"
								  size:CGSizeMake(500, 406)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7.jpg"
								  smallURL:@"http://farm2.static.flickr.com/1004/3174172875_1e7a34ccb7_t.jpg"
								  size:CGSizeMake(500, 372)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4.jpg"
								  smallURL:@"http://farm3.static.flickr.com/2300/2179038972_65f1e5f8c4_t.jpg"
								  size:CGSizeMake(391, 500)] autorelease],
								
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3246/2957580101_33c799fc09_o.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3246/2957580101_d63ef56b15_t.jpg"
								  size:CGSizeMake(960, 1280)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3444/3223645618_13fe36887a_o.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3444/3223645618_f5e2fa7fea_t.jpg"
								  size:CGSizeMake(320, 480)
								  caption:@"These are the wood tiles that we had installed after the accident."] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123.jpg?v=0"
								  smallURL:@"http://farm2.static.flickr.com/1124/3164979509_bcfdd72123_t.jpg"
								  size:CGSizeMake(320, 480)
								  caption:@"A hike."] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3106/3203111597_d849ef615b_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3099/3164979221_6c0e583f7d_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2.jpg?v=0"
								  smallURL:@"http://farm4.static.flickr.com/3081/3164978791_3c292029f2_t.jpg"
								  size:CGSizeMake(320, 480)] autorelease],
								
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e.jpg"
								  smallURL:@"http://farm3.static.flickr.com/2358/2179913094_3a1591008e_t.jpg"
								  size:CGSizeMake(383, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3162/2677417507_e5d0007e41_t.jpg"
								  size:CGSizeMake(391, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3334/3334095096_ffdce92fc4_t.jpg"
								  size:CGSizeMake(407, 500)] autorelease],
								[[[MockPhoto alloc]
								  initWithURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889.jpg"
								  smallURL:@"http://farm4.static.flickr.com/3118/3122869991_c15255d889_t.jpg"
								  size:CGSizeMake(500, 406)] autorelease],
								
								nil
								]
						
						photos2:nil
						//  photos2:[[NSArray alloc] initWithObjects:
						//    [[[MockPhoto alloc]
						//      initWithURL:@"http://farm4.static.flickr.com/3280/2949707060_e639b539c5_o.jpg"
						//      smallURL:@"http://farm4.static.flickr.com/3280/2949707060_8139284ba5_t.jpg"
						//      size:CGSizeMake(800, 533)] autorelease],
						//    nil]
						];
	 
	 */
	
}




- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	
	self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
	self.tableView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.0];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[mActivityIndicator release];
    [super dealloc];
}




- (void)fetchPhotosFromPUMPLServer
{
	if([mActivityIndicator isAnimating])
	{
		return;
	}
	
	
	[self showActivity];
	
	
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
#pragma mark Private Methods

- (void)configureTheView
{
	self.navigationBarStyle = UIBarStyleBlackOpaque;
	self.navigationController.navigationBar.bounds = CGRectMake(0, 0, 320, 44);
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];
	
	UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicatorView.center = CGPointMake(160, 184);
	self.mActivityIndicator = indicatorView;
	[self.view addSubview:mActivityIndicator];
	[mActivityIndicator release];
	
	mActivityIndicator.hidden = YES;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)] autorelease];
}

- (void)showActivity
{
	mActivityIndicator.hidden = NO;
	[mActivityIndicator startAnimating];
}

- (void)hideActivity
{
	[mActivityIndicator stopAnimating];
	mActivityIndicator.hidden = YES;
}




#pragma mark -
#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[self hideActivity];
	
	NSString *responseString = [request responseString];
	
	NSDictionary *responseDic = [responseString JSONValue];
	
	NSInteger code = [[responseDic valueForKey:@"code"] integerValue];
	if(code == 0)
	{
		NSArray *photos = [responseDic valueForKey:@"value"];
		
		NSMutableArray *mockPhotosArray = [NSMutableArray array];
		
		for(NSDictionary *photoDic in photos)
		{
			NSString *bigUrl = [photoDic valueForKey:@"original_url"];
			NSString *smallUrl = [photoDic valueForKey:@"thumbnail_url"];
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
			
			MockPhoto *mkPhoto = [[MockPhoto alloc] initWithURL:bigUrl smallURL:smallUrl size:CGSizeMake(imageWidth, imageHeight) caption:titleString];
			[mockPhotosArray addObject:mkPhoto];
			[mkPhoto release];
		}
		
		self.photoSource = [[[MockPhotoSource alloc] initWithType:MockPhotoSourceNormal title:@"My Photos" photos:mockPhotosArray photos2:nil] autorelease];
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
	[self hideActivity];
	
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Failed With error - %@",[request error]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
}






#pragma mark -
#pragma mark Notification Response Methods


- (void)respondToPUMPLLogout:(NSNotification *)notificationObject
{
	self.photoSource = [[[MockPhotoSource alloc] initWithType:MockPhotoSourceNormal title:@"My Photos" photos:nil photos2:nil] autorelease];
}


- (void)respondToPUMPLLogin:(NSNotification *)notificationObject
{
	[self fetchPhotosFromPUMPLServer];
}





#pragma mark -
#pragma mark Action Methods

- (void)reload:(id)sender
{
	[self fetchPhotosFromPUMPLServer];
}





#pragma mark -
#pragma mark Superclass methods

- (id<TTTableViewDataSource>)createDataSource {
	return [[[HomeViewThumbsDataSource alloc] initWithPhotoSource:_photoSource delegate:self] autorelease];
}


- (void)updateTableLayout {
	self.tableView.contentInset = UIEdgeInsetsMake(14, 0, 0, 0);
	self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 0, 0);
}



@end
