//
//  HomeViewThumbsTableViewCell.m
//  PUMPL
//
//  Created by Harmandeep Singh on 08/05/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "HomeViewThumbsTableViewCell.h"



static const CGFloat kSpacing = 5;
static const CGFloat kDefaultThumbSize = 75;
static const CGFloat kDefaultThumbWidth = 100;
static const CGFloat kDefaultThumbHeight = 100;


@implementation HomeViewThumbsTableViewCell

@synthesize thumbWidth = _thumbWidth;
@synthesize thumbHeight = _thumbHeight;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
		_thumbViews = [[NSMutableArray alloc] init];
		_thumbSize = kDefaultThumbSize;
		_thumbOrigin = CGPointMake(kSpacing, 0);
		_thumbWidth = kDefaultThumbWidth;
		_thumbHeight = kDefaultThumbHeight;
		
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return self;
}





- (void)layoutThumbViews {
	CGRect thumbFrame = CGRectMake(self.thumbOrigin.x, self.thumbOrigin.y,
								   self.thumbWidth, self.thumbHeight);
	
	for (TTThumbView* thumbView in _thumbViews) {
		thumbView.frame = thumbFrame;
		thumbFrame.origin.x += kSpacing + self.thumbWidth;
	}
}



- (void)setThumbWidth:(CGFloat)thumbWidth {
	_thumbWidth = thumbWidth;
	[self setNeedsLayout];
}


- (void)setThumbHeight:(CGFloat)thumbHeight {
	_thumbHeight = thumbHeight;
	[self setNeedsLayout];
}

@end
