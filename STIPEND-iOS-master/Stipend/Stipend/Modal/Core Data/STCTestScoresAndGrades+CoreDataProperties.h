//
//  STCTestScoresAndGrades+CoreDataProperties.h
//  
//
//  Created by Ganesh kumar on 24/05/17.
//
//

#import "STCTestScoresAndGrades+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface STCTestScoresAndGrades (CoreDataProperties)

+ (NSFetchRequest<STCTestScoresAndGrades *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *barChartSelectedIndex;
@property (nullable, nonatomic, copy) NSNumber *pieChartSelectedIndex;
@property (nullable, nonatomic, retain) NSOrderedSet<STCAverageScoreItem *> *averageScores;
@property (nullable, nonatomic, retain) STCSATPieChartLayout *testScoreSATPieChart;
@property (nullable, nonatomic, retain) NSOrderedSet<STCTestScoresBarChart *> *testScoresBarCharts;
@property (nullable, nonatomic, retain) NSOrderedSet<STCPieChart *> *testScoresPieCharts;
@property (nullable, nonatomic, retain) STCTestScoresHSCRBarChart *testScoreHSCRBarCharts;

@end

@interface STCTestScoresAndGrades (CoreDataGeneratedAccessors)

- (void)insertObject:(STCAverageScoreItem *)value inAverageScoresAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAverageScoresAtIndex:(NSUInteger)idx;
- (void)insertAverageScores:(NSArray<STCAverageScoreItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAverageScoresAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAverageScoresAtIndex:(NSUInteger)idx withObject:(STCAverageScoreItem *)value;
- (void)replaceAverageScoresAtIndexes:(NSIndexSet *)indexes withAverageScores:(NSArray<STCAverageScoreItem *> *)values;
- (void)addAverageScoresObject:(STCAverageScoreItem *)value;
- (void)removeAverageScoresObject:(STCAverageScoreItem *)value;
- (void)addAverageScores:(NSOrderedSet<STCAverageScoreItem *> *)values;
- (void)removeAverageScores:(NSOrderedSet<STCAverageScoreItem *> *)values;

- (void)insertObject:(STCTestScoresBarChart *)value inTestScoresBarChartsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTestScoresBarChartsAtIndex:(NSUInteger)idx;
- (void)insertTestScoresBarCharts:(NSArray<STCTestScoresBarChart *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTestScoresBarChartsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTestScoresBarChartsAtIndex:(NSUInteger)idx withObject:(STCTestScoresBarChart *)value;
- (void)replaceTestScoresBarChartsAtIndexes:(NSIndexSet *)indexes withTestScoresBarCharts:(NSArray<STCTestScoresBarChart *> *)values;
- (void)addTestScoresBarChartsObject:(STCTestScoresBarChart *)value;
- (void)removeTestScoresBarChartsObject:(STCTestScoresBarChart *)value;
- (void)addTestScoresBarCharts:(NSOrderedSet<STCTestScoresBarChart *> *)values;
- (void)removeTestScoresBarCharts:(NSOrderedSet<STCTestScoresBarChart *> *)values;

- (void)insertObject:(STCPieChart *)value inTestScoresPieChartsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTestScoresPieChartsAtIndex:(NSUInteger)idx;
- (void)insertTestScoresPieCharts:(NSArray<STCPieChart *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTestScoresPieChartsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTestScoresPieChartsAtIndex:(NSUInteger)idx withObject:(STCPieChart *)value;
- (void)replaceTestScoresPieChartsAtIndexes:(NSIndexSet *)indexes withTestScoresPieCharts:(NSArray<STCPieChart *> *)values;
- (void)addTestScoresPieChartsObject:(STCPieChart *)value;
- (void)removeTestScoresPieChartsObject:(STCPieChart *)value;
- (void)addTestScoresPieCharts:(NSOrderedSet<STCPieChart *> *)values;
- (void)removeTestScoresPieCharts:(NSOrderedSet<STCPieChart *> *)values;

@end

NS_ASSUME_NONNULL_END
