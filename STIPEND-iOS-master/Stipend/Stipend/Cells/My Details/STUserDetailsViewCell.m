//
//  STUserDetailsViewCell.m
//  SwitchDemo
//
//  Created by mahesh on 14/05/15.
//  Copyright (c) 2015 Tarun Tyagi. All rights reserved.
//

#import "STUserDetailsViewCell.h"

@implementation STUserDetailsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ibUserProfileNameLabel.textColor = [UIColor cellTextFieldTextColor];
    self.ibUserEmailLabelValue.textColor  = [UIColor cellTextFieldTextColor];
    
    self.ibUserProfileNameLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0f];
    self.ibUserEmailLabelValue.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0f];
    
    self.ibOverlayView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.ibOverlayView.hidden = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
