//
//  STFreshmanRateCell.m
//  Stipend
//
//  Created by Ganesh kumar on 07/02/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import "STFreshmanRateCell.h"

#define KEY_MALE_PERCENTAGE             @"kMalePercentageKey"
#define KEY_FEM_PERCENTAGE              @"kFemalePercentageKey"

@implementation STFreshmanRateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) updateRatesPercentageWithDetails:(STCFreshmanGraduationDetails *)details forType:(FreshmenItem)type {

    if(type == FreshmenItemGraduationRate) {
        self.ratesView.firstPercentage = [details.fourYearGraduationRate floatValue];
        self.ratesView.secondPercentage = [details.sixYearGraduationRate floatValue];
    } else if(type == FreshmenItemRetentionRate) {
        self.ratesView.firstPercentage = [details.retentionRate floatValue];
        self.ratesView.secondPercentage = 0.0;
    }
    
    self.ratesView.freshmenItem = type;
    
    self.ratesView.imageClickActionBlock = ^(UIImageView *questionMarkview){
        if(self.imageClickActionBlock) {
            self.imageClickActionBlock(questionMarkview);
        }
    };

    [self.ratesView setNeedsDisplay];
}

- (void)dealloc {
}

@end
