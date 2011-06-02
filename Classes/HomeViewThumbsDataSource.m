//
//  HomeViewThumbsDataSource.m
//  PUMPL
//
//  Created by Harmandeep Singh on 08/05/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "HomeViewThumbsDataSource.h"

// UINavigator
#import "Three20UINavigator/TTGlobalNavigatorMetrics.h"

#import "HomeViewThumbsTableViewCell.h"


static CGFloat kThumbSize = 100;
static CGFloat kThumbSpacing = 5;

@implementation HomeViewThumbsDataSource

- (NSInteger)columnCount {
	//CGFloat width = TTScreenBounds().size.width;
	CGFloat width = 320;
	return round((width - kThumbSpacing*2) / (kThumbSize+kThumbSpacing));
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
	if ([object conformsToProtocol:@protocol(TTPhoto)]) {
		return [HomeViewThumbsTableViewCell class];
	} else {
		return [super tableView:tableView cellClassForObject:object];
	}
}


- (void)        tableView: (UITableView*)tableView
                     cell: (UITableViewCell*)cell
    willAppearAtIndexPath: (NSIndexPath*)indexPath {
	if ([cell isKindOfClass:[HomeViewThumbsTableViewCell class]]) {
		HomeViewThumbsTableViewCell* thumbsCell = (HomeViewThumbsTableViewCell *)cell;
		thumbsCell.delegate = _delegate;
		thumbsCell.columnCount = self.columnCount;
	}
}


@end



