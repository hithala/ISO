//
//  STCTestScoresAndGrades+CoreDataProperties.m
//  
//
//  Created by Ganesh kumar on 24/05/17.
//
//

#import "STCTestScoresAndGrades+CoreDataProperties.h"

@implementation STCTestScoresAndGrades (CoreDataProperties)

+ (NSFetchRequest<STCTestScoresAndGrades *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"STCTestScoresAndGrades"];
}

@dynamic barChartSelectedIndex;
@dynamic pieChartSelectedIndex;
@dynamic averageScores;
@dynamic testScoreSATPieChart;
@dynamic testScoresBarCharts;
@dynamic testScoresPieCharts;
@dynamic testScoreHSCRBarCharts;

@end
