//
//  EditScrollViewController.m
//  PUMPL
//
//  Created by Asad Khan on 2/13/11.
//  Copyright 2011 Semantic Notion Inc. All rights reserved.
//

#import "EditScrollViewController.h"
#import "SelectedPhotoViewController.h"



@implementation EditScrollViewController
@synthesize scrollView, imageView, selectedImage, label;



- (void)dealloc {
    [super dealloc];
	[scrollView release];
	[imageView release];
	[selectedImage release];
	[label release];
}


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
	
	//Black & White button
	UIButton *blackAndWiteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    blackAndWiteButton.frame = CGRectMake(20, 6, 57, 57); 
	blackAndWiteButton.tag = 0;
    [blackAndWiteButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:blackAndWiteButton];
	
	//Black & White label
	UILabel *blackAndWhiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 57, 72, 21)];
	blackAndWhiteLabel.text = @"Black And White";
	blackAndWhiteLabel.font = [UIFont systemFontOfSize:8];
	blackAndWhiteLabel.backgroundColor = [UIColor clearColor];
	blackAndWhiteLabel.textColor = [UIColor blackColor];
	[scrollView addSubview:blackAndWhiteLabel];
	[blackAndWhiteLabel release];
	
	//Haduri Button
	UIButton *haduriButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    haduriButton.frame = CGRectMake(100, 6, 57, 57); 
	haduriButton.tag = 1;
    [haduriButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:haduriButton];
	
	UILabel *haduriLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 57, 72, 21)];
	haduriLabel.text = @"Haduri";
	haduriLabel.font = [UIFont systemFontOfSize:8];
	haduriLabel.backgroundColor = [UIColor clearColor];
	haduriLabel.textColor = [UIColor blackColor];
	[scrollView addSubview:haduriLabel];
	[haduriLabel release];
	
	//Vintage Button
	UIButton *vintageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    vintageButton.frame = CGRectMake(180, 6, 57, 57);
	vintageButton.tag = 2;
    [vintageButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:vintageButton];
	
	UILabel *vintageLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 57, 72, 21)];
	vintageLabel.text = @"Vintage";
	vintageLabel.font = [UIFont systemFontOfSize:8];
	vintageLabel.backgroundColor = [UIColor clearColor];
	vintageLabel.textColor = [UIColor blackColor];
	[scrollView addSubview:vintageLabel];
	[vintageLabel release];
	
	//Lomo Button
	UIButton *lomoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lomoButton.frame = CGRectMake(260, 6, 57, 57); 
	lomoButton.tag = 3;
    [lomoButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:lomoButton];
	
	UILabel *lomoLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 57, 72, 21)];
	lomoLabel.text = @"Lomo";
	lomoLabel.font = [UIFont systemFontOfSize:8];
	lomoLabel.backgroundColor = [UIColor clearColor];
	lomoLabel.textColor = [UIColor blackColor];
	[scrollView addSubview:lomoLabel];
	[lomoLabel release];
	
	//Cross Processing Button
	UIButton *crossProcessingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    crossProcessingButton.frame = CGRectMake(340, 6, 57, 57); 
	crossProcessingButton.tag = 4;
    [crossProcessingButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:crossProcessingButton];
	
	UILabel *crossProcessingLabel = [[UILabel alloc] initWithFrame:CGRectMake(335, 57, 72, 21)];
	crossProcessingLabel.text = @"Cross Processing";
	crossProcessingLabel.font = [UIFont systemFontOfSize:8];
	crossProcessingLabel.backgroundColor = [UIColor clearColor];
	crossProcessingLabel.textColor = [UIColor blackColor];
	[scrollView addSubview:crossProcessingLabel];
	[crossProcessingLabel release];
	
	//Instagram Button
	UIButton *instagramButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    instagramButton.frame = CGRectMake(420, 6, 57, 57); 
	instagramButton.tag = 5;
    [instagramButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:instagramButton];
	
	UILabel *instagramLabel = [[UILabel alloc] initWithFrame:CGRectMake(430, 57, 72, 21)];
	instagramLabel.text = @"Instagram";
	instagramLabel.font = [UIFont systemFontOfSize:8];
	instagramLabel.backgroundColor = [UIColor clearColor];
	instagramLabel.textColor = [UIColor blackColor];
	[scrollView addSubview:instagramLabel];
	[instagramLabel release];
	
	//MovieEffect Button
	UIButton *movieEffectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    movieEffectButton.frame = CGRectMake(500, 6, 57, 57); 
	movieEffectButton.tag = 6;
    [movieEffectButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:movieEffectButton];
	
	UILabel *movieEffectLabel = [[UILabel alloc] initWithFrame:CGRectMake(510, 57, 72, 21)];
	movieEffectLabel.text = @"Movie Effect";
	movieEffectLabel.font = [UIFont systemFontOfSize:8];
	movieEffectLabel.backgroundColor = [UIColor clearColor];
	movieEffectLabel.textColor = [UIColor blackColor];
	[scrollView addSubview:movieEffectLabel];
	[movieEffectLabel release];
	
	//Dramatic Button
	UIButton *dramaticButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dramaticButton.frame = CGRectMake(580, 6, 57, 57); 
	dramaticButton.tag = 7;
    [dramaticButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:dramaticButton];
	
	UILabel *dramaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(590, 57, 72, 21)];
	dramaticLabel.text = @"Dramatic";
	dramaticLabel.font = [UIFont systemFontOfSize:8];
	dramaticLabel.backgroundColor = [UIColor clearColor];
	dramaticLabel.textColor = [UIColor blackColor];
	[scrollView addSubview:dramaticLabel];
	[dramaticLabel release];
	
	//Cool Warm Sepia Button
	UIButton *coolWarmSepiaButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    coolWarmSepiaButton.frame = CGRectMake(660, 6, 57, 57); 
	coolWarmSepiaButton.tag	= 8;
    [coolWarmSepiaButton addTarget:self action:@selector(filterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:coolWarmSepiaButton];
	
	UILabel *coolWarmSepiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(660, 57, 72, 21)];
	coolWarmSepiaLabel.text = @"Cool Warm Sepia";
	coolWarmSepiaLabel.font = [UIFont systemFontOfSize:8];
	coolWarmSepiaLabel.backgroundColor = [UIColor clearColor];
	coolWarmSepiaLabel.textColor = [UIColor blackColor];
	[scrollView addSubview:coolWarmSepiaLabel];
	[coolWarmSepiaLabel release];
	
	[scrollView setCanCancelContentTouches:NO];
	[scrollView setContentSize:CGSizeMake(750,78)];
	[self.imageView setImage:self.selectedImage];
	
	//Adding right side bar button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextTapped)] autorelease];
	//Add the PUMPL image to the Nav Bar
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];
	if (imageView.image.imageOrientation == UIImageOrientationLeft || imageView.image.imageOrientation == UIImageOrientationRight) {
		NSLog(@"Rotate");
		self.imageView.frame = CGRectMake(0, 40, 320, 240);
	}
	
}

- (void)nextTapped{
	NSLog(@"Save tapped");
	SelectedPhotoViewController *viewController = [[SelectedPhotoViewController alloc] initWithNibName:@"SelectedPhotoViewController" bundle:nil];
	viewController.mSelectedImage = self.imageView.image;
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction) filterButtonTapped:(id)sender{
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not implemented" message:@"Feature not implemented yet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	switch ([sender tag]) {
		case 0:
			self.label.text = @"Black & White";
			//Put respective Image filtering messages here
			break;
		case 1:
			self.label.text = @"Haduri";
			break;
		case 2:
			self.label.text = @"Vintage";
			break;
		case 3:
			self.label.text = @"Lomo";
			break;
		case 4:
			self.label.text = @"Cross Processing";
			break;
		case 5:
			self.label.text = @"Instagram";
			break;
		case 6:
			self.label.text = @"Movie Effect";
			break;
		case 7:
			self.label.text = @"Dramatic";
			break;
		case 8:
			self.label.text = @"Cool Warm Sepia";
			break;
		default:
			break;
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





@end
