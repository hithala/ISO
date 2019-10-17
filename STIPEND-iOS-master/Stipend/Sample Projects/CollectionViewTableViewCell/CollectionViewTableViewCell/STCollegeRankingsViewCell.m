//
//  STCollegeRankingsViewCell.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 12/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCollegeRankingsViewCell.h"

@implementation STCollegeRankingsViewCell

- (void)awakeFromNib {
    // Initialization code
    self.ibImageView.layer.cornerRadius = self.ibImageView.frame.size.width / 2;
    self.ibImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
