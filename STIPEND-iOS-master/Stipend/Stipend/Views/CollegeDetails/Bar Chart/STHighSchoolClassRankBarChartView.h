//
//  STHighSchoolClassRankBarChartView.h
//  Stipend
//
//  Created by Ganesh kumar on 29/05/17.
//  Copyright © 2017 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STHighSchoolClassRankBarChartView;

@protocol STHSCRBarChartDataSourceDelegate <NSObject>
@required
- (CGFloat) minimumYValueOfBarChart:(STHighSchoolClassRankBarChartView *)barChart;
- (CGFloat) maximumYValueOfBarChart:(STHighSchoolClassRankBarChartView *)barChart;

- (NSUInteger)numberOfBarsInBarChart:(STHighSchoolClassRankBarChartView *)barChart;

- (NSString *)barChart:(STHighSchoolClassRankBarChartView *)barChart labelForPercentilesAtIndex:(NSUInteger)index;

- (NSUInteger)barChart:(STHighSchoolClassRankBarChartView *)barChart valueForPercentileAtIndex:(NSUInteger)index;

- (NSUInteger)valueOfFreshmenRankPercentageInBarChart:(STHighSchoolClassRankBarChartView *) barChart;

@property (nonatomic, assign) NSArray<NSDictionary *> *bar;

@optional

@end

@interface STHighSchoolClassRankBarChartView : UIView

@property (nonatomic,assign) NSInteger                                  minYValue;
@property (nonatomic,assign) NSInteger                                  maxYValue;
@property (nonatomic,assign) NSInteger                                 stepYValue;
@property (nonatomic,retain) UIColor                             *percentileColor;

@property (nonatomic,assign) NSInteger                         freshmenPercentage;

@property (nonatomic,retain) NSString                            *percentageTitle;

@property (nonatomic, weak) id<STHSCRBarChartDataSourceDelegate>         delegate;

@end
