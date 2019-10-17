//
//  STCAdmissionCodes.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCAdmissions;

@interface STCAdmissionCodes : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) STCAdmissions *admissions;

@end
