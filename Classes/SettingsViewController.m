//
//  SettingsViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 10/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "SettingsViewController.h"
#import "DataManager.h"
#import "ImageQualitySettingController.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "TwitterLoginViewController.h"
#import "FacebookConnectionWebViewController.h"
#import "TumblrLoginViewController.h"
#import "Me2DayLoginViewController.h"
#import "PMNavigationController.h"
#import "FacebookSettingsController.h"

#define kAccessoryTypeDisclosureIndicator 0
#define kAccessoryTypeNone 1
#define kCellImageTypeCheckmark 0
#define kCellImageTypeNotChecked 1

#define kCellViewTagCheckmarkButton 100


#define kCellType1 0
#define kCellType2 1


#define kAlertViewForLogout 1
#define kAlertViewForFacebookDisconnect 2
#define kAlertViewForTwitterDisconnect 3
#define kAlertViewForTumblrDisconnect 4
#define kAlertViewForMe2dayDisconnect 5

#define kServerCallTypeCheckConnections 1
#define kServerCallTypeFacebookConnect 2
#define kServerCallTypeFacebookDisconnect 3
#define kServerCallTypeTwitterDisconnect 4
#define kServerCallTypeTumblrDisconnect 5
#define kServerCallTypeMe2dayConnect 6
#define kServerCallTypeMe2dayDisconnect 7


#define kOverlayCameraTabXCoord 49
#define kOverlayCameraTabYCoord 271

#define kOverlaySettingsServicesXCoord 49
#define kOverlaySettingsServicesYCoord 77


@interface SettingsViewController (Private)

- (void)launchServerCallForCheckingConnectedServices;
- (void)serverCallForCheckingConnectedServices;
- (void)launchFacebookConnectionCall;
- (void)makeFacebookConnectionCall;
- (void)launchFacebookDisconnectionCall;
- (void)makeFacebookDisconnectionCall;
- (void)launchTwitterDisconnectionCall;
- (void)makeTwitterDisconnectionCall;
- (void)launchTumblrDisconnectionCall;
- (void)makeTumblrDisconnectionCall;
- (void)launchMe2dayConnectionCall;
- (void)makeMe2dayConnectionCall;
- (void)launchMe2dayDisconnectionCall;
- (void)makeMe2dayDisconnectionCall;
- (UIView *)overlayViewForCameraButton;
- (UIView *)overlayViewForSettingsServices;
- (void)showOverlayViewForCameraButtonAnimated:(BOOL)animated;
- (void)removeOverlayViewForCameraButtonAnimated:(BOOL)animated;
- (void)showOverlayViewForSettingsServicesAnimated:(BOOL)animated;
- (void)removeOverlayViewForSettingsServicesAnimated:(BOOL)animated;

@end

@implementation SettingsViewController

@synthesize mTableView;
@synthesize mTableData;

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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPUMPLLogin:) name:kNotificationPUMPLUserDidLogin object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPUMPLLogout:) name:kNotificationPUMPLUserDidLogout object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToFBDidLogin:) name:kNotificationFBDidLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToFBDidLogout:) name:kNotificationFBDidLogout object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToTwitterDidLogin:) name:kNotificationTwitterDidLogin object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToTumblrDidLogin:) name:kNotificationTumblrDidLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToMe2dayDidLogin:) name:kNotificationMe2dayDidLogin object:nil];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureTheView];
	
	
	[self buildTableData];
	[mTableView reloadData];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if(self.navigationController.navigationBar.frame.origin.y < 20)
    {
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
    }

    
    if(![[DataManager sharedDataManager] hasUserPostedAnyPhoto])
    {
        [self showOverlayViewForCameraButtonAnimated:YES];
    }
    
    if(![[DataManager sharedDataManager] hasUserConnectedToAServiceAtLeastOneTime])
    {
       [self showOverlayViewForSettingsServicesAnimated:YES]; 
    }
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
}


- (void)dealloc {
    
    [mOverlaySettingsServicesView release];
    [mOverlayCameraButtonView release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[mTableData release];
	[mTableView release];
    [_HUD release];
    [super dealloc];
}



#pragma mark -
#pragma mark Private Methods

- (void)configureTheView
{
    
    
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];
    
    UIColor *backgroundColor = [[UIColor alloc] initWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
    self.view.backgroundColor = backgroundColor;
    [backgroundColor release];
	
	mTableView.backgroundColor = [UIColor clearColor];
	mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return [mTableData count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [[mTableData objectAtIndex:section] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell;
	
	NSDictionary *rowDic = [[mTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSInteger cellType = [[rowDic valueForKey:@"cellType"] integerValue];
	
	
	
	switch (cellType) 
	{
		case kCellType1:
		{
			static NSString *CellIdentifier = @"Cell1";
			
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
				
				
                
                UIButton *checkMarkButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                                       0,
                                                                                       44, 
                                                                                       44)];
                checkMarkButton.tag = kCellViewTagCheckmarkButton;
                [checkMarkButton addTarget:self action:@selector(checkmarkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:checkMarkButton];
                [checkMarkButton release];
                
                
                
                UIImage *fakeImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SettingsFakeImage" ofType:@"png"]];
                cell.imageView.image = fakeImage;
                [fakeImage release];
			}
			
			
			cell.textLabel.text = [rowDic valueForKey:@"blackLabel"];
			cell.detailTextLabel.text = [rowDic valueForKey:@"detailedLabel"];
			cell.textLabel.textAlignment = [[rowDic valueForKey:@"textAlignment"] integerValue];
			
			
			NSInteger accessoryType = [[rowDic valueForKey:@"accessoryType"] integerValue];
			if(accessoryType == kAccessoryTypeNone)
			{
				cell.accessoryView = nil;
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			else if(accessoryType == kAccessoryTypeDisclosureIndicator)
			{
				cell.accessoryView = nil;
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
            
            
            
            UIButton *checkmarkButton = (UIButton *)[cell.contentView viewWithTag:kCellViewTagCheckmarkButton];
            
            NSInteger imageType = [[rowDic valueForKey:@"imageType"] integerValue];
            if(imageType == kCellImageTypeCheckmark)
            {
                UIImage *checkImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SettingsCheckmark" ofType:@"png"]];
                [checkmarkButton setBackgroundImage:checkImage forState:UIControlStateNormal];
                [checkImage release];
                
                checkmarkButton.userInteractionEnabled = YES;
            }
            else if(imageType == kCellImageTypeNotChecked)
            {
                UIImage *checkImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SettingsUncheckmark" ofType:@"png"]];
                [checkmarkButton setBackgroundImage:checkImage forState:UIControlStateNormal];
                [checkImage release];
                
                checkmarkButton.userInteractionEnabled = NO;
            }
            
            
            
			
			break;
		}
			
		case kCellType2:
		{
			static NSString *CellIdentifier = @"Cell2";
			
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				
				
			}
			
			
			cell.textLabel.text = [rowDic valueForKey:@"blackLabel"];
			cell.textLabel.textAlignment = [[rowDic valueForKey:@"textAlignment"] integerValue];
			
			
			NSInteger accessoryType = [[rowDic valueForKey:@"accessoryType"] integerValue];
			if(accessoryType == kAccessoryTypeNone)
			{
				cell.accessoryView = nil;
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			else if(accessoryType == kAccessoryTypeDisclosureIndicator)
			{
				cell.accessoryView = nil;
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			
			break;
		}
			
		default:
			break;
	}
	
    
	
	
	
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *sectionTitle = nil;
	
	if(section == 0)
	{
		sectionTitle = NSLocalizedString(@"SharingKey", @"");
	}
	
	return sectionTitle;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSDictionary *rowDic = [[mTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *blackLabelText = [rowDic valueForKey:@"blackLabel"];
	
	if([blackLabelText isEqualToString:NSLocalizedString(@"FacebookKey", @"")])
	{
		BOOL isFacebookLoggedIn = [[DataManager sharedDataManager] isFacebookConnected];
		if(isFacebookLoggedIn)
		{            
            FacebookSettingsController *settingsController = [[FacebookSettingsController alloc] initWithNibName:@"FacebookSettingsController" bundle:nil];
            [self.navigationController pushViewController:settingsController animated:YES];
            [settingsController release];
            
		}
		else 
		{
			[[DataManager sharedDataManager] facebookLogin];
		}

	}
	else if([blackLabelText isEqualToString:NSLocalizedString(@"TwitterKey", @"")])
	{
		BOOL isTwitterLoggedIn = [[DataManager sharedDataManager] isTwitterConnected];
		if(isTwitterLoggedIn)
		{

		}
		else 
		{
			TwitterLoginViewController *viewController = [[TwitterLoginViewController alloc] initWithNibName:@"TwitterLoginViewController" bundle:nil];			
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];

		}
		
	}
	else if([blackLabelText isEqualToString:NSLocalizedString(@"TumblrKey", @"")])
	{
		BOOL isTumblrLoggedIn = [[DataManager sharedDataManager] isTumblrConnected];
		if(isTumblrLoggedIn)
		{

		}
		else 
		{
			TumblrLoginViewController *viewController = [[TumblrLoginViewController alloc] initWithNibName:@"TumblrLoginViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];

		}
		
	}
    else if([blackLabelText isEqualToString:NSLocalizedString(@"me2dayKey", @"")])
	{
		BOOL isMe2dayLoggedIn = [[DataManager sharedDataManager] isMe2dayConnected];
		if(isMe2dayLoggedIn)
		{

		}
		else 
		{
			[self launchMe2dayConnectionCall];			
		}
        
	}
	else if([blackLabelText isEqualToString:NSLocalizedString(@"LogoutKey", @"")])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"AccountLogoutConfirmationMessageKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"NoKey", @"") otherButtonTitles:NSLocalizedString(@"YesKey", @""), nil];
		alertView.tag = kAlertViewForLogout;
		[alertView show];
		[alertView release];
	}
	else if([blackLabelText isEqualToString:@"Image Quality"])
	{
		ImageQualitySettingController *viewController = [[ImageQualitySettingController alloc] initWithNibName:@"ImageQualitySettingController" bundle:nil];
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
	
	[mTableView deselectRowAtIndexPath:indexPath animated:YES];
	 
}



#pragma mark -
#pragma mark Data Methods

- (void)launchServerCallForCheckingConnectedServices
{
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"ConnectingToServerKey", @"");
	
	[_HUD show:YES];
	[self serverCallForCheckingConnectedServices];
}

- (void)serverCallForCheckingConnectedServices
{
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
	
	NSString *urlString = [NSString stringWithFormat:@"%@?id=%@&session_api=%@", kURLForConnectedServices, idString, session_api];
	ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];
	request.delegate = self;
	request.userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:kServerCallTypeCheckConnections] forKey:@"callType"];
	request.requestMethod = @"GET";
	[request startAsynchronous];
}


- (void)launchFacebookConnectionCall
{
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"ConnectingToFacebookKey", @"");
	
    
	[_HUD show:YES];
	[self makeFacebookConnectionCall];
}

- (void)makeFacebookConnectionCall
{
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
    NSString *accessToken = [[[DataManager sharedDataManager] facebook] accessToken];
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"ko"])
    {
        language = @"kr";
    }
    
   
    
    
	
	NSString *urlString = [NSString stringWithFormat:@"%@", kURLForFacebookSingleSignOn];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];
    request.delegate = self;
    request.requestMethod = @"POST";
    [request setPostValue:idString forKey:@"id"];
	[request setPostValue:session_api forKey:@"session_api"];
    [request setPostValue:accessToken forKey:@"fb_access_token"];
    [request setPostValue:language forKey:@"language"];
	request.userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:kServerCallTypeFacebookConnect] forKey:@"callType"];
	[request startAsynchronous];
}










- (void)launchFacebookDisconnectionCall
{
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"DisconnectingFromFacebookKey", @"");	
    
	[_HUD show:YES];
	[self makeFacebookDisconnectionCall];
}

- (void)makeFacebookDisconnectionCall
{
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
	
	NSString *urlString = [NSString stringWithFormat:@"%@?id=%@&session_api=%@", kURLForFacebookDisconnection, idString, session_api];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];
	request.delegate = self;
	request.userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:kServerCallTypeFacebookDisconnect] forKey:@"callType"];
	[request startAsynchronous];
}


- (void)launchTwitterDisconnectionCall
{
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"DisconnectingFromTwitterKey", @"");
	
    
	[_HUD show:YES];
	[self makeTwitterDisconnectionCall];
}

- (void)makeTwitterDisconnectionCall
{
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
	
	NSString *urlString = [NSString stringWithFormat:@"%@?id=%@&session_api=%@", kURLForTwitterDisconnection, idString, session_api];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];
	request.delegate = self;
	request.userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:kServerCallTypeTwitterDisconnect] forKey:@"callType"];
	[request startAsynchronous];
}

- (void)launchTumblrDisconnectionCall
{
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"DisconnectingFromTumblrKey", @"");
	
	[_HUD show:YES];
	[self makeTumblrDisconnectionCall];
}

- (void)makeTumblrDisconnectionCall
{
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
	
	NSString *urlString = [NSString stringWithFormat:@"%@?id=%@&session_api=%@", kURLForTumblrDisconnection, idString, session_api];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];
	request.delegate = self;
	request.userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:kServerCallTypeTumblrDisconnect] forKey:@"callType"];
	[request startAsynchronous];
}

- (void)launchMe2dayConnectionCall
{
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"ConnectingToMe2dayKey", @"");
	
    
	[_HUD show:YES];
	[self makeMe2dayConnectionCall];
}

- (void)makeMe2dayConnectionCall
{
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
	
	NSString *urlString = [NSString stringWithFormat:@"%@", kURLForMe2dayConnection];
	ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];
    request.delegate = self;
    request.requestMethod = @"POST";
    [request setPostValue:idString forKey:@"id"];
	[request setPostValue:session_api forKey:@"session_api"];
	request.userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:kServerCallTypeMe2dayConnect] forKey:@"callType"];
	[request startAsynchronous];
}


- (void)launchMe2dayDisconnectionCall
{
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"DisconnectingFromMe2dayKey", @"");
	
	[_HUD show:YES];
	[self makeMe2dayDisconnectionCall];
}

- (void)makeMe2dayDisconnectionCall
{
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
	
	NSString *urlString = [NSString stringWithFormat:@"%@?id=%@&session_api=%@", kURLForMe2dayDisconnection, idString, session_api];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];
	request.delegate = self;
	request.userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:kServerCallTypeMe2dayDisconnect] forKey:@"callType"];
	[request startAsynchronous];
}




- (void)buildTableData
{
	NSMutableArray *array = [NSMutableArray array];
	
	

	
	NSMutableArray *section1 = [NSMutableArray array];
	
	NSDictionary *row1_1 = [NSMutableDictionary dictionary];
	[row1_1 setValue:[NSNumber numberWithInt:kCellType1] forKey:@"cellType"];
	[row1_1 setValue:NSLocalizedString(@"FacebookKey", @"") forKey:@"blackLabel"];
	[row1_1 setValue:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];  
    BOOL isFacebookLoggedIn = [[DataManager sharedDataManager] isFacebookConnected];
	if(isFacebookLoggedIn)
    {
        [row1_1 setValue:[NSNumber numberWithInt:kCellImageTypeCheckmark] forKey:@"imageType"];
        [row1_1 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
    }
	else
    {
        [row1_1 setValue:[NSNumber numberWithInt:kCellImageTypeNotChecked] forKey:@"imageType"];
        [row1_1 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
    }
		
	[section1 addObject:row1_1];
	
	
	
	NSDictionary *row1_2 = [NSMutableDictionary dictionary];
	[row1_2 setValue:[NSNumber numberWithInt:kCellType1] forKey:@"cellType"];
	[row1_2 setValue:NSLocalizedString(@"TwitterKey", @"") forKey:@"blackLabel"];
	[row1_2 setValue:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];
    BOOL isTwitterLoggedIn = [[DataManager sharedDataManager] isTwitterConnected];
	if(isTwitterLoggedIn)
    {
        [row1_2 setValue:[NSNumber numberWithInt:kCellImageTypeCheckmark] forKey:@"imageType"];
        [row1_2 setValue:[NSNumber numberWithInt:kAccessoryTypeNone] forKey:@"accessoryType"];
    }
	else
    {
        [row1_2 setValue:[NSNumber numberWithInt:kCellImageTypeNotChecked] forKey:@"imageType"];
        [row1_2 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
    }

	[section1 addObject:row1_2];
	
	
	
	NSDictionary *row1_3 = [NSMutableDictionary dictionary];
	[row1_3 setValue:[NSNumber numberWithInt:kCellType1] forKey:@"cellType"];
	[row1_3 setValue:NSLocalizedString(@"TumblrKey", @"") forKey:@"blackLabel"];
	[row1_3 setValue:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];
    
    BOOL isTumblrLoggedIn = [[DataManager sharedDataManager] isTumblrConnected];
	if(isTumblrLoggedIn)
    {
        [row1_3 setValue:[NSNumber numberWithInt:kCellImageTypeCheckmark] forKey:@"imageType"];
        [row1_3 setValue:[NSNumber numberWithInt:kAccessoryTypeNone] forKey:@"accessoryType"];
    }
	else
    {
        [row1_3 setValue:[NSNumber numberWithInt:kCellImageTypeNotChecked] forKey:@"imageType"];
        [row1_3 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
    }

	[section1 addObject:row1_3];
    
    
    
    
    
    
    NSDictionary *row1_4 = [NSMutableDictionary dictionary];
	[row1_4 setValue:[NSNumber numberWithInt:kCellType1] forKey:@"cellType"];
	[row1_4 setValue:NSLocalizedString(@"me2dayKey", @"") forKey:@"blackLabel"];
	[row1_4 setValue:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];
    
    BOOL isMe2dayLoggedIn = [[DataManager sharedDataManager] isMe2dayConnected];
	if(isMe2dayLoggedIn)
    {
        [row1_4 setValue:[NSNumber numberWithInt:kCellImageTypeCheckmark] forKey:@"imageType"];
        [row1_4 setValue:[NSNumber numberWithInt:kAccessoryTypeNone] forKey:@"accessoryType"];
    }
	else
    {
        [row1_4 setValue:[NSNumber numberWithInt:kCellImageTypeNotChecked] forKey:@"imageType"];
        [row1_4 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
    }

	[section1 addObject:row1_4];
	
	/*
	NSDictionary *row1_3 = [NSMutableDictionary dictionary];
	[row1_3 setValue:[NSNumber numberWithInt:kCellType1] forKey:@"cellType"];
	[row1_3 setValue:@"me2day" forKey:@"blackLabel"];
	[row1_3 setValue:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];
	[row1_3 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
	[section1 addObject:row1_3];
	
	NSDictionary *row1_4 = [NSMutableDictionary dictionary];
	[row1_4 setValue:[NSNumber numberWithInt:kCellType1] forKey:@"cellType"];
	[row1_4 setValue:@"cyworld" forKey:@"blackLabel"];
	[row1_4 setValue:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];
	[row1_4 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
	[section1 addObject:row1_4];
	 */
	
	
	[array addObject:section1];
	
	
	//The image quality settings have been temporarily disbaled.
	
	/*
	NSMutableArray *section3 = [NSMutableArray array];
	
	NSDictionary *row3_1 = [NSMutableDictionary dictionary];
	[row3_1 setValue:[NSNumber numberWithInt:kCellType1] forKey:@"cellType"];
	[row3_1 setValue:@"Image Quality" forKey:@"blackLabel"];
	
	NSString *imageQualityString;
	NSInteger imageQuality = [[DataManager sharedDataManager] imageQualitySetting];
	switch (imageQuality) 
	{
		case kSettingsImageQualitySmall:
		{
			imageQualityString = @"Small";
			break;
		}
			
		case kSettingsImageQualityMedium:
		{
			imageQualityString = @"Medium";
			break;
		}
			
		case kSettingsImageQualityFull:
		{
			imageQualityString = @"Full";
			break;
		}
			
		default:
		{
			imageQualityString = @"Unknown";
			break;
		}
			
	}
	[row3_1 setValue:imageQualityString forKey:@"detailedLabel"];
	[row3_1 setValue:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];
	[row3_1 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
	[section3 addObject:row3_1];
	
	[array addObject:section3];
	*/
	
	
	
	
	
	NSMutableArray *section2 = [NSMutableArray array];
	
	NSDictionary *row2_1 = [NSMutableDictionary dictionary];
	[row2_1 setValue:[NSNumber numberWithInt:kCellType2] forKey:@"cellType"];
	[row2_1 setValue:NSLocalizedString(@"LogoutKey", @"") forKey:@"blackLabel"];
	[row2_1 setValue:[NSNumber numberWithInt:UITextAlignmentCenter] forKey:@"textAlignment"];
	[row2_1 setValue:[NSNumber numberWithInt:kAccessoryTypeNone] forKey:@"accessoryType"];
	[section2 addObject:row2_1];
	
	[array addObject:section2];
	
	
	
	
	
	self.mTableData = array;
}



#pragma mark -
#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[_HUD hide:YES];
	
	NSString *responseString = [request responseString];
	NSDictionary *responseDic = [responseString JSONValue];
	
	
//    NSLog(@"Response - %@", responseDic);
    
	if(responseDic)
    {
        NSInteger code = [[responseDic valueForKey:@"code"] integerValue];
        if(code == 0)
        {
            NSInteger callType = [[request.userInfo valueForKey:@"callType"] integerValue];
            
            switch (callType) 
            {
                case kServerCallTypeCheckConnections:
                {
                    //Facebook Data
                    NSDictionary *facebookData = [[responseDic objectForKey:@"value"] objectForKey:@"facebook"];
                    if(facebookData)
                    {
                        BOOL isConnected = [[facebookData valueForKey:@"is_connected"] boolValue];
                        if(isConnected)
                        {
                            NSString *nickName = [facebookData valueForKey:@"nickname"];
                            [[DataManager sharedDataManager] setFacebookConnected:YES withNickname:nickName];
                        }
                        else 
                        {
                            [[DataManager sharedDataManager] setFacebookConnected:NO withNickname:nil];
                        }
                    }
                    
                    
                    //Twitter Data
                    NSDictionary *twitterData = [[responseDic objectForKey:@"value"] objectForKey:@"twitter"];
                    if(twitterData)
                    {
                        BOOL isConnected = [[twitterData valueForKey:@"is_connected"] boolValue];
                        if(isConnected)
                        {
                            NSString *nickName = [twitterData valueForKey:@"nickname"];
                            [[DataManager sharedDataManager] setTwitterConnected:YES withNickname:nickName];
                        }
                        else 
                        {
                            [[DataManager sharedDataManager] setTwitterConnected:NO withNickname:nil];
                        }
                    }
                    
                    
                    //Tumblr Data
                    NSDictionary *tumblrData = [[responseDic objectForKey:@"value"] objectForKey:@"tumblr"];
                    if(tumblrData)
                    {
                        BOOL isConnected = [[tumblrData valueForKey:@"is_connected"] boolValue];
                        if(isConnected)
                        {
                            NSString *nickName = [tumblrData valueForKey:@"nickname"];
                            [[DataManager sharedDataManager] setTumblrConnected:YES withNickname:nickName];
                        }
                        else 
                        {
                            [[DataManager sharedDataManager] setTumblrConnected:NO withNickname:nil];
                        }
                    }
                    
                    
                    //me2day Data
                    NSDictionary *me2dayData = [[responseDic objectForKey:@"value"] objectForKey:@"me2day"];
                    if(me2dayData)
                    {
                        BOOL isConnected = [[me2dayData valueForKey:@"is_connected"] boolValue];
                        if(isConnected)
                        {
                            NSString *nickName = [me2dayData valueForKey:@"nickname"];
                            [[DataManager sharedDataManager] setMe2dayConnected:YES withNickname:nickName];
                        }
                        else 
                        {
                            [[DataManager sharedDataManager] setMe2dayConnected:NO withNickname:nil];
                        }
                    }
                    
                    break;
                }
                    
                case kServerCallTypeFacebookConnect:
                {                
                    NSString *nickName = [[[responseDic valueForKey:@"value"] valueForKey:@"user"] valueForKey:@"nickname"];
                    [[DataManager sharedDataManager] setFacebookConnected:YES withNickname:nickName];
                    
                    [self buildTableData];
                    [mTableView reloadData];
                    
                    break;
                }
                    
                case kServerCallTypeFacebookDisconnect:
                {
                    NSString *check = [[[responseDic valueForKey:@"value"] valueForKey:@"facebook"] valueForKey:@"unlink"];
                    if([[check lowercaseString] isEqualToString:@"success"])
                    {
                        [[DataManager sharedDataManager] facebookLogout];
                        [[DataManager sharedDataManager] setFacebookConnected:NO withNickname:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationFBDidLogout object:nil]];
                        
                        /*
                         self.mTableData = nil;
                         [mTableView reloadData];
                         [self launchServerCallForCheckingConnectedServices];
                         */
                    }
                    
                    break;
                }
                    
                case kServerCallTypeTwitterDisconnect:
                {
                    NSString *check = [[[responseDic valueForKey:@"value"] valueForKey:@"twitter"] valueForKey:@"unlink"];
                    if([[check lowercaseString] isEqualToString:@"success"])
                    {
                        [[DataManager sharedDataManager] setTwitterConnected:NO withNickname:nil];
                        [self buildTableData];
                        [mTableView reloadData];
                        
                        /*
                         self.mTableData = nil;
                         [mTableView reloadData];
                         [self launchServerCallForCheckingConnectedServices];
                         */
                    }
                    
                    break;
                }
                    
                case kServerCallTypeTumblrDisconnect:
                {
                    
                    NSString *check = [[[responseDic valueForKey:@"value"] valueForKey:@"tumblr"] valueForKey:@"unlink"];
                    if([[check lowercaseString] isEqualToString:@"success"])
                    {
                        [[DataManager sharedDataManager] setTumblrConnected:NO withNickname:nil];
                        [self buildTableData];
                        [mTableView reloadData];
                        
                        /*
                         self.mTableData = nil;
                         [mTableView reloadData];
                         [self launchServerCallForCheckingConnectedServices];
                         */
                    }
                    
                    
                    break;
                }
                    
                case kServerCallTypeMe2dayConnect:
                {
                    //Build End Point URL
                    NSString *alreadyLoggedInUrl = [NSString stringWithFormat:@"http://me2day.net/"];
                    NSString *endPointUrl = [NSString stringWithFormat:@"http://www.pumpl.com//me2day/confirm.json?result=true"];
                    
                    NSString *urlString = [[responseDic valueForKey:@"value"] valueForKey:@"authorize_url"];
                    Me2DayLoginViewController *viewController = [[Me2DayLoginViewController alloc] initWithNibName:@"Me2DayLoginViewController" bundle:nil];
                    viewController.urlString = urlString;
                    viewController.alreadyLoggedInUrlString = alreadyLoggedInUrl;
                    viewController.endPointCheckUrlString = endPointUrl;
                    [self.navigationController pushViewController:viewController animated:YES];
                    [viewController release];
                    
                    break;
                }
                    
                    
                case kServerCallTypeMe2dayDisconnect:
                {
                    
                    NSString *check = [[[responseDic valueForKey:@"value"] valueForKey:@"me2day"] valueForKey:@"unlink"];
                    if([[check lowercaseString] isEqualToString:@"success"])
                    {
                        [[DataManager sharedDataManager] setMe2dayConnected:NO withNickname:nil];
                        [self buildTableData];
                        [mTableView reloadData];
                        
                        /*
                         self.mTableData = nil;
                         [mTableView reloadData];
                         [self launchServerCallForCheckingConnectedServices];
                         */
                    }
                    
                    
                    break;
                }
                    
                    
                    
                default:
                    break;
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
	
	
	
	
	
	
	
	[self buildTableData];
	[mTableView reloadData];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
	[_HUD hide:YES];
	
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"FailedToConnectToTheServerPleaseTryAgainLaterKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
}






	 




#pragma mark -
#pragma mark Notification Response Methods


- (void)respondToPUMPLLogout:(NSNotification *)notificationObject
{
	self.mTableData = nil;
	[mTableView reloadData];
}


- (void)respondToPUMPLLogin:(NSNotification *)notificationObject
{
	[self launchServerCallForCheckingConnectedServices];
}


- (void)respondToFBDidLogin:(NSNotification *)notificationObject
{    
    [self launchFacebookConnectionCall];
}

- (void)respondToFBDidLogout:(NSNotification *)notificationObject
{    
    [self buildTableData];
	[mTableView reloadData];
}



- (void)respondToTwitterDidLogin:(NSNotification *)notificationObject
{
	/*
	self.mTableData = nil;
	[mTableView reloadData];
	[self launchServerCallForCheckingConnectedServices];
	 */
	
	[self buildTableData];
	[mTableView reloadData];
}

- (void)respondToTumblrDidLogin:(NSNotification *)notificationObject
{
	/*
	self.mTableData = nil;
	[mTableView reloadData];
	[self launchServerCallForCheckingConnectedServices];
	 */
	
	[self buildTableData];
	[mTableView reloadData];
}

- (void)respondToMe2dayDidLogin:(NSNotification *)notificationObject
{
	/*
     self.mTableData = nil;
     [mTableView reloadData];
     [self launchServerCallForCheckingConnectedServices];
	 */
	
	[self buildTableData];
	[mTableView reloadData];
}


#pragma mark -
#pragma mark UIAlertView delegate Methods


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == kAlertViewForLogout)
	{
		if(buttonIndex == 1)
		{
			[[DataManager sharedDataManager] logoutUser];
			[self.tabBarController dismissModalViewControllerAnimated:YES];
		}
		
	}
	else if(alertView.tag == kAlertViewForFacebookDisconnect)
	{
		if(buttonIndex == 1)
		{
			[self launchFacebookDisconnectionCall];
		}
			
	}
	else if(alertView.tag == kAlertViewForTwitterDisconnect)
	{
		if(buttonIndex == 1)
		{
			[self launchTwitterDisconnectionCall];
		}
		
	}
	else if(alertView.tag == kAlertViewForTumblrDisconnect)
	{
		if(buttonIndex == 1)
		{
			[self launchTumblrDisconnectionCall];
		}
		
	}
    else if(alertView.tag == kAlertViewForMe2dayDisconnect)
	{
		if(buttonIndex == 1)
		{
			[self launchMe2dayDisconnectionCall];
		}
		
	}
}



#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
    [_HUD release];
	_HUD = nil;
}





#pragma mark -
#pragma mark Action methods

- (void)checkmarkButtonClicked:(id)sender
{
    UITableViewCell *cell = (UITableViewCell *)[[(UIButton *)sender superview] superview];
    NSIndexPath *indexPath = [mTableView indexPathForCell:cell];
    
    
    NSDictionary *rowDic = [[mTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *blackLabelText = [rowDic valueForKey:@"blackLabel"];
	
	if([blackLabelText isEqualToString:NSLocalizedString(@"FacebookKey", @"")])
	{
		BOOL isFacebookLoggedIn = [[DataManager sharedDataManager] isFacebookConnected];
		if(isFacebookLoggedIn)
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"FacebookLogoutConfirmationMessageKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"NoKey", @"") otherButtonTitles:NSLocalizedString(@"YesKey", @""), nil];
			alertView.tag = kAlertViewForFacebookDisconnect;
			[alertView show];
			[alertView release];
		}
		
        
	}
	else if([blackLabelText isEqualToString:NSLocalizedString(@"TwitterKey", @"")])
	{
		BOOL isTwitterLoggedIn = [[DataManager sharedDataManager] isTwitterConnected];
		if(isTwitterLoggedIn)
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"TwitterLogoutConfirmationMessageKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"NoKey", @"") otherButtonTitles:NSLocalizedString(@"YesKey", @""), nil];
			alertView.tag = kAlertViewForTwitterDisconnect;
			[alertView show];
			[alertView release];
		}
	}
	else if([blackLabelText isEqualToString:NSLocalizedString(@"TumblrKey", @"")])
	{
		BOOL isTumblrLoggedIn = [[DataManager sharedDataManager] isTumblrConnected];
		if(isTumblrLoggedIn)
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"TumblerLogoutConfirmationMessageKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"NoKey", @"") otherButtonTitles:NSLocalizedString(@"YesKey", @""), nil];
			alertView.tag = kAlertViewForTumblrDisconnect;
			[alertView show];
			[alertView release];
		}
	}
    else if([blackLabelText isEqualToString:NSLocalizedString(@"me2dayKey", @"")])
	{
		BOOL isMe2dayLoggedIn = [[DataManager sharedDataManager] isMe2dayConnected];
		if(isMe2dayLoggedIn)
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Me2dayLogoutConfirmationMessageKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"NoKey", @"") otherButtonTitles:NSLocalizedString(@"YesKey", @""), nil];
			alertView.tag = kAlertViewForMe2dayDisconnect;
			[alertView show];
			[alertView release];
		}
        
	}
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


- (UIView *)overlayViewForSettingsServices
{
    if(mOverlaySettingsServicesView == nil)
    {
        UIImage *overlayImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OverlayForSettingsTab" ofType:@"png"]];
        
        UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kOverlaySettingsServicesXCoord,
                                                                                      kOverlaySettingsServicesYCoord,
                                                                                      overlayImage.size.width,
                                                                                      overlayImage.size.height)];
        overlayImageView.image = overlayImage;
        [overlayImage release];
        
        mOverlaySettingsServicesView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                self.view.frame.size.width,
                                                                                self.view.frame.size.height)];
        mOverlaySettingsServicesView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        mOverlaySettingsServicesView.alpha = 0.0;
        
        [mOverlaySettingsServicesView addSubview:overlayImageView];
        [overlayImageView release];
    }
    
    return mOverlaySettingsServicesView;
}


- (void)showOverlayViewForCameraButtonAnimated:(BOOL)animated
{
    UIView *overlayViewForCameraTab = [self overlayViewForCameraButton];
    [self.view addSubview:overlayViewForCameraTab];
    
    if(animated)
    {
        [UIView animateWithDuration:0.6
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



- (void)showOverlayViewForSettingsServicesAnimated:(BOOL)animated
{
    UIView *overlayViewForSettingsServices = [self overlayViewForSettingsServices];
    [self.view addSubview:overlayViewForSettingsServices];
    
    if(animated)
    {
        [UIView animateWithDuration:0.6
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             
                             overlayViewForSettingsServices.alpha = 1.0;
                         } 
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else
    {
        overlayViewForSettingsServices.alpha = 1.0;
    }
    
}

- (void)removeOverlayViewForSettingsServicesAnimated:(BOOL)animated
{
    UIView *overlayViewForSettingsServices = [self overlayViewForSettingsServices];
    
    
    if(animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut
                         animations:^{
                             
                             overlayViewForSettingsServices.alpha = 0.0;
                         } 
                         completion:^(BOOL finished) {
                             
                             [overlayViewForSettingsServices removeFromSuperview];
                         }]; 
    }
    else
    {
        overlayViewForSettingsServices.alpha = 0.0;
        [overlayViewForSettingsServices removeFromSuperview];
    }
    
}




#pragma mark -
#pragma mark UITouches Methods


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view == mOverlayCameraButtonView)
    {
        [self removeOverlayViewForCameraButtonAnimated:YES];
    }
    else if(touch.view == mOverlaySettingsServicesView)
    {
        [self removeOverlayViewForSettingsServicesAnimated:YES];
    }
}



@end
