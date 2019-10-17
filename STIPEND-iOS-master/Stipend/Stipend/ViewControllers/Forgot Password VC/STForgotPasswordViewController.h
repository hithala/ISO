//
//  STForgotPasswordViewController.h
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STForgotPasswordViewController : UITableViewController

@property (nonatomic,retain) NSMutableDictionary *forgotPasswordDataSourceDictionary;
@property (nonatomic,retain) NSString                                  *emailAddress;
@property (nonatomic,retain) UITapGestureRecognizer                      *tapGesture;

- (void) didUpdateValueInCell:(id) cell;

@end
