//
//  STCFreshmanGraduationDetails.h
//  Stipend
//
//  Created by Ganesh Kumar on 03/02/18.
//  Copyright (c) 2018 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCFreshman;

@interface STCFreshmanGraduationDetails : NSManagedObject

@property (nonatomic, retain) NSNumber * fourYearGraduationRate;
@property (nonatomic, retain) NSNumber * sixYearGraduationRate;
@property (nonatomic, retain) NSNumber * retentionRate;
@property (nonatomic, retain) STCFreshman *freshman;

@end
