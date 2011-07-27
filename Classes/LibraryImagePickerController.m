//
//  LibraryImagePickerController.m
//  PUMPL
//
//  Created by Harmandeep Singh on 26/07/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "LibraryImagePickerController.h"


@implementation LibraryImagePickerController

@synthesize customDelegate;


- (void)viewDidDisappear:(BOOL)animated 
{
    if([customDelegate respondsToSelector:@selector(libraryImagePickerControllerDisappeared)])
    {
        [customDelegate libraryImagePickerControllerDisappeared];
    }
}


- (void)dealloc
{
    [super dealloc];
}

@end
