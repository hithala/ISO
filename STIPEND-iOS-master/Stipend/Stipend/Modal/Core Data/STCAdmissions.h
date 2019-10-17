//
//  STCAdmissions.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCAdmissionCodes, STCAdmissionItem;

@interface STCAdmissions : STCollegeSections

@property (nonatomic, retain) NSOrderedSet *admissionCodes;
@property (nonatomic, retain) NSOrderedSet *admissionItems;
@end

@interface STCAdmissions (CoreDataGeneratedAccessors)

- (void)insertObject:(STCAdmissionCodes *)value inAdmissionCodesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAdmissionCodesAtIndex:(NSUInteger)idx;
- (void)insertAdmissionCodes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAdmissionCodesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAdmissionCodesAtIndex:(NSUInteger)idx withObject:(STCAdmissionCodes *)value;
- (void)replaceAdmissionCodesAtIndexes:(NSIndexSet *)indexes withAdmissionCodes:(NSArray *)values;
- (void)addAdmissionCodesObject:(STCAdmissionCodes *)value;
- (void)removeAdmissionCodesObject:(STCAdmissionCodes *)value;
- (void)addAdmissionCodes:(NSOrderedSet *)values;
- (void)removeAdmissionCodes:(NSOrderedSet *)values;
- (void)insertObject:(STCAdmissionItem *)value inAdmissionItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAdmissionItemsAtIndex:(NSUInteger)idx;
- (void)insertAdmissionItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAdmissionItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAdmissionItemsAtIndex:(NSUInteger)idx withObject:(STCAdmissionItem *)value;
- (void)replaceAdmissionItemsAtIndexes:(NSIndexSet *)indexes withAdmissionItems:(NSArray *)values;
- (void)addAdmissionItemsObject:(STCAdmissionItem *)value;
- (void)removeAdmissionItemsObject:(STCAdmissionItem *)value;
- (void)addAdmissionItems:(NSOrderedSet *)values;
- (void)removeAdmissionItems:(NSOrderedSet *)values;
@end
