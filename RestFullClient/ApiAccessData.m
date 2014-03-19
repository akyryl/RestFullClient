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
    if (userName != nil && [self.secureStorage saveKeychainValue:userName identifier:kApiUserNameID])
    {
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
        NSData *userName = [self.secureStorage searchKeychainValue:kApiUserNameID];
        if (userName != nil)
        {
            _userName = [[[NSString alloc] initWithData:userName encoding:NSUTF8StringEncoding] copy];
        }
    }
    return _userName;

/*    NSData *userName = [self.secureStorage searchKeychainValue:kApiUserNameID];
    if (userName != nil)
    {
        return[[NSString alloc] initWithData:userName encoding:NSUTF8StringEncoding];
    }
    return nil;*/
}

- (void)setAccessToken:(NSString *)accessToken
{
    if (accessToken != nil && [self.secureStorage saveKeychainValue:accessToken identifier:kAuthenticationTokenID])
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

- (NSString *)accessToken
{
    if (_accessToken == nil)
    {
        NSData *tokenData = [self.secureStorage searchKeychainValue:kAuthenticationTokenID];
        if (tokenData != nil)
        {
            _accessToken = [[[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding] copy];
        }
    }
    return _accessToken;

    /*NSData *tokenData = [self.secureStorage searchKeychainValue:kAuthenticationTokenID];
    if (tokenData != nil)
    {
        return[[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding];
    }
    return nil;*/
}

- (void)cleanData
{
    [self.secureStorage deleteKeychainValue:kApiUserNameID];
    self.userName = nil;
    [self.secureStorage deleteKeychainValue:kAuthenticationTokenID];
    self.accessToken = nil;
}

@end
