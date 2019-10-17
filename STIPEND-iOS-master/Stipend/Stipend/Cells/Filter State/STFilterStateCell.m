//
//  STFilterStateCell.m
//  Stipend
//
//  Created by sourcebits on 06/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFilterStateCell.h"

@implementation STFilterStateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.seperatorView.backgroundColor = [UIColor defaultCellUnderlineColor];
    self.labelField.textColor = [UIColor cellTextFieldTextColor];
    self.labelField.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
