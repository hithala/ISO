//
//  STTestScoresPieChartCell.m
//  Stipend
//
//  Created by Arun S on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STTestScoresPieChartCell.h"

#define PIE_CHART_BASE_TAG              2769
#define PIE_CHART_ROW_HEIGHT            180.0

#define SAT_PIE_CHART_BASE_TAG          2479
#define SAT_PIE_CHART_ROW_HEIGHT        300.0

#define TOGGLE_STATE_VIEW_TAG           670
#define FOOTER_VIEW_TAG                 660

#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"

@implementation STTestScoresPieChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedIndex = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updateTestScorePieCharts];
}

- (void) updateTestScorePieChartWithDetails:(STCTestScoresAndGrades *) testScores {
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.testScoresAndGrades = testScores;
    [self createPieChartListsSet];
    [self updateTestScorePieCharts];
}

- (void) updateTestScorePieCharts {

    STCollegeSegmentControl *segmentControl = (STCollegeSegmentControl *)[self viewWithTag:(TOGGLE_STATE_VIEW_TAG)];
    
    if(!segmentControl) {
        segmentControl = [[STCollegeSegmentControl alloc] initWithFrame:CGRectZero];
        segmentControl.delegate = self;
        segmentControl.tag = TOGGLE_STATE_VIEW_TAG;
        [self.contentView addSubview:segmentControl];
    }
    
    if([self.testScoresAndGrades.pieChartSelectedIndex integerValue] == 0) {
        self.selectedIndex = 0;
    }
    else if ([self.testScoresAndGrades.pieChartSelectedIndex integerValue] == 1) {
        self.selectedIndex = 1;
    }
    else if ([self.testScoresAndGrades.pieChartSelectedIndex integerValue] == 2){
        self.selectedIndex = 2;
    }
    else {
        self.selectedIndex = 0;
    }

    CGFloat footerOrigin = 50.0;
    
    NSArray *itemArray = [self getItemsFromTestScoresPicChartList];
    segmentControl.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 40.0);
    [segmentControl setSelectedIndex:self.selectedIndex];
    [segmentControl updateSegmentControlWithItems:itemArray];

    id pieChartItem = [self getPieChartObjectForItemAtIndex:self.selectedIndex];
    
    if([pieChartItem isKindOfClass:[STCSATPieChartLayout class]]) {
        STSATPieChartView *satPieChart = (STSATPieChartView *)[self viewWithTag:(SAT_PIE_CHART_BASE_TAG)];
        
        if(!satPieChart) {
//            satPieChart = [[STSATPieChartView alloc] initWithFrame:CGRectMake(0.0, 50.0, self.frame.size.width, SAT_PIE_CHART_ROW_HEIGHT)];
            satPieChart = [[STSATPieChartView alloc] initWithFrame:CGRectMake(0.0, 50.0, self.frame.size.width, self.frame.size.height - 50.0)];
            satPieChart.backgroundColor = [UIColor clearColor];
            [satPieChart updateSATLayoutItems:[(STCSATPieChartLayout *)pieChartItem items]];
            satPieChart.tag = SAT_PIE_CHART_BASE_TAG;
            [self.contentView addSubview:satPieChart];
        }
        
        satPieChart.backgroundColor = [UIColor clearColor];
//        satPieChart.frame = CGRectMake(0.0, 50.0, self.frame.size.width, SAT_PIE_CHART_ROW_HEIGHT);
        satPieChart.frame = CGRectMake(0.0, 50.0, self.frame.size.width, self.frame.size.height - 50.0);
//        footerOrigin += SAT_PIE_CHART_ROW_HEIGHT;
        footerOrigin += self.frame.size.height - 50.0;
    }
    else {
        STPieChartView *pieChart = (STPieChartView *)[self viewWithTag:(PIE_CHART_BASE_TAG)];
        
        if(!pieChart) {
            pieChart = [[STPieChartView alloc] initWithFrame:CGRectMake(0.0, 50.0, self.frame.size.width, PIE_CHART_ROW_HEIGHT)];
            pieChart.delegate = self;
            pieChart.backgroundColor = [UIColor clearColor];
            pieChart.tag = PIE_CHART_BASE_TAG;
            [self.contentView addSubview:pieChart];
        }
        
        pieChart.frame = CGRectMake(0.0, 50.0, self.frame.size.width, PIE_CHART_ROW_HEIGHT);
        footerOrigin += PIE_CHART_ROW_HEIGHT;
    }
}

- (void) didClickSegmentAtIndex:(NSUInteger) index {
    
    if(index != self.selectedIndex) {
        self.selectedIndex = index;
        self.testScoresAndGrades.pieChartSelectedIndex = [NSNumber numberWithInteger:index];
        [self updateTestScorePieCharts];
        if(self.toggleAction) {
            self.toggleAction();
        }
    }
}

- (NSUInteger)numberOfSlicesInPieChart:(STPieChartView *)pieChart {
    
    STCPieChart *pieChartObject = (STCPieChart *)[self getPieChartObjectForItemAtIndex:self.selectedIndex];
    if(pieChartObject.pieChartItem.count > 0) {
        return pieChartObject.pieChartItem.count;
    }
    return 0;
}

- (CGFloat)pieChart:(STPieChartView *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    
    STCPieChart *pieChartObject = (STCPieChart *)[self getPieChartObjectForItemAtIndex:self.selectedIndex];
    STCPieChartItem *item = [pieChartObject.pieChartItem objectAtIndex:index];
        
    return [item.value floatValue];
}

- (UIColor *)pieChart:(STPieChartView *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    
    return [BLUE_COLOR_ARRAY objectAtIndex:index];
}

- (NSUInteger)numberOfDescriptionsInPieChart:(STPieChartView *)pieChart {
    
    STCPieChart *pieChartObject = (STCPieChart *)[self getPieChartObjectForItemAtIndex:self.selectedIndex];
    return pieChartObject.pieChartItem.count;
}

- (NSString *)pieChart:(STPieChartView *)pieChart valueForDescriptionAtIndex:(NSUInteger)index {
    
    STCPieChart *pieChartObject = (STCPieChart *)[self getPieChartObjectForItemAtIndex:self.selectedIndex];
    STCPieChartItem *item = [pieChartObject.pieChartItem objectAtIndex:index];
        
    return [NSString stringWithFormat:@"%@     -   %.0f%%", item.key, [item.value floatValue]];
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

- (NSMutableArray *) getItemsFromTestScoresPicChartList {
    
    NSMutableArray *valueArray = [NSMutableArray array];
    
    for (STCPieChart *item in self.testScoresAndGrades.testScoresPieCharts) {
        if([item.name isEqualToString:@"GPA SCORES"]) {
            [valueArray addObject:item.name];
            break;
        }
    }
    
    if(self.testScoresAndGrades.testScoreSATPieChart) {
        [valueArray addObject:self.testScoresAndGrades.testScoreSATPieChart.name];
    }
    
    
    for (STCPieChart *item in self.testScoresAndGrades.testScoresPieCharts) {
        if([item.name isEqualToString:@"ACT SCORES"]) {
            [valueArray addObject:item.name];
            break;
        }
    }
    
    return valueArray;
}

- (void) createPieChartListsSet {
    
    self.pieChartSet = [NSMutableOrderedSet orderedSet];
    
    for (STCPieChart *item in self.testScoresAndGrades.testScoresPieCharts) {
        if([item.name isEqualToString:@"GPA SCORES"]) {
            [self.pieChartSet addObject:item];
            break;
        }
    }
    
    if(self.testScoresAndGrades.testScoreSATPieChart) {
        [self.pieChartSet addObject:self.testScoresAndGrades.testScoreSATPieChart];
    }
    
    
    for (STCPieChart *item in self.testScoresAndGrades.testScoresPieCharts) {
        if([item.name isEqualToString:@"ACT SCORES"]) {
            [self.pieChartSet addObject:item];
            break;
        }
    }
}

- (id) getPieChartObjectForItemAtIndex:(NSInteger) index {
    
    if(self.pieChartSet.count > index) {
        return [self.pieChartSet objectAtIndex:index];
    } else {
        return nil;
    }
}

- (void)dealloc {
    self.testScoresAndGrades = nil;
}

@end
