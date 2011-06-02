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
	
	IBOutlet UIImageView *mSelectedImageView;
	IBOutlet UIScrollView *mFilterButtonScrollView;
	
	MBProgressHUD *_HUD;
	BOOL _wasFilterSelected;
}

@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *finalImage;

@end
