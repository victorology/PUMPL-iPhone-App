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

#define kAccessoryTypeDisclosureIndicator 0
#define kAccessoryTypeNone 1

#define kCellType1 0
#define kCellType2 1


#define kAlertViewForLogout 1
#define kAlertViewForFacebookDisconnect 2
#define kAlertViewForTwitterDisconnect 3
#define kAlertViewForTumblrDisconnect 4

#define kServerCallTypeCheckConnections 1
#define kServerCallTypeFacebookConnect 2
#define kServerCallTypeFacebookDisconnect 3
#define kServerCallTypeTwitterDisconnect 4
#define kServerCallTypeTumblrDisconnect 5


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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPUMPLLogin:) name:kNotificationPUMPLUserDidLogin object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToPUMPLLogout:) name:kNotificationPUMPLUserDidLogout object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToFBDidLogin:) name:kNotificationFBDidLogin object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToTwitterDidLogin:) name:kNotificationTwitterDidLogin object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToTumblrDidLogin:) name:kNotificationTumblrDidLogin object:nil];
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
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[mTableData release];
	[mTableView release];
    [super dealloc];
}



#pragma mark -
#pragma mark Private Methods

- (void)configureTheView
{
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];
	
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
		sectionTitle = @"Sharing";
	}
	
	return sectionTitle;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSDictionary *rowDic = [[mTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *blackLabelText = [rowDic valueForKey:@"blackLabel"];
	
	if([blackLabelText isEqualToString:@"Facebook"])
	{
		BOOL isFacebookLoggedIn = [[DataManager sharedDataManager] isFacebookConnected];
		if(isFacebookLoggedIn)
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to disconnect from facebook?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
			alertView.tag = kAlertViewForFacebookDisconnect;
			[alertView show];
			[alertView release];
		}
		else 
		{
			[self launchFacebookConnectionCall];			
		}

	}
	else if([blackLabelText isEqualToString:@"Twitter"])
	{
		BOOL isTwitterLoggedIn = [[DataManager sharedDataManager] isTwitterConnected];
		if(isTwitterLoggedIn)
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to disconnect from twitter?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
			alertView.tag = kAlertViewForTwitterDisconnect;
			[alertView show];
			[alertView release];
		}
		else 
		{
			TwitterLoginViewController *viewController = [[TwitterLoginViewController alloc] initWithNibName:@"TwitterLoginViewController" bundle:nil];
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
			[viewController release];
			[self presentModalViewController:navController animated:YES];
			[navController release];
		}
		
	}
	else if([blackLabelText isEqualToString:@"Tumblr"])
	{
		BOOL isTumblrLoggedIn = [[DataManager sharedDataManager] isTumblrConnected];
		if(isTumblrLoggedIn)
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to disconnect from Tumblr?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
			alertView.tag = kAlertViewForTumblrDisconnect;
			[alertView show];
			[alertView release];
		}
		else 
		{
			TumblrLoginViewController *viewController = [[TumblrLoginViewController alloc] initWithNibName:@"TumblrLoginViewController" bundle:nil];
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
			[viewController release];
			[self presentModalViewController:navController animated:YES];
			[navController release];
		}
		
	}
	else if([blackLabelText isEqualToString:@"Logout"])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
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
    _HUD.labelText = @"Connecting to server";
	
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
    _HUD.labelText = @"Connecting to facebook";
	
    
	[_HUD show:YES];
	[self makeFacebookConnectionCall];
}

- (void)makeFacebookConnectionCall
{
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
	
	NSString *urlString = [NSString stringWithFormat:@"%@?id=%@&session_api=%@", kURLForFacebookConnection, idString, session_api];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];
	request.delegate = self;
	request.userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:kServerCallTypeFacebookConnect] forKey:@"callType"];
	[request startAsynchronous];
}

- (void)launchFacebookDisconnectionCall
{
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = @"Disconnecting from facebook";
	
    
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
    _HUD.labelText = @"Disconnecting from twitter";
	
    
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
    _HUD.labelText = @"Disconnecting from tumblr";
	
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



- (void)buildTableData
{
	NSMutableArray *array = [NSMutableArray array];
	
	

	
	NSMutableArray *section1 = [NSMutableArray array];
	
	NSDictionary *row1_1 = [NSMutableDictionary dictionary];
	[row1_1 setValue:[NSNumber numberWithInt:kCellType1] forKey:@"cellType"];
	[row1_1 setValue:@"Facebook" forKey:@"blackLabel"];
	[row1_1 setValue:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];
	[row1_1 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
	BOOL isFacebookLoggedIn = [[DataManager sharedDataManager] isFacebookConnected];
	if(isFacebookLoggedIn)
		[row1_1 setValue:@"Disconnect" forKey:@"detailedLabel"];
	else
		[row1_1 setValue:nil forKey:@"detailedLabel"];
	[section1 addObject:row1_1];
	
	
	
	NSDictionary *row1_2 = [NSMutableDictionary dictionary];
	[row1_2 setValue:[NSNumber numberWithInt:kCellType1] forKey:@"cellType"];
	[row1_2 setValue:@"Twitter" forKey:@"blackLabel"];
	[row1_2 setValue:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];
	[row1_2 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
	BOOL isTwitterLoggedIn = [[DataManager sharedDataManager] isTwitterConnected];
	if(isTwitterLoggedIn)
		[row1_2 setValue:@"Disconnect" forKey:@"detailedLabel"];
	else
		[row1_2 setValue:nil forKey:@"detailedLabel"];
	[section1 addObject:row1_2];
	
	
	
	NSDictionary *row1_3 = [NSMutableDictionary dictionary];
	[row1_3 setValue:[NSNumber numberWithInt:kCellType1] forKey:@"cellType"];
	[row1_3 setValue:@"Tumblr" forKey:@"blackLabel"];
	[row1_3 setValue:[NSNumber numberWithInt:UITextAlignmentLeft] forKey:@"textAlignment"];
	[row1_3 setValue:[NSNumber numberWithInt:kAccessoryTypeDisclosureIndicator] forKey:@"accessoryType"];
	BOOL isTumblrLoggedIn = [[DataManager sharedDataManager] isTumblrConnected];
	if(isTumblrLoggedIn)
		[row1_3 setValue:@"Disconnect" forKey:@"detailedLabel"];
	else
		[row1_3 setValue:nil forKey:@"detailedLabel"];
	[section1 addObject:row1_3];
	
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
	[row2_1 setValue:@"Logout" forKey:@"blackLabel"];
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
				
				break;
			}
				
			case kServerCallTypeFacebookConnect:
			{
				//Build End Point URL
				NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
				NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
				NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
				NSString *endPointUrl = [NSString stringWithFormat:@"http://www.pumpl.com/facebook/confirm_api/%@/id/%@.json", session_api, idString];
				
				NSString *urlString = [[responseDic valueForKey:@"value"] valueForKey:@"authorize_url"];
				FacebookConnectionWebViewController *viewController = [[FacebookConnectionWebViewController alloc] initWithNibName:@"FacebookConnectionWebViewController" bundle:nil];
				viewController.urlString = urlString;
				viewController.endPointCheckUrlString = endPointUrl;
				[self.navigationController pushViewController:viewController animated:YES];
				[viewController release];
				
				break;
			}
				
			case kServerCallTypeFacebookDisconnect:
			{
				NSString *check = [[[responseDic valueForKey:@"value"] valueForKey:@"facebook"] valueForKey:@"unlink"];
				if([check isEqualToString:@"success"])
				{
					[[DataManager sharedDataManager] setFacebookConnected:NO withNickname:nil];
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
				
			case kServerCallTypeTwitterDisconnect:
			{
				NSString *check = [[[responseDic valueForKey:@"value"] valueForKey:@"twitter"] valueForKey:@"unlink"];
				if([check isEqualToString:@"success"])
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
				if([check isEqualToString:@"success"])
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
				
			default:
				break;
		}
		
	}
	else 
	{
		NSString *errorMessage = [responseDic valueForKey:@"error_message"];
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	
	
	
	
	
	
	
	[self buildTableData];
	[mTableView reloadData];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
	[_HUD hide:YES];
	
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to connect with server." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
	/*
	self.mTableData = nil;
	[mTableView reloadData];
	[self launchServerCallForCheckingConnectedServices];
	 */
	
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
}



#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
    [_HUD release];
	_HUD = nil;
}




@end
