//
//  STCAdmissionItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCAdmissions, STCIntendedStudy, STCItem, STCSports;

@interface STCAdmissionItem : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) STCAdmissions *admission;
@property (nonatomic, retain) STCIntendedStudy *intendedStudy;
@property (nonatomic, retain) NSOrderedSet *items;
@property (nonatomic, retain) STCSports *sports;
@end

@interface STCAdmissionItem (CoreDataGeneratedAccessors)

- (void)insertObject:(STCItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(STCItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(STCItem *)value;
- (void)removeItemsObject:(STCItem *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end
