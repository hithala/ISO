//
//  STCSportsDivision.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCMenSports, STCSportsItem, STCWomenSports;

@interface STCSportsDivision : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) STCMenSports *mensSports;
@property (nonatomic, retain) NSOrderedSet *sportsItems;
@property (nonatomic, retain) STCWomenSports *womenSports;
@end

@interface STCSportsDivision (CoreDataGeneratedAccessors)

- (void)insertObject:(STCSportsItem *)value inSportsItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSportsItemsAtIndex:(NSUInteger)idx;
- (void)insertSportsItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSportsItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSportsItemsAtIndex:(NSUInteger)idx withObject:(STCSportsItem *)value;
- (void)replaceSportsItemsAtIndexes:(NSIndexSet *)indexes withSportsItems:(NSArray *)values;
- (void)addSportsItemsObject:(STCSportsItem *)value;
- (void)removeSportsItemsObject:(STCSportsItem *)value;
- (void)addSportsItems:(NSOrderedSet *)values;
- (void)removeSportsItems:(NSOrderedSet *)values;
@end
