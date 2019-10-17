//
//  STEditDetailsViewCell.h
//  SwitchDemo
//
//  Created by mahesh on 14/05/15.
//  Copyright (c) 2015 Tarun Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    eEmailField,
    eOldPasswordField,
    ePasswordField,
    eConfirmPasswordField,
}EFieldType;

@interface STEditDetailsViewCell : UITableViewCell

- (void)loadTextFieldType:(EFieldType)type;

@property (weak, nonatomic) IBOutlet UIView                                        *ibSeparatorView;
@property (weak, nonatomic) IBOutlet UIImageView                                *ibProfileImageView;
@property (weak, nonatomic) IBOutlet UITextField                                *ibContentTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint      *ibSepratorViewVerticalSpaceConstraint;

@property (nonatomic,retain) NSIndexPath                                             *cellIndexPath;

@property (nonatomic, assign) EFieldType type;

@property (nonatomic, strong) void (^didUpdateCellActionBlock)(id type);
@property (nonatomic, strong) void (^didClickReturnActionBlock)(id type);


@end
