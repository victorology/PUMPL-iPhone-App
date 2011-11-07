//
//  FacebookSettingsController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 05/10/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "FacebookSettingsController.h"
#import "DataManager.h"
#import "JSON.h"
#import "PMTabBarController.h"



@interface FacebookSettingsController (Private)

- (void)configureTheView;
- (void)buildTableData;
- (void)launchServerCallForGettingAlbumNames;
- (void)serverCallForGettingAlbumNames;

@end



@implementation FacebookSettingsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self configureTheView];
    [self launchServerCallForGettingAlbumNames];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    
    [mUserAlbumsArray release];
    [mTableData release];
    
    mRequest.delegate = nil;
    [mRequest release];
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
    
    
    UIImage *backButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageBarButtonBackButtonKey", @"") ofType:@"png"]];
    self.navigationItem.leftBarButtonItem = [UITabBarController tabBarButtonWithImage:backButtonImage
                                                                               target:self action:@selector(cancel:)];
    [backButtonImage release];
}



#pragma mark -
#pragma mark Data Methods

- (void)launchServerCallForGettingAlbumNames
{
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = @"Getting user albums";
	
	[_HUD show:YES];
	[self serverCallForGettingAlbumNames];
}

- (void)serverCallForGettingAlbumNames
{
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
	
	NSString *urlString = [NSString stringWithFormat:@"%@?id=%@&session_api=%@", kURLForGettingFacebookAlbums, idString, session_api];
	mRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	mRequest.delegate = self;
	[mRequest startAsynchronous];
}


- (void)buildTableData
{
    [mTableData release];
    mTableData = [[NSMutableArray alloc] init];
    
    

    NSString *selectedAlbumName = [[DataManager sharedDataManager] getFacebookUploadAlbumName];
    NSString *selectedAlbumID = [[DataManager sharedDataManager] getFacebookUploadAlbumID];
    
    
    
    if(selectedAlbumName && selectedAlbumID == nil)
    {
        // This means this is case that user is loading the facebook settings for the first time.
        // And for that we have to make "Mobile Photos (PUMPL)" the default selected album.
        // When the user logs in, the DataManager sets the album name as ""Mobile Photos (PUMPL)" and albumID as nil
        // That is why we reach this situation when user logs for the first time
        
        for(NSDictionary *albumDic in mUserAlbumsArray)
        {
            
            if([selectedAlbumName isEqualToString:[albumDic valueForKey:@"name"]])
            {
                selectedAlbumID = [NSString stringWithFormat:@"%@", [albumDic valueForKey:@"id"]];
                [[DataManager sharedDataManager] setFacebookUploadAlbum:selectedAlbumName withAlbumID:selectedAlbumID];
                break;
            }
        }
    }
    
    
    
    
    // Create the First section
    NSMutableDictionary *sectionDic1 = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *contentArray1 = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *rowDic1_1 = [[NSMutableDictionary alloc] init];
    if(selectedAlbumName)
    {
        [rowDic1_1 setValue:selectedAlbumName forKey:@"text"];
    }
    else
    {
        [rowDic1_1 setValue:NSLocalizedString(@"WallKey", @"") forKey:@"text"];
    }
    [rowDic1_1 setValue:[NSNumber numberWithBool:NO] forKey:@"isChecked"];
    
    [contentArray1 addObject:rowDic1_1];
    [rowDic1_1 release];
    
    [sectionDic1 setObject:contentArray1 forKey:@"contentArray"];
    [contentArray1 release];
    
    [mTableData addObject:sectionDic1];
    [sectionDic1 release];
    
    
    
    
    
    
    
    // Create the Second section
    NSMutableDictionary *sectionDic2 = [[NSMutableDictionary alloc] init];
    [sectionDic2 setValue:NSLocalizedString(@"PostToWallKey", @"") forKey:@"sectionTitle"];
    
    NSMutableArray *contentArray2 = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *rowDic2_1 = [[NSMutableDictionary alloc] init];
    [rowDic2_1 setValue:NSLocalizedString(@"WallKey", @"") forKey:@"text"];
    if(selectedAlbumName)
    {
        [rowDic2_1 setValue:[NSNumber numberWithBool:NO] forKey:@"isChecked"];
    }
    else
    {
        [rowDic2_1 setValue:[NSNumber numberWithBool:YES] forKey:@"isChecked"];
    }
    
    
    [contentArray2 addObject:rowDic2_1];
    [rowDic2_1 release];
    
    [sectionDic2 setObject:contentArray2 forKey:@"contentArray"];
    [contentArray2 release];
    
    [mTableData addObject:sectionDic2];
    [sectionDic2 release];
    
    
    
    
    
    
    
    // Create the Third section
    NSMutableDictionary *sectionDic3 = [[NSMutableDictionary alloc] init];
    [sectionDic3 setValue:NSLocalizedString(@"PostToAlbumKey", @"") forKey:@"sectionTitle"];
    
    NSMutableArray *contentArray3 = [[NSMutableArray alloc] init];
    
    for(NSDictionary *albumDic in mUserAlbumsArray)
    {
        NSMutableDictionary *rowDic3 = [[NSMutableDictionary alloc] init];
        [rowDic3 setValue:[albumDic valueForKey:@"name"] forKey:@"text"];
        if([selectedAlbumName isEqualToString:[albumDic valueForKey:@"name"]] && [[albumDic valueForKey:@"id"] longLongValue] == [selectedAlbumID longLongValue])
        {
            [rowDic3 setValue:[NSNumber numberWithBool:YES] forKey:@"isChecked"];
        }
        else
        {
            [rowDic3 setValue:[NSNumber numberWithBool:NO] forKey:@"isChecked"];
        }
        [rowDic3 setObject:albumDic forKey:@"albumDic"];
        
        
        [contentArray3 addObject:rowDic3];
        [rowDic3 release];
    }
    
    
    [sectionDic3 setObject:contentArray3 forKey:@"contentArray"];
    [contentArray3 release];
    
    if([contentArray3 count] > 0)
    {
       [mTableData addObject:sectionDic3]; 
    }
    [sectionDic3 release];
    
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [mTableData count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[mTableData objectAtIndex:section] objectForKey:@"contentArray"] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	// Configure the cell...
	
	NSDictionary *rowDic = [[[mTableData objectAtIndex:indexPath.section] objectForKey:@"contentArray"] objectAtIndex:indexPath.row];
    cell.textLabel.text = [rowDic valueForKey:@"text"];
    
    BOOL isChecked = [[rowDic valueForKey:@"isChecked"] boolValue];
    if(isChecked)
    {
        UIImage *checkedImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FacebookSettingsCheck" ofType:@"png"]];
        UIImageView *checkedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                      0,
                                                                                      checkedImage.size.width,
                                                                                      checkedImage.size.height)];
        checkedImageView.image = checkedImage;
        cell.accessoryView = checkedImageView;
        [checkedImage release];
        [checkedImageView release];
    }
    else
    {
        cell.accessoryView = nil;
    }
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *headerTitle = [[mTableData objectAtIndex:indexPath.section] valueForKey:@"sectionTitle"];
    
    NSDictionary *rowDic = [[[mTableData objectAtIndex:indexPath.section] objectForKey:@"contentArray"] objectAtIndex:indexPath.row];
    if(![[rowDic valueForKey:@"isChecked"] boolValue])
    {
        if([headerTitle isEqualToString:NSLocalizedString(@"PostToWallKey", @"")])
        {
            [[DataManager sharedDataManager] setFacebookUploadAlbum:nil withAlbumID:nil];
            
            [self buildTableData];
            [mTableView reloadData];
        }
        else if([headerTitle isEqualToString:NSLocalizedString(@"PostToAlbumKey", @"")])
        {
            NSDictionary *albumDic = [[[[mTableData objectAtIndex:indexPath.section] objectForKey:@"contentArray"] objectAtIndex:indexPath.row] objectForKey:@"albumDic"];
            
            NSString *albumName = [albumDic valueForKey:@"name"];
            NSString *albumID = [NSString stringWithFormat:@"%@", [albumDic valueForKey:@"id"]];
            [[DataManager sharedDataManager] setFacebookUploadAlbum:albumName withAlbumID:albumID];
            
            [self buildTableData];
            [mTableView reloadData];
        }
    }
    
    
}




- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[mTableData objectAtIndex:section] valueForKey:@"sectionTitle"];
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
            [mUserAlbumsArray release];
            mUserAlbumsArray = [[NSMutableArray alloc] init];
            
            NSArray *albumsArray = [responseDic valueForKey:@"value"];
            for(NSDictionary *albumDic in albumsArray)
            {
                [mUserAlbumsArray addObject:albumDic];
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
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
    [_HUD release];
	_HUD = nil;
}



#pragma mark -
#pragma mark Action Methods

- (void)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //	[self dismissModalViewControllerAnimated:YES];
}


@end
