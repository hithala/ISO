//
//  STBarChartView.h
//  PieChartSample
//
//  Created by Arun S on 27/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STBarChartView;

@protocol STBarChartDataSourceDelegate <NSObject>
@required
- (CGFloat) minimumYValueOfBarChart:(STBarChartView *)barChart;
- (CGFloat) maximumYValueOfBarChart:(STBarChartView *)barChart;

- (NSUInteger)numberOfBarsInBarChart:(STBarChartView *)barChart;

- (NSString *)barChart:(STBarChartView *)barChart labelForPercentilesAtIndex:(NSUInteger)index;

- (NSUInteger)barChart:(STBarChartView *)barChart valueFor25thPercentileAtIndex:(NSUInteger)index;
- (UIColor *)barChart:(STBarChartView *)barChart colorFor25thPercentileAtIndex:(NSUInteger)index;

- (NSUInteger)barChart:(STBarChartView *)barChart valueFor75thPercentileAtIndex:(NSUInteger)index;
- (UIColor *)barChart:(STBarChartView *)barChart colorFor75thPercentileAtIndex:(NSUInteger)index;

@optional

@end

@interface STBarChartView : UIView

@property (nonatomic,assign) NSInteger minYValue;
@property (nonatomic,assign) NSInteger maxYValue;
@property (nonatomic,assign) NSInteger stepYValue;
@property (nonatomic, weak) id<STBarChartDataSourceDelegate>            delegate;

@end
