//
//  STTestScoresBarChartCell.h
//  Stipend
//
//  Created by Arun S on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STBarChartView.h"
#import "STCTestScoresAndGrades+CoreDataClass.h"
#import "STCTestScoresAndGrades+CoreDataProperties.h"
#import "STCollegeSegmentControl.h"
#import "STTestScorePopoverViewController.h"

@interface STTestScoresBarChartCell : UITableViewCell <STBarChartDataSourceDelegate,STSegmentControlDelegate>

@property (nonatomic,retain) STCTestScoresAndGrades     *testScoresAndGrades;
@property (nonatomic,assign)  NSUInteger                       selectedIndex;

@property (nonatomic, copy) void (^toggleAction)(void);
@property (nonatomic, copy) void (^presentPopoverController)(STTestScorePopoverViewController*);

- (void) updateBarChartsWithDetails:(STCTestScoresAndGrades *) testScores;

@end
