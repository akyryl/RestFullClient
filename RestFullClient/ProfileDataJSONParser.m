//
//  ProfileDataJSONParser.m
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "ProfileDataJSONParser.h"

#import "ProfileData.h"


@implementation ProfileDataJSONParser

- (ProfileData *)parse:(NSData *)data
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
    
    ProfileData *profileData = [[[ProfileData alloc] init] autorelease];
    profileData.userName = [profileDictionary valueForKey:@"username"];
    profileData.firstName = [profileDictionary valueForKey:@"first_name"];
    profileData.lastName = [profileDictionary valueForKey:@"last_name"];
    profileData.email = [profileDictionary valueForKey:@"email"];
    profileData.accessToken = [profileDictionary valueForKey:@"access_token"];
    return profileData;
}

@end
