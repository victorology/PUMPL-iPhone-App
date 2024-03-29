//
//  SignupViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "PMTabBarController.h"
#import "SignupViewController.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "LaunchViewController.h"
#import "WelcomeScreenViewController.h"

#define kViewTagInputNameLabel 1
#define kViewTagInputTextField 2

@implementation SignupViewController

@synthesize mTableView;
@synthesize mActivityIndicator;
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
	
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
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
	[mTableData release];
	[mActivityIndicator release];
	[mTableView release];
    [super dealloc];
}





#pragma mark -
#pragma mark Private Methods

- (void)configureTheView
{

    
    
    UIImage *backButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageBarButtonBackButtonKey", @"") ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [UITabBarController tabBarButtonWithImage:backButtonImage
                                                                               target:self action:@selector(back:)];
    [backButtonImage release];
    
    
    UIImage *signUpButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageBarButtonSignUpButtonKey", @"") ofType:@"png"]];
    self.navigationItem.rightBarButtonItem = [UITabBarController tabBarButtonWithImage:signUpButtonImage
                                                                                target:self action:@selector(signUp:)];
    [signUpButtonImage release];
    
    
	
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];
    
    
    UIColor *backgroundColor = [[UIColor alloc] initWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
	self.view.backgroundColor = backgroundColor;
    [backgroundColor release];
    
    
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.frame = CGRectMake(141, 86, 37, 37);
    self.mActivityIndicator = indicatorView;
    [indicatorView release];
    mActivityIndicator.hidden = YES;
    [self.view addSubview:mActivityIndicator];
    
	

	mTableView.backgroundColor = [UIColor clearColor];
	mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
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
		
		UILabel *inputNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 43)];
		inputNameLabel.tag = kViewTagInputNameLabel;
		inputNameLabel.backgroundColor = [UIColor clearColor];
		inputNameLabel.textColor = [UIColor blackColor];
		inputNameLabel.font = [UIFont boldSystemFontOfSize:18];
		[cell.contentView addSubview:inputNameLabel];
		[inputNameLabel release];
		
		UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, 170, 31)];
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
    
	inputTextField.returnKeyType = [[rowDic valueForKey:@"keyboardReturnKey"] integerValue];
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
	[row1 setValue:NSLocalizedString(@"EmailKey", @"") forKey:@"inputName"];
    
    
    if([DataManager iOS_5])
        [row1 setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:@"keyboardType"];
    else
        [row1 setValue:[NSNumber numberWithInt:UIKeyboardTypeEmailAddress] forKey:@"keyboardType"];

    
	[row1 setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:@"keyboardReturnKey"];
	[row1 setValue:[NSNumber numberWithBool:NO] forKey:@"secureTextEntry"];
	[array addObject:row1];
	
    
    
	NSDictionary *row2 = [NSMutableDictionary dictionary];
	[row2 setValue:NSLocalizedString(@"UsernameKey", @"") forKey:@"inputName"];
    
    if([DataManager iOS_5])
        [row2 setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:@"keyboardType"];
    else
        [row2 setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:@"keyboardType"];
    
	[row2 setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:@"keyboardReturnKey"];
	[row2 setValue:[NSNumber numberWithBool:NO] forKey:@"secureTextEntry"];
	[array addObject:row2];
    
    
    
	
	NSDictionary *row3 = [NSMutableDictionary dictionary];
    
    if([DataManager iOS_5])
        [row3 setValue:[NSNumber numberWithInt:UIKeyboardTypeDefault] forKey:@"keyboardType"];
    else
        [row3 setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:@"keyboardType"];
    
	[row3 setValue:[NSNumber numberWithInt:UIReturnKeyGo] forKey:@"keyboardReturnKey"];
	[row3 setValue:NSLocalizedString(@"PasswordKey", @"") forKey:@"inputName"];
	[row3 setValue:[NSNumber numberWithBool:YES] forKey:@"secureTextEntry"];
	[array addObject:row3];
	
	self.mTableData = array;
}





#pragma mark -
#pragma mark Action Methods

- (void)signUp:(id)sender
{
	if([mActivityIndicator isAnimating])
	{
		return;
	}
	
	NSString *email = [[[self getTextFieldForRowIndex:0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([email isEqualToString:@""])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"PleaseEnterYourEmailKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	
	NSString *username = [[[self getTextFieldForRowIndex:1] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([username isEqualToString:@""])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"PleaseEnterYourUsernameKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	
	
	NSString *password = [[self getTextFieldForRowIndex:2] text];
	if([password isEqualToString:@""])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"PleaseEnterYourPasswordKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	
	if([password length] < 4)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"PasswordShouldBeAtLeast4CharactersLongKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
    
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"ko"])
    {
        language = @"kr";
    }
    
	
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:kURLForRegistrationRequest]];
	request.delegate = self;
	request.requestMethod = @"POST";
	[request setPostValue:email forKey:@"user[email]"];
	[request setPostValue:username forKey:@"user[nickname]"];
	[request setPostValue:password forKey:@"user[password]"];
    [request setPostValue:language forKey:@"language"];
	[request startAsynchronous];
	[request release];
	
	[self showActivity];
}


-(void) back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        if(!mSignUpDoneCheckToPreventCrash)
        {
            [self signUp:nil];
        }
	}

	
	return YES;
}




#pragma mark -
#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
	
	NSDictionary *responseDic = [responseString JSONValue];
	NSLog(@"response - %@", responseDic);
	
	NSInteger code = [[responseDic valueForKey:@"code"] integerValue];
	if(responseDic)
	{
		if(code == 0)
		{
			NSDictionary *userInfo = [[responseDic objectForKey:@"value"] objectForKey:@"registered_user"];
			[[DataManager sharedDataManager] setUserAsLoggedInWithProfileData:userInfo]; 
		
			
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"CongratulationsYouHaveSuccessfullyRegisteredKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
			alertView.tag = 1;
			[alertView show];
			[alertView release];
			
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

	

	[self hideActivity];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"ServerRequestFailedKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	
	[self hideActivity];
}




#pragma mark -
#pragma mark UIAlertView Delegate Methods


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == 1)
	{
        
        mSignUpDoneCheckToPreventCrash = YES;
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kShouldUserBePresentedWithWelcomeScreen];
        
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationPUMPLUserDidLogin object:nil]];
		
		[(LaunchViewController *)[[self.navigationController viewControllers] objectAtIndex:0] launchTabBarControllerAnimated:NO withSelectedTabIndex:0];
        
        [self.navigationController popViewControllerAnimated:YES];

	}
}


@end
