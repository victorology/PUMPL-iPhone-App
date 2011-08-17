//
//  LoginViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate> {

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

- (void)login:(id)sender;

- (UITextField *)getTextFieldForRowIndex:(NSInteger)rowIndex;

@end
