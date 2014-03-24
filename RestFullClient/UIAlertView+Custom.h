//
//  UIAlertView+Custom.h
//  RestFullClient
//
//  Created by akyryl on 3/24/14.
//  Copyright (c) 2014 Anatolii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Custom)

+ (UIAlertView *)connectionError;
+ (UIAlertView *)confirmDeletion:(id)delegate;

@end
