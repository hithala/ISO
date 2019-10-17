//
//  STTestScoresBarChartCell.m
//  Stipend
//
//  Created by Arun S on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STTestScoresBarChartCell.h"
#import "STCTestScoresBarChart.h"
#import "STCBarChartItem.h"
#import "STTutorialView.h"
#import "STTestScoresNewTotalPopUp.h"

#define BAR_CHART_BASE_TAG       2873
#define BAR_CHART_ROW_HEIGHT      300

#define POPUP_VEIW_TAG            301

#define TOGGLE_STATE_VIEW_TAG     360

@interface STTestScoresBarChartCell ()

@property (retain) UIView *barChartView;
@end


@implementation STTestScoresBarChartCell
@synthesize bar = _bar;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.selectedIndex = 0;
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

    STTestScoresNewTotalPopUp *popupView = (STTestScoresNewTotalPopUp *)[self viewWithTag:POPUP_VEIW_TAG];
    if(popupView) {
        [popupView removeFromSuperview];
    }
    
    [self updateBarCharts];
    [[self viewWithTag:BAR_CHART_BASE_TAG] setNeedsDisplay];
}

- (NSOrderedSet *) getOrderedSetForTestScoreBarChart:(NSInteger) index {

    return (NSOrderedSet *)[self.testScoresAndGrades.testScoresBarCharts objectAtIndex:index];
}

- (void) updateBarCharts {

    STCollegeSegmentControl *segmentControl = (STCollegeSegmentControl *)[self viewWithTag:(TOGGLE_STATE_VIEW_TAG)];

    if(!segmentControl) {
        segmentControl = [[STCollegeSegmentControl alloc] initWithFrame:CGRectZero];
        segmentControl.delegate = self;
        segmentControl.tag = TOGGLE_STATE_VIEW_TAG;
        [self.contentView addSubview:segmentControl];
    }

    if([self.testScoresAndGrades.barChartSelectedIndex integerValue] != -1) {
        self.selectedIndex = [self.testScoresAndGrades.barChartSelectedIndex integerValue];
    }

    NSMutableArray *itemArray = [self getItemsFromTestScoresList];
    segmentControl.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 40.0);
    [segmentControl setSelectedIndex:self.selectedIndex];
    [segmentControl updateSegmentControlWithItems:itemArray];

//    BOOL isSatScore = [itemArray[self.selectedIndex] containsString:@"SAT"];

    STBarChartView *barChart = (STBarChartView *)[self viewWithTag:(BAR_CHART_BASE_TAG)];

    if(!barChart) {
        barChart = [[STBarChartView alloc] initWithFrame:CGRectMake(0.0, 60.0, self.frame.size.width, 180.0)];
        barChart.delegate = self;
        barChart.backgroundColor = [UIColor clearColor];
        barChart.tag = BAR_CHART_BASE_TAG;
        [self.contentView addSubview:barChart];
    }

//    UITapGestureRecognizer *barTap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(showBarChartPopover:)];
//
//    if (isSatScore) {
//        [barChart addGestureRecognizer:barTap];
//        self.barChartView = barChart;
//    } else {
//        for(UIGestureRecognizer *gesture in barChart.gestureRecognizers) {
//            [barChart removeGestureRecognizer:gesture];
//        }
//    }

    if(!barChart.percentile25thColor) {
        barChart.percentile25thColor = [UIColor colorWithRed:54.0/255.0 green:145.0/255.0 blue:242.0/255.0 alpha:1.0];
    }

    if(!barChart.percentile75thColor) {
        barChart.percentile75thColor = [UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:66.0/255.0 alpha:1.0];
    }

    barChart.frame = CGRectMake(0.0, 60.0, self.frame.size.width, BAR_CHART_ROW_HEIGHT);
}

- (void) didClickSegmentAtIndex:(NSUInteger) index {

    if(index != self.selectedIndex) {
        self.testScoresAndGrades.barChartSelectedIndex = [NSNumber numberWithInteger:index];
        self.selectedIndex = index;
        if(self.toggleAction) {
            self.toggleAction();
        }
    }
}

- (void) showBarChartPopover:(UITapGestureRecognizer*) tapGesture {

    for (NSDictionary *barDictionary in self.bar) {

        UIBezierPath *graphPath = [ barDictionary objectForKey:@"graphPath" ];
        NSString *graphTitle = [ barDictionary objectForKey:@"graphTitle" ];

        if([graphPath containsPoint:[tapGesture locationInView:self.barChartView]] && [graphTitle isEqualToString:@"TotalScore"]){

          /*  STTestScorePopoverViewController *popoverView = [[ STTestScorePopoverViewController alloc ] initWithNibName:@"STTestScorePopoverViewController" bundle:nil ];
            popoverView.modalPresentationStyle = UIModalPresentationPopover;
            popoverView.popoverPresentationController.delegate = popoverView;
            popoverView.popoverPresentationController.sourceView = self.barChartView;
            popoverView.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown| UIPopoverArrowDirectionUp;
            popoverView.popoverPresentationController.sourceRect = CGPathGetPathBoundingBox(graphPath.CGPath);

            if(self.presentPopoverController){
                self.presentPopoverController(popoverView);
                
                STCTestScoresBarChart *selectedBarChart = [self.testScoresAndGrades.testScoresBarCharts objectAtIndex:self.selectedIndex];
                
                NSString *newSatEquivalentValue = [NSString stringWithFormat:@"%@ / %@", selectedBarChart.percentageNewLowValue, selectedBarChart.percentageNewHighValue];
                [popoverView.currentSATScoreLabel setText: newSatEquivalentValue];
                //[popoverView.currentSATScoreLabel sizeToFit];
            } */
            
            STCTestScoresBarChart *selectedBarChart = [self.testScoresAndGrades.testScoresBarCharts objectAtIndex:self.selectedIndex];

            STTestScoresNewTotalPopUp *popupView = (STTestScoresNewTotalPopUp *)[self viewWithTag:POPUP_VEIW_TAG];
            if(!popupView) {
                popupView = [[NSBundle mainBundle] loadNibNamed:@"STTestScoresNewTotalPopUp" owner:self options:0].firstObject;
                CGRect barRect = CGPathGetPathBoundingBox(graphPath.CGPath);
                barRect.origin.y += 28;
                popupView.frame = barRect;
                popupView.tag = POPUP_VEIW_TAG;
                popupView.backgroundColor = [UIColor clearColor];
                popupView.label.text = [NSString stringWithFormat:@"New SAT Equiv: %@ / %@", selectedBarChart.percentageNewLowValue, selectedBarChart.percentageNewHighValue];
                [self addSubview:popupView];
            } else {
                [popupView removeFromSuperview];
            }

            STLog(@"%@",  [ barDictionary objectForKey:@"graphTitle" ] );
            break;
        }
    }
}

// BAR CHART DATASOURCES

- (CGFloat) minimumYValueOfBarChart:(STBarChartView *)barChart {

    STCTestScoresBarChart *selectedBarChart = [self.testScoresAndGrades.testScoresBarCharts objectAtIndex:self.selectedIndex];
    if([selectedBarChart.title isEqualToString:@"ACT SCORE"]) {
        return 8.0;
    } else {
        return 200.0;
    }

    return 0.0;
}

- (CGFloat) maximumYValueOfBarChart:(STBarChartView *)barChart {

    STCTestScoresBarChart *selectedBarChart = [self.testScoresAndGrades.testScoresBarCharts objectAtIndex:self.selectedIndex];
    if([selectedBarChart.title isEqualToString:@"ACT SCORE"]) {
        return 36.0;
    } else {
        return 800.0;
    }
}

- (NSUInteger)numberOfBarsInBarChart:(STBarChartView *)barChart {

    STCTestScoresBarChart *selectedBarChart = [self.testScoresAndGrades.testScoresBarCharts objectAtIndex:self.selectedIndex];

    if([selectedBarChart.title isEqualToString:@"ACT SCORE"]) {
        barChart.percentageTitle = @"Composite";
    } else {
        barChart.percentageTitle = @"Total";
    }

    return selectedBarChart.barChartItems.count;
}

- (NSUInteger)barChart:(STBarChartView *)barChart valueFor25thPercentileAtIndex:(NSUInteger)index {

    STCTestScoresBarChart *selectedBarChart = [self.testScoresAndGrades.testScoresBarCharts objectAtIndex:self.selectedIndex];
    STCBarChartItem *item = [selectedBarChart.barChartItems objectAtIndex:index];

    return [item.lowerValue integerValue];
}

- (UIColor *)barChart:(STBarChartView *)barChart colorFor25thPercentileAtIndex:(NSUInteger)index {
    return [UIColor colorWithRed:54.0/255.0 green:145.0/255.0 blue:242.0/255.0 alpha:1.0];
}

- (NSUInteger)barChart:(STBarChartView *)barChart valueFor75thPercentileAtIndex:(NSUInteger)index {

    STCTestScoresBarChart *selectedBarChart = [self.testScoresAndGrades.testScoresBarCharts objectAtIndex:self.selectedIndex];
    STCBarChartItem *item = [selectedBarChart.barChartItems objectAtIndex:index];

    return [item.upperValue integerValue];
}

- (UIColor *)barChart:(STBarChartView *)barChart colorFor75thPercentileAtIndex:(NSUInteger)index {
    return [UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:66.0/255.0 alpha:1.0];
}

- (NSString *)barChart:(STBarChartView *)barChart labelForPercentilesAtIndex:(NSUInteger)index {

    STCTestScoresBarChart *selectedBarChart = [self.testScoresAndGrades.testScoresBarCharts objectAtIndex:self.selectedIndex];
    STCBarChartItem *item = [selectedBarChart.barChartItems objectAtIndex:index];

    return item.title;
}

- (NSUInteger)valueOfFirstPercentageInBarChart:(STBarChartView *) barChart {

    STCTestScoresBarChart *selectedBarChart = [self.testScoresAndGrades.testScoresBarCharts objectAtIndex:self.selectedIndex];
    if([selectedBarChart.title isEqualToString:@"ACT SCORE"]) {
        return [selectedBarChart.percentageLowValue integerValue];
    } else {
        if([selectedBarChart.newScoresAvailable boolValue]) {
            return [selectedBarChart.percentageNewLowValue integerValue];
        } else {
            return [selectedBarChart.percentageLowValue integerValue];
        }
    }
}

- (NSUInteger)valueOfSecondPercentageInBarChart:(STBarChartView *) barChart {

    STCTestScoresBarChart *selectedBarChart = [self.testScoresAndGrades.testScoresBarCharts objectAtIndex:self.selectedIndex];
    if([selectedBarChart.title isEqualToString:@"ACT SCORE"]) {
        return [selectedBarChart.percentageHighValue integerValue];
    } else {
        if([selectedBarChart.newScoresAvailable boolValue]) {
            return [selectedBarChart.percentageNewHighValue integerValue];
        } else {
            return [selectedBarChart.percentageHighValue integerValue];
        }
    }
}

- (NSMutableArray *) getItemsFromTestScoresList {

    NSMutableArray *valueArray = [NSMutableArray array];

    for (STCTestScoresBarChart *item in self.testScoresAndGrades.testScoresBarCharts) {
        [valueArray addObject:item.title];

    }
    
    return valueArray;
}

- (void)dealloc {
}

@end
