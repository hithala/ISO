//
//  STCCalender.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCMostImportantCalenderDates, STCOtherCalenderDates;

@interface STCCalender : STCollegeSections

@property (nonatomic, retain) NSOrderedSet *mostImportantDates;
@property (nonatomic, retain) NSOrderedSet *otherImportantDates;
@end

@interface STCCalender (CoreDataGeneratedAccessors)

- (void)insertObject:(STCMostImportantCalenderDates *)value inMostImportantDatesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMostImportantDatesAtIndex:(NSUInteger)idx;
- (void)insertMostImportantDates:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMostImportantDatesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMostImportantDatesAtIndex:(NSUInteger)idx withObject:(STCMostImportantCalenderDates *)value;
- (void)replaceMostImportantDatesAtIndexes:(NSIndexSet *)indexes withMostImportantDates:(NSArray *)values;
- (void)addMostImportantDatesObject:(STCMostImportantCalenderDates *)value;
- (void)removeMostImportantDatesObject:(STCMostImportantCalenderDates *)value;
- (void)addMostImportantDates:(NSOrderedSet *)values;
- (void)removeMostImportantDates:(NSOrderedSet *)values;
- (void)insertObject:(STCOtherCalenderDates *)value inOtherImportantDatesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOtherImportantDatesAtIndex:(NSUInteger)idx;
- (void)insertOtherImportantDates:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOtherImportantDatesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOtherImportantDatesAtIndex:(NSUInteger)idx withObject:(STCOtherCalenderDates *)value;
- (void)replaceOtherImportantDatesAtIndexes:(NSIndexSet *)indexes withOtherImportantDates:(NSArray *)values;
- (void)addOtherImportantDatesObject:(STCOtherCalenderDates *)value;
- (void)removeOtherImportantDatesObject:(STCOtherCalenderDates *)value;
- (void)addOtherImportantDates:(NSOrderedSet *)values;
- (void)removeOtherImportantDates:(NSOrderedSet *)values;
@end
