//
//  ApplyFilterViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 02/05/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "ApplyFilterViewController.h"
#import "SelectedPhotoViewController.h"
#import "UIImage+CrossProcess.h"
#import "UIImage+Photochrom.h"
#import "UIImage+Vintage.h"
#import "UIImage+Lomo.h"
#import "UIImage+Monochrome.h"


#define kFilterLabelWidth 80
#define kFilterLabelHeight 16
#define kPaddingBetweenFilterButtons 3
#define kFilterButtonSide 60

#define kFilterTagNormal 1
#define kFilterTagXPro 2
#define kFilterTagVintage 3
#define kFilterTagLomo 4
#define kFilterTagPhotochrome 5
#define kFilterTagMonochrome 6


@interface ApplyFilterViewController (Private)

- (void)buildFilterButtonScrollView;
- (void)configureImageViewForOrientation;

@end


@implementation ApplyFilterViewController

@synthesize selectedImage;
@synthesize finalImage;

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
	
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];
	
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(next:)] autorelease];
	
	
	[self buildFilterButtonScrollView];
	[self configureImageViewForOrientation];
	
	
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
	[finalImage release];
	[selectedImage release];
    [super dealloc];
}



- (void)buildFilterButtonScrollView
{
	NSInteger buttonYCoordinate = 26;
	NSInteger lableYCoordinate = 4;
	
	
	NSInteger buttonXCoordinate = (kFilterLabelWidth - kFilterButtonSide) / 2;
	
	
	//Set the content size of the scrollview to zero
	mFilterButtonScrollView.contentSize = CGSizeMake(0, mFilterButtonScrollView.frame.size.height);
	mFilterButtonScrollView.showsHorizontalScrollIndicator = NO;
	
	
	//Normal Fitler
	
	UILabel *normalLabel = [[UILabel alloc] initWithFrame:CGRectMake((0 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
																	 lableYCoordinate,
																	 kFilterLabelWidth,
																	 kFilterLabelHeight)];
	normalLabel.text = @"Normal";
	normalLabel.font = [UIFont boldSystemFontOfSize:11];
	normalLabel.textAlignment = UITextAlignmentCenter;
	normalLabel.textColor = [UIColor whiteColor];
	normalLabel.backgroundColor = [UIColor clearColor];
	
	
	UIButton *normalButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXCoordinate + normalLabel.frame.origin.x,
																		buttonYCoordinate,
																		kFilterButtonSide,
																		kFilterButtonSide)];
	[normalButton setImage:[UIImage imageNamed:@"normal.jpg"] forState:UIControlStateNormal];
	normalButton.tag = kFilterTagNormal;
	[normalButton addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
	normalButton.imageView.layer.masksToBounds = YES;
	normalButton.imageView.layer.cornerRadius = 7.5;
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kFilterLabelWidth,
													 mFilterButtonScrollView.contentSize.height);
	
	[mFilterButtonScrollView addSubview:normalLabel];
	[mFilterButtonScrollView addSubview:normalButton];
	[normalLabel release];
	[normalButton release];
	 
	
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kPaddingBetweenFilterButtons,
													 mFilterButtonScrollView.contentSize.height);
	
	
	
	
	//XPro Filter
	
	UILabel *xProLabel = [[UILabel alloc] initWithFrame:CGRectMake((1 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
																	 lableYCoordinate,
																	 kFilterLabelWidth,
																	 kFilterLabelHeight)];
	xProLabel.text = @"XPro";
	xProLabel.font = [UIFont boldSystemFontOfSize:11];
	xProLabel.textAlignment = UITextAlignmentCenter;
	xProLabel.textColor = [UIColor whiteColor];
	xProLabel.backgroundColor = [UIColor clearColor];
	
	UIButton *xProButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXCoordinate + xProLabel.frame.origin.x,
																		buttonYCoordinate,
																		kFilterButtonSide,
																		kFilterButtonSide)];
	[xProButton setImage:[UIImage imageNamed:@"xpro.jpg"] forState:UIControlStateNormal];
	xProButton.tag = kFilterTagXPro;
	[xProButton addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
	xProButton.imageView.layer.masksToBounds = YES;
	xProButton.imageView.layer.cornerRadius = 7.5;
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kFilterLabelWidth,
													 mFilterButtonScrollView.contentSize.height);
	
	[mFilterButtonScrollView addSubview:xProLabel];
	[mFilterButtonScrollView addSubview:xProButton];
	[xProLabel release];
	[xProButton release];
	
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kPaddingBetweenFilterButtons,
													 mFilterButtonScrollView.contentSize.height);
	
	
	
	
	
	//Vintage Filter
	
	UILabel *vintageLabel = [[UILabel alloc] initWithFrame:CGRectMake((2 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
																   lableYCoordinate,
																   kFilterLabelWidth,
																   kFilterLabelHeight)];
	vintageLabel.text = @"Vintage";
	vintageLabel.font = [UIFont boldSystemFontOfSize:11];
	vintageLabel.textAlignment = UITextAlignmentCenter;
	vintageLabel.textColor = [UIColor whiteColor];
	vintageLabel.backgroundColor = [UIColor clearColor];
	
	UIButton *vintageButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXCoordinate + vintageLabel.frame.origin.x,
																	  buttonYCoordinate,
																	  kFilterButtonSide,
																	  kFilterButtonSide)];
	[vintageButton setImage:[UIImage imageNamed:@"vintage.jpg"] forState:UIControlStateNormal];
	vintageButton.tag = kFilterTagVintage;
	[vintageButton addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
	vintageButton.imageView.layer.masksToBounds = YES;
	vintageButton.imageView.layer.cornerRadius = 7.5;
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kFilterLabelWidth,
													 mFilterButtonScrollView.contentSize.height);
	
	[mFilterButtonScrollView addSubview:vintageLabel];
	[mFilterButtonScrollView addSubview:vintageButton];
	[vintageLabel release];
	[vintageButton release];
													 
													 
													 
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kPaddingBetweenFilterButtons,
													 mFilterButtonScrollView.contentSize.height);												 
	
	
	
	
	//Lomo Filter
	
	UILabel *lomoLabel = [[UILabel alloc] initWithFrame:CGRectMake((3 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
																	  lableYCoordinate,
																	  kFilterLabelWidth,
																	  kFilterLabelHeight)];
	lomoLabel.text = @"Lomo";
	lomoLabel.font = [UIFont boldSystemFontOfSize:11];
	lomoLabel.textAlignment = UITextAlignmentCenter;
	lomoLabel.textColor = [UIColor whiteColor];
	lomoLabel.backgroundColor = [UIColor clearColor];
	
	UIButton *lomoButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXCoordinate + lomoLabel.frame.origin.x,
																		 buttonYCoordinate,
																		 kFilterButtonSide,
																		 kFilterButtonSide)];
	[lomoButton setImage:[UIImage imageNamed:@"lomo.jpg"] forState:UIControlStateNormal];
	lomoButton.tag = kFilterTagLomo;
	[lomoButton addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
	lomoButton.imageView.layer.masksToBounds = YES;
	lomoButton.imageView.layer.cornerRadius = 7.5;
	
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kFilterLabelWidth,
													 mFilterButtonScrollView.contentSize.height);
	
	[mFilterButtonScrollView addSubview:lomoLabel];
	[mFilterButtonScrollView addSubview:lomoButton];
	[lomoLabel release];
	[lomoButton release];
	
	
	
	
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kPaddingBetweenFilterButtons,
													 mFilterButtonScrollView.contentSize.height);												 
	
	
	
	
	//Photochrome Filter
	
	UILabel *photochromeLabel = [[UILabel alloc] initWithFrame:CGRectMake((4 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
																   lableYCoordinate,
																   kFilterLabelWidth,
																   kFilterLabelHeight)];
	photochromeLabel.text = @"Photochrom";
	photochromeLabel.font = [UIFont boldSystemFontOfSize:11];
	photochromeLabel.textAlignment = UITextAlignmentCenter;
	photochromeLabel.textColor = [UIColor whiteColor];
	photochromeLabel.backgroundColor = [UIColor clearColor];
	
	UIButton *photochromeButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXCoordinate + photochromeLabel.frame.origin.x,
																	  buttonYCoordinate,
																	  kFilterButtonSide,
																	  kFilterButtonSide)];
	
	[photochromeButton setImage:[UIImage imageNamed:@"photochrom.jpg"] forState:UIControlStateNormal];
	photochromeButton.tag = kFilterTagPhotochrome;
	[photochromeButton addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
	photochromeButton.imageView.layer.masksToBounds = YES;
	photochromeButton.imageView.layer.cornerRadius = 7.5;
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kFilterLabelWidth,
													 mFilterButtonScrollView.contentSize.height);
	
	[mFilterButtonScrollView addSubview:photochromeLabel];
	[mFilterButtonScrollView addSubview:photochromeButton];
	[photochromeLabel release];
	[photochromeButton release];
	
	
	
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kPaddingBetweenFilterButtons,
													 mFilterButtonScrollView.contentSize.height);												 
	
	
	
	
	//Monochrome Filter
	
	UILabel *monochromeLabel = [[UILabel alloc] initWithFrame:CGRectMake((5 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
																		  lableYCoordinate,
																		  kFilterLabelWidth,
																		  kFilterLabelHeight)];
	monochromeLabel.text = @"Monochrome";
	monochromeLabel.font = [UIFont boldSystemFontOfSize:11];
	monochromeLabel.textAlignment = UITextAlignmentCenter;
	monochromeLabel.textColor = [UIColor whiteColor];
	monochromeLabel.backgroundColor = [UIColor clearColor];
	
	UIButton *monochromeButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXCoordinate + monochromeLabel.frame.origin.x,
																			 buttonYCoordinate,
																			 kFilterButtonSide,
																			 kFilterButtonSide)];
	[monochromeButton setImage:[UIImage imageNamed:@"monochrome.jpg"] forState:UIControlStateNormal];
	monochromeButton.tag = kFilterTagMonochrome;
	[monochromeButton addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
	monochromeButton.imageView.layer.masksToBounds = YES;
	monochromeButton.imageView.layer.cornerRadius = 7.5;
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kFilterLabelWidth,
													 mFilterButtonScrollView.contentSize.height);
	
	
	
	[mFilterButtonScrollView addSubview:monochromeLabel];
	[mFilterButtonScrollView addSubview:monochromeButton];
	[monochromeLabel release];
	[monochromeButton release];
	
}


- (void)configureImageViewForOrientation
{
	if(selectedImage.size.height >= selectedImage.size.width)
	{
		mSelectedImageView.frame = CGRectMake(40, 0, 240, 320);
	}
	else
	{
		mSelectedImageView.frame = CGRectMake(0, 40, 320, 240);
	}

	self.finalImage = selectedImage;
	mSelectedImageView.image = finalImage;
}


- (void)next:(id)sender
{
	SelectedPhotoViewController *viewController = [[SelectedPhotoViewController alloc] initWithNibName:@"SelectedPhotoViewController" bundle:nil];
	viewController.mSelectedImage = finalImage;
	viewController.wasFilterSelected = _wasFilterSelected;
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)filterClicked:(id)sender
{
	UIButton *button = (UIButton *)sender;
	
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = @"Applying Filter";
	
    [_HUD showWhileExecuting:@selector(applyFilter:) onTarget:self withObject:[NSNumber numberWithInteger:button.tag] animated:YES];
}



- (void)applyFilter:(NSNumber *)filterTagNumber
{
	NSInteger filterTag = [filterTagNumber integerValue];
	
	switch (filterTag) 
	{
		case kFilterTagNormal:
		{
			self.finalImage = selectedImage;
			_wasFilterSelected = NO;
			break;
		}
			
		case kFilterTagXPro:
		{
			self.finalImage = [selectedImage imageByApplyingCrossProcessFilter];
			_wasFilterSelected = YES;
			break;
		}
			
		case kFilterTagVintage:
		{
			self.finalImage = [selectedImage imageByApplyingVintageFilter];
			_wasFilterSelected = YES;
			break;
		}
			
		case kFilterTagLomo:
		{
			self.finalImage = [selectedImage imageByApplyingLomoFilter];
			_wasFilterSelected = YES;
			break;
		}
			
		case kFilterTagPhotochrome:
		{
			self.finalImage = [selectedImage imageByApplyingPhotochromFilter];
			_wasFilterSelected = YES;
			break;
		}
			
		case kFilterTagMonochrome:
		{
			self.finalImage = [selectedImage imageByApplyingMonochromeFilter];
			_wasFilterSelected = YES;
			break;
		}
			
		default:
			break;
	}
	
	mSelectedImageView.image = finalImage;
	
	[_HUD hide:YES];
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
