//
//  RegistrationViewController.m
//  RestFullClient
//
//  Created by akyryl on 3/15/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "RegistrationViewController.h"

#import "ProfileData.h"
#import "UserDataSource.h"
#import "UIAlertView+Custom.h"


@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder)
    {
        [nextResponder becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return NO;
}

- (IBAction)registrationButtonTapped:(UIButton *)button
{
    activityIndicator.hidden = NO;

    ProfileData *profileData = [[ProfileData alloc] init];
    profileData.firstName = firstNameTextField.text;
    profileData.lastName = lastNameTextField.text;
    profileData.email = emailTextField.text;
    
    [self.profileDataSource addProfile:userNameTextField.text profileData:profileData delegate:self];
    [profileData release];
}

- (IBAction)cancelButtonTapped:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Protocol methods

- (void)newProfileAdded
{
    activityIndicator.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestFailed
{
    activityIndicator.hidden = YES;

    UIAlertView *alert = [UIAlertView connectionError];
    [alert show];
}

@end
