//
//  SignupViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DataManager.h"

@interface SignupViewController : UIViewController <UITextFieldDelegate> {
	
	UITableView *mTableView;
	UIActivityIndicatorView *mActivityIndicator;

	NSMutableArray *mTableData;
}

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (nonatomic, retain) NSMutableArray *mTableData;

- (void)configureTheView;
- (void)showActivity;
- (void)hideActivity;

- (void)buildTableData;

- (void)signUp:(id)sender;

- (UITextField *)getTextFieldForRowIndex:(NSInteger)rowIndex;

@end
