//
//  FacebookConnectionWebViewController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 05/05/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FacebookConnectionWebViewController : UIViewController {

	IBOutlet UIWebView *mWebView;
	
	NSString *urlString;
	NSString *endPointCheckUrlString;
}

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *endPointCheckUrlString;

@end
