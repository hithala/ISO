//
//  STSectionItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STSections;

@interface STSectionItem : NSManagedObject

@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * sectionID;
@property (nonatomic, retain) NSString * sectionTitle;
@property (nonatomic, retain) STSections *sections;

@end
