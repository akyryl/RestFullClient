//
//  ViewController.h
//  RestFullClient
//
//  Created by akyryl on 3/15/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserDataSourceProtocol.h"

@interface ViewController : UIViewController <UserDataSourceProtocol>
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *greetingsLable;
    IBOutlet UIButton *goToProfileButton;
    IBOutlet UIButton *goToRegistrationButton;
}

@end
