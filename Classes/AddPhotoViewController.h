//
//  AddPhotoViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 10/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kSelectedPhotoSourceCamera 0
#define kSelectedPhotoSourceLibrary 1



@interface AddPhotoViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {

	NSInteger _selectedPhotoSource;
	IBOutlet UIView *_imagePickerOverLayView;
	UIImagePickerController *_imagePickerController;
	IBOutlet UIButton *_cropButton;
	IBOutlet UIImageView *_cropImageView;
}

@property (nonatomic, retain) UIImagePickerController *_imagePickerController;



- (IBAction)takePicture:(id)sender;
- (IBAction)cancelImagePicker:(id)sender;
- (void)cropCameraViewClicked:(id)sender;

@end
