//
//  EnabledService.h
//  PUMPL
//
//  Created by Harmandeep Singh on 21/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EnabledService : NSObject {

	NSString *serviceName;
	BOOL toBeUsedWhileUploading;
}

@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, assign) BOOL toBeUsedWhileUploading;

@end
