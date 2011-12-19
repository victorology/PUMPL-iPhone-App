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


#define kFlashOptionButtonTagAuto 1
#define kFlashOptionButtonTagOn 2
#define kFlashOptionButtonTagOff 3




@interface AddPhotoViewController (Private)

- (CameraImagePickerController *)newCameraImagePickerController;
- (LibraryImagePickerController *)newLibraryImagePickerController;
- (void)checkAndConfigureTheCameraControlsForDifferentVersionsOfDevice;
- (void)configureFlashCameraControlsForCameraDevice:(UIImagePickerControllerCameraDevice)device forPickerController:(UIImagePickerController *)controller;
- (void)showFlashOptionsViewAnimated:(BOOL)animated;
- (void)hideFlashOptionsViewAnimated:(BOOL)animated;
- (void)showFlashStatusButtonForStatus:(NSInteger)flashOption Animated:(BOOL)animated;
- (void)hideFlashStatusButtonAnimated:(BOOL)animated;
- (void)showCropButtonAnimated:(BOOL)animated;
- (void)hideCropButtonAnimated:(BOOL)animated;


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
    
    
    _shouldDisplayCameraPickerInViewWillAppear = YES;
    

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    
#if TARGET_IPHONE_SIMULATOR
    
    [self performSelector:@selector(presentCameraImagePickerController)];
    
#else
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:_HUD];
	
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"PleaseWaitKey", @"");
	
	[_HUD show:YES];
    [self performSelector:@selector(presentCameraImagePickerController) withObject:nil afterDelay:0.01];
    
#endif
    

    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}



- (void)presentCameraImagePickerController
{
    if(_shouldDisplayCameraPickerInViewWillAppear)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            _selectedPhotoSource = kSelectedPhotoSourceCamera;
            
            if(!_cameraImagePickerController)
            {
                self._cameraImagePickerController = [self newCameraImagePickerController];
            }
            
            
            
            
            
            _cropButton.tag = kCropButtonDuringFull;
            [_cropButton setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
            _cropButton.frame = CGRectMake(119, 10, 82, 34);
            _cropImageView.hidden = YES;
            
            
            [self presentModalViewController:_cameraImagePickerController animated:YES];
        }
        else
        {
#if TARGET_IPHONE_SIMULATOR
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
    }
    else
    {
        _shouldDisplayCameraPickerInViewWillAppear = YES;
    } 
    
    
    [_HUD hide:YES];
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
    [_currentFlashOptionButton release];
    [_flashOptionsView release];
	[_cameraImagePickerController release];
    [_libraryImagePickerController release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIConfiguration Methods


- (void)checkAndConfigureTheCameraControlsForDifferentVersionsOfDevice
{
    // Lets first check whether there is additional front camera or not
    BOOL isFrontCameraAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    
    if(isFrontCameraAvailable)
    {
        UIButton *switchCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(241,
                                                                                  10,
                                                                                  69,
                                                                                  34)];
        UIImage *switchCameraImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SelfCamera" ofType:@"png"]];
        [switchCameraButton setImage:switchCameraImage forState:UIControlStateNormal];
        [switchCameraImage release];
        
        [switchCameraButton addTarget:self action:@selector(switchCameraClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_imagePickerOverLayView addSubview:switchCameraButton];
        [switchCameraButton release];
    }

}


- (void)configureFlashCameraControlsForCameraDevice:(UIImagePickerControllerCameraDevice)device forPickerController:(UIImagePickerController *)controller
{
//    UIImagePickerControllerCameraDevice newCamera = 0;
//    
//    if(device == UIImagePickerControllerCameraDeviceRear)
//    {
//        newCamera = UIImagePickerControllerCameraDeviceFront;
//    }
//    else if(device == UIImagePickerControllerCameraDeviceFront)
//    {
//        newCamera = UIImagePickerControllerCameraDeviceRear;
//    }
    
    
    
    // Remove the flash options if visible in any case
    [self hideFlashOptionsViewAnimated:YES];
    
    
    BOOL isFlashAvailable = [UIImagePickerController isFlashAvailableForCameraDevice:device];
    
    if(isFlashAvailable)
    {
        UIImagePickerControllerCameraFlashMode flashMode = controller.cameraFlashMode;
        
        NSInteger flashModeToShow = 0;
        if(flashMode == UIImagePickerControllerCameraFlashModeAuto)
        {
            flashModeToShow = kFlashOptionButtonTagAuto;
        }
        else if(flashMode == UIImagePickerControllerCameraFlashModeOn)
        {
            flashModeToShow = kFlashOptionButtonTagOn;
        }
        else if(flashMode == UIImagePickerControllerCameraFlashModeOff)
        {
            flashModeToShow = kFlashOptionButtonTagOff;
        }
        
        [self showFlashStatusButtonForStatus:flashModeToShow Animated:YES];
    }
    else
    {
        [self hideFlashStatusButtonAnimated:YES];
    }
}


- (void)showFlashStatusButtonForStatus:(NSInteger)flashOption Animated:(BOOL)animated
{
    if(_currentFlashOptionButton == nil)
    {
        _currentFlashOptionButton = [[UIButton alloc] init];
        [_currentFlashOptionButton addTarget:self action:@selector(currentFlashStatusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         
                         _currentFlashOptionButton.alpha = 0.0;
                     } 
                     completion:^(BOOL finished) {
                         
                         if(_currentFlashOptionButton.superview == nil)
                         {
                             _currentFlashOptionButton.alpha = 0.0;
                             [_imagePickerOverLayView addSubview:_currentFlashOptionButton];
                         }
                         
                         
                         if(flashOption == kFlashOptionButtonTagAuto)
                         {
                             UIImage *flashAutoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FlashAuto" ofType:@"png"]];
                             [_currentFlashOptionButton setImage:flashAutoImage forState:UIControlStateNormal];
                             [flashAutoImage release];
                             
                             _currentFlashOptionButton.frame = CGRectMake(10,
                                                                          10,
                                                                          80,
                                                                          34);
                         }
                         else if(flashOption == kFlashOptionButtonTagOn)
                         {
                             UIImage *flashAutoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FlashOn" ofType:@"png"]];
                             [_currentFlashOptionButton setImage:flashAutoImage forState:UIControlStateNormal];
                             [flashAutoImage release];
                             
                             _currentFlashOptionButton.frame = CGRectMake(10,
                                                                          10,
                                                                          67,
                                                                          34);
                         }
                         else if(flashOption == kFlashOptionButtonTagOff)
                         {
                             UIImage *flashAutoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FlashOff" ofType:@"png"]];
                             [_currentFlashOptionButton setImage:flashAutoImage forState:UIControlStateNormal];
                             [flashAutoImage release];
                             
                             _currentFlashOptionButton.frame = CGRectMake(10,
                                                                          10,
                                                                          68,
                                                                          34);
                         }
                         
                         
                         [UIView animateWithDuration:0.3
                                               delay:0.0
                                             options:UIViewAnimationCurveLinear
                                          animations:^{
                                              
                                              _currentFlashOptionButton.alpha = 1.0;
                                          } 
                                          completion:^(BOOL finished) {
                                              
                                          }];
                         
                         
                     }];
    
    
    
    
    
}

- (void)hideFlashStatusButtonAnimated:(BOOL)animated
{
    if(animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             
                             _currentFlashOptionButton.alpha = 0.0;
                         } 
                         completion:^(BOOL finished) {
                             
                             [_currentFlashOptionButton removeFromSuperview];
                             _currentFlashOptionButton.alpha = 1.0;
                         }];
    }
    else
    {
        
    }
}


- (void)showFlashOptionsViewAnimated:(BOOL)animated
{
    if(_flashOptionsView == nil)
    {
        _flashOptionsView = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                                     10,
                                                                     192,
                                                                     35)];
        _flashOptionsView.backgroundColor = [UIColor clearColor];
        
        UIImage *flashOptionAutoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flashOptionsViewAutoButton" ofType:@"png"]];
        UIButton *autoButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          82,
                                                                          35)];
        autoButton.tag = kFlashOptionButtonTagAuto;
        [autoButton setImage:flashOptionAutoImage forState:UIControlStateNormal];
        [flashOptionAutoImage release];
        [autoButton addTarget:self action:@selector(flashOptionsSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_flashOptionsView addSubview:autoButton];
        [autoButton release];
        
        
        
        UIImage *flashOptionOnImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flashOptionsViewOnButton" ofType:@"png"]];
        UIButton *onButton = [[UIButton alloc] initWithFrame:CGRectMake(82,
                                                                        0,
                                                                        55,
                                                                        35)];
        onButton.tag = kFlashOptionButtonTagOn;
        [onButton setImage:flashOptionOnImage forState:UIControlStateNormal];
        [flashOptionOnImage release];
        [onButton addTarget:self action:@selector(flashOptionsSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_flashOptionsView addSubview:onButton];
        [onButton release];
        
        
        
        UIImage *flashOptionOffImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flashOptionsViewOffButton" ofType:@"png"]];
        UIButton *offButton = [[UIButton alloc] initWithFrame:CGRectMake(137,
                                                                         0,
                                                                         55,
                                                                         35)];
        offButton.tag = kFlashOptionButtonTagOff;
        [offButton setImage:flashOptionOffImage forState:UIControlStateNormal];
        [flashOptionOffImage release];
        [offButton addTarget:self action:@selector(flashOptionsSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_flashOptionsView addSubview:offButton];
        [offButton release];
    }
    
    
    if(animated)
    {
        
        _flashOptionsView.alpha = 0.0;
        [_imagePickerOverLayView addSubview:_flashOptionsView];
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             
                             _flashOptionsView.alpha = 1.0;
                         } 
                         completion:^(BOOL finished) {
                             
                         }];
    }
    else
    {
        
    }
}

- (void)hideFlashOptionsViewAnimated:(BOOL)animated
{
    if(animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationCurveLinear
                         animations:^{
                             
                             _flashOptionsView.alpha = 0.0;
                         } 
                         completion:^(BOOL finished) {
                             
                             [_flashOptionsView removeFromSuperview];
                             _flashOptionsView.alpha = 1.0;
                         }];
    }
    else
    {
        
    }
}



- (void)showCropButtonAnimated:(BOOL)animated
{
    if(_cropButton.superview == nil)
    {
        [_imagePickerOverLayView addSubview:_cropButton];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                        
                         _cropButton.alpha = 1.0;
                     } 
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)hideCropButtonAnimated:(BOOL)animated
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         
                         _cropButton.alpha = 0.0;
                     } 
                     completion:^(BOOL finished) {
                         
                         [_cropButton removeFromSuperview];
                     }];
}




#pragma mark -
#pragma mark Action Methods

- (IBAction)takePicture:(id)sender
{
	[_cameraImagePickerController takePicture];
}

- (IBAction)cancelImagePicker:(id)sender
{
    _shouldDisplayCameraPickerInViewWillAppear = NO;
    [_cameraImagePickerController dismissModalViewControllerAnimated:YES];
    [self.tabBarController setSelectedIndex:[[DataManager sharedDataManager] mLastSelectedTabBarIndex]]; 
}




- (IBAction)rollClicked:(id)sender
{    
    _shouldDisplayCameraPickerInViewWillAppear = NO;
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
        button.frame = CGRectMake(132, 10, 57, 34);
		_cropImageView.hidden = NO;
	}
	else if(button.tag == kCropButtonDuringSquare)
	{
		button.tag = kCropButtonDuringFull;
		[button setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(119, 10, 82, 34);
		_cropImageView.hidden = YES;
	}
}


- (void)switchCameraClicked:(id)sender
{
    UIImagePickerControllerCameraDevice currentDevice = _cameraImagePickerController.cameraDevice;
    
    if(currentDevice == UIImagePickerControllerCameraDeviceRear)
    {
        _cameraImagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self configureFlashCameraControlsForCameraDevice:UIImagePickerControllerCameraDeviceFront forPickerController:_cameraImagePickerController];
    }
    else if(currentDevice == UIImagePickerControllerCameraDeviceFront)
    {
        _cameraImagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [self configureFlashCameraControlsForCameraDevice:UIImagePickerControllerCameraDeviceRear forPickerController:_cameraImagePickerController];
    }
}


- (void)currentFlashStatusButtonClicked:(id)sender
{
    [self hideCropButtonAnimated:YES];
    [self hideFlashStatusButtonAnimated:YES];
    [self showFlashOptionsViewAnimated:YES];
}

- (void)flashOptionsSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if(button.tag == kFlashOptionButtonTagAuto)
    {
        _cameraImagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto; 
    }
    else if(button.tag == kFlashOptionButtonTagOn)
    {
        _cameraImagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn; 
    }
    else if(button.tag == kFlashOptionButtonTagOn)
    {
        _cameraImagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff; 
    }
    
    [self hideFlashOptionsViewAnimated:YES];
    [self showFlashStatusButtonForStatus:button.tag Animated:YES];
    [self showCropButtonAnimated:YES];
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
        CGSize  temp = imagePicked.size;
        NSLog(@"image size - %@", NSStringFromCGSize(temp));
		


        
		if(imagePicked)
		{
			
			ApplyFilterViewController *viewController = [[ApplyFilterViewController alloc] initWithNibName:@"ApplyFilterViewController" bundle:nil];
                
            
            BOOL wasImageTakenFromCamera = NO;
            if(_selectedPhotoSource == kSelectedPhotoSourceCamera)
            {
                wasImageTakenFromCamera = YES;
            }

            viewController.wantsFullScreenLayout = YES;
			viewController.hidesBottomBarWhenPushed = YES;
			viewController.originalImage = imagePicked;
            viewController.imageTakenFromCamera = wasImageTakenFromCamera;
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
    
    [self checkAndConfigureTheCameraControlsForDifferentVersionsOfDevice];
    
    // Now lets configure the flash controls for the current camera device
    [self configureFlashCameraControlsForCameraDevice:pickerController.cameraDevice forPickerController:pickerController];
    
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



#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [_HUD removeFromSuperview];
    [_HUD release];
	_HUD = nil;
}


@end
