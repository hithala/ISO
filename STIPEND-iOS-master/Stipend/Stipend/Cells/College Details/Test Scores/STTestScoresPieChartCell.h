//
//  STTestScoresPieChartCell.h
//  Stipend
//
//  Created by Arun S on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCollegeSegmentControl.h"
#import "STPieChartView.h"
#import "STCTestScoresAndGrades+CoreDataClass.h"
#import "STCTestScoresAndGrades+CoreDataProperties.h"
#import "STCPieChart.h"
#import "STCPieChartItem.h"
#import "STSATPieChartView.h"

@interface STTestScoresPieChartCell : UITableViewCell <STPieChartDataSourceDelegate,STSegmentControlDelegate>

@property (nonatomic,assign)  NSUInteger                                   selectedIndex;
@property (nonatomic,retain)  STCTestScoresAndGrades                *testScoresAndGrades;
@property (nonatomic,retain)  NSMutableOrderedSet                           *pieChartSet;

@property (nonatomic, copy) void (^toggleAction)(void);

- (void) updateTestScorePieChartWithDetails:(STCTestScoresAndGrades *) testScores;

@end
