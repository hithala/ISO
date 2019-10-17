//
//  STDefaultCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 15/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STDefaultCell.h"

@implementation STDefaultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellSeparatorHeightConstraint.constant = 0.5f;
    self.ibCellTitleLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0f];
    self.ibCellTitleLabel.textColor = [UIColor cellTextFieldTextColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
}

@end
