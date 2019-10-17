//
//  STCSimilarSchools.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCSimilarSchoolItem;

@interface STCSimilarSchools : STCollegeSections

@property (nonatomic, retain) NSNumber * hasSeeMore;
@property (nonatomic, retain) NSOrderedSet *simlarSchoolItems;
@end

@interface STCSimilarSchools (CoreDataGeneratedAccessors)

- (void)insertObject:(STCSimilarSchoolItem *)value inSimlarSchoolItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSimlarSchoolItemsAtIndex:(NSUInteger)idx;
- (void)insertSimlarSchoolItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSimlarSchoolItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSimlarSchoolItemsAtIndex:(NSUInteger)idx withObject:(STCSimilarSchoolItem *)value;
- (void)replaceSimlarSchoolItemsAtIndexes:(NSIndexSet *)indexes withSimlarSchoolItems:(NSArray *)values;
- (void)addSimlarSchoolItemsObject:(STCSimilarSchoolItem *)value;
- (void)removeSimlarSchoolItemsObject:(STCSimilarSchoolItem *)value;
- (void)addSimlarSchoolItems:(NSOrderedSet *)values;
- (void)removeSimlarSchoolItems:(NSOrderedSet *)values;
@end
