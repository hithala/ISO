//
//  STFilter.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STFilterCollegeType, STFilterRangeItem, STFilterAdmissionType;

@interface STFilter : NSManagedObject

@property (nonatomic, retain) NSNumber * favoriteOnly;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * stateCode;
@property (nonatomic, retain) NSString * stateName;
@property (nonatomic, retain) NSString * religiousAffiliation;
@property (nonatomic, retain) NSNumber * testOptional;
@property (nonatomic, retain) STFilterCollegeType *collegeType;
@property (nonatomic, retain) STFilterAdmissionType *admissionType;
@property (nonatomic, retain) NSSet *filterRangeItems;
@property (nonatomic, retain) NSOrderedSet *majors;

@end

@interface STFilter (CoreDataGeneratedAccessors)

- (void)addFilterRangeItemsObject:(STFilterRangeItem *)value;
- (void)removeFilterRangeItemsObject:(STFilterRangeItem *)value;
- (void)addFilterRangeItems:(NSSet *)values;
- (void)removeFilterRangeItems:(NSSet *)values;

@end
