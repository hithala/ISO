//
//  STCollegeSections.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCollege;

@interface STCollegeSections : NSManagedObject

@property (nonatomic, retain) NSNumber * collegeID;
@property (nonatomic, retain) NSNumber * isExpanded;
@property (nonatomic, retain) NSNumber * sectionID;
@property (nonatomic, retain) NSString * sectionTitle;
@property (nonatomic, retain) STCollege *college;

@end
