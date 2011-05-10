//
//  EditScrollViewController.h
//  PUMPL
//
//  Created by Asad Khan on 2/13/11.
//  Copyright 2011 Semantic Notion Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditScrollViewController : UIViewController <UIScrollViewDelegate>{
	UIScrollView *scrollView;
	UIImageView *imageView;
	UIImage *selectedImage;
	UILabel *label;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) IBOutlet UILabel *label;
- (IBAction) filterButtonTapped:(id)sender;

@end
