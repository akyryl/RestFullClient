//
//  ViewController.m
//  RestFullClient
//
//  Created by akyryl on 3/15/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "ViewController.h"

#import "UserDataSource.h"
#import "ProfileData.h"
#import "RegistrationViewController.h"
#import "UserHomeViewController.h"
#import "UIAlertView+Custom.h"


static NSString *const kGreetingsNewUserText = @"Hi New User!";
static NSString *const kGreetingsExistingUserText = @"Hi %@!";

@interface ViewController ()

@property (nonatomic, retain) UserDataSource *profileDataSource;

@end

@implementation ViewController

- (void)dealloc
{
    [_profileDataSource release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _profileDataSource = [[UserDataSource alloc] init];
    [_profileDataSource authenticate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateControls:self.profileDataSource.isAuthenticated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RegistrationSegue"])
    {
        RegistrationViewController *registrationController = (RegistrationViewController *)segue.destinationViewController;
        registrationController.profileDataSource = self.profileDataSource;
    }
    else if ([segue.identifier isEqualToString:@"HomeSegue"])
    {
        UserHomeViewController *userHomeController = (UserHomeViewController *)segue.destinationViewController;
        userHomeController.profileDataSource = self.profileDataSource;
    }
}

- (void)updateControls:(BOOL)isAuthenticated
{
    activityIndicator.hidden = YES;
    goToProfileButton.hidden = !isAuthenticated;
    goToRegistrationButton.hidden = isAuthenticated;
    if (isAuthenticated)
    {
        NSString *userName = self.profileDataSource.profileData.firstName;
        greetingsLable.text = [NSString stringWithFormat:kGreetingsExistingUserText, userName];
    }
    else
    {
        greetingsLable.text = kGreetingsNewUserText;
    }
}

#pragma mark -
#pragma mark Protocol methods

- (void)authenticationSuccessful
{
    [self updateControls:YES];
}

- (void)authenticationFailed
{
    [self updateControls:NO];
}

- (void)requestFailed
{
    [self updateControls:NO];
    
    UIAlertView *alert = [UIAlertView connectionError];
    [alert show];
}

@end
