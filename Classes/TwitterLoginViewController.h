//
//  TwitterLoginViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 20/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"

@interface TwitterLoginViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate> {

	UITableView *mTableView;
	MBProgressHUD *_HUD;
	
	NSMutableArray *mTableData;
	ASIFormDataRequest *_request;
}

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) NSMutableArray *mTableData;

- (void)configureTheView;

- (void)buildTableData;

- (void)login:(id)sender;


- (UITextField *)getTextFieldForRowIndex:(NSInteger)rowIndex;

@end
