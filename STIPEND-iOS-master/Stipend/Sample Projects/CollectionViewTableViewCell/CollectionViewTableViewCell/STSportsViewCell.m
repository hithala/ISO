//
//  STSportsViewCell.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 10/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STSportsViewCell.h"

@implementation STSportsViewCell

- (void)awakeFromNib {
    // Initialization code
    //self.ibRightLabel.hidden = YES;
    //self.ibRightSeparatorLine.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //self.ibLeftLabelWidthConstraint.constant = self.frame.size.width - 20.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
