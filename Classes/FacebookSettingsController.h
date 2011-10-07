//
//  FacebookSettingsController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 05/10/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"

@interface FacebookSettingsController : UIViewController <MBProgressHUDDelegate> {
    
    IBOutlet UITableView *mTableView;
    MBProgressHUD *_HUD;
    
    NSMutableArray *mTableData;
    NSMutableArray *mUserAlbumsArray;
    ASIHTTPRequest *mRequest;
}

@end
