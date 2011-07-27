//
//  Me2DayLoginViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 17/07/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"

@interface Me2DayLoginViewController : UIViewController {
    
    IBOutlet UIWebView *mWebView;
	
	NSString *urlString;
	NSString *endPointCheckUrlString;
    NSString *alreadyLoggedInUrlString;
}

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *endPointCheckUrlString;
@property (nonatomic, copy) NSString *alreadyLoggedInUrlString;

@end
