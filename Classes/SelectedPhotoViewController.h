//
//  SelectedPhotoViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 11/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoUploader.h"
#import "DDProgressView.h"

@interface SelectedPhotoViewController : UIViewController <UITextFieldDelegate, PhotoUploaderDelegate> {

	
	UITableView *mTableView;
	UIView *mFreezeView;
	UILabel *mFreezeMessageLabel;
	DDProgressView *progressView;
	
	UIImage *mSelectedImage;
	BOOL wasFilterSelected;
	
	NSMutableArray *mTableData;
	PhotoUploader *mPhotoUploader;
	
}


@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UIView *mFreezeView;
@property (nonatomic, retain) IBOutlet UILabel *mFreezeMessageLabel;
@property (nonatomic, retain) UIImage *mSelectedImage;
@property (nonatomic, retain) NSMutableArray *mTableData;
@property (nonatomic, retain) PhotoUploader *mPhotoUploader;
@property (nonatomic, assign) BOOL wasFilterSelected;


- (void)buildTableData;
- (void)configureTheView;
- (void)save:(id)sender;
- (UITextField *)getTextFieldForIndexPath:(NSIndexPath *)indexPath;

@end
