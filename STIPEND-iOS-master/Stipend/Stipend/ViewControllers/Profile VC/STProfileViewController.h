//
//  STProfileViewController.h
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STProfileViewController : UITableViewController

@property (nonatomic,retain) UITapGestureRecognizer               *tapGesture;

@property (nonatomic,retain) NSMutableDictionary *profileDataSourceDictionary;
@property (nonatomic,assign) UserType                        selectedUserType;
@property (nonatomic,assign) GenderType                    selectedGenderType;

@end
