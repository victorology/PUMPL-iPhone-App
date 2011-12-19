//
//  SelectedPhotoViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 11/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "SelectedPhotoViewController.h"
#import "DataManager.h"
#import "EnabledService.h"
#import "PUMPLAppDelegate.h"
#import "LaunchViewController.h"
#import "TwitterLoginViewController.h"
#import "TumblrLoginViewController.h"
#import "FacebookConnectionWebViewController.h"
#import "HomeScreenViewController.h"
#import "Me2DayLoginViewController.h"
#import "PMNavigationController.h"
#import "PMTabBarController.h"
#import "ApplyFilterViewController.h"
#import "Constants.h"

#define kCellTypeTextField 1
#define kCellTypeSwitch 2
#define kCellTypeDisclosureIndicator 3

#define kViewTagInputNameLabel 1
#define kViewTagInputTextField 2

#define kServerCallTypeFacebookConnect 2
#define kServerCallTypeMe2dayConnect 3




@interface SelectedPhotoViewController (Private)

- (void)launchFacebookConnectionCall;
- (void)makeFacebookConnectionCall;
- (void)launchMe2dayConnectionCall;
- (void)makeMe2dayConnectionCall;

@end


@implementation SelectedPhotoViewController


@synthesize mTableView;
@synthesize mFreezeView;
@synthesize mFreezeMessageLabel;
@synthesize mSelectedImage;
@synthesize mTableData;
@synthesize mPhotoUploader;
@synthesize wasFilterSelected;
@synthesize filterApplied;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToFBDidLogin:) name:kNotificationFBDidLogin object:nil];
    
    
	[self configureTheView];
	
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self buildTableData];
	[mTableView reloadData];
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
	[mPhotoUploader release];
	[mFreezeMessageLabel release];
	[mFreezeView release];
	[progressView release];
	[mTableData release];
	[mSelectedImage release];
    
    
	[mTableView release];
    // There was a crash. So to resolve it i had to nulify the delegate and datasource of mTableView
    mTableView.delegate = nil;
    mTableView.dataSource = nil;
    
    
    [super dealloc];
}




#pragma mark -
#pragma mark Private Methods

- (void)configureTheView
{
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];

    
    
    
    
    
    UIImage *backButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageBarButtonCancelBlackButtonKey", @"") ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [UITabBarController tabBarButtonWithImage:backButtonImage
                                                                               target:self action:@selector(cancel:)];
    [backButtonImage release];
    
    
    
    UIImage *doneButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageBarButtonDoneButtonKey", @"") ofType:@"png"]];
    self.navigationItem.rightBarButtonItem = [UITabBarController tabBarButtonWithImage:doneButtonImage
                                                                               target:self action:@selector(save:)];
    [doneButtonImage release];
    

    
    UIColor *backgroundColor = [[UIColor alloc] initWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
	self.view.backgroundColor = backgroundColor;
    [backgroundColor release];
    
	
	mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	
	progressView = [[DDProgressView alloc] initWithFrame: CGRectMake(20.0f, 240.0f, self.view.bounds.size.width-40.0f, 0.0f)];
	[progressView setOuterColor: [UIColor grayColor]] ;
	[progressView setInnerColor: [UIColor lightGrayColor]] ;
	[mFreezeView addSubview: progressView];
}



- (void)showFreezeScreen
{
	[mFreezeView removeFromSuperview];
	
	mFreezeView.frame = CGRectMake(0, 0, 320, 480);
	[self.navigationController.view addSubview:mFreezeView];
}

- (void)hideFreezeScreen
{
	[mFreezeView removeFromSuperview];
}



#pragma mark -
#pragma mark Data Methods




- (void)buildTableData
{
	NSMutableArray *array = [NSMutableArray array];
	
	
	
	
	NSMutableArray *section1 = [NSMutableArray array];
	
	NSMutableDictionary *row1_1 = [NSMutableDictionary dictionary];
	[row1_1 setValue:[NSNumber numberWithInteger:kCellTypeTextField] forKey:@"cellType"];
	[row1_1 setValue:NSLocalizedString(@"CaptionKey", @"") forKey:@"inputName"];
    
    if([DataManager iOS_5])
        [row1_1 setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:@"keyboardType"];
    else
        [row1_1 setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:@"keyboardType"];
    
	[row1_1 setValue:[NSNumber numberWithBool:NO] forKey:@"secureTextEntry"];
	[section1 addObject:row1_1];
	
	[array addObject:section1];
	
	
	
	
	
	NSMutableArray *section2 = [NSMutableArray array];
	
	
	
	NSMutableDictionary *row2_1 = [NSMutableDictionary dictionary];
	[row2_1 setValue:NSLocalizedString(@"FacebookKey", @"") forKey:@"inputName"];
	BOOL isFacebookLoggedIn = [[DataManager sharedDataManager] isFacebookConnected];
	if(isFacebookLoggedIn)
	{
		[row2_1 setValue:[NSNumber numberWithInteger:kCellTypeSwitch] forKey:@"cellType"];
		[row2_1 setValue:[NSNumber numberWithBool:YES] forKey:@"isOn"];
	}
	else 
	{
		[row2_1 setValue:[NSNumber numberWithInteger:kCellTypeDisclosureIndicator] forKey:@"cellType"];
		[row2_1 setValue:nil forKey:@"isOn"];
	}
	[section2 addObject:row2_1];
	
	
	NSMutableDictionary *row2_2 = [NSMutableDictionary dictionary];
	[row2_2 setValue:NSLocalizedString(@"TwitterKey", @"") forKey:@"inputName"];
	BOOL isTwitterLoggedIn = [[DataManager sharedDataManager] isTwitterConnected];
	if(isTwitterLoggedIn)
	{
		[row2_2 setValue:[NSNumber numberWithInteger:kCellTypeSwitch] forKey:@"cellType"];
		[row2_2 setValue:[NSNumber numberWithBool:YES] forKey:@"isOn"];
	}
	else 
	{
		[row2_2 setValue:[NSNumber numberWithInteger:kCellTypeDisclosureIndicator] forKey:@"cellType"];
		[row2_2 setValue:nil forKey:@"isOn"];
	}
	[section2 addObject:row2_2];
	
	
	NSMutableDictionary *row2_3 = [NSMutableDictionary dictionary];
	[row2_3 setValue:NSLocalizedString(@"TumblrKey", @"") forKey:@"inputName"];
	BOOL isTumblrLoggedIn = [[DataManager sharedDataManager] isTumblrConnected];
	if(isTumblrLoggedIn)
	{
		[row2_3 setValue:[NSNumber numberWithInteger:kCellTypeSwitch] forKey:@"cellType"];
		[row2_3 setValue:[NSNumber numberWithBool:YES] forKey:@"isOn"];
	}
	else 
	{
		[row2_3 setValue:[NSNumber numberWithInteger:kCellTypeDisclosureIndicator] forKey:@"cellType"];
		[row2_3 setValue:nil forKey:@"isOn"];
	}
	[section2 addObject:row2_3];
    
    
    
    NSMutableDictionary *row2_4 = [NSMutableDictionary dictionary];
	[row2_4 setValue:NSLocalizedString(@"me2dayKey", @"") forKey:@"inputName"];
	BOOL isMe2dayLoggedIn = [[DataManager sharedDataManager] isMe2dayConnected];
	if(isMe2dayLoggedIn)
	{
		[row2_4 setValue:[NSNumber numberWithInteger:kCellTypeSwitch] forKey:@"cellType"];
		[row2_4 setValue:[NSNumber numberWithBool:YES] forKey:@"isOn"];
	}
	else 
	{
		[row2_4 setValue:[NSNumber numberWithInteger:kCellTypeDisclosureIndicator] forKey:@"cellType"];
		[row2_4 setValue:nil forKey:@"isOn"];
	}
	[section2 addObject:row2_4];
    
    

    
	
	
	[array addObject:section2];
	
	
	
	
	self.mTableData = array;
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



#pragma mark -
#pragma mark Action Methods

- (void)save:(id)sender
{
	
	[self showFreezeScreen];

	//resign the active text field
	[[self getTextFieldForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] resignFirstResponder];
	
	NSString *titleString = [[self getTextFieldForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] text];

	NSMutableArray *array = [NSMutableArray array];
	
	for(NSDictionary *rowDic in [mTableData objectAtIndex:1])
	{
		BOOL isOn = [[rowDic valueForKey:@"isOn"] boolValue];
		if(isOn)
		{
			[array addObject:[rowDic valueForKey:@"inputName"]];
		}
	}
    
    
    
    // Now we have to upload the 800 by 600 version (if Full Size) and 600 by 600 (if Square image) of the photo.
    
    UIImage *imageToBeUploaded = nil;
    
    if(mSelectedImage.size.width == mSelectedImage.size.height)
    {
        imageToBeUploaded = [ApplyFilterViewController croppedImageToSize:CGSizeMake(600, 600) fromFullImage:mSelectedImage];
    }
    else
    {
        imageToBeUploaded = [ApplyFilterViewController resizeImage:mSelectedImage forImageQuality:kSettingsImageQualitySmall];
    }
    
    
    
								
	
	self.mPhotoUploader = [[[PhotoUploader alloc] initWithImage:imageToBeUploaded andTitle:titleString andServices:array andFilter:filterApplied] autorelease];
	if(mPhotoUploader)
	{
		mPhotoUploader.delegate = self;
		[mPhotoUploader startUploading];
	}
	 
}


- (void)serviceSwitchValueChanged:(id)sender
{
	UISwitch *serviceSwitch = (UISwitch *)sender;
	UITableViewCell *cell = (UITableViewCell *)[serviceSwitch superview];
	
	NSIndexPath *indexPath = [mTableView indexPathForCell:cell];
	NSMutableDictionary *rowDic = [[mTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	[rowDic setValue:[NSNumber numberWithBool:serviceSwitch.on] forKey:@"isOn"];
}


-(void) cancel:(id)sender {
    

    
    // Bring back the status bar which was set hidden when we displayed the filter screen
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //Show and configure the Home tab
    PUMPLAppDelegate *appDelegate = (PUMPLAppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarController *tabController = [(LaunchViewController *)[[appDelegate.navController viewControllers] objectAtIndex:0] mTabBarController];
    [tabController setSelectedIndex:0];
    
    // Make the navigation controller of second tab in tab bar pop to root view controller
    [(UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:1] popToRootViewControllerAnimated:YES];
    
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [mTableData count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[mTableData objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = nil;
	
    NSDictionary *rowDic = [[mTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSInteger cellType = [[rowDic valueForKey:@"cellType"] integerValue];
	
	switch (cellType) 
	{
		case kCellTypeTextField:
		{
			static NSString *CellIdentifier = @"Cell1";
			
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				
                
                
                UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 290, 31)];
				inputTextField.tag = kViewTagInputTextField;
				inputTextField.backgroundColor = [UIColor clearColor];
				inputTextField.borderStyle = UITextBorderStyleNone;
				inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
				inputTextField.delegate = self;
				inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
				[cell.contentView addSubview:inputTextField];
				[inputTextField release];
                
                
				UILabel *inputNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 43)];
				inputNameLabel.tag = kViewTagInputNameLabel;
				inputNameLabel.backgroundColor = [UIColor clearColor];
				inputNameLabel.textColor = [UIColor blackColor];
				inputNameLabel.font = [UIFont boldSystemFontOfSize:18];
				[cell.contentView addSubview:inputNameLabel];
				[inputNameLabel release];
				
				
				
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			
			// Configure the cell...
			UILabel *inputNameLabel = (UILabel *)[cell.contentView viewWithTag:kViewTagInputNameLabel];
			inputNameLabel.text = [rowDic valueForKey:@"inputName"];
			
			UITextField *inputTextField = (UITextField *)[cell.contentView viewWithTag:kViewTagInputTextField];
			inputTextField.keyboardType = [[rowDic valueForKey:@"keyboardType"] integerValue];
			inputTextField.secureTextEntry = [[rowDic valueForKey:@"secureTextEntry"] boolValue];
			
			
			break;
		}
			
			
		case kCellTypeSwitch:
		{
			static NSString *CellIdentifier = @"Cell2";
			
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			
			// Configure the cell...
			
			cell.textLabel.text = [rowDic valueForKey:@"inputName"];

			UISwitch *serviceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 94, 27)];
			[serviceSwitch addTarget:self action:@selector(serviceSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
			
			BOOL isOn = [[rowDic valueForKey:@"isOn"] boolValue];
			if(isOn)
			{
				[serviceSwitch setOn:YES];
			}
			else 
			{
				[serviceSwitch setOn:NO];
			}
			cell.accessoryView = serviceSwitch;
			[serviceSwitch release];

			
			break;
		}
			
			
			
		case kCellTypeDisclosureIndicator:
		{
			static NSString *CellIdentifier = @"Cell3";
			
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			
			// Configure the cell...
			
			
			cell.textLabel.text = [rowDic valueForKey:@"inputName"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			break;
		}
			
		default:
			break;
	}
	
	
	
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *rowDic = [[mTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSInteger cellType = [[rowDic valueForKey:@"cellType"] integerValue];
	
	switch (cellType) 
	{
		case kCellTypeTextField:
		{
			
			break;
		}
			
		case kCellTypeSwitch:
		{
			
			break;
		}
			
		case kCellTypeDisclosureIndicator:
		{
			NSString *inputName = [rowDic valueForKey:@"inputName"];
			if([inputName isEqualToString:@"Facebook"])
			{
                [[DataManager sharedDataManager] facebookLogin];
			}
			else if([inputName isEqualToString:@"Twitter"])
			{
				TwitterLoginViewController *viewController = [[TwitterLoginViewController alloc] initWithNibName:@"TwitterLoginViewController" bundle:nil];
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
				
			}
			else if([inputName isEqualToString:@"Tumblr"])
			{
				TumblrLoginViewController *viewController = [[TumblrLoginViewController alloc] initWithNibName:@"TumblrLoginViewController" bundle:nil];
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];

				
			}
            else if([inputName isEqualToString:@"me2day"])
			{
				[self launchMe2dayConnectionCall];
			}
        
			
			break;
		}
			
		default:
			break;
	}
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *sectionTitle = nil;
	
	if(section == 0)
	{
		sectionTitle = NSLocalizedString(@"PostPhotoKey", @"");
	}
	
	return sectionTitle;
}




#pragma mark -
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UILabel *inputLabel = (UILabel *)[[textField superview] viewWithTag:kViewTagInputNameLabel];
    inputLabel.hidden = YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        UILabel *inputLabel = (UILabel *)[[textField superview] viewWithTag:kViewTagInputNameLabel];
        inputLabel.hidden = NO;
    }
}






#pragma mark -
#pragma mark PhotoUploader Delegate Methods

- (void)photoUploader:(PhotoUploader *)uploader hasStartedTheStepWithTitle:(NSString *)stepTitle
{
	mFreezeMessageLabel.text = stepTitle;
}

- (void)photoUploaderHasFinishedUploading
{
	[self hideFreezeScreen];
	
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YourPhotoHasBeenSuccessfullyUploadedKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
	alertView.tag = 1;
	[alertView show];
	[alertView release];
}


- (void)photoUploader:(PhotoUploader *)uploader hasEncounteredError:(NSString *)errorMessage
{
	
	[self hideFreezeScreen];
	
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UploadFailedKey", @"") message:[NSString stringWithFormat:@"%@",errorMessage] delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


- (void)photoUploader:(PhotoUploader *)uploader uploadProgress:(float)progress
{
	[progressView setProgress:progress + 0.01f] ;
}



#pragma mark -
#pragma mark UIAlertView Delegate Methods



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 1)
	{
        // Mark in the user save data that user has now at least posted one photo
        [[DataManager sharedDataManager] setThatCurrentUserHasPostedPhotosEarlier];
        
        // Bring back the status bar which was set hidden when we displayed the filter screen
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
		//Show and configure the Home tab
		PUMPLAppDelegate *appDelegate = (PUMPLAppDelegate *)[[UIApplication sharedApplication] delegate];
		UITabBarController *tabController = [(LaunchViewController *)[[appDelegate.navController viewControllers] objectAtIndex:0] mTabBarController];
		
		UINavigationController *firstTabNavigationController = (UINavigationController *)[[tabController viewControllers] objectAtIndex:0];
		[firstTabNavigationController popToRootViewControllerAnimated:YES];
        [(HomeScreenViewController *)[[firstTabNavigationController viewControllers] objectAtIndex:0] fetchPhotosFromPUMPLServer];
		[(HomeScreenViewController *)[[firstTabNavigationController viewControllers] objectAtIndex:0] fetchPhotosFromPUMPLServer];
		[tabController setSelectedIndex:0];
        
        // Make the navigation controller of second tab in tab bar pop to root view controller
        [(UINavigationController *)[[self.tabBarController viewControllers] objectAtIndex:1] popToRootViewControllerAnimated:YES];
	}
}




#pragma mark -
#pragma mark Miscellenous Methods

- (UITextField *)getTextFieldForIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [mTableView cellForRowAtIndexPath:indexPath];
	UITextField *textField = (UITextField *)[cell.contentView viewWithTag:kViewTagInputTextField];
	
	return textField;
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
			
			case kServerCallTypeFacebookConnect:
			{
				NSString *nickName = [[[responseDic valueForKey:@"value"] valueForKey:@"user"] valueForKey:@"nickname"];
                [[DataManager sharedDataManager] setFacebookConnected:YES withNickname:nickName];
                
                [self buildTableData];
                [mTableView reloadData];
				
				break;
			}
				

            case kServerCallTypeMe2dayConnect:
			{
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
	
	
	
	
	
	
	
	
	[self buildTableData];
	[mTableView reloadData];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
	[_HUD hide:YES];
	
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"FailedToConnectWithServerKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
}








- (void)respondToFBDidLogin:(NSNotification *)notificationObject
{    
    [self launchFacebookConnectionCall];
}

@end
