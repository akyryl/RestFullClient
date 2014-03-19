//
//  ProfileDataJSONParser.h
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ProfileData;
@class ApiAccessData;

@interface UserDataJSONParser : NSObject

@property (nonatomic, copy) NSString *responseErrorString;
@property (nonatomic, retain) NSError *parsingError;

- (ProfileData *)parse:(NSData *)data;
- (ApiAccessData *)parseApiData:(NSData *)data;

@end
