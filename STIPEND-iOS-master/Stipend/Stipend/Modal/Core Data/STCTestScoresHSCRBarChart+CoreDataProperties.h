//
//  STCTestScoresHSCRBarChart+CoreDataProperties.h
//  
//
//  Created by Ganesh kumar on 24/05/17.
//
//

#import "STCTestScoresHSCRBarChart+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface STCTestScoresHSCRBarChart (CoreDataProperties)

+ (NSFetchRequest<STCTestScoresHSCRBarChart *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *topTenthPercentageValue;
@property (nullable, nonatomic, copy) NSNumber *totalPercentageValue;
@property (nullable, nonatomic, copy) NSNumber *bottomQuarterPercentageValue;
@property (nullable, nonatomic, copy) NSNumber *bottomHalfPercentageValue;
@property (nullable, nonatomic, copy) NSNumber *topHalfPercentageValue;
@property (nullable, nonatomic, copy) NSNumber *topQuarterPercentageValue;
@property (nullable, nonatomic, retain) STCTestScoresAndGrades *testScoresAndGrades;

@end

NS_ASSUME_NONNULL_END
