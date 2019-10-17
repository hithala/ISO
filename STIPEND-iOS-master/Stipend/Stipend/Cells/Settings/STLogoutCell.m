//
//  STLogoutCell.m
//  Stipend
//
//  Created by Arun S on 20/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STLogoutCell.h"

@implementation STLogoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([[STUserManager sharedManager] isGuestUser]) {
        self.ibValueLabel.text = @"Reset App";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
