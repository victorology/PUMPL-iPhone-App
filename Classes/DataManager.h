//
//  DataManager.h
//  PUMPL
//
//  Created by Harmandeep Singh on 05/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "FBConnect.h"


@interface DataManager : NSObject <FBSessionDelegate> {

	NSInteger mLastSelectedTabBarIndex;

    Facebook* facebook;
    NSArray* _permissions;
}


@property (nonatomic, assign) NSInteger mLastSelectedTabBarIndex;
@property (nonatomic, readonly) Facebook* facebook;

+ (DataManager*)sharedDataManager;

- (void)setUserAsLoggedInWithProfileData:(NSDictionary *)profileDic;
- (BOOL)isUserLoggedIn;
- (NSMutableDictionary *)getUserProfile;
- (void)logoutUser;

- (BOOL)isFacebookConnected;
- (BOOL)isTwitterConnected;
- (BOOL)isTumblrConnected;
- (BOOL)isMe2dayConnected;
- (void)setFacebookConnected:(BOOL)isConnected withNickname:(NSString *)nickname;
- (void)setTwitterConnected:(BOOL)isConnected withNickname:(NSString *)nickname;
- (void)setTumblrConnected:(BOOL)isConnected withNickname:(NSString *)nickname;
- (void)setMe2dayConnected:(BOOL)isConnected withNickname:(NSString *)nickname;

- (void)facebookLogin;
- (void)facebookLogout;


- (NSInteger)imageQualitySetting;
- (void)setImageQuality:(NSInteger)imageQuality;

@end
