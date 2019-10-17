//
//  STCItem.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCAdmissionItem;

@interface STCItem : NSManagedObject

@property (nonatomic, retain) NSString * badgeText;
@property (nonatomic, retain) NSNumber * badgeType;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) STCAdmissionItem *admissionItem;

@end
