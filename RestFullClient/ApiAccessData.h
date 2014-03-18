//
//  ApiAccessData.h
//  RestFullClient
//
//  Created by akyryl on 3/18/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SecureStorage;

@interface ApiAccessData : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *accessToken;

@end
