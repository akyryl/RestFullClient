//
//  ProfileDataSourceProtocol.h
//  RestFullClient
//
//  Created by akyryl on 3/16/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProfileDataSourceProtocol <NSObject>

@optional
- (void)authenticationSuccessful;
- (void)authenticationFailed;
- (void)newProfileAdded;
- (void)profileUpdated;
- (void)profileDeleted;
- (void)requestFailed;

@end
