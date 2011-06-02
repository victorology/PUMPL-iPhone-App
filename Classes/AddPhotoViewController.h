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
}

- (UIImage *)resizeImage:(UIImage *)image forImageQuality:(NSInteger)imageQuality;

@end
