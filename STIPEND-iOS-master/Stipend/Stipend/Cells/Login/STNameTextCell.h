//
//  STNameTextCell.h
//  Stipend
//
//  Created by Arun S on 07/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STNameTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel                                *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel                                 *lastNameLabel;
@property (weak, nonatomic) IBOutlet UITextField                            *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField                             *lastNameField;
@property (weak, nonatomic) IBOutlet UIView                          *lastNameSeperatorView;
@property (weak, nonatomic) IBOutlet UIView                         *firstNameSeperatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNameSeperatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint  *lastNameSeperatorHeightConstraint;

@property (nonatomic,retain) NSIndexPath                                     *cellIndexPath;

@property (nonatomic, strong) void (^didUpdateCellActionBlock)(id);
@property (nonatomic, strong) void (^didStartEditingActionBlock)(id,BOOL);
@property (nonatomic, strong) void (^didEndEditingActionBlock)(id,BOOL);
@property (nonatomic, strong) void (^didClickReturnActionBlock)(id);

@end
