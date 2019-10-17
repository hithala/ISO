//
//  STCollegeRankingsViewCell.h
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 12/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCollegeRankingsViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel                              *ibLabelValue;
@property (weak, nonatomic) IBOutlet UIImageView                           *ibImageView;
@property (weak, nonatomic) IBOutlet UILabel                               *ibRankLabel;
@property (weak, nonatomic) IBOutlet UIView                        *ibSeparatorLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint  *cellSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorLeadingConstraint;

@end
