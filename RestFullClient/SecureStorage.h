//
//  SecureStorage.h
//  RestFullClient
//
//  Created by akyryl on 3/18/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecureStorage : NSObject

- (id)initWithServiceName:(NSString *)serviceName;
- (BOOL)saveKeychainValue:(NSString *)token identifier:(NSString *)identifier;
- (NSData *)searchKeychainValue:(NSString *)identifier;
- (void)deleteKeychainValue:(NSString *)identifier;

@end
