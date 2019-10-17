//
//  STCRankings.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCRankingItem;

@interface STCRankings : STCollegeSections

@property (nonatomic, retain) NSOrderedSet *rankingItems;
@end

@interface STCRankings (CoreDataGeneratedAccessors)

- (void)insertObject:(STCRankingItem *)value inRankingItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRankingItemsAtIndex:(NSUInteger)idx;
- (void)insertRankingItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRankingItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRankingItemsAtIndex:(NSUInteger)idx withObject:(STCRankingItem *)value;
- (void)replaceRankingItemsAtIndexes:(NSIndexSet *)indexes withRankingItems:(NSArray *)values;
- (void)addRankingItemsObject:(STCRankingItem *)value;
- (void)removeRankingItemsObject:(STCRankingItem *)value;
- (void)addRankingItems:(NSOrderedSet *)values;
- (void)removeRankingItems:(NSOrderedSet *)values;
@end
