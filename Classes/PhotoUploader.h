//
//  PhotoUploader.h
//  PUMPL
//
//  Created by Harmandeep Singh on 21/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "DataManager.h"
#import "JSON.h"


@class PhotoUploader;

@protocol PhotoUploaderDelegate <NSObject>

- (void)photoUploader:(PhotoUploader *)uploader hasStartedTheStepWithTitle:(NSString *)stepTitle;
- (void)photoUploaderHasFinishedUploading;
- (void)photoUploader:(PhotoUploader *)uploader hasEncounteredError:(NSString *)errorMessage;
- (void)photoUploader:(PhotoUploader *)uploader uploadProgress:(float)progress;

@end




@interface PhotoUploader : NSObject  {

	UIImage *_image;
	NSMutableArray *_services;
	NSString *_title;

	ASIFormDataRequest *_request;
	
	id <PhotoUploaderDelegate> delegate;
}

@property (nonatomic, assign) id <PhotoUploaderDelegate> delegate;

- (id)initWithImage:(UIImage *)image andTitle:(NSString *)title andServices:(NSMutableArray *)services;

- (void)startUploading;

@end
