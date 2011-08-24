//
//  ApplyFilterViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 02/05/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "PUMPLAppDelegate.h"
#import "PMTabBarController.h"
#import "ApplyFilterViewController.h"
#import "SelectedPhotoViewController.h"

/*
#import "UIImage+CrossProcess.h"
#import "UIImage+Photochrom.h"
#import "UIImage+Vintage.h"
#import "UIImage+Lomo.h"
#import "UIImage+Monochrome.h"
#import "UIImage+PlasticEye.h"
#import "UIImage+Polaroid.h"
#import "UIImage+Redscale.h"
 */

#import "UIImage+Resize.h"
#import "UIImage-Extensions.h"

#import "EAGLView.h"
#import "RenderTexture+Filters.h"

#define kFilterLabelWidth 80
#define kFilterLabelHeight 16
#define kPaddingBetweenFilterButtons 3
#define kFilterButtonSide 70




#define kCropButtonDuringFull 0
#define kCropButtonDuringSquare 1


#define kPercentageWidthRetainedWhileCroppingToSquare 93.75
#define kPercentageHeightRetainedWhileCroppingToSquare 70.42


static inline double radians (double degrees) {return degrees * M_PI/180;}


@interface ApplyFilterViewController (Private)

- (void)buildFilterButtonScrollView;
- (void)configureForSquareAndFull;
- (void)showApplyingFilterActivityIndicatorView;
- (void)hideApplyingFilterActivityIndicatorView;
+ (UIImage *)resizeImage:(UIImage *)image forImageQuality:(NSInteger)imageQuality;
+ (UIImage *)croppedImageToSize:(CGSize)croppedSize fromFullImage:(UIImage *)fullImage;
+ (UIImage *)cropImage:(UIImage*)sourceImage;


@end


@implementation ApplyFilterViewController

@synthesize selectedImage;
@synthesize imageClickedInSquareMode;
@synthesize fullImageForBackUp;
@synthesize squareImageForBackUp;
@synthesize originalImage;
@synthesize render;

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
	
	

	UIImage *backButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageBarButtonBackButtonKey", @"") ofType:@"png"]];
   
    self.navigationItem.leftBarButtonItem = [UITabBarController tabBarButtonWithImage:backButtonImage
                                                                               target:self action:@selector(back:)];
    [backButtonImage release];
    
    
    
    UIImage *nextButtonImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"ImageBarButtonNextButtonKey", @"") ofType:@"png"]];
    self.navigationItem.rightBarButtonItem = [UITabBarController tabBarButtonWithImage:nextButtonImage
                                                                                target:self action:@selector(next:)];
    [nextButtonImage release];
    
    
    
    
    _applyingFilterIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _applyingFilterIndicatorView.frame = CGRectMake(142, 0, 37, 37);
    [_applyingFilterView addSubview:_applyingFilterIndicatorView];
    
    _applyingFilterTextLabel.text = NSLocalizedString(@"ApplyingFilterKey", @"");

    
    
    
    
	
	[self buildFilterButtonScrollView];
	
	
	_cropButton.hidden = YES;

    EAGLContext* context = [(PUMPLAppDelegate*)[[UIApplication sharedApplication] delegate] eaglContext];
    [renderView setContext:context];
    [renderView setFramebuffer];

    
	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"ProcessingImageKey", @"");
	
    [_HUD showWhileExecuting:@selector(configureForSquareAndFull) onTarget:self withObject:nil animated:YES];
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
    [_applyingFilterIndicatorView release];
    [renderView release];
	[originalImage release];
	[squareImageForBackUp release];
	[fullImageForBackUp release];
	[selectedImage release];
    [render release];
    [super dealloc];
}


-(void) drawFilter:(int)filterTag
{
    [renderView setFramebuffer];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    CGSize imageSize = [render contentSize];
    
    CGFloat widthFactor = renderView.frame.size.width / imageSize.width;
    CGFloat heightFactor = renderView.frame.size.height / imageSize.height;
    CGFloat scaleFactor = widthFactor < heightFactor ? widthFactor : heightFactor;
    
    CGFloat w = imageSize.width*scaleFactor;
    CGFloat h = imageSize.height*scaleFactor;
    
    w = w/renderView.frame.size.width;
    h = h/renderView.frame.size.height;
    
    CGRect rect = CGRectMake(-w, -h, 2*w, 2*h);
    
	switch (filterTag) 
	{
		case kFilterTag:
		case kFilterTagNormal:
            [render drawInRect:rect];
            break;
			
		case kFilterTagXPro:
            [render drawCrossProcessInRect:rect];
			break;
			
		case kFilterTagVintage:
            [render drawVintageInRect:rect];
			break;
			
		case kFilterTagLomo:
            [render drawLomoInRect:rect];
			break;
			
		case kFilterTagPhotochrome:
            [render drawPhotochromInRect:rect];
			break;
			
		case kFilterTagMonochrome:
            [render drawMonochromeInRect:rect];
			break;
            
		case kFilterTagPlasticEye:
            [render drawPlasticEyeInRect:rect];
			break;
            
		case kFilterTagPolaroid:
            [render drawPolaroidInRect:rect];
			break;
            
		case kFilterTagRedscale:
            [render drawRedscaleInRect:rect];
			break;
            
		default:
            [render drawInRect:rect];
			break;
	}
    
    [renderView presentFramebuffer];  
}

-(UIImage*) getImageProcessedWithFilter:(int)filterTag 
{
	switch (filterTag) 
	{
		case kFilterTag:
		case kFilterTagNormal:
            return selectedImage;
			
		case kFilterTagXPro:
            [render applyCrossProcessFilter];
			break;
			
		case kFilterTagVintage:
            [render applyVintageFilter];
			break;
			
		case kFilterTagLomo:
            [render applyLomoFilter];
			break;
			
		case kFilterTagPhotochrome:
            [render applyPhotochromFilter];
			break;
			
		case kFilterTagMonochrome:
            [render applyMonochromeFilter];
			break;
            
		case kFilterTagPlasticEye:
            [render applyPlasticEyeFilter];
			break;
            
		case kFilterTagPolaroid:
            [render applyPolaroidFilter];
			break;
            
		case kFilterTagRedscale:
            [render applyRedscaleFilter];
			break;
	}
    
    return [render getUIImage];
}



- (void)buildFilterButtonScrollView
{
	NSInteger buttonYCoordinate = 36;
	NSInteger lableYCoordinate = 14;
	
	
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
	[normalButton setImage:[UIImage imageNamed:@"Normal.jpeg"] forState:UIControlStateNormal];
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
	[xProButton setImage:[UIImage imageNamed:@"Xpro.jpeg"] forState:UIControlStateNormal];
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
	[vintageButton setImage:[UIImage imageNamed:@"Vintage.jpeg"] forState:UIControlStateNormal];
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
	[lomoButton setImage:[UIImage imageNamed:@"Lomo.jpeg"] forState:UIControlStateNormal];
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
	
	
    
    
    
    
    
    //Polaroid Filter
	
	UILabel *polaroidLabel = [[UILabel alloc] initWithFrame:CGRectMake((4 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
                                                                       lableYCoordinate,
                                                                       kFilterLabelWidth,
                                                                       kFilterLabelHeight)];
	polaroidLabel.text = @"Polaroid";
	polaroidLabel.font = [UIFont boldSystemFontOfSize:11];
	polaroidLabel.textAlignment = UITextAlignmentCenter;
	polaroidLabel.textColor = [UIColor whiteColor];
	polaroidLabel.backgroundColor = [UIColor clearColor];
	
	UIButton *polaroidButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXCoordinate + polaroidLabel.frame.origin.x,
                                                                          buttonYCoordinate,
                                                                          kFilterButtonSide,
                                                                          kFilterButtonSide)];
	[polaroidButton setImage:[UIImage imageNamed:@"Roid.jpeg"] forState:UIControlStateNormal];
	polaroidButton.tag = kFilterTagPolaroid;
	[polaroidButton addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
	polaroidButton.imageView.layer.masksToBounds = YES;
	polaroidButton.imageView.layer.cornerRadius = 7.5;
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kFilterLabelWidth,
													 mFilterButtonScrollView.contentSize.height);
    
    [mFilterButtonScrollView addSubview:polaroidLabel];
	[mFilterButtonScrollView addSubview:polaroidButton];
	[polaroidLabel release];
	[polaroidButton release];
    
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kPaddingBetweenFilterButtons,
													 mFilterButtonScrollView.contentSize.height);
    
    
	
    
    
    
    
	
	//Photochrome Filter
	
	UILabel *photochromeLabel = [[UILabel alloc] initWithFrame:CGRectMake((5 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
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
	
	[photochromeButton setImage:[UIImage imageNamed:@"Photochrom.jpeg"] forState:UIControlStateNormal];
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
	
	
	
    
    
    
	
												 
    
    
    
    //////////
    
	//Redscale Filter
	
	UILabel *redscaleLabel = [[UILabel alloc] initWithFrame:CGRectMake((6 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
                                                                         lableYCoordinate,
                                                                         kFilterLabelWidth,
                                                                         kFilterLabelHeight)];
	redscaleLabel.text = @"Redscale";
	redscaleLabel.font = [UIFont boldSystemFontOfSize:11];
	redscaleLabel.textAlignment = UITextAlignmentCenter;
	redscaleLabel.textColor = [UIColor whiteColor];
	redscaleLabel.backgroundColor = [UIColor clearColor];
	
	UIButton *redscaleButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXCoordinate + redscaleLabel.frame.origin.x,
                                                                            buttonYCoordinate,
                                                                            kFilterButtonSide,
                                                                            kFilterButtonSide)];
	[redscaleButton setImage:[UIImage imageNamed:@"Redscale.jpeg"] forState:UIControlStateNormal];
	redscaleButton.tag = kFilterTagRedscale;
	[redscaleButton addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
	redscaleButton.imageView.layer.masksToBounds = YES;
	redscaleButton.imageView.layer.cornerRadius = 7.5;
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kFilterLabelWidth,
													 mFilterButtonScrollView.contentSize.height);
        
    [mFilterButtonScrollView addSubview:redscaleLabel];
	[mFilterButtonScrollView addSubview:redscaleButton];
	[redscaleLabel release];
	[redscaleButton release];

	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kPaddingBetweenFilterButtons,
													 mFilterButtonScrollView.contentSize.height);												 
    
    
	//PlasticEye Filter
	
	UILabel *plasticEyeLabel = [[UILabel alloc] initWithFrame:CGRectMake((7 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
                                                                  lableYCoordinate,
                                                                  kFilterLabelWidth,
                                                                  kFilterLabelHeight)];
	plasticEyeLabel.text = @"PlasticEye";
	plasticEyeLabel.font = [UIFont boldSystemFontOfSize:11];
	plasticEyeLabel.textAlignment = UITextAlignmentCenter;
	plasticEyeLabel.textColor = [UIColor whiteColor];
	plasticEyeLabel.backgroundColor = [UIColor clearColor];
	
	UIButton *plasticEyeButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonXCoordinate + plasticEyeLabel.frame.origin.x,
                                                                     buttonYCoordinate,
                                                                     kFilterButtonSide,
                                                                     kFilterButtonSide)];
	[plasticEyeButton setImage:[UIImage imageNamed:@"Plastic Eye.jpeg"] forState:UIControlStateNormal];
	plasticEyeButton.tag = kFilterTagPlasticEye;
	[plasticEyeButton addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventTouchUpInside];
	plasticEyeButton.imageView.layer.masksToBounds = YES;
	plasticEyeButton.imageView.layer.cornerRadius = 7.5;
	
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kFilterLabelWidth,
													 mFilterButtonScrollView.contentSize.height);
    
    [mFilterButtonScrollView addSubview:plasticEyeLabel];
	[mFilterButtonScrollView addSubview:plasticEyeButton];
	[plasticEyeLabel release];
	[plasticEyeButton release];
    
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kPaddingBetweenFilterButtons,
													 mFilterButtonScrollView.contentSize.height);												 
    
    
    
    
    
    //Monochrome Filter
	
	UILabel *monochromeLabel = [[UILabel alloc] initWithFrame:CGRectMake((8 * (kPaddingBetweenFilterButtons + kFilterLabelWidth)),
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
	[monochromeButton setImage:[UIImage imageNamed:@"Monochrome.jpeg"] forState:UIControlStateNormal];
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
    
	mFilterButtonScrollView.contentSize = CGSizeMake(mFilterButtonScrollView.contentSize.width + kPaddingBetweenFilterButtons,
													 mFilterButtonScrollView.contentSize.height);	
 													 
    
}


- (void)configureForSquareAndFull
{
	NSInteger selectedImageQuality = [[DataManager sharedDataManager] imageQualitySetting];
	
	

	
	if(imageClickedInSquareMode)
	{
		self.squareImageForBackUp = [ApplyFilterViewController croppedImageToSize:CGSizeMake(600, 600) fromFullImage:originalImage];
		
		_cropButton.hidden = YES;
		
		self.selectedImage = squareImageForBackUp;
		_contentModeToBeApplied = UIViewContentModeScaleToFill;
	}
	else 
	{
		self.fullImageForBackUp = [ApplyFilterViewController resizeImage:originalImage forImageQuality:selectedImageQuality];
		self.squareImageForBackUp = [ApplyFilterViewController croppedImageToSize:CGSizeMake(600, 600) fromFullImage:originalImage];
		
		_cropButton.hidden = NO;
		
		self.selectedImage = fullImageForBackUp;
        
        
        
		[_cropButton setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
		_cropButton.tag = kCropButtonDuringFull;
        
        if(selectedImage.size.height >= selectedImage.size.width)
            _cropButton.frame = CGRectMake(187, 275, 83, 35);
        else
            _cropButton.frame = CGRectMake(227, 235, 83, 35);
        
		_contentModeToBeApplied = UIViewContentModeScaleAspectFit;
	}
	 
    [renderView setFramebuffer];
    self.render = [[[RenderTexture alloc] initWithImage:selectedImage] autorelease];
    [self drawFilter:kFilterTagNormal];
	
	self.originalImage = nil;
	
	[_HUD hide:YES];
}


- (void)back:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)next:(id)sender
{	
	SelectedPhotoViewController *viewController = [[SelectedPhotoViewController alloc] initWithNibName:@"SelectedPhotoViewController" bundle:nil];
	viewController.mSelectedImage = [self getImageProcessedWithFilter:_filterApplied];
	viewController.wasFilterSelected = _wasFilterSelected;
	viewController.filterApplied = _filterApplied;
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];	
}



- (void)filterClicked:(id)sender
{
	UIButton *button = (UIButton *)sender;
	
    [self showApplyingFilterActivityIndicatorView];
    [self performSelector:@selector(applyFilter:) withObject:[NSNumber numberWithInteger:button.tag] afterDelay:0];
    
//	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//	[self.navigationController.view addSubview:_HUD];
//	
//    _HUD.delegate = self;
//    _HUD.labelText = NSLocalizedString(@"ApplyingFilterKey", @"");
//	
//    [_HUD showWhileExecuting:@selector(applyFilter:) onTarget:self withObject:[NSNumber numberWithInteger:button.tag] animated:YES];
}



- (void)applyFilter:(NSNumber *)filterTagNumber
{
	NSInteger filterTag = [filterTagNumber integerValue];
	
	_filterApplied = filterTag;
	
    
    if(filterTag==kFilterTag || filterTag==kFilterTagNormal) 
    {
        _wasFilterSelected = NO;
    } 
    else
    {
        _wasFilterSelected = YES;
    }
    
    [self drawFilter:filterTag];
    
    
    if(_contentModeToBeApplied == UIViewContentModeScaleToFill)
	{
		[_cropButton setImage:[UIImage imageNamed:@"Full.png"] forState:UIControlStateNormal];
        
        _cropButton.frame = CGRectMake(237, 275, 73, 35);
	}
	else 
	{
		[_cropButton setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
        
        if(selectedImage.size.height >= selectedImage.size.width)
            _cropButton.frame = CGRectMake(187, 275, 83, 35);
        else
            _cropButton.frame = CGRectMake(227, 235, 83, 35);
	}

	_cropButton.enabled = YES;
	
//	[_HUD hide:YES];
    [self hideApplyingFilterActivityIndicatorView];
}



- (IBAction)squareOrFullClicked:(id)sender
{
	_cropButton.enabled = NO;
	
	UIButton *button = (UIButton *)sender;
	if(button.tag == kCropButtonDuringFull)
	{
		button.tag = kCropButtonDuringSquare;
		_contentModeToBeApplied = UIViewContentModeScaleToFill;
		self.selectedImage = squareImageForBackUp;
	}
	else if(button.tag == kCropButtonDuringSquare)
	{
		button.tag = kCropButtonDuringFull;
		_contentModeToBeApplied = UIViewContentModeScaleAspectFit;
		self.selectedImage = fullImageForBackUp;
	}
	
    self.render = [[[RenderTexture alloc] initWithImage:selectedImage] autorelease];
	
    [self showApplyingFilterActivityIndicatorView];
    [self performSelector:@selector(applyFilter:) withObject:[NSNumber numberWithInteger:_filterApplied] afterDelay:0.1];
    
//	_HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//	[self.navigationController.view addSubview:_HUD];
//	
//    _HUD.delegate = self;
//    _HUD.labelText = NSLocalizedString(@"ApplyingFilterKey", @"");
//	
//    [_HUD showWhileExecuting:@selector(applyFilter:) onTarget:self withObject:[NSNumber numberWithInteger:_filterApplied] animated:YES];
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
#pragma mark UIImage manipulation Methods


+ (UIImage *)resizeImage:(UIImage *)image forImageQuality:(NSInteger)imageQuality
{
	UIImage *modifiedImage = nil;
	
	switch (imageQuality) 
	{
		case kSettingsImageQualitySmall:
		{
			//NSData *previousimageData = UIImagePNGRepresentation(image);
			
			//Determine the orientation of the image
			float imageWidth = [image size].width;
			float imageHeight = [image size].height;
			
			if(imageHeight >= imageWidth)
			{
				modifiedImage = [image resizedImage:CGSizeMake(600, 800) interpolationQuality:kCGInterpolationHigh];
			}
			else 
			{
				modifiedImage = [image resizedImage:CGSizeMake(800, 600) interpolationQuality:kCGInterpolationHigh];
			}
			
			//NSData *imageData = UIImagePNGRepresentation(modifiedImage);
			
			break;
		}
			
		case kSettingsImageQualityMedium:
		{
			//NSData *previousimageData = UIImagePNGRepresentation(image);
			
			//Determine the orientation of the image
			float imageWidth = [image size].width;
			float imageHeight = [image size].height;
			
			if(imageHeight >= imageWidth)
			{
				modifiedImage = [image resizedImage:CGSizeMake(900, 1200) interpolationQuality:kCGInterpolationHigh];
			}
			else 
			{
				modifiedImage = [image resizedImage:CGSizeMake(1200, 900) interpolationQuality:kCGInterpolationHigh];
			}
			
			//NSData *imageData = UIImagePNGRepresentation(modifiedImage);
			
			break;
		}
			
		case kSettingsImageQualityFull:
		{
			modifiedImage = image;
			break;
		}
			
		default:
			break;
	}
	
	return modifiedImage;
}



+ (UIImage *)croppedImageToSize:(CGSize)croppedSize fromFullImage:(UIImage *)fullImage
{
	//Crop Image Code
	UIImage *resizedCroppedImage = nil;
	
	UIImage *croppedImage = [ApplyFilterViewController cropImage:fullImage];
	resizedCroppedImage = [croppedImage resizedImage:croppedSize interpolationQuality:kCGInterpolationHigh];
	
	return resizedCroppedImage;
}






+(UIImage*)cropImage:(UIImage*)sourceImage {
	
	UIImage *imageToBeCropped = nil;
	BOOL needsOrientationChangeInTheEnd = NO;
	UIImageOrientation originalImageOrientation = sourceImage.imageOrientation;
	

	
	if(sourceImage.imageOrientation == UIImageOrientationLeft) 
	{
		imageToBeCropped = [UIImage imageWithCGImage:[sourceImage CGImage] scale:1.0 orientation:UIImageOrientationUp];
		needsOrientationChangeInTheEnd = YES;
    } 
	else if(sourceImage.imageOrientation == UIImageOrientationRight) 
	{
		imageToBeCropped = [UIImage imageWithCGImage:[sourceImage CGImage] scale:1.0 orientation:UIImageOrientationUp];
		needsOrientationChangeInTheEnd = YES;
    } 
	else if(sourceImage.imageOrientation == UIImageOrientationUp) 
	{
		imageToBeCropped = sourceImage;
    } 
	else if(sourceImage.imageOrientation == UIImageOrientationDown) 
	{
		imageToBeCropped = sourceImage;
    }
	
	
	CGSize sizeOfOriginalImage = [imageToBeCropped size];
	
	CGFloat widthOfOriginalImage = sizeOfOriginalImage.width;
	CGFloat heightOfOriginalImage = sizeOfOriginalImage.height;
	
	CGFloat reducedSide;
	if(widthOfOriginalImage <= heightOfOriginalImage)
	{
		reducedSide = (kPercentageWidthRetainedWhileCroppingToSquare / 100) * widthOfOriginalImage;
	}
	else 
	{
		reducedSide = (kPercentageWidthRetainedWhileCroppingToSquare / 100) * heightOfOriginalImage;
	}

	
	
	
	CGFloat croppedImageXCoordinates = (widthOfOriginalImage - reducedSide) / 2;
	CGFloat croppedImageYCoordinates = (heightOfOriginalImage - reducedSide) / 2;
	
	CGRect rect = CGRectMake(croppedImageXCoordinates, croppedImageYCoordinates, reducedSide, reducedSide);
	
	
	
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToBeCropped CGImage], rect);
	
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
#ifdef TARGET_IPHONE_SIMULATOR    
    bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif     
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    CGContextRef bitmap = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
	
    if (imageToBeCropped.imageOrientation == UIImageOrientationLeft) {
        
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -rect.size.height);
		
    } else if (imageToBeCropped.imageOrientation == UIImageOrientationRight) {
		
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -rect.size.width, 0);
	
		
    } else if (imageToBeCropped.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (imageToBeCropped.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, rect.size.width, rect.size.height);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
	
    CGContextDrawImage(bitmap, CGRectMake(0, 0, rect.size.width, rect.size.height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	
    UIImage *resultImage=[UIImage imageWithCGImage:ref];
    CGImageRelease(imageRef);
    CGContextRelease(bitmap);
    CGImageRelease(ref);
	
	
	
	UIImage *resultFinallyRotatedImage = nil;
	
	if(needsOrientationChangeInTheEnd)
	{
		resultFinallyRotatedImage = [UIImage imageWithCGImage:[resultImage CGImage] scale:1.0 orientation:originalImageOrientation];
	}
	else
	{
		resultFinallyRotatedImage = resultImage;
	}
	
	
    return resultFinallyRotatedImage;	
}




#pragma mark -
#pragma mark UIActivity Indicator View manipulation Methods

- (void)showApplyingFilterActivityIndicatorView
{
    _applyingFilterView.frame = CGRectMake(0, 200, 320, 69);
    [self.view addSubview:_applyingFilterView];
    [_applyingFilterIndicatorView startAnimating];
}


- (void)hideApplyingFilterActivityIndicatorView
{
    [_applyingFilterIndicatorView stopAnimating];
    [_applyingFilterView removeFromSuperview];
}




@end
