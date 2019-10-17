//
//  STFilterCell.m
//  Stipend
//
//  Created by Arun S on 19/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFilterCell.h"

@implementation STFilterCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0];
    self.titleLabel.textColor = [UIColor cellTextFieldTextColor];
    
    self.valueLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0];
    self.valueLabel.textColor = [UIColor cellLabelTextColor];
}

- (void)updateTitleFontIfNeeded {

    if((self.cellIndexPath.section == RELIGIOUS_AFFILIATION_SECTION) || (self.cellIndexPath.section == MAJORS_SECTION)) {
        self.titleLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:13.0];
        self.titleLabel.textColor = [UIColor cellTextFieldTextColor];
    } else {
        self.titleLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0];
        self.titleLabel.textColor = [UIColor cellTextFieldTextColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
