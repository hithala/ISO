//
//  STCTestScoresHSCRBarChart+CoreDataProperties.m
//  
//
//  Created by Ganesh kumar on 24/05/17.
//
//

#import "STCTestScoresHSCRBarChart+CoreDataProperties.h"

@implementation STCTestScoresHSCRBarChart (CoreDataProperties)

+ (NSFetchRequest<STCTestScoresHSCRBarChart *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"STCTestScoresHSCRBarChart"];
}

@dynamic topTenthPercentageValue;
@dynamic totalPercentageValue;
@dynamic bottomQuarterPercentageValue;
@dynamic bottomHalfPercentageValue;
@dynamic topHalfPercentageValue;
@dynamic topQuarterPercentageValue;
@dynamic testScoresAndGrades;

@end
