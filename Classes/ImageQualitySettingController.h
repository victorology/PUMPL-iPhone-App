//
//  ImageQualitySettingController.h
//  PUMPL
//
//  Created by Harmandeep Singh on 25/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageQualitySettingController : UIViewController {
	
	UITableView *mTableView;
	
	NSMutableArray *mTableData;
	NSIndexPath *mOldIndexPath;

}

@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) NSMutableArray *mTableData;
@property (nonatomic, retain) NSIndexPath *mOldIndexPath;

- (void)configureTheView;
- (void)buildTableData;

@end
