//
//  STClippingsItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STClippingSectionItem, STUser;

@interface STClippingsItem : NSManagedObject

@property (nonatomic, retain) NSNumber * collegeID;
@property (nonatomic, retain) NSString * collegeName;
@property (nonatomic, retain) NSOrderedSet *clippingSections;
@property (nonatomic, retain) STUser *user;
@end

@interface STClippingsItem (CoreDataGeneratedAccessors)

- (void)insertObject:(STClippingSectionItem *)value inClippingSectionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromClippingSectionsAtIndex:(NSUInteger)idx;
- (void)insertClippingSections:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeClippingSectionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInClippingSectionsAtIndex:(NSUInteger)idx withObject:(STClippingSectionItem *)value;
- (void)replaceClippingSectionsAtIndexes:(NSIndexSet *)indexes withClippingSections:(NSArray *)values;
- (void)addClippingSectionsObject:(STClippingSectionItem *)value;
- (void)removeClippingSectionsObject:(STClippingSectionItem *)value;
- (void)addClippingSections:(NSOrderedSet *)values;
- (void)removeClippingSections:(NSOrderedSet *)values;
@end
