//
//  STCProminentAlumini.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCAluminiItem;

@interface STCProminentAlumini : STCollegeSections

@property (nonatomic, retain) NSNumber * hasSeeMore;
@property (nonatomic, retain) NSOrderedSet *aluminiItems;
@end

@interface STCProminentAlumini (CoreDataGeneratedAccessors)

- (void)insertObject:(STCAluminiItem *)value inAluminiItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAluminiItemsAtIndex:(NSUInteger)idx;
- (void)insertAluminiItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAluminiItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAluminiItemsAtIndex:(NSUInteger)idx withObject:(STCAluminiItem *)value;
- (void)replaceAluminiItemsAtIndexes:(NSIndexSet *)indexes withAluminiItems:(NSArray *)values;
- (void)addAluminiItemsObject:(STCAluminiItem *)value;
- (void)removeAluminiItemsObject:(STCAluminiItem *)value;
- (void)addAluminiItems:(NSOrderedSet *)values;
- (void)removeAluminiItems:(NSOrderedSet *)values;
@end
