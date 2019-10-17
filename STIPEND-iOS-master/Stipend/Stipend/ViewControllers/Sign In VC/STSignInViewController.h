//
//  STSignInViewController.h
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSignInViewController : UITableViewController

@property (nonatomic,retain) NSMutableDictionary *signInDataSourceDictionary;
@property (nonatomic,retain) UITapGestureRecognizer              *tapGesture;

- (void) didUpdateValueInCell:(id) cell;

@end
