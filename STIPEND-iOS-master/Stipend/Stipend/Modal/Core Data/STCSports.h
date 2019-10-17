//
//  STCSports.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCAdmissionItem, STCMenSports, STCWomenSports;

@interface STCSports : STCollegeSections

@property (nonatomic, retain) NSString * mascotName;
@property (nonatomic, retain) NSNumber * sportsSelectedIndex;
@property (nonatomic, retain) NSOrderedSet *admissionItems;
@property (nonatomic, retain) STCMenSports *menSports;
@property (nonatomic, retain) STCWomenSports *womenSports;
@end

@interface STCSports (CoreDataGeneratedAccessors)

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
