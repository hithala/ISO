//
//  STCPieChart.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCFreshman, STCIntendedStudy, STCPieChartItem, STCTestScoresAndGrades;

@interface STCPieChart : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) STCFreshman *freshman;
@property (nonatomic, retain) STCIntendedStudy *intendedStudy;
@property (nonatomic, retain) NSOrderedSet *pieChartItem;
@property (nonatomic, retain) STCTestScoresAndGrades *testScoresAndGrades;
@end

@interface STCPieChart (CoreDataGeneratedAccessors)

- (void)insertObject:(STCPieChartItem *)value inPieChartItemAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPieChartItemAtIndex:(NSUInteger)idx;
- (void)insertPieChartItem:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePieChartItemAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPieChartItemAtIndex:(NSUInteger)idx withObject:(STCPieChartItem *)value;
- (void)replacePieChartItemAtIndexes:(NSIndexSet *)indexes withPieChartItem:(NSArray *)values;
- (void)addPieChartItemObject:(STCPieChartItem *)value;
- (void)removePieChartItemObject:(STCPieChartItem *)value;
- (void)addPieChartItem:(NSOrderedSet *)values;
- (void)removePieChartItem:(NSOrderedSet *)values;
@end
