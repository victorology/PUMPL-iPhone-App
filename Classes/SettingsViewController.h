//
//  SettingsViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 10/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface SettingsViewController : UIViewController <MBProgressHUDDelegate> {

	UITableView *mTableView;
	NSMutableArray *mTableData;
	
	MBProgressHUD *_HUD;
}

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) NSMutableArray *mTableData;

- (void)configureTheView;
- (void)buildTableData;


@end
