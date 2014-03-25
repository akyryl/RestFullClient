//
//  UIAlertView+Custom.m
//  RestFullClient
//
//  Created by akyryl on 3/24/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import "UIAlertView+Custom.h"

@implementation UIAlertView (Custom)

+ (UIAlertView *)connectionError
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Request error!"
                                                     message:@"Can't connect to the server"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"otherButtonTitles:nil, nil] autorelease];
    return alert;
}

+ (UIAlertView *)confirmDeletion:(id)delegate
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Confirm deletion"
                                                    message:@"Do you really want to delete your profile?"
                                                   delegate:delegate
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil] autorelease];
    return alert;
}

+ (UIAlertView *)invalidDataEntered
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Invalid Data!"
                                                     message:@"Please, enter valid data"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"otherButtonTitles:nil, nil] autorelease];
    return alert;
}

@end
