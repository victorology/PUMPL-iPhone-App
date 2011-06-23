//
//  TempScrollView.m
//  PUMPL
//
//  Created by Harmandeep Singh on 23/06/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "TempScrollView.h"


@implementation TempScrollView

- (void)setFrame:(CGRect)newRect
{
	NSLog(@"self - %@", NSStringFromCGRect(newRect));
	[super setFrame:newRect];
}

@end
