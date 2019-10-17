//
//  STCalenderDetailsCell.h
//  Stipend
//
//  Created by Mahesh A on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "STCCalender.h"
#import "STCMostImportantCalenderDates.h"
#import "STCOtherCalenderDates.h"

@interface STCalenderDetailsCell : UITableViewCell

@property (nonatomic, retain) STCCalender                   *calender;
@property (nonatomic, retain) UIScrollView     *disclaimerPopOverView;

- (void) updateCalenderSectionWithDetails:(STCCalender *) calenderDetails;

@end

