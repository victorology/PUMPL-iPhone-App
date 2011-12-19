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

@class EAGLView;
@class RenderTexture;
@interface ApplyFilterViewController : UIViewController <MBProgressHUDDelegate> {

	UIImage *selectedImage;
	UIImage *fullImageForBackUp;
	UIImage *originalImage;

	IBOutlet EAGLView* renderView;
	IBOutlet UIScrollView *mFilterButtonScrollView;
	IBOutlet UIButton *_cropButton;
    
    RenderTexture* render;
	
	MBProgressHUD *_HUD;
	BOOL _wasFilterSelected;
	BOOL imageClickedInSquareMode;
	NSInteger _filterApplied;
    BOOL imageTakenFromCamera;
	
	UIViewContentMode _contentModeToBeApplied;
    
    IBOutlet UIView *_applyingFilterView;
    UIActivityIndicatorView *_applyingFilterIndicatorView;
    IBOutlet UILabel *_applyingFilterTextLabel;
}

@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *fullImageForBackUp;
@property (nonatomic, retain) UIImage *squareImageForBackUp;
@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, assign) BOOL imageClickedInSquareMode;
@property (nonatomic, assign) BOOL imageTakenFromCamera;
@property (nonatomic, retain) RenderTexture* render;

+ (UIImage *)resizeImage:(UIImage *)image forImageQuality:(NSInteger)imageQuality;
+ (UIImage *)croppedImageToSize:(CGSize)croppedSize fromFullImage:(UIImage *)fullImage;
+ (UIImage *)cropImage:(UIImage*)sourceImage;
+ (UIImage *)resizeTo2048By1536ForImage:(UIImage *)imageToBeResized;


- (IBAction)squareOrFullClicked:(id)sender;

@end
