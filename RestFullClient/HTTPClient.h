//
//  HTTPClient.h
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    GET,
    POST,
    PUT,
    DELETE
} HTTPMethod;

@interface HTTPClient : NSObject

- (id)initBaseURL:(NSURL *)baseUrl;
- (NSURLRequest *)requestWithMethod:(HTTPMethod)method
                               path:(NSString *)path
                         parameters:(NSString *)parameters
                   headerParameters:(NSDictionary *)headerParameters;

@end
