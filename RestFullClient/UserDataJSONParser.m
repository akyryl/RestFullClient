//
//  ProfileDataJSONParser.m
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "UserDataJSONParser.h"

#import "ApiAccessData.h"
#import "ProfileData.h"


@implementation UserDataJSONParser

- (ProfileData *)parse:(NSData *)data
{
    NSDictionary *profileDictionary = [self dictionaryFromData:data];
    if (profileDictionary == nil)
    {
        return nil;
    }

    ProfileData *profileData = [[[ProfileData alloc] init] autorelease];
    profileData.firstName = [profileDictionary valueForKey:@"first_name"];
    profileData.lastName = [profileDictionary valueForKey:@"last_name"];
    profileData.email = [profileDictionary valueForKey:@"email"];
    return profileData;
}

- (ApiAccessData *)parseApiData:(NSData *)data
{
    NSDictionary *profileDictionary = [self dictionaryFromData:data];
    if (profileDictionary == nil)
    {
        return nil;
    }

    ApiAccessData *apiData = nil;
    NSString *userName = [profileDictionary valueForKey:@"username"];
    NSString *accessToken = [profileDictionary valueForKey:@"access_token"];
    if (userName != nil && accessToken != nil)
    {
        apiData = [[ApiAccessData alloc] init];
        apiData.userName = userName;
        apiData.accessToken = accessToken;
    }
    return apiData;
}

- (NSDictionary *)dictionaryFromData:(NSData *)data
{
    NSError *parsingError = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&parsingError];
    if (parsingError != nil)
    {
        self.parsingError = [parsingError retain];
        return nil;
    }
    
    NSString *errorValue = [dataDictionary valueForKey:@"error"];
    if (errorValue != nil)
    {
        self.responseErrorString = [errorValue retain];
        return nil;
    }
    NSDictionary *profileDictionary = [dataDictionary valueForKey:@"user"];
    if (profileDictionary == nil)
    {
        profileDictionary = dataDictionary;
    }
    return profileDictionary;
}

@end
