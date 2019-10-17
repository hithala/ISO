//
//  STCSATPieChart.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCSATPieChartItem, STCSATPieChartLayout;

@interface STCSATPieChart : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *pieChartItems;
@property (nonatomic, retain) STCSATPieChartLayout *satPieChartLayout;
@end

@interface STCSATPieChart (CoreDataGeneratedAccessors)

- (void)insertObject:(STCSATPieChartItem *)value inPieChartItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPieChartItemsAtIndex:(NSUInteger)idx;
- (void)insertPieChartItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePieChartItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPieChartItemsAtIndex:(NSUInteger)idx withObject:(STCSATPieChartItem *)value;
- (void)replacePieChartItemsAtIndexes:(NSIndexSet *)indexes withPieChartItems:(NSArray *)values;
- (void)addPieChartItemsObject:(STCSATPieChartItem *)value;
- (void)removePieChartItemsObject:(STCSATPieChartItem *)value;
- (void)addPieChartItems:(NSOrderedSet *)values;
- (void)removePieChartItems:(NSOrderedSet *)values;
@end
