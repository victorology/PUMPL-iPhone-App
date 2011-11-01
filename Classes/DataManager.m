//
//  DataManager.m
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "DataManager.h"


static NSString* kAppId = @"170977086255854";

#define kUserInfoKey @"userInfo"

static DataManager *sharedDataManager = nil;



@implementation DataManager



@synthesize mLastSelectedTabBarIndex;
@synthesize facebook;


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
				
				facebook = [[Facebook alloc] initWithAppId:kAppId
                                                andDelegate:self];
            }
        }
    }
    return sharedDataManager;
}

- (id)copyWithZone:(NSZone *)zone { return self; }

- (id)retain { return self; }

- (unsigned)retainCount { return UINT_MAX; }

//- (void)release {}

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
    [self setFacebookConnected:NO withNickname:nil];
    [self setTwitterConnected:NO withNickname:nil];
    [self setTumblrConnected:NO withNickname:nil];
    [self setMe2dayConnected:NO withNickname:nil];
    [self setFacebookUploadAlbum:nil withAlbumID:nil];
    
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

- (BOOL)isMe2dayConnected
{
	return [[[NSUserDefaults standardUserDefaults] valueForKey:kIsMe2dayAccountConnected] boolValue];
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

- (void)setMe2dayConnected:(BOOL)isConnected withNickname:(NSString *)nickname
{
	[[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:isConnected] forKey:kIsMe2dayAccountConnected];
	[[NSUserDefaults standardUserDefaults] setValue:nickname forKey:kMe2dayAccountNickname];
	[[NSUserDefaults standardUserDefaults] synchronize];
}





#pragma mark -
#pragma mark Facebook Methods

- (void)facebookLogin
{
    if(_permissions == nil)
    {
        _permissions =  [[NSArray arrayWithObjects:
                          @"read_stream", @"publish_stream", @"offline_access",nil] retain]; 
    }
    
    [facebook authorize:_permissions];
}


- (void)facebookLogout
{
    [facebook logout:self];
}


- (void)setFacebookUploadAlbum:(NSString *)albumName withAlbumID:(NSString *)albumID
{
    [[NSUserDefaults standardUserDefaults] setValue:albumName forKey:kFacebookUploadAlbumName];
	[[NSUserDefaults standardUserDefaults] setValue:albumID forKey:kFacebookUploadAlbumID];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)getFacebookUploadAlbumName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookUploadAlbumName];
}

- (NSString *)getFacebookUploadAlbumID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookUploadAlbumID];
}





#pragma mark -
#pragma mark FBSession Delegate Methods

- (void)fbDidLogin {

    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationFBDidLogin object:nil]];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
//    NSLog(@"did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {

    
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





#pragma mark -
#pragma mark Helper Methods


+ (BOOL)iOS_5 {
    
    BOOL isOS5 = NO;
    
    NSString *osVersion = @"5.0";
    NSString *currOsVersion = [[UIDevice currentDevice] systemVersion];
    
    NSComparisonResult result = [currOsVersion compare:osVersion options:NSNumericSearch];
    if(result == NSOrderedAscending)
    {
        isOS5 = NO;
    }
    else if(result == NSOrderedSame)
    {
        isOS5 = YES;
    }
    else if(result == NSOrderedDescending)
    {
        isOS5 = YES;
    }
    
    return isOS5;
}



@end
