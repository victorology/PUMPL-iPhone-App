//
//  WelcomeScreenViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 20/07/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface WelcomeScreenViewController : UIViewController <MBProgressHUDDelegate> {
    
    UITableView *mTableView;
    UILabel *mWelcomeLabel;
    UILabel *mMessageLabel;
    UIView *mTableHeaderView;
    
    MBProgressHUD *_HUD;
    
    NSMutableArray *mTableData;
}

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UILabel *mWelcomeLabel;
@property (nonatomic, retain) IBOutlet UILabel *mMessageLabel;
@property (nonatomic, retain) IBOutlet UIView *mTableHeaderView;
@property (nonatomic, retain) NSMutableArray *mTableData;


@end
