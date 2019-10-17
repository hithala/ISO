//
//  STSections.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STSectionItem, STUser;

@interface STSections : NSManagedObject

@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) STSectionItem *sectionItem;
@property (nonatomic, retain) STUser *user;

@end
