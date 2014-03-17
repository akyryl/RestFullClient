//
//  HTTPClient.m
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "HTTPClient.h"


@interface HTTPClient ()

@property (nonatomic, retain) NSURL *baseURL;

@end

@implementation HTTPClient

- (id)initBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self != nil)
    {
        self.baseURL = baseURL;
    }
    return self;
}

- (NSURLRequest *)requestWithMethod:(HTTPMethod)method
                               path:(NSString *)path
                         parameters:(NSString *)parameters
                   headerParameters:(NSDictionary *)headerParameters;
{
    NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseURL];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
    
    NSString *httpMethod = [self stringFromHTTPMethod:method];
    if (httpMethod != nil)
    {
        [request setHTTPMethod:httpMethod];
    }

    if (parameters != nil)
    {
        NSData *requestData = [NSData dataWithBytes:[parameters UTF8String] length:[parameters length]];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        [request setHTTPBody:requestData];
    }

    if (headerParameters != nil)
    {
        for (id key in [headerParameters allKeys])
        {
            [request setValue:[headerParameters valueForKey:key] forHTTPHeaderField:key];
        }
    }

    return [[request copy] autorelease];
}

- (NSString *)stringFromHTTPMethod:(HTTPMethod)method
{
    NSString *value = nil;
    if (method == GET)
    {
        value = @"GET";
    }
    else if (method == POST)
    {
        value = @"POST";
    }
    else if (method == PUT)
    {
        value = @"PUT";
    }
    else if (method == DELETE)
    {
        value = @"DELETE";
    }
    return value;
}

@end
