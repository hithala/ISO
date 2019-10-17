//
//  STFilterCheckboxCell.m
//  Stipend
//
//  Created by Arun S on 18/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFilterCheckboxCell.h"

@implementation STFilterCheckboxCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.textColor = [UIColor cellTextFieldTextColor];
    self.titleLabel.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:16.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onCheckBoxButtonAction:(id)sender {
    
    UIButton *checkBoxButton = (UIButton *)sender;
    
    if([checkBoxButton isSelected]) {
        [checkBoxButton setSelected:NO];
        self.isSelected = NO;
    }
    else {
        [checkBoxButton setSelected:YES];
        self.isSelected = YES;
    }
    
    if(self.didUpdateCellActionBlock) {
        self.didUpdateCellActionBlock(self);
    }
}

@end
