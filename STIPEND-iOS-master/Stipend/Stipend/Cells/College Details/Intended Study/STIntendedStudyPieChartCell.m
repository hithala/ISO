//
//  STIntendedStudyPieChartCell.m
//  Stipend
//
//  Created by Arun S on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STIntendedStudyPieChartCell.h"

#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"

@implementation STIntendedStudyPieChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cellSeparatorHeightConstraint.constant = 0.5f;
    self.pieChartView.delegate = self;
}

- (void) updatePieChartViewWithDetails:(NSOrderedSet *) details {
    
    self.pieChartDetails = details;
    self.pieChartView.isPopularMajorsView = YES;
    [self.pieChartView setNeedsDisplay];
}

- (NSUInteger)numberOfSlicesInPieChart:(STPieChartView *)pieChart {
    
    return [self.pieChartDetails count];
}

- (CGFloat)pieChart:(STPieChartView *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    
    STCPieChartItem *item = [self.pieChartDetails objectAtIndex:index];
    
    if([item.value floatValue] > 0.0) {
        return [item.value floatValue];
    }
    
    return (100.0/self.pieChartDetails.count);
}

- (UIColor *)pieChart:(STPieChartView *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    
    return [BLUE_COLOR_ARRAY objectAtIndex:index];
}

- (NSUInteger)numberOfDescriptionsInPieChart:(STPieChartView *)pieChart {
    
    return [self.pieChartDetails count];
}

- (NSString *)pieChart:(STPieChartView *)pieChart valueForDescriptionAtIndex:(NSUInteger)index {
    
    STCPieChartItem *item = [self.pieChartDetails objectAtIndex:index];
    
    if([item.value floatValue] > 0.0) {
        return [NSString stringWithFormat:@"%@ - %.0f%%", item.key, [item.value floatValue]];
    }
    
    return [NSString stringWithFormat:@"%@",item.key];
}

- (UIColor *)pieChart:(STPieChartView *)pieChart colorForDescriptionBulletAtIndex:(NSUInteger)index {
    
    return [BLUE_COLOR_ARRAY objectAtIndex:index];
}

- (NSString *)valueOfTitleText:(STPieChartView *)pieChart {
    
    return @"";
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
