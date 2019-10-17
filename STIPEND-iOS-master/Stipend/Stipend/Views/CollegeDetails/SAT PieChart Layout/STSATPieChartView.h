//
//  STSATPieChartView.h
//  Stipend
//
//  Created by Arun S on 04/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSATPieChartView : UIView

@property (nonatomic, assign) CGFloat        circleRadius;
@property (nonatomic, retain) NSOrderedSet     *pieCharts;
@property (nonatomic, assign) CGFloat      titleYPosition;

- (void) updateSATLayoutItems:(NSOrderedSet *) layoutItems;

@end
