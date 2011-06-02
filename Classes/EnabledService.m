//
//  EnabledService.m
//  PUMPL
//
//  Created by Harmandeep Singh on 21/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "EnabledService.h"


@implementation EnabledService

@synthesize serviceName;
@synthesize toBeUsedWhileUploading;

- (void)dealloc
{
	[serviceName release];
	[super dealloc];
}

@end
