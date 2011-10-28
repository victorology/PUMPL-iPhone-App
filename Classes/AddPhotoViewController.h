//
//  AddPhotoViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 10/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraImagePickerController.h"
#import "LibraryImagePickerController.h"
#import "MBProgressHUD.h"


#define kSelectedPhotoSourceCamera 0
#define kSelectedPhotoSourceLibrary 1



@interface AddPhotoViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CameraImagePickerControllerDelegate, LibraryImagePickerControllerDelegate, MBProgressHUDDelegate> {

	NSInteger _selectedPhotoSource;
	IBOutlet UIView *_imagePickerOverLayView;
	CameraImagePickerController *_cameraImagePickerController;
    LibraryImagePickerController *_libraryImagePickerController;
	IBOutlet UIButton *_cropButton;
	IBOutlet UIImageView *_cropImageView;
    MBProgressHUD *_HUD;
    
    BOOL _shouldDisplayCameraPickerOnDisappearOfLibrary;
    BOOL _shouldDisplayLibraryPickerOnCameraOfLibrary;
    BOOL _shouldDisplayCameraPickerInViewWillAppear;
}

@property (nonatomic, retain) CameraImagePickerController *_cameraImagePickerController;
@property (nonatomic, retain) LibraryImagePickerController *_libraryImagePickerController;


- (IBAction)takePicture:(id)sender;
- (IBAction)cancelImagePicker:(id)sender;
- (IBAction)rollClicked:(id)sender;
- (void)cropCameraViewClicked:(id)sender;

@end
