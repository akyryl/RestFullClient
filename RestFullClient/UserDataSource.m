//
//  UserDataSource.m
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "UserDataSource.h"

#import "ApiAccessData.h"
#import "HTTPClient.h"
#import "ProfileData.h"
#import "UserDataJSONParser.h"


static NSString *const kBaseURL = @"http://localhost:5000/mymusic/api/v1.0/users/";
static NSString *const kApiAccessTokenKey = @"api_access_token";
static NSString *const kApiUserNameKey = @"api_username";

static NSString *const kCreateProfileTemplate = @"{\"username\":\"%@\",\"email\":\"%@\",\"last_name\":\"%@\",\"first_name\":\"%@\"}";
static NSString *const kUpdateProfileTemplate = @"{\"email\":\"%@\",\"last_name\":\"%@\",\"first_name\":\"%@\"}";


@interface UserDataSource ()

@property (nonatomic, retain) ApiAccessData *apiAccessData;
@property (nonatomic, retain) HTTPClient *httpClient;
@property (nonatomic, retain) UserDataJSONParser *parser;

@end;


@implementation UserDataSource

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _apiAccessData = [[ApiAccessData alloc] init];
        _httpClient = [[HTTPClient alloc] initBaseURL:[NSURL URLWithString:kBaseURL]];
        _parser = [[UserDataJSONParser alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_parser release];
    [_profileData release];
    [_httpClient release];
    [_apiAccessData release];
    [super dealloc];
}

- (BOOL)isAuthenticated
{
    return self.apiAccessData.accessToken != nil &&  self.apiAccessData.userName != nil;
}

- (NSString *)userName
{
    return self.apiAccessData.userName;
}

- (void)authenticate:(id <UserDataSourceProtocol>) delegate
{
    if (![self isAuthenticated])
    {
        [delegate authenticationFailed];
        return;
    }

    NSDictionary *headerParameters = @{kApiAccessTokenKey:self.apiAccessData.accessToken,
                                       kApiUserNameKey:self.apiAccessData.userName};
    NSURLRequest *request = [self.httpClient requestWithMethod:GET
                                                          path:kBaseURL
                                                    parameters:nil
                                              headerParameters:headerParameters];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && error == nil)
        {
            ProfileData *profileData = [self.parser parse:data];
            if (profileData != nil)
            {
                self.profileData = profileData;
                SEL selector = @selector(authenticationSuccessful);
                if ([delegate respondsToSelector:selector])
                {
                    [delegate authenticationSuccessful];
                }
            }
            else
            {
                [delegate requestFailed];
            }
        }
        else
        {
            [delegate requestFailed];
        }
    }];
}

- (void)addProfile:(NSString *)userName profileData:(ProfileData *)profileData delegate:(id <UserDataSourceProtocol>) delegate
{
    NSString *parameters = [NSString stringWithFormat:kCreateProfileTemplate, userName, profileData.email, profileData.lastName, profileData.firstName];
    NSURLRequest *request = [self.httpClient requestWithMethod:POST
                                                          path:kBaseURL
                                                    parameters:parameters
                                              headerParameters:nil];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && error == nil)
        {
            ProfileData *savedProfileData = [self.parser parse:data];
            ApiAccessData *apiAccessData = [self.parser parseApiData:data];
            if (savedProfileData != nil && apiAccessData != nil)
            {
                self.profileData = savedProfileData;
                self.apiAccessData = apiAccessData;

                SEL selector = @selector(newProfileAdded);
                if ([delegate respondsToSelector:selector])
                {
                    [delegate newProfileAdded];
                }
            }
            else
            {
                [delegate requestFailed];
            }
        }
        else
        {
            [delegate requestFailed];
        }
    }];
}

- (void)updateProfile:(ProfileData *)profileData delegate:(id <UserDataSourceProtocol>) delegate
{
    NSString *parameters = [NSString stringWithFormat:kUpdateProfileTemplate, profileData.email, profileData.lastName, profileData.firstName];
    NSDictionary *headerParameters = @{kApiAccessTokenKey:self.apiAccessData.accessToken,
                                       kApiUserNameKey:self.apiAccessData.userName};


    NSURLRequest *request = [self.httpClient requestWithMethod:PUT
                                                          path:kBaseURL
                                                    parameters:parameters
                                              headerParameters:headerParameters];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        // TODO: check on other kinds of error
        if ([data length] > 0 && error == nil)
        {
            ProfileData *updatedProfileData = [self.parser parse:data];
            if (updatedProfileData != nil)
            {
                [self.profileData updateWithData:updatedProfileData];
                SEL selector = @selector(profileUpdated);
                if ([delegate respondsToSelector:selector])
                {
                    [delegate profileUpdated];
                }
            }
            else
            {
                [delegate requestFailed];
            }
        }
        else
        {
            [delegate requestFailed];
        }
    }];
}

- (void)deleteProfile:(id <UserDataSourceProtocol>) delegate
{
    NSDictionary *headerParameters = @{kApiAccessTokenKey:self.apiAccessData.accessToken,
                                       kApiUserNameKey:self.apiAccessData.userName};
    NSURLRequest *request = [self.httpClient requestWithMethod:DELETE
                                                          path:kBaseURL
                                                    parameters:nil
                                              headerParameters:headerParameters];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         // TODO: check on other kinds of error
         if ([data length] > 0 && error == nil)
         {
             self.profileData = nil;
             [self.apiAccessData cleanData];
             SEL selector = @selector(profileDeleted);
             if ([delegate respondsToSelector:selector])
             {
                 [delegate profileDeleted];
             }
         }
         else
         {
             [delegate requestFailed];
         }
     }];
}

@end
