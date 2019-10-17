//
//  STFinancialStateViewCell.h
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 11/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFinancialStateViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ibLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibRightLabel;
@property (weak, nonatomic) IBOutlet UIView  *ibLeftSeparatorLine;
@property (weak, nonatomic) IBOutlet UIView  *ibRightSeparatorLine;
@property (strong, nonatomic) void (^onButtonActionBlock)(id sender);

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibLeftLabelWidthConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibLeftLabelTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibRightLabelWidthConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibRightLabelLeadingConstraint;

- (IBAction)onButtonAction:(id)sender;

@end
