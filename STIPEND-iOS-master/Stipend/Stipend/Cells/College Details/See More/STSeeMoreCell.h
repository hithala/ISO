//
//  STSeeMoreCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 5/30/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSeeMoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView                               *topCellSeparatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint       *topCellSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint    *bottomCellSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint    *cellSeparatorLeadingSpaceConstraint;

@property (weak, nonatomic) IBOutlet UIButton                                      *ibTapButton;

- (IBAction)clickAction:(UIButton *)sender;

@property (nonatomic, copy) void (^clickActionBlock)(NSInteger tag);

@end
