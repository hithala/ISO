//
//  STFilterCollegeType.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STFilter;

@interface STFilterCollegeType : NSManagedObject

@property (nonatomic, retain) NSNumber * isCity;
@property (nonatomic, retain) NSNumber * isCollege;
@property (nonatomic, retain) NSNumber * isPrivate;
@property (nonatomic, retain) NSNumber * isPublic;
@property (nonatomic, retain) NSNumber * isRural;
@property (nonatomic, retain) NSNumber * isTown;
@property (nonatomic, retain) NSNumber * isUniversity;
@property (nonatomic, retain) STFilter *filter;

@end
