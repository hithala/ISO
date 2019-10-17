//
//  STFreshmenEthnicityCell.m
//  Stipend
//
//  Created by Arun S on 25/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFreshmenEthnicityCell.h"

#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"

@implementation STFreshmenEthnicityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pieChartView.delegate = self;
}

- (void) updatePieChartViewWithDetails:(NSOrderedSet *) details {
    
    self.pieChartDetails = details;
}

- (NSUInteger)numberOfSlicesInPieChart:(STPieChartView *)pieChart {
    
    if(self.pieChartDetails && self.pieChartDetails.count > 0) {
        return [self.pieChartDetails count];
    }
    return 0;
}

- (CGFloat)pieChart:(STPieChartView *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    
    STCPieChartItem *item = [self.pieChartDetails objectAtIndex:index];
    
    return [item.value floatValue];
}

- (UIColor *)pieChart:(STPieChartView *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    
    return [BLUE_COLOR_ARRAY objectAtIndex:index];
}

- (NSUInteger)numberOfDescriptionsInPieChart:(STPieChartView *)pieChart {
    
    return [self.pieChartDetails count];
}

- (NSString *)pieChart:(STPieChartView *)pieChart valueForDescriptionAtIndex:(NSUInteger)index {
    
    STCPieChartItem *item = [self.pieChartDetails objectAtIndex:index];
    
    return [NSString stringWithFormat:@"%@ - %.0f%%", item.key, [item.value floatValue]];
}

- (UIColor *)pieChart:(STPieChartView *)pieChart colorForDescriptionBulletAtIndex:(NSUInteger)index {
    
    return [BLUE_COLOR_ARRAY objectAtIndex:index];
}

- (NSString *)valueOfTitleText:(STPieChartView *)pieChart {
    
    return @"ETHNICITY";
}

- (UIColor *)colorOfTitleText:(STPieChartView *)pieChart {
    return [UIColor cellTextFieldTextColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc {
    self.pieChartDetails = nil;
}

@end
