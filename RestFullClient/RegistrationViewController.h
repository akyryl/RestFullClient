//
//  RegistrationViewController.h
//  RestFullClient
//
//  Created by akyryl on 3/15/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProfileDataSourceProtocol.h"


@class ProfileDataSource;

@interface RegistrationViewController : UIViewController <ProfileDataSourceProtocol>
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UIButton *registerButton;
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *lastNameTextField;
    IBOutlet UITextField *emailTextField;
}

@property (nonatomic, assign) ProfileDataSource *profileDataSource;

- (IBAction)registrationButtonTapped:(UIButton *)button;
- (IBAction)cancelButtonTapped:(UIButton *)button;
- (void)newProfileAdded;

@end
