//
//  ProfileDataSource.m
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "ProfileDataSource.h"

#import "ApiAccessData.h"
#import "HTTPClient.h"
#import "ProfileData.h"
#import "ProfileDataJSONParser.h"


static NSString *const kBaseURL = @"http://localhost:5000/mymusic/api/v1.0/users/";
static NSString *const kCreateProfileTemplate = @"{\"username\":\"%@\",\"email\":\"%@\",\"last_name\":\"%@\",\"first_name\":\"%@\"}";
static NSString *const kUpdateProfileTemplate = @"{\"email\":\"%@\",\"last_name\":\"%@\",\"first_name\":\"%@\"}";


@interface ProfileDataSource ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) ApiAccessData *apiAccessData;
@property (nonatomic, retain) HTTPClient *httpClient;
@property (nonatomic, retain) ProfileDataJSONParser *parser;

@end;


@implementation ProfileDataSource

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _apiAccessData = [[ApiAccessData alloc] init];
        _httpClient = [[HTTPClient alloc] initBaseURL:[NSURL URLWithString:kBaseURL]];
        _parser = [[ProfileDataJSONParser alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_parser release];
    [_httpClient release];
    [_apiAccessData release];
    [super dealloc];
}

- (BOOL)isAuthenticated
{
    // TODO:
    return self.profileData != nil;

    // TODO: check if it is working
    // return self.apiAccessData.accessToken != nil &&  self.apiAccessData.userName != nil;

}

- (BOOL)authenticate:(id <ProfileDataSourceProtocol>) delegate
{
    // use isAuthenticated here
    NSString *apiAccessToken = self.apiAccessData.accessToken;
    NSString *apiUserName = self.apiAccessData.userName;
    if (apiAccessToken == nil || apiUserName == nil)
    {
        [delegate authenticationFailed];
        return YES;
    }

    NSDictionary *headerParameters = @{@"api_access_token":apiAccessToken,
                                       @"api_username":apiUserName};
    NSURLRequest *request = [self.httpClient requestWithMethod:GET
                                                          path:kBaseURL
                                                    parameters:nil
                                              headerParameters:headerParameters];
    //[NSURLConnection connectionWithRequest:request delegate:self];
    
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
    return YES;
}

- (BOOL)addProfile:(ProfileData *)profileData delegate:(id <ProfileDataSourceProtocol>) delegate
{
    NSString *parameters = [NSString stringWithFormat:kCreateProfileTemplate, profileData.userName, profileData.email, profileData.lastName, profileData.firstName];
    
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

    return YES;
}

- (BOOL)updateProfile:(ProfileData *)profileData delegate:(id <ProfileDataSourceProtocol>) delegate
{
    NSString *parameters = [NSString stringWithFormat:kUpdateProfileTemplate, profileData.email, profileData.lastName, profileData.firstName];
    NSDictionary *headerParameters = @{@"api_access_token":self.apiAccessData.accessToken,
                                       @"api_username":self.apiAccessData.userName};


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
    return YES;
}

- (BOOL)deleteProfile:(id <ProfileDataSourceProtocol>) delegate
{
    NSDictionary *headerParameters = @{@"api_access_token":self.apiAccessData.accessToken,
                                       @"api_username":self.apiAccessData.userName};
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
    return YES;
}

/*- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    //[self.apiReturnXMLData setLength:0];
    
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //[self.apiReturnXMLData appendData:data];
    NSMutableData *d = [NSMutableData data];
    [d appendData:data];
    
    NSString *a = [[NSString alloc] initWithData:d encoding:NSASCIIStringEncoding];
    
    NSLog(@"Data: %@", a);
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    //NSLog(@"URL Connection Failed!");
    //currentConnection = nil;
}*/

@end
