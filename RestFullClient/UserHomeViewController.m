//
//  UserHomeViewController.m
//  RestFullClient
//
//  Created by akyryl on 3/15/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "UserHomeViewController.h"

#import "EditProfileViewController.h"
#import "ProfileDataSource.h"
#import "ProfileData.h"


static NSString *const kCaptionLabelText = @"%@'s home page";

@interface UserHomeViewController ()

@end


@implementation UserHomeViewController

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
    [self updateControls];
}

- (void)viewDidAppear:(BOOL)animated
{
    // For case we deleted user in EditProfileViewController
    if (!self.profileDataSource.isAuthenticated)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)updateControls
{
    NSString *captionText = self.profileDataSource.isAuthenticated
        ? [NSString stringWithFormat:kCaptionLabelText, self.profileDataSource.userName]
        : @"";
    captionLable.text = captionText;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EditProfileSegue"])
    {
        EditProfileViewController *editViewController = (EditProfileViewController *)segue.destinationViewController;
        editViewController.profileDataSource = self.profileDataSource;
    }
}

@end
