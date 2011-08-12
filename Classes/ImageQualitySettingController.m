//
//  ImageQualitySettingController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 25/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "ImageQualitySettingController.h"
#import "DataManager.h"


@implementation ImageQualitySettingController

@synthesize mTableView;
@synthesize mTableData;
@synthesize mOldIndexPath;

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
	[mOldIndexPath release];
	[mTableData release];
	[mTableView release];
    [super dealloc];
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
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	NSDictionary *rowDic = [mTableData objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [rowDic valueForKey:@"textLabel"];

	BOOL isSelected = [[rowDic valueForKey:@"isSelected"] boolValue];
	if(isSelected)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		self.mOldIndexPath = indexPath;
	}
	else 
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	
	
    // Configure the cell...
    
    return cell;
}


// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if(indexPath != mOldIndexPath)
	{
		[[tableView cellForRowAtIndexPath: indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
		[[tableView cellForRowAtIndexPath: mOldIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
		self.mOldIndexPath = indexPath;
	}
}


#pragma mark -
#pragma mark Private Methods

- (void)configureTheView
{
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];
	
	mTableView.backgroundColor = [UIColor clearColor];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(save:)] autorelease];
}


#pragma mark -
#pragma mark Data Methods

- (void)buildTableData
{
	NSMutableArray *array = [NSMutableArray array];
	
	NSMutableDictionary *row1 = [NSMutableDictionary dictionary];
	[row1 setValue:@"Small" forKey:@"textLabel"];
	[row1 setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
	[row1 setValue:[NSNumber numberWithInteger:kSettingsImageQualitySmall] forKey:@"imageQuality"];
	[array addObject:row1];
	
	NSMutableDictionary *row2 = [NSMutableDictionary dictionary];
	[row2 setValue:@"Medium" forKey:@"textLabel"];
	[row2 setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
	[row2 setValue:[NSNumber numberWithInteger:kSettingsImageQualityMedium] forKey:@"imageQuality"];
	[array addObject:row2];
	
	NSMutableDictionary *row3 = [NSMutableDictionary dictionary];
	[row3 setValue:@"Full" forKey:@"textLabel"];
	[row3 setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
	[row3 setValue:[NSNumber numberWithInteger:kSettingsImageQualityFull] forKey:@"imageQuality"];
	[array addObject:row3];
	
	
	NSInteger selectedImageQuality = [[DataManager sharedDataManager] imageQualitySetting];
	switch (selectedImageQuality) 
	{
		case kSettingsImageQualitySmall:
		{
			[row1 setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
			break;
		}
			
		case kSettingsImageQualityMedium:
		{
			[row2 setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
			break;
		}
			
		case kSettingsImageQualityFull:
		{
			[row3 setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
			break;
		}
			
			
		default:
			break;
	}
	
	self.mTableData = array;
}



#pragma mark -
#pragma mark Action Methods

- (void)save:(id)sender
{
	NSInteger selectedImageQuality = [[[mTableData objectAtIndex:mOldIndexPath.row] valueForKey:@"imageQuality"] integerValue];
	[[DataManager sharedDataManager] setImageQuality:selectedImageQuality];
	[self.navigationController popViewControllerAnimated:YES];
}

@end
