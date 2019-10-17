//
//  STClippingSectionItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STClippingsItem;

@interface STClippingSectionItem : NSManagedObject

@property (nonatomic, retain) NSNumber * collegeID;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * isExpanded;
@property (nonatomic, retain) NSNumber * sectionID;
@property (nonatomic, retain) NSString * sectionTitle;
@property (nonatomic, retain) STClippingsItem *clipping;

@end
