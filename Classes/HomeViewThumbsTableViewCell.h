//
//  HomeViewThumbsTableViewCell.h
//  PUMPL
//
//  Created by Harmandeep Singh on 08/05/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface HomeViewThumbsTableViewCell : TTThumbsTableViewCell {

	CGFloat _thumbWidth;
	CGFloat _thumbHeight;
}

@property (nonatomic) CGFloat thumbWidth;
@property (nonatomic) CGFloat thumbHeight;


@end
