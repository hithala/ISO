//
//  STCIntendedStudy.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "STCollegeSections.h"

@class STCAdmissionItem, STCPieChart;

@interface STCIntendedStudy : STCollegeSections

@property (nonatomic, retain) NSString * studentFacultyRatio;
@property (nonatomic, retain) NSOrderedSet *admissionItems;
@property (nonatomic, retain) NSNumber * hasSeeMore;
@property (nonatomic, retain) STCPieChart *intendedStudyPieChart;
@end

@interface STCIntendedStudy (CoreDataGeneratedAccessors)

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
