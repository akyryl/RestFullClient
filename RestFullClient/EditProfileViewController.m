//
//  EditProfileViewController.m
//  RestFullClient
//
//  Created by akyryl on 3/15/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "EditProfileViewController.h"

#import "ProfileData.h"
#import "UserDataSource.h"
#import "UIAlertView+Custom.h"


@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [self updateControlsValue];
    [self updateControlsState:NO];
}

- (void)updateControlsValue
{
    ProfileData *currentUserData = self.profileDataSource.profileData;
    firstNameTextField.text = currentUserData.firstName;
    lastNameTextField.text = currentUserData.lastName;
    emailTextField.text = currentUserData.email;
}

- (void)updateControlsState:(BOOL)isRequestingData
{
    activityIndicator.hidden = !isRequestingData;
    saveButton.enabled = !isRequestingData;
    removeProfileButton.enabled = !isRequestingData;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder)
    {
        [nextResponder becomeFirstResponder];
    } else
    {
        [textField resignFirstResponder];
    }
    return NO;
}

- (IBAction)saveButtonTapped:(UIButton *)button
{
    if (![self isEnteredDataValid])
    {
        UIAlertView *alert = [UIAlertView invalidDataEntered];
        [alert show];
    }
    else
    {
        [self updateControlsState:YES];
        
        ProfileData *profileData = [[ProfileData alloc] init];
        profileData.firstName = firstNameTextField.text;
        profileData.lastName = lastNameTextField.text;
        profileData.email = emailTextField.text;
        
        [self.profileDataSource updateProfile:profileData delegate:self];
        [profileData release];
    }
}

- (IBAction)removeButtonTapped:(UIButton *)button
{
    UIAlertView *alert = [UIAlertView confirmDeletion:self];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        [self updateControlsState:YES];
        
        [self.profileDataSource deleteProfile:self];
    }
}

- (BOOL)isEnteredDataValid
{
    return [firstNameTextField.text length] != 0
        && [lastNameTextField.text length] != 0
        // TODO: add email validation
        && [emailTextField.text length] != 0;
}

#pragma mark -
#pragma mark Protocol methods

- (void)profileUpdated
{
    [self updateControlsState:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)profileDeleted
{
    [self updateControlsState:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFailed
{
    [self updateControlsState:NO];
    
    UIAlertView *alert = [UIAlertView connectionError];
    [alert show];
}

@end
