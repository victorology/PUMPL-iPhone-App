//
//  ApplyFilterViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 02/05/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface ApplyFilterViewController : UIViewController <MBProgressHUDDelegate> {

	UIImage *selectedImage;
	UIImage *finalImage;
	UIImage *fullImageForBackUp;
	UIImage *originalImage;
	
	IBOutlet UIImageView *mSelectedImageView;
	IBOutlet UIScrollView *mFilterButtonScrollView;
	IBOutlet UIButton *_cropButton;
	
	MBProgressHUD *_HUD;
	BOOL _wasFilterSelected;
	BOOL imageClickedInSquareMode;
	NSInteger _filterApplied;
	
	UIViewContentMode _contentModeToBeApplied;
    
    IBOutlet UIView *_applyingFilterView;
    IBOutlet UIActivityIndicatorView *_applyingFilterIndicatorView;
}

@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *finalImage;
@property (nonatomic, retain) UIImage *fullImageForBackUp;
@property (nonatomic, retain) UIImage *squareImageForBackUp;
@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, assign) BOOL imageClickedInSquareMode;


- (IBAction)squareOrFullClicked:(id)sender;

@end
