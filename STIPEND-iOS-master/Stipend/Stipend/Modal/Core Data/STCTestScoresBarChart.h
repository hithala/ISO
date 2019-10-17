//
//  STCTestScoresBarChart.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCBarChartItem, STCTestScoresAndGrades;

@interface STCTestScoresBarChart : NSManagedObject

@property (nonatomic, retain) NSNumber * percentageHighValue;
@property (nonatomic, retain) NSNumber * percentageLowValue;
@property (nonatomic, retain) NSNumber * percentageNewHighValue;
@property (nonatomic, retain) NSNumber * percentageNewLowValue;
@property (nonatomic, retain) NSNumber * newScoresAvailable;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *barChartItems;
@property (nonatomic, retain) STCTestScoresAndGrades *testScoresAndGrades;
@end

@interface STCTestScoresBarChart (CoreDataGeneratedAccessors)

- (void)insertObject:(STCBarChartItem *)value inBarChartItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBarChartItemsAtIndex:(NSUInteger)idx;
- (void)insertBarChartItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBarChartItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBarChartItemsAtIndex:(NSUInteger)idx withObject:(STCBarChartItem *)value;
- (void)replaceBarChartItemsAtIndexes:(NSIndexSet *)indexes withBarChartItems:(NSArray *)values;
- (void)addBarChartItemsObject:(STCBarChartItem *)value;
- (void)removeBarChartItemsObject:(STCBarChartItem *)value;
- (void)addBarChartItems:(NSOrderedSet *)values;
- (void)removeBarChartItems:(NSOrderedSet *)values;
@end
