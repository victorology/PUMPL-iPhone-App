//
//  DataManager.m
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "DataManager.h"



#define kUserInfoKey @"userInfo"

static DataManager *sharedDataManager = nil;



@implementation DataManager



@synthesize mLastSelectedTabBarIndex;


#pragma mark -
#pragma mark Singleton Pattern Methods

+ (DataManager*)sharedDataManager
{
    @synchronized(self) {
        if (sharedDataManager == nil) {
            [[self alloc] init];
        }
    }
    return sharedDataManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedDataManager == nil) {
            return [super allocWithZone:zone];
        }
    }
    return sharedDataManager;
}

- (id)init
{
    Class myClass = [self class];
    @synchronized(myClass) {
        if (sharedDataManager == nil) {
            if (self = [super init]) {
                sharedDataManager = self;
                // custom initialization here
				
				
            }
        }
    }
    return sharedDataManager;
}

- (id)copyWithZone:(NSZone *)zone { return self; }

- (id)retain { return self; }

- (unsigned)retainCount { return UINT_MAX; }

- (void)release {}

- (id)autorelease { return self; }






#pragma mark -
#pragma mark Login Data Methods

- (void)setUserAsLoggedInWithProfileData:(NSDictionary *)profileDic
{
	NSMutableDictionary *mutableProfileDic = nil;
	if(profileDic != nil)
	{
		mutableProfileDic = [NSMutableDictionary dictionaryWithDictionary:profileDic];
	}	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:mutableProfileDic forKey:kUserInfoKey];
	[defaults synchronize];
}

- (BOOL)isUserLoggedIn
{
	BOOL isLogged = NO;
	
	NSMutableDictionary *mutableProfileDic = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKey];
	if(mutableProfileDic)
	{
		isLogged = YES;
	}
	
	return isLogged;
}

- (NSMutableDictionary *)getUserProfile
{
	NSMutableDictionary *userProfile = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKey];
	return userProfile;
}



- (void)logoutUser
{

	[[DataManager sharedDataManager] setUserAsLoggedInWithProfileData:nil];
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationPUMPLUserDidLogout object:nil]];
}



- (BOOL)isFacebookConnected
{
	return [[[NSUserDefaults standardUserDefaults] valueForKey:kIsFacebookAccountConnected] boolValue];
}

- (BOOL)isTwitterConnected
{
	return [[[NSUserDefaults standardUserDefaults] valueForKey:kIsTwitterAccountConnected] boolValue];
}

- (BOOL)isTumblrConnected
{
	return [[[NSUserDefaults standardUserDefaults] valueForKey:kIsTumblrAccountConnected] boolValue];
}



- (void)setFacebookConnected:(BOOL)isConnected withNickname:(NSString *)nickname
{
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:isConnected] forKey:kIsFacebookAccountConnected];
	[[NSUserDefaults standardUserDefaults] setValue:nickname forKey:kFacebookAccountNickname];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTwitterConnected:(BOOL)isConnected withNickname:(NSString *)nickname
{
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:isConnected] forKey:kIsTwitterAccountConnected];
	[[NSUserDefaults standardUserDefaults] setValue:nickname forKey:kTwitterAccountNickname];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTumblrConnected:(BOOL)isConnected withNickname:(NSString *)nickname
{
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:isConnected] forKey:kIsTumblrAccountConnected];
	[[NSUserDefaults standardUserDefaults] setValue:nickname forKey:kTumblrAccountNickname];
	[[NSUserDefaults standardUserDefaults] synchronize];
}





#pragma mark -
#pragma mark Image Quality Settings Methods

- (NSInteger)imageQualitySetting
{
	NSInteger imageQuailty;
	
	NSNumber *imageQualityNumber = [[NSUserDefaults standardUserDefaults] valueForKey:kSettingsImageQualityKey];
	if(imageQualityNumber == nil)
	{
		[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:kSettingsImageQualitySmall] forKey:kSettingsImageQualityKey];
		imageQuailty = kSettingsImageQualitySmall;
	}
	else 
	{
		imageQuailty = [imageQualityNumber integerValue];
	}
	
	return imageQuailty;
}

- (void)setImageQuality:(NSInteger)imageQuality
{
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:imageQuality] forKey:kSettingsImageQualityKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


@end
