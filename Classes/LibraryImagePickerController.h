//
//  LibraryImagePickerController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 26/07/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LibraryImagePickerController;


@protocol LibraryImagePickerControllerDelegate <NSObject>

- (void)libraryImagePickerControllerDisappeared;

@end

@interface LibraryImagePickerController : UIImagePickerController {
    
    id <LibraryImagePickerControllerDelegate> customDelegate;
}

@property (nonatomic, assign) id <LibraryImagePickerControllerDelegate> customDelegate;

@end
