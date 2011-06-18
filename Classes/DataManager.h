//
//  DataManager.h
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"


@interface DataManager : NSObject  {

	NSInteger mLastSelectedTabBarIndex;

}


@property (nonatomic, assign) NSInteger mLastSelectedTabBarIndex;

+ (DataManager*)sharedDataManager;

- (void)setUserAsLoggedInWithProfileData:(NSDictionary *)profileDic;
- (BOOL)isUserLoggedIn;
- (NSMutableDictionary *)getUserProfile;
- (void)logoutUser;

- (BOOL)isFacebookConnected;
- (BOOL)isTwitterConnected;
- (BOOL)isTumblrConnected;
- (void)setFacebookConnected:(BOOL)isConnected withNickname:(NSString *)nickname;
- (void)setTwitterConnected:(BOOL)isConnected withNickname:(NSString *)nickname;
- (void)setTumblrConnected:(BOOL)isConnected withNickname:(NSString *)nickname;


- (NSInteger)imageQualitySetting;
- (void)setImageQuality:(NSInteger)imageQuality;

@end
