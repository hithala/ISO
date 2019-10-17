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
    [super awakeFromNib];
    // Initialization code
    
    self.cellSeparatorHeightConstraint.constant = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
}

@end
