//
//  TwitterLoginViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 20/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "TwitterLoginViewController.h"
#import "DataManager.h"
#import "JSON.h"
#import "Constants.h"
#import "PMTabBarController.h"


#define kViewTagInputNameLabel 1
#define kViewTagInputTextField 2

@interface TwitterLoginViewController (Private)

- (void)makeLoginCallWithCredentials:(NSDictionary *)credentials;

@end



@implementation TwitterLoginViewController

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureTheView];
	[self buildTableData];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	UITextField *firstTextField = [self getTextFieldForRowIndex:0];
	[firstTextField becomeFirstResponder];
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
	
	_request.delegate = nil;
	[_request release];
	[mTableData release];
	[mTableView release];
    [super dealloc];
}



#pragma mark -
#pragma mark Private Methods

- (void)configureTheView
{
    
    UIImage *backButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageBarButtonBackButtonKey", @"") ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [UITabBarController tabBarButtonWithImage:backButtonImage
                                                                               target:self action:@selector(cancel:)];
    [backButtonImage release];
    
    

	self.navigationItem.title = NSLocalizedString(@"TwitterLoginKey", @"");
	
    
    UIImage *loginButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageBarButtonLoginButtonKey", @"") ofType:@"png"]];
    self.navigationItem.rightBarButtonItem = [UITabBarController tabBarButtonWithImage:loginButtonImage
                                                                                target:self action:@selector(login:)];
    [loginButtonImage release];
    
    
    
	
    UIColor *backgroundColor = [[UIColor alloc] initWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
	self.view.backgroundColor = backgroundColor;
    [backgroundColor release];
    
    
	mTableView.backgroundColor = [UIColor clearColor];
}





#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [mTableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		UILabel *inputNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 43)];
		inputNameLabel.tag = kViewTagInputNameLabel;
		inputNameLabel.backgroundColor = [UIColor clearColor];
		inputNameLabel.textColor = [UIColor blackColor];
		inputNameLabel.font = [UIFont boldSystemFontOfSize:18];
		[cell.contentView addSubview:inputNameLabel];
		[inputNameLabel release];
		
		UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 180, 31)];
		inputTextField.tag = kViewTagInputTextField;
		inputTextField.backgroundColor = [UIColor clearColor];
		inputTextField.borderStyle = UITextBorderStyleNone;
		inputTextField.clearButtonMode = UITextFieldViewModeAlways;
		inputTextField.delegate = self;
		inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		inputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		[cell.contentView addSubview:inputTextField];
		[inputTextField release];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	// Configure the cell...
	
	NSDictionary *rowDic = [mTableData objectAtIndex:indexPath.row];
	
	UILabel *inputNameLabel = (UILabel *)[cell.contentView viewWithTag:kViewTagInputNameLabel];
	inputNameLabel.text = [rowDic valueForKey:@"inputName"];
	
	UITextField *inputTextField = (UITextField *)[cell.contentView viewWithTag:kViewTagInputTextField];
	inputTextField.returnKeyType = UIReturnKeyNext;
	inputTextField.keyboardType = [[rowDic valueForKey:@"keyboardType"] integerValue];
	inputTextField.secureTextEntry = [[rowDic valueForKey:@"secureTextEntry"] boolValue];
    
    
    return cell;
}



#pragma mark -
#pragma mark Data Methods

- (void)buildTableData
{
	NSMutableArray *array = [NSMutableArray array];
	
	NSDictionary *row1 = [NSMutableDictionary dictionary];
	[row1 setValue:NSLocalizedString(@"UsernameKey", @"") forKey:@"inputName"];
    
    if([DataManager iOS_5])
        [row1 setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:@"keyboardType"];
    else
        [row1 setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:@"keyboardType"];

	[row1 setValue:[NSNumber numberWithBool:NO] forKey:@"secureTextEntry"];
	[array addObject:row1];
	
	NSDictionary *row2 = [NSMutableDictionary dictionary];
	[row2 setValue:NSLocalizedString(@"PasswordKey", @"") forKey:@"inputName"];
    
    if([DataManager iOS_5])
        [row2 setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:@"keyboardType"];
    else
        [row2 setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:@"keyboardType"];
    
	[row2 setValue:[NSNumber numberWithBool:YES] forKey:@"secureTextEntry"];
	[array addObject:row2];
	
	self.mTableData = array;
}

- (void)makeLoginCallWithCredentials:(NSDictionary *)credentials
{
	NSString *username = [credentials valueForKey:@"username"];
	NSString *password = [credentials valueForKey:@"password"];

	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
	NSString *urlString = [NSString stringWithFormat:@"%@", kURLForTwitterConnection];
	
	
	_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	_request.delegate = self;
	_request.requestMethod = @"POST";
	[_request setPostValue:idString forKey:@"id"];
	[_request setPostValue:session_api forKey:@"session_api"];
	[_request setPostValue:username forKey:@"x_auth_username"];
	[_request setPostValue:password forKey:@"x_auth_password"];
	[_request startAsynchronous];

}



#pragma mark -
#pragma mark Action Methods

- (void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//	[self dismissModalViewControllerAnimated:YES];
}

- (void)login:(id)sender
{
	
	NSString *username = [[[self getTextFieldForRowIndex:0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([username isEqualToString:@""])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"PleaseEnterYourUsernameKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	
	
	NSString *password = [[self getTextFieldForRowIndex:1] text];
	if([password isEqualToString:@""])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"PleaseEnterYourPasswordKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	
	NSMutableDictionary *credentialsDic = [NSMutableDictionary dictionary];
	[credentialsDic setValue:username forKey:@"username"];
	[credentialsDic setValue:password forKey:@"password"];
	
	
	_HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"ConnectingToServerKey", @"");
	
    
	[_HUD show:YES];
	[self makeLoginCallWithCredentials:credentialsDic];
}






#pragma mark -
#pragma mark Miscellenous Methods

- (UITextField *)getTextFieldForRowIndex:(NSInteger)rowIndex
{
	UITableViewCell *cell = [mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
	UITextField *textField = (UITextField *)[cell.contentView viewWithTag:kViewTagInputTextField];
	
	return textField;
}




#pragma mark -
#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
	NSIndexPath *indexPath = [mTableView indexPathForCell:cell];
	
	NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0];
	UITableViewCell *nextCell = [mTableView cellForRowAtIndexPath:nextIndexPath];
	if(nextCell)
	{
		UITextField *nextTextField = (UITextField *)[nextCell.contentView viewWithTag:kViewTagInputTextField];
		[nextTextField becomeFirstResponder];
	}
	else 
	{
		[self login:nil];
	}
	
	
	return YES;
}





#pragma mark -
#pragma mark UIAlertView Delegate Methods


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 1)
	{
		[[DataManager sharedDataManager] setThatCurrentUserHasConnectedToAServiceAtLeastOneTime];
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationTwitterDidLogin object:nil]];
        [self.navigationController popViewControllerAnimated:YES];

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
#pragma mark ASIHTTPRequest Delegate Methods




- (void)requestFinished:(ASIHTTPRequest *)request
{
	[_HUD hide:YES];
	
	NSString *responseString = [request responseString];
	NSDictionary *responseDic = [responseString JSONValue];
	
	
	if(responseDic)
    {
        NSInteger code = [[responseDic valueForKey:@"code"] integerValue];
        if(code == 0)
        {
            if([[[responseDic valueForKey:@"value"] valueForKey:@"is_twitter_connected"] boolValue])
            {
                [[DataManager sharedDataManager] setTwitterConnected:YES withNickname:nil];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CongratulationsKey", @"") message:NSLocalizedString(@"YouHaveSuccessfullyLoggedIntoYourTwitterAccountKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
                alertView.tag = 1;
                [alertView show];
                [alertView release];
            }
            else 
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"CouldNotLogIntoTwitterScreenKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
                [alertView show];
                [alertView release];
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


@end
