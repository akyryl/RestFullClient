//
//  SecureStorage.h
//  RestFullClient
//
//  Created by akyryl on 3/18/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecureStorage : NSObject

- (BOOL)saveAuthenticationToken:(NSString *)token identifier:(NSString *)identifier;
- (NSData *)searchKeychainCopyMatching:(NSString *)identifier;

@end
