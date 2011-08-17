//
//  LoginViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "LoginViewController.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "LaunchViewController.h"
#import "PasswordLostViewController.h"
#import "PMTabBarController.h"

#define kViewTagInputNameLabel 1
#define kViewTagInputTextField 2

#define kCellTypeTextField 1
#define kCellTypeOnlyLabel 2

@implementation LoginViewController

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
    
    
    UIImage *loginButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageBarButtonLoginButtonKey", @"") ofType:@"png"]];
    self.navigationItem.rightBarButtonItem = [UITabBarController tabBarButtonWithImage:loginButtonImage
                                                                                target:self action:@selector(login:)];
    [loginButtonImage release];
    
    
	
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];
    
    UIColor *backgroundColor = [[UIColor alloc] initWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
	self.view.backgroundColor = backgroundColor;
    [backgroundColor release];
	
	mActivityIndicator.hidden = YES;
	mTableView.backgroundColor = [UIColor clearColor];
	mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    
    
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 29)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    
    UIButton *forgotButton = [[UIButton alloc] initWithFrame:CGRectMake(72.5, 10, 175, 19)];
    UIImage *buttonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageButtonLostPasswordButtonKey", @"") ofType:@"png"]];
    [forgotButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [buttonImage release];
    [forgotButton addTarget:self action:@selector(forgotButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:forgotButton];
    [forgotButton release];
    
    mTableView.tableFooterView = tableFooterView;
    [tableFooterView release];
    
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
    
    if(cellType == kCellTypeTextField)
    {
        static NSString *CellIdentifier = @"Cell1";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
        
        
        
        UILabel *inputNameLabel = (UILabel *)[cell.contentView viewWithTag:kViewTagInputNameLabel];
        inputNameLabel.text = [rowDic valueForKey:@"inputName"];
        
        UITextField *inputTextField = (UITextField *)[cell.contentView viewWithTag:kViewTagInputTextField];
        inputTextField.returnKeyType = [[rowDic valueForKey:@"keyboardReturnKey"] integerValue];
        inputTextField.keyboardType = [[rowDic valueForKey:@"keyboardType"] integerValue];
        inputTextField.secureTextEntry = [[rowDic valueForKey:@"secureTextEntry"] boolValue];
    }
    else if(cellType == kCellTypeOnlyLabel)
    {
        static NSString *CellIdentifier = @"Cell2";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        // Configure the cell...
        
        
        cell.textLabel.text = [rowDic valueForKey:@"inputName"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *rowDic = [[mTableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if([[rowDic valueForKey:@"inputName"] isEqualToString:NSLocalizedString(@"LostPasswordKey", @"")])
    {
        PasswordLostViewController *viewController = [[PasswordLostViewController alloc] initWithNibName:@"PasswordLostViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}


#pragma mark -
#pragma mark Data Methods

- (void)buildTableData
{
	NSMutableArray *array = [NSMutableArray array];
	
    NSMutableArray *section1 = [NSMutableArray array];

	NSDictionary *row1 = [NSMutableDictionary dictionary];
    [row1 setValue:[NSNumber numberWithInteger:kCellTypeTextField] forKey:@"cellType"];
	[row1 setValue:NSLocalizedString(@"EmailKey", @"") forKey:@"inputName"];
	[row1 setValue:[NSNumber numberWithInt:UIKeyboardTypeEmailAddress] forKey:@"keyboardType"];
	[row1 setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:@"keyboardReturnKey"];
	[row1 setValue:[NSNumber numberWithBool:NO] forKey:@"secureTextEntry"];
	[section1 addObject:row1];
	
	NSDictionary *row2 = [NSMutableDictionary dictionary];
    [row2 setValue:[NSNumber numberWithInteger:kCellTypeTextField] forKey:@"cellType"];
	[row2 setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:@"keyboardType"];
	[row2 setValue:[NSNumber numberWithInt:UIReturnKeyGo] forKey:@"keyboardReturnKey"];
	[row2 setValue:NSLocalizedString(@"PasswordKey", @"") forKey:@"inputName"];
	[row2 setValue:[NSNumber numberWithBool:YES] forKey:@"secureTextEntry"];
	[section1 addObject:row2];
	
    [array addObject:section1];
    
    
    
    
    
//    NSMutableArray *section2 = [NSMutableArray array];
//    
//    NSDictionary *row2_1 = [NSMutableDictionary dictionary];
//    [row2_1 setValue:[NSNumber numberWithInteger:kCellTypeOnlyLabel] forKey:@"cellType"];
//	[row2_1 setValue:NSLocalizedString(@"LostPasswordKey", @"") forKey:@"inputName"];
//	[section2 addObject:row2_1];
//    
//    [array addObject:section2];
    
    
    
    
    
	self.mTableData = array;
}





#pragma mark -
#pragma mark Action Methods

- (void)login:(id)sender
{
	if([mActivityIndicator isAnimating])
	{
		return;
	}
	
	UITextField *emailTextField = [self getTextFieldForRowIndex:0];
	emailTextField.text = [emailTextField.text lowercaseString];
	NSString *email = [[emailTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([email isEqualToString:@""])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"PleaseEnterYourEmailKey", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
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
	
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:kURLForLoginRequest]];
	request.delegate = self;
	request.requestMethod = @"POST";
	[request setPostValue:email forKey:@"user[email]"];
	[request setPostValue:password forKey:@"user[password]"];
	[request startAsynchronous];
	[request release];
	
	[self showActivity];
}


-(void) back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)forgotButtonClicked:(id)sender
{
    PasswordLostViewController *viewController = [[PasswordLostViewController alloc] initWithNibName:@"PasswordLostViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
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
#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
	
	NSDictionary *responseDic = [responseString JSONValue];
	
	NSInteger code = [[responseDic valueForKey:@"code"] integerValue];
	if(code == 0)
	{
		NSDictionary *userInfo = [[responseDic objectForKey:@"value"] objectForKey:@"registered_user"];
		[[DataManager sharedDataManager] setUserAsLoggedInWithProfileData:userInfo]; 
		[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationPUMPLUserDidLogin object:nil]];
		
		[(LaunchViewController *)[[self.navigationController viewControllers] objectAtIndex:0] launchTabBarControllerAnimated:YES withSelectedTabIndex:0];
		[self.navigationController popViewControllerAnimated:YES];
	}
	else 
	{
		NSString *errorMessage = [responseDic valueForKey:@"error_message"];
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
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





@end
