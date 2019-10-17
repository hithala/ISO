//
//  STFilterAdmissionType.h
//  Stipend
//
//  Created by Ganesh kumar on 03/01/18.
//  Copyright (c) 2018 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STFilter;

@interface STFilterAdmissionType : NSManagedObject

@property (nonatomic, retain) NSNumber * isEarlyDecision;
@property (nonatomic, retain) NSNumber * isEarlyAction;
@property (nonatomic, retain) NSNumber * isCommonApp;
@property (nonatomic, retain) STFilter *filter;

@end
