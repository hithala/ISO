//
//  STCSimilarSchoolItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCSimilarSchools;

@interface STCSimilarSchoolItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * schoolID;
@property (nonatomic, retain) NSString * similarSchoolURL;
@property (nonatomic, retain) STCSimilarSchools *similarSchools;

@end
