//
//  PasswordLostViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 28/06/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PasswordLostViewController : UIViewController <UITextFieldDelegate> {

	UITableView *mTableView;
	UIActivityIndicatorView *mActivityIndicator;
	
	NSMutableArray *mTableData;
}

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) UIActivityIndicatorView *mActivityIndicator;
@property (nonatomic, retain) NSMutableArray *mTableData;


- (void)configureTheView;
- (void)showActivity;
- (void)hideActivity;

- (void)buildTableData;

- (void)lostPassword:(id)sender;

- (UITextField *)getTextFieldForRowIndex:(NSInteger)rowIndex;

@end
