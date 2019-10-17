//
//  STTestScoresHSCRCell.m
//  Stipend
//
//  Created by Ganesh kumar on 27/05/17.
//  Copyright © 2017 Sourcebits. All rights reserved.
//

#import "STTestScoresHSCRCell.h"

#define BAR_CHART_BASE_TAG       2873
#define BAR_CHART_ROW_HEIGHT      300

@interface STTestScoresHSCRCell ()

@property (retain) UIView *barChartView;

@property (strong, nonatomic) NSArray *barTitles;
@property (strong, nonatomic) NSArray *barValues;

@end

@implementation STTestScoresHSCRCell
@synthesize bar = _bar;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBar:(NSArray<NSDictionary *> *)bars{
    
    _bar = bars;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateBarCharts];
}

- (void) updateBarChartsWithDetails:(STCTestScoresAndGrades *) testScores {
    self.testScoresAndGrades = testScores;
    self.barTitles = @[@"Top Tenth", @"Top Qtr", @"Top Half", @"Bottom Half", @"Bottom Qtr"];
    self.barValues = [self getBarValues];
    
    [self updateBarCharts];
    [[self viewWithTag:BAR_CHART_BASE_TAG] setNeedsDisplay];
}

- (NSArray *)getBarValues {
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    STCTestScoresHSCRBarChart *barChart = self.testScoresAndGrades.testScoreHSCRBarCharts;
    
    [values addObject:barChart.topTenthPercentageValue];
    [values addObject:barChart.topQuarterPercentageValue];
    [values addObject:barChart.topHalfPercentageValue];
    [values addObject:barChart.bottomHalfPercentageValue];
    [values addObject:barChart.bottomQuarterPercentageValue];

    return values;
}

- (NSOrderedSet *) getOrderedSetForTestScoreBarChart:(NSInteger) index {
    
    return (NSOrderedSet *)[self.testScoresAndGrades.testScoresBarCharts objectAtIndex:index];
}

- (void) updateBarCharts {

    STHighSchoolClassRankBarChartView *barChart = (STHighSchoolClassRankBarChartView *)[self viewWithTag:(BAR_CHART_BASE_TAG)];

    if(!barChart) {
        barChart = [[STHighSchoolClassRankBarChartView alloc] initWithFrame:CGRectMake(0.0, 60.0, self.frame.size.width, 180.0)];
        barChart.delegate = self;
        barChart.backgroundColor = [UIColor clearColor];
        barChart.tag = BAR_CHART_BASE_TAG;
        [self.contentView addSubview:barChart];
    }

    if(!barChart.percentileColor) {
        barChart.percentileColor = [UIColor colorWithRed:54.0/255.0 green:145.0/255.0 blue:242.0/255.0 alpha:1.0];
    }
    
    barChart.frame = CGRectMake(0.0, 20.0, self.frame.size.width, BAR_CHART_ROW_HEIGHT);

    STCTestScoresHSCRBarChart *barChartValues = self.testScoresAndGrades.testScoreHSCRBarCharts;
    
    if(barChartValues.totalPercentageValue.integerValue > 0) {
        barChart.percentageTitle = @"Freshmen Who Submitted Rank";
    } else {
        barChart.percentageTitle = @"";
    }
}


// BAR CHART DATASOURCES

- (CGFloat) minimumYValueOfBarChart:(STHighSchoolClassRankBarChartView *)barChart {

    return 0.0;
}

- (CGFloat) maximumYValueOfBarChart:(STHighSchoolClassRankBarChartView *)barChart {
    
    return 100.0;
}

- (NSUInteger)numberOfBarsInBarChart:(STHighSchoolClassRankBarChartView *)barChart {

    return 5;
}

- (NSUInteger)barChart:(STHighSchoolClassRankBarChartView *)barChart valueForPercentileAtIndex:(NSUInteger)index {
    
    NSNumber *value = [self.barValues objectAtIndex:index];
    return value.integerValue;
}

- (NSString *)barChart:(STHighSchoolClassRankBarChartView *)barChart labelForPercentilesAtIndex:(NSUInteger)index {
    
    return [self.barTitles objectAtIndex:index];
}

- (NSUInteger)valueOfFreshmenRankPercentageInBarChart:(STHighSchoolClassRankBarChartView *) barChart {

    STCTestScoresHSCRBarChart *barChartValues = self.testScoresAndGrades.testScoreHSCRBarCharts;
    return barChartValues.totalPercentageValue.integerValue;
}

- (void)dealloc {
}

@end
