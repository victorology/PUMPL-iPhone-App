//
//  PasswordLostViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 28/06/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "PasswordLostViewController.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "LaunchViewController.h"

#define kViewTagInputNameLabel 1
#define kViewTagInputTextField 2

@implementation PasswordLostViewController

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
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStyleBordered target:self action:@selector(lostPassword:)] autorelease];
	
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];
	
	mActivityIndicator.hidden = YES;
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
    inputTextField.placeholder = @"Required";
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
	[row1 setValue:@"Email" forKey:@"inputName"];
	[row1 setValue:[NSNumber numberWithInt:UIKeyboardTypeEmailAddress] forKey:@"keyboardType"];
	[row1 setValue:[NSNumber numberWithInt:UIReturnKeyGo] forKey:@"keyboardReturnKey"];
	[row1 setValue:[NSNumber numberWithBool:NO] forKey:@"secureTextEntry"];
	[array addObject:row1];
	

	
	self.mTableData = array;
}





#pragma mark -
#pragma mark Action Methods

- (void)lostPassword:(id)sender
{
	if([mActivityIndicator isAnimating])
	{
		return;
	}
	
	NSString *email = [[[self getTextFieldForRowIndex:0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if([email isEqualToString:@""])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You cannot leave email blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	
	
	
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:kURLForLostPassword]];
	request.delegate = self;
	request.requestMethod = @"POST";
	[request setPostValue:email forKey:@"users[email]"];
	[request startAsynchronous];
	[request release];
	
	[self showActivity];
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
		[self lostPassword:nil];
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
	if(responseDic)
	{
		if(code == 0)
		{
			BOOL success = [[[responseDic objectForKey:@"value"] objectForKey:@"send_reset_link"] boolValue];
			
			if(success)
			{
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Your password has been reset and sent to your email address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				alertView.tag = 1;
				[alertView show];
				[alertView release];
			}
			else 
			{
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error in reseting the password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}

			
		}
		else 
		{
			NSString *errorMessage = [responseDic valueForKey:@"error_message"];
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
	}
	else 
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown server response" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	
	
	[self hideActivity];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Server Request Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
		[self.navigationController popViewControllerAnimated:YES];
	}
}



@end
