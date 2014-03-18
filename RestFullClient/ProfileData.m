//
//  ProfileData.m
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "ProfileData.h"

@implementation ProfileData

- (NSString *)accessToken
{
    // TODO: read access token
    return @"";
}

- (void)setAccessToken:(NSString *)accessToken
{
    // TODO: save access token
}

- (void)updateWithData:(ProfileData *)profileData
{
    if (![profileData.userName isEqualToString:@"(null)"])
    {
        self.userName = profileData.userName;
    }
    if (![profileData.firstName isEqualToString:@"(null)"])
    {
        self.firstName = profileData.firstName;
    }
    if (![profileData.lastName isEqualToString:@"(null)"])
    {
        self.lastName = profileData.lastName;
    }
    if (![profileData.email isEqualToString:@"(null)"])
    {
        self.email = profileData.email;
    }
}

@end