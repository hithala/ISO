//
//  STFilterOptionsCell.m
//  Stipend
//
//  Created by Arun S on 19/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFilterOptionsCell.h"

@interface STFilterOptionsCell ()

@end

@implementation STFilterOptionsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.switchView.backgroundColor = [UIColor whiteColor];
    self.labelField.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:13.0];
    self.labelField.textColor = [UIColor cellTextFieldTextColor];
    
    self.mySwitch = [[TTSwitch alloc] initWithFrame:CGRectMake(0, 0, 75, 25)];
    self.mySwitch.thumbInsetX = 2.0f;
    self.mySwitch.thumbOffsetY = 2.0f;
    self.mySwitch.overlayImage = [UIImage imageNamed:@"filter_option_inactive_background"];
    self.mySwitch.thumbImage = [UIImage imageNamed:@"filter_option_inactive_head"];
    [self.mySwitch addTarget:self action:@selector(mySwitchClickAction) forControlEvents:UIControlEventValueChanged];
    
    [self.switchView addSubview:self.mySwitch];
    
    [self.switchView bringSubviewToFront:self.statusLabelField];
    
}

- (void)updateSwitchWithStatus:(BOOL)status {

    if(status) {
        self.mySwitch.overlayImage = [UIImage imageNamed:@"filter_option_active_background"];
        self.mySwitch.thumbImage = [UIImage imageNamed:@"filter_option_active_head"];
        self.statusLabelCenterXPosition.constant = -7.5;
    } else {
        self.mySwitch.overlayImage = [UIImage imageNamed:@"filter_option_inactive_background"];
        self.mySwitch.thumbImage = [UIImage imageNamed:@"filter_option_inactive_head"];
        self.statusLabelCenterXPosition.constant = 7.5;
    }
}

- (void)mySwitchClickAction {

    if(self.mySwitch.isOn) {
        [self updateSwitchWithStatus:YES];
    } else {
        [self updateSwitchWithStatus:NO];
    }
    
    if(self.didUpdateCellActionBlock) {
        self.didUpdateCellActionBlock(self);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
