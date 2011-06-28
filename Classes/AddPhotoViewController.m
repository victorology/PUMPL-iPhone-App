//
//  AddPhotoViewController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 10/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "AddPhotoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SelectedPhotoViewController.h"
#import "EditScrollViewController.h"
#import "ApplyFilterViewController.h"


#define kCropButtonDuringFull 0
#define kCropButtonDuringSquare 1











@implementation AddPhotoViewController

@synthesize _imagePickerController;

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
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
	//[actionSheet showInView:self.tabBarController.tabBar];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
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
	[_imagePickerController release];
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)takePicture:(id)sender
{
	[_imagePickerController takePicture];
}

- (IBAction)cancelImagePicker:(id)sender
{
	
	 

	[_imagePickerController dismissModalViewControllerAnimated:YES];
	self._imagePickerController = nil;
}


- (void)cropCameraViewClicked:(id)sender
{
	UIButton *button = (UIButton *)sender;
	if(button.tag == kCropButtonDuringFull)
	{
		button.tag = kCropButtonDuringSquare;
		[button setImage:[UIImage imageNamed:@"Full.png"] forState:UIControlStateNormal];
		_cropImageView.hidden = NO;
	}
	else if(button.tag == kCropButtonDuringSquare)
	{
		button.tag = kCropButtonDuringFull;
		[button setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
		_cropImageView.hidden = YES;
	}
}



#pragma mark -
#pragma mark UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0)
	{
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		{
			_selectedPhotoSource = kSelectedPhotoSourceCamera;
			
		
			
			UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
			self._imagePickerController = pickerController;
			[pickerController release];
			
			pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
			pickerController.delegate = self;
			pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
			
			
			_cropButton.tag = kCropButtonDuringFull;
			[_cropButton setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
			_cropImageView.hidden = YES;
			
			pickerController.showsCameraControls = NO;
			_imagePickerOverLayView.frame = CGRectMake(0, 0, 320, 480);
			pickerController.cameraOverlayView = _imagePickerOverLayView;
			
			[self presentModalViewController:pickerController animated:YES];
			
			
		}
		else
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your iphone does not have the capibility to capture image." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
	}
	else if(buttonIndex == 1)
	{
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
		{
			_selectedPhotoSource = kSelectedPhotoSourceLibrary;
			
			UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
			self._imagePickerController = pickerController;
			[pickerController release];
			
			_cropButton.tag = kCropButtonDuringFull;
			[_cropButton setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
			_cropImageView.hidden = YES;
			
			pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			pickerController.delegate = self;
			pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
			[self presentModalViewController:pickerController animated:YES];
		}
		else
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your iphone does not have the capibility to show photo library." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
	}
	else if(buttonIndex == 2)
	{
		[self.tabBarController setSelectedIndex:[[DataManager sharedDataManager] mLastSelectedTabBarIndex]];
	}
}




#pragma mark -
#pragma mark UIPickerView Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	if([[info valueForKey:@"UIImagePickerControllerMediaType"] isEqualToString:(NSString *)kUTTypeImage])
	{
		UIImage *imagePicked = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
		
		if(_selectedPhotoSource == kSelectedPhotoSourceCamera)
		{
			UIImageWriteToSavedPhotosAlbum(imagePicked, nil, nil, nil);
		}
		
		if(imagePicked)
		{
			
			ApplyFilterViewController *viewController = [[ApplyFilterViewController alloc] initWithNibName:@"ApplyFilterViewController" bundle:nil];
			viewController.hidesBottomBarWhenPushed = YES;
			viewController.originalImage = imagePicked;
			viewController.imageClickedInSquareMode = _cropButton.tag;
			[self.navigationController pushViewController:viewController animated:NO];
			[viewController release];
			 
			
		}
	}
	
	[picker dismissModalViewControllerAnimated:YES];
	self._imagePickerController = nil;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	
	/*
	UIImage *imagePicked = [UIImage imageNamed:@"vertical.jpg"];
	//UIImage *imagePicked = [UIImage imageNamed:@"horizontal.jpg"];
	UIImageWriteToSavedPhotosAlbum(imagePicked, nil, nil, nil);
	
	
	
	if(imagePicked)
	{
		//NSInteger selectedImageQuality = [[DataManager sharedDataManager] imageQualitySetting];
		
		
		ApplyFilterViewController *viewController = [[ApplyFilterViewController alloc] initWithNibName:@"ApplyFilterViewController" bundle:nil];
		viewController.hidesBottomBarWhenPushed = YES;
		viewController.originalImage = imagePicked;
		viewController.imageClickedInSquareMode = NO;
		[self.navigationController pushViewController:viewController animated:NO];
		[viewController release];
		
	}
	*/
	 
	
	[picker dismissModalViewControllerAnimated:YES];
}













@end
