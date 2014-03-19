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
@property (nonatomic, readonly) NSString *userName;
@property (readonly) BOOL isAuthenticated;

- (void)authenticate:(id <ProfileDataSourceProtocol>) delegate;
- (void)addProfile:(NSString *)userName profileData:(ProfileData *)profileData delegate:(id <ProfileDataSourceProtocol>) delegate;
- (void)updateProfile:(ProfileData *)profileData delegate:(id <ProfileDataSourceProtocol>) delegate;
- (void)deleteProfile:(id <ProfileDataSourceProtocol>) delegate;

@end
