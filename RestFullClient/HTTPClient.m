//
//  HTTPClient.m
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "HTTPClient.h"


@implementation HTTPClient
{
    NSURL *_baseURL;
}

- (id)initBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self != nil)
    {
        _baseURL = [baseURL retain];
    }
    return self;
}

- (void)dealloc
{
    [_baseURL release];
    
    [super dealloc];
}

- (NSURLRequest *)requestWithMethod:(HTTPMethod)method
                               path:(NSString *)path
                         parameters:(NSString *)parameters
                   headerParameters:(NSDictionary *)headerParameters;
{
    NSURL *url = [NSURL URLWithString:path relativeToURL:_baseURL];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
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
    NSURLRequest *immutableRequest = [[request copy] autorelease];
    [request release];
    return immutableRequest;
}

- (NSString *)stringFromHTTPMethod:(HTTPMethod)method
{
    NSString *value = nil;
    switch (method)
    {
        case GET:
            value = @"GET";
            break;
        case POST:
            value = @"POST";
            break;
        case PUT:
            value = @"PUT";
            break;
        case DELETE:
            value = @"DELETE";
            break;
        default:
            break;
    }
    return value;
}

@end
