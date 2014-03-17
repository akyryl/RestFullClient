//
//  ProfileDataSource.h
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProfileDataSourceProtocol.h"


@class ProfileData;

@interface ProfileDataSource : NSObject
{
}

@property (nonatomic, retain) ProfileData *profileData;
@property (readonly) BOOL isAuthenticated;

- (BOOL)authenticate:(id <ProfileDataSourceProtocol>) delegate;
- (BOOL)addProfile:(ProfileData *)profileData delegate:(id <ProfileDataSourceProtocol>) delegate;
- (BOOL)updateProfile:(ProfileData *)profileData delegate:(id <ProfileDataSourceProtocol>) delegate;
- (BOOL)deleteProfile:(id <ProfileDataSourceProtocol>) delegate;

@end
