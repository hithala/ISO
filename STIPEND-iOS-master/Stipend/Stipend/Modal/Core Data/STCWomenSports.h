//
//  STCWomenSports.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCSports, STCSportsDivision;

@interface STCWomenSports : NSManagedObject

@property (nonatomic, retain) STCSports *sports;
@property (nonatomic, retain) NSOrderedSet *sportsDivisions;
@end

@interface STCWomenSports (CoreDataGeneratedAccessors)

- (void)insertObject:(STCSportsDivision *)value inSportsDivisionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSportsDivisionsAtIndex:(NSUInteger)idx;
- (void)insertSportsDivisions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSportsDivisionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSportsDivisionsAtIndex:(NSUInteger)idx withObject:(STCSportsDivision *)value;
- (void)replaceSportsDivisionsAtIndexes:(NSIndexSet *)indexes withSportsDivisions:(NSArray *)values;
- (void)addSportsDivisionsObject:(STCSportsDivision *)value;
- (void)removeSportsDivisionsObject:(STCSportsDivision *)value;
- (void)addSportsDivisions:(NSOrderedSet *)values;
- (void)removeSportsDivisions:(NSOrderedSet *)values;
@end
