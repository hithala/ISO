//
//  STFreshmanGenderCell.m
//  Stipend
//
//  Created by Arun S on 25/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFreshmanGenderCell.h"

#define KEY_MALE_PERCENTAGE             @"kMalePercentageKey"
#define KEY_FEM_PERCENTAGE              @"kFemalePercentageKey"

@implementation STFreshmanGenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateGenderPercentageWithDetails:(STCFreshmanGenderDetails *) details {
    
    self.genderView.malePercentage = [details.malePercentage floatValue];
    self.genderView.femalePercentage = [details.femalePercentage floatValue];
}

- (void)dealloc {
}

@end
