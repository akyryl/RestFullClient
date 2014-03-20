//
//  SecureStorage.m
//  RestFullClient
//
//  Created by akyryl on 3/18/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "SecureStorage.h"

#import <Security/Security.h>


@implementation SecureStorage
{
    NSString *_serviceName;
}

- (id)initWithServiceName:(NSString *)serviceName
{
    self = [super init];
    if (self != nil)
    {
        _serviceName = [serviceName copy];
    }
    return self;
}

- (void)dealloc
{
    [_serviceName release];
    
    [super dealloc];
}

- (NSData *)searchKeychainValue:(NSString *)identifier
{
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    [self prepareSearchDictionary:searchDictionary identifier:identifier];
    
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    NSData *result = nil;

    OSStatus status = SecItemCopyMatching((CFDictionaryRef)searchDictionary, (CFTypeRef *)&result);
    if (status != errSecSuccess)
    {
        NSLog(@"Value %@ not found in keychain", identifier);
    }
    
    [searchDictionary release];
    return result;
}

- (void)prepareSearchDictionary:(NSMutableDictionary *)dict identifier:(NSString *)identifier
{
    [dict setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
    [dict setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
    [dict setObject:_serviceName forKey:(id)kSecAttrService];
}

- (void)deleteKeychainValue:(NSString *)identifier
{
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    [self prepareSearchDictionary:searchDictionary identifier:identifier];
    SecItemDelete((CFDictionaryRef)searchDictionary);
    [searchDictionary release];
}

- (BOOL)saveKeychainValue:(NSString *)token identifier:(NSString *)identifier
{
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    [self prepareSearchDictionary:searchDictionary identifier:identifier];
    
    NSData *tokenData = [token dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:tokenData forKey:(id)kSecValueData];
    
    OSStatus status = SecItemAdd((CFDictionaryRef)searchDictionary, NULL);
    [searchDictionary release];
    
    if (status == errSecSuccess)
    {
        return YES;
    }
    return NO;
}

@end
