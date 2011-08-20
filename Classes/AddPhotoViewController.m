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
#import "ApplyFilterViewController.h"


#define kCropButtonDuringFull 0
#define kCropButtonDuringSquare 1


#define kAlertViewForCameraCapability 1
#define kAlertViewForCameraRollCapability 2




@interface AddPhotoViewController (Private)

- (CameraImagePickerController *)newCameraImagePickerController;
- (LibraryImagePickerController *)newLibraryImagePickerController;

@end





@implementation AddPhotoViewController

@synthesize _cameraImagePickerController;
@synthesize _libraryImagePickerController;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-bar-logo.png"]];
	self.navigationItem.titleView = logoImageView;
	[logoImageView release];
    
    
    UIColor *backgroundColor = [[UIColor alloc] initWithRed:0.91 green:0.91 blue:0.91 alpha:1.0];
	self.view.backgroundColor = backgroundColor;
    [backgroundColor release];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    
    
    
    
    
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _selectedPhotoSource = kSelectedPhotoSourceCamera;
    
        if(!_cameraImagePickerController)
        {
            self._cameraImagePickerController = [self newCameraImagePickerController];
        }
        
        _cropButton.tag = kCropButtonDuringFull;
        [_cropButton setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
        _cropImageView.hidden = YES;
        
        
        [self presentModalViewController:_cameraImagePickerController animated:YES];
    }
    else
    {
#ifdef TARGET_IPHONE_SIMULATOR
        NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"Default.png"], @"UIImagePickerControllerOriginalImage",
                              kUTTypeImage, @"UIImagePickerControllerMediaType", nil];
        [self imagePickerController:nil didFinishPickingMediaWithInfo:info];
        return;
#endif
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YourIphoneDoesNotHaveTheCapibilityToCaptureImageKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
        alertView.tag = kAlertViewForCameraCapability;
        [alertView show];
        [alertView release];
    }
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
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
	[_cameraImagePickerController release];
    [_libraryImagePickerController release];
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)takePicture:(id)sender
{
	[_cameraImagePickerController takePicture];
}

- (IBAction)cancelImagePicker:(id)sender
{

    [_cameraImagePickerController dismissModalViewControllerAnimated:YES];
    [self.tabBarController setSelectedIndex:[[DataManager sharedDataManager] mLastSelectedTabBarIndex]]; 
}




- (IBAction)rollClicked:(id)sender
{    
    _shouldDisplayLibraryPickerOnCameraOfLibrary = YES;
    [_cameraImagePickerController dismissModalViewControllerAnimated:YES];
}


- (void)cropCameraViewClicked:(id)sender
{
	UIButton *button = (UIButton *)sender;
	if(button.tag == kCropButtonDuringFull)
	{
		button.tag = kCropButtonDuringSquare;
		[button setImage:[UIImage imageNamed:@"Full.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(237, 381, 73, 35);
		_cropImageView.hidden = NO;
	}
	else if(button.tag == kCropButtonDuringSquare)
	{
		button.tag = kCropButtonDuringFull;
		[button setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(227, 381, 83, 35);
		_cropImageView.hidden = YES;
	}
}






#pragma mark -
#pragma mark UIAlertView delegate Methods


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(alertView.tag == kAlertViewForCameraCapability)
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
		
#ifndef TARGET_IPHONE_SIMULATOR
		if(_selectedPhotoSource == kSelectedPhotoSourceCamera)
		{
			UIImageWriteToSavedPhotosAlbum(imagePicked, nil, nil, nil);
		}
#endif
        
		if(imagePicked)
		{
			
			ApplyFilterViewController *viewController = [[ApplyFilterViewController alloc] initWithNibName:@"ApplyFilterViewController" bundle:nil];
            

            viewController.wantsFullScreenLayout = YES;
			viewController.hidesBottomBarWhenPushed = YES;
			viewController.originalImage = imagePicked;
			viewController.imageClickedInSquareMode = _cropButton.tag;
			[self.navigationController pushViewController:viewController animated:YES];
			[viewController release];
			 
			
		}
	}
	
    
	[_libraryImagePickerController dismissModalViewControllerAnimated:YES];
    [_cameraImagePickerController dismissModalViewControllerAnimated:YES];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    _shouldDisplayCameraPickerOnDisappearOfLibrary = YES;
	[picker dismissModalViewControllerAnimated:YES];
}





#pragma mark -
#pragma mark CameraImagePickerController delegate Methods

- (void)cameraImagePickerControllerDisappeared
{
    if(_shouldDisplayLibraryPickerOnCameraOfLibrary)
    {
        _shouldDisplayLibraryPickerOnCameraOfLibrary = NO;
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            _selectedPhotoSource = kSelectedPhotoSourceLibrary;
            
            if(!_libraryImagePickerController)
            {
                self._libraryImagePickerController = [self newLibraryImagePickerController];
            }
            [self presentModalViewController:_libraryImagePickerController animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YourIphoneDoesNotHaveTheCapibilityToShowPhotoLibraryKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
            alertView.tag = kAlertViewForCameraRollCapability;
            [alertView show];
            [alertView release];
        }
    }
}





#pragma mark -
#pragma mark LibraryImagePickerController delegate Methods

- (void)libraryImagePickerControllerDisappeared
{
    if(_shouldDisplayCameraPickerOnDisappearOfLibrary)
    {
        _shouldDisplayCameraPickerOnDisappearOfLibrary = NO;
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            _selectedPhotoSource = kSelectedPhotoSourceCamera;
            
            if(!_cameraImagePickerController)
            {
                self._cameraImagePickerController = [self newCameraImagePickerController];
            }
            
            _cropButton.tag = kCropButtonDuringFull;
            [_cropButton setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
            _cropImageView.hidden = YES;
            
            [self presentModalViewController:_cameraImagePickerController animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YourIphoneDoesNotHaveTheCapibilityToCaptureImageKey", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OkKey", @"") otherButtonTitles:nil];
            alertView.tag = kAlertViewForCameraCapability;
            [alertView show];
            [alertView release];
        }
    }
}





#pragma mark -
#pragma mark Object Creater Methods

- (CameraImagePickerController *)newCameraImagePickerController
{
    CameraImagePickerController *pickerController = [[CameraImagePickerController alloc] init];
    
    
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.delegate = self;
    pickerController.customDelegate = self;
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    
    pickerController.showsCameraControls = NO;
    _imagePickerOverLayView.frame = CGRectMake(0, 0, 320, 480);
    pickerController.cameraOverlayView = _imagePickerOverLayView;
    
    return pickerController;
}

- (LibraryImagePickerController *)newLibraryImagePickerController
{
    LibraryImagePickerController *pickerController = [[[LibraryImagePickerController alloc] init] autorelease];
    
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    pickerController.customDelegate = self;
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    
    return pickerController;
}


@end
