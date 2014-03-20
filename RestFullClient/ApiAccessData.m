//
//  ApiAccessData.m
//  RestFullClient
//
//  Created by akyryl on 3/18/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "ApiAccessData.h"

#import "SecureStorage.h"


static NSString *const kServiceName = @"RESTFullClient";
static NSString *const kAuthenticationTokenID = @"authTokenID";
static NSString *const kApiUserNameID = @"apiUserNameID";

@interface ApiAccessData ()

@property (nonatomic, retain) SecureStorage *secureStorage;

@end

@implementation ApiAccessData

@synthesize userName =_userName;
@synthesize accessToken =_accessToken;

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _secureStorage = [[SecureStorage alloc] initWithServiceName:kServiceName];
    }
    return self;
}

- (void)dealloc
{
    [_secureStorage release];
    [_userName release];
    [_accessToken release];
    
    [super dealloc];
}

- (void)setUserName:(NSString *)userName
{
    if (userName != nil && ![_userName isEqualToString:userName])
    {
        // store to user defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:userName forKey:kApiUserNameID];
        [userDefaults synchronize];

        [_userName release];
        _userName = [userName copy];
    }
    else
    {
        [_userName release];
        _userName = nil;
    }
}

- (NSString *)userName
{
    if (_userName == nil)
    {
        // read from user defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _userName = [[userDefaults objectForKey:kApiUserNameID] retain];
    }
    return _userName;
}

- (void)setAccessToken:(NSString *)accessToken
{
    if (accessToken != nil)
    {
        // remove old value from keychain if it exists there somehow
        NSData *tokenData = [self.secureStorage searchKeychainValue:kAuthenticationTokenID];
        if (tokenData != nil)
        {
            NSString *savedToken = [[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding];
            if (savedToken != nil && savedToken != accessToken)
            {
                [self.secureStorage deleteKeychainValue:kAuthenticationTokenID];
            }
        }

        // save to keychain
        if ([self.secureStorage saveKeychainValue:accessToken identifier:kAuthenticationTokenID])
        {
            [_accessToken release];
            _accessToken = [accessToken copy];
        }
        else
        {
            [_accessToken release];
            _accessToken = nil;
        }
    }
    else
    {
        [_accessToken release];
        _accessToken = nil;
    }
}

- (NSString *)accessToken
{
    // read from keychain
    if (_accessToken == nil)
    {
        NSData *tokenData = [self.secureStorage searchKeychainValue:kAuthenticationTokenID];
        if (tokenData != nil)
        {
            _accessToken = [[[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding] copy];
        }
    }
    return _accessToken;
}

- (void)cleanData
{
    // clean user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kApiUserNameID];
    [userDefaults synchronize];

    // clear keychain
    [self.secureStorage deleteKeychainValue:kAuthenticationTokenID];

    self.userName = nil;
    self.accessToken = nil;
}

@end
