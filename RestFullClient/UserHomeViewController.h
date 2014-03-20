//
//  UserHomeViewController.h
//  RestFullClient
//
//  Created by akyryl on 3/15/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UserDataSource;

@interface UserHomeViewController : UIViewController
{
    IBOutlet UILabel *captionLable;
    IBOutlet UIButton *editProfileButton;
}

@property (nonatomic, assign) UserDataSource *profileDataSource;

@end
