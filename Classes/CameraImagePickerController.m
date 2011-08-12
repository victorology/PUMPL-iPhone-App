//
//  CameraImagePickerController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 26/07/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "CameraImagePickerController.h"


@implementation CameraImagePickerController

@synthesize customDelegate;


- (void)viewDidDisappear:(BOOL)animated 
{
    if([customDelegate respondsToSelector:@selector(cameraImagePickerControllerDisappeared)])
    {
        [customDelegate cameraImagePickerControllerDisappeared];
    }
}


- (void)dealloc
{
    [super dealloc];
}

@end
