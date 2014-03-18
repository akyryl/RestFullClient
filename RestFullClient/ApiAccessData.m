//
//  ApiAccessData.m
//  RestFullClient
//
//  Created by akyryl on 3/18/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "ApiAccessData.h"

#import "SecureStorage.h"


static NSString *const kAuthenticationTokenID = @"authTokenID";
static NSString *const kApiUserNameID = @"apiUserNameID";

@interface ApiAccessData ()

@property (nonatomic, retain) SecureStorage *secureStorage;

@end

@implementation ApiAccessData

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _secureStorage = [[SecureStorage alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_secureStorage release];
    
    [super dealloc];
}

- (void)setUserName:(NSString *)userName
{
    [self.secureStorage saveAuthenticationToken:userName identifier:kApiUserNameID];
}

- (NSString *)userName
{
    NSData *userName = [self.secureStorage searchKeychainCopyMatching:kApiUserNameID];
    if (userName != nil)
    {
        return[[NSString alloc] initWithData:userName encoding:NSUTF8StringEncoding];
    }
    return nil;

}

- (NSString *)accessToken
{
    NSData *tokenData = [self.secureStorage searchKeychainCopyMatching:kAuthenticationTokenID];
    if (tokenData != nil)
    {
        return[[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (void)setAccessToken:(NSString *)accessToken
{
    [self.secureStorage saveAuthenticationToken:accessToken identifier:kAuthenticationTokenID];
}

@end
