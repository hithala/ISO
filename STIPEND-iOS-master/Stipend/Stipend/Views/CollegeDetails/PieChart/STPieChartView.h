//
//  STPieChartView.h
//  Stipend
//
//  Created by Arun S on 27/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STPieChartView;

@protocol STPieChartDataSourceDelegate <NSObject>
@required
- (NSUInteger)numberOfSlicesInPieChart:(STPieChartView *)pieChart;
- (CGFloat)pieChart:(STPieChartView *)pieChart valueForSliceAtIndex:(NSUInteger)index;
- (UIColor *)pieChart:(STPieChartView *)pieChart colorForSliceAtIndex:(NSUInteger)index;

- (NSUInteger)numberOfDescriptionsInPieChart:(STPieChartView *)pieChart;
- (NSString *)pieChart:(STPieChartView *)pieChart valueForDescriptionAtIndex:(NSUInteger)index;
- (UIColor *)pieChart:(STPieChartView *)pieChart colorForDescriptionBulletAtIndex:(NSUInteger)index;

- (NSString *)valueOfTitleText:(STPieChartView *)pieChart;
- (UIColor *)colorOfTitleText:(STPieChartView *)pieChart;

@optional

@end

@interface STPieChartView : UIView

@property (nonatomic, assign) CGFloat                               circleRadius;
@property (nonatomic, weak) id<STPieChartDataSourceDelegate>            delegate;
@property (nonatomic, strong) NSString                                    *title;
@property (nonatomic, assign) BOOL                           isPopularMajorsView;

@end
