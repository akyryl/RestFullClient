//
//  EditProfileViewController.h
//  RestFullClient
//
//  Created by akyryl on 3/15/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "ProfileDataSourceProtocol.h"


@class ProfileDataSource;

@interface EditProfileViewController : UIViewController <ProfileDataSourceProtocol>
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *lastNameTextField;
    IBOutlet UITextField *emailTextField;

    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *removeProfileButton;
}

@property (nonatomic, assign) ProfileDataSource *profileDataSource;

- (IBAction)saveButtonTapped:(UIButton *)button;
- (IBAction)removeButtonTapped:(UIButton *)button;
- (void)profileUpdated;
- (void)profileDeleted;

@end
