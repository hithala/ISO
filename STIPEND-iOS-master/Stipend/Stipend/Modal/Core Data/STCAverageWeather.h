//
//  STCAverageWeather.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCAverageWeatherItem, STCWeather;

@interface STCAverageWeather : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *averageWeatherItems;
@property (nonatomic, retain) STCWeather *weather;
@end

@interface STCAverageWeather (CoreDataGeneratedAccessors)

- (void)insertObject:(STCAverageWeatherItem *)value inAverageWeatherItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAverageWeatherItemsAtIndex:(NSUInteger)idx;
- (void)insertAverageWeatherItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAverageWeatherItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAverageWeatherItemsAtIndex:(NSUInteger)idx withObject:(STCAverageWeatherItem *)value;
- (void)replaceAverageWeatherItemsAtIndexes:(NSIndexSet *)indexes withAverageWeatherItems:(NSArray *)values;
- (void)addAverageWeatherItemsObject:(STCAverageWeatherItem *)value;
- (void)removeAverageWeatherItemsObject:(STCAverageWeatherItem *)value;
- (void)addAverageWeatherItems:(NSOrderedSet *)values;
- (void)removeAverageWeatherItems:(NSOrderedSet *)values;
@end
