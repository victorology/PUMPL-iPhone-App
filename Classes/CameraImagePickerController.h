//
//  CameraImagePickerController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 26/07/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraImagePickerController;


@protocol CameraImagePickerControllerDelegate <NSObject>

- (void)cameraImagePickerControllerDisappeared;

@end


@interface CameraImagePickerController : UIImagePickerController {
    
    id <CameraImagePickerControllerDelegate> customDelegate;
}

@property (nonatomic, assign) id <CameraImagePickerControllerDelegate> customDelegate;

@end
