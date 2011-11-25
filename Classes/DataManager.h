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
    
    NSMutableDictionary *settingsDictionary;
}


@property (nonatomic, assign) NSInteger mLastSelectedTabBarIndex;
@property (nonatomic, readonly) Facebook* facebook;

+ (DataManager*)sharedDataManager;
+ (BOOL)iOS_5;

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
- (void)setFacebookUploadAlbum:(NSString *)albumName withAlbumID:(NSString *)albumID;
- (NSString *)getFacebookUploadAlbumName;
- (NSString *)getFacebookUploadAlbumID;


- (NSInteger)imageQualitySetting;
- (void)setImageQuality:(NSInteger)imageQuality;



- (void)initializeSettingsDictionary;
- (void)saveSettingsDictionary;
- (void)setCurrentUserID:(NSInteger)currentUserID;
- (NSMutableDictionary *)getUserDataForCurrentUser;
- (void)userHasLoggedInWithProfileData:(NSDictionary *)profileData;
- (BOOL)hasUserPostedAnyPhoto;
- (void)setThatCurrentUserHasPostedPhotosEarlier;
- (BOOL)hasUserConnectedToAServiceAtLeastOneTime;
- (void)setThatCurrentUserHasConnectedToAServiceAtLeastOneTime;

@end
