//
//  STCSATPieChartLayout.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCSATPieChart, STCTestScoresAndGrades;

@interface STCSATPieChartLayout : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *items;
@property (nonatomic, retain) STCTestScoresAndGrades *testScoresAndGrades;
@end

@interface STCSATPieChartLayout (CoreDataGeneratedAccessors)

- (void)insertObject:(STCSATPieChart *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(STCSATPieChart *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(STCSATPieChart *)value;
- (void)removeItemsObject:(STCSATPieChart *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end
