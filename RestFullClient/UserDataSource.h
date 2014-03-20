//
//  UserDataSource.h
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserDataSourceProtocol.h"


@class ProfileData;

@interface UserDataSource : NSObject

@property (nonatomic, retain) ProfileData *profileData;
@property (nonatomic, readonly) NSString *userName;
@property (readonly) BOOL isAuthenticated;

- (void)authenticate:(id <UserDataSourceProtocol>) delegate;
- (void)addProfile:(NSString *)userName profileData:(ProfileData *)profileData delegate:(id <UserDataSourceProtocol>) delegate;
- (void)updateProfile:(ProfileData *)profileData delegate:(id <UserDataSourceProtocol>) delegate;
- (void)deleteProfile:(id <UserDataSourceProtocol>) delegate;

@end
