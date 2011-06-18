//
//  HomeScreenDataSource.h
//  PUMPL
//
//  Created by Harmandeep Singh on 16/06/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTPhotoBrowserDataSource.h"

@interface HomeScreenDataSource : NSObject <KTPhotoBrowserDataSource> {

	NSArray *images_;
	NSArray *titles_;
}

- (CGSize)thumbSize;
- (NSInteger)thumbsPerRow;

- (void)setImagesArray:(NSArray *)imagesArray;
- (void)setTitlesArray:(NSArray *)titlesArray;

@end
