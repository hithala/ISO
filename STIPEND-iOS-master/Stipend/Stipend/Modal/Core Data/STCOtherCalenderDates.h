//
//  STCOtherCalenderDates.h
//  Stipend
//
//  Created by Arun S on 17/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STCCalender;

@interface STCOtherCalenderDates : NSManagedObject

@property (nonatomic, retain) NSDate * eventDate;
@property (nonatomic, retain) NSString * eventdateDescription;
@property (nonatomic, retain) NSString * eventDateString;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) STCCalender *calender;

@end
