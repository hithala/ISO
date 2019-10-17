//
//  STTestScoresHSCRCell.h
//  Stipend
//
//  Created by Ganesh kumar on 27/05/17.
//  Copyright © 2017 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STHighSchoolClassRankBarChartView.h"

@interface STTestScoresHSCRCell : UITableViewCell <STHSCRBarChartDataSourceDelegate>

@property (nonatomic,retain) STCTestScoresAndGrades     *testScoresAndGrades;

- (void) updateBarChartsWithDetails:(STCTestScoresAndGrades *) testScores;

@end
