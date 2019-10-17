//
//  STCollegeCalenderViewCell.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#define CALENDER_VIEW_FOOTER_HEIGHT                 139.0
#define IMPORTANT_DATES_VIEW_TAG_CONSTANT           1560
#define OTHER_DATES_VIEW_TAG_CONSTANT               1660
#define CALENDER_FOOTER_VIEW_TAG_CONSTANT           1760
#define CALENDER_POPOVER_VIEW_TAG_CONSTANT          1860

#define KEY_VALUES_ARRAY                            @"kValuesArrayKey"

#import "STCalenderDetailsCell.h"
#import "STCalenderFooterView.h"
#import "STCalenderPopOverView.h"
#import "STImportantDateView.h"
#import "STOtherDatesView.h"
#import "STEventKitManager.h"

@interface STCalenderDetailsCell ()

@end
@implementation STCalenderDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateCalenderSectionDetails];
    [self setNeedsDisplay];
}

- (void) updateCalenderSectionWithDetails:(STCCalender *) calenderDetails {
    
    self.calender = calenderDetails;
    [self updateCalenderSectionDetails];
}

- (NSString *) getDayStringFromDate:(NSDate *) date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *dayLabel = [dateFormatter stringFromDate:date];
    
    return dayLabel;
}

- (NSString *) getMonthStringFromDate:(NSDate *) date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MMM"];
    NSString *monthLabel = [dateFormatter stringFromDate:date];
    
    return monthLabel;
}

- (void) updateCalenderSectionDetails {
    
    //Important Date View
    
    NSOrderedSet *importantDateSet = self.calender.mostImportantDates;
    
    NSSortDescriptor *keySort = [NSSortDescriptor sortDescriptorWithKey:@"eventDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:keySort];
    NSArray *mostImpDateSortedArray = [importantDateSet sortedArrayUsingDescriptors:sortDescriptors];

    for (NSUInteger index = 0; index < mostImpDateSortedArray.count; index++) {
        @autoreleasepool {
            
            STCMostImportantCalenderDates *mostImportantDates = [mostImpDateSortedArray objectAtIndex:index];
            
            STImportantDateView *impDateView = (STImportantDateView *)[self viewWithTag:IMPORTANT_DATES_VIEW_TAG_CONSTANT + index];
            
            if (impDateView == nil) {
                impDateView =  (STImportantDateView *)[[NSBundle mainBundle] loadNibNamed:@"STImportantDateView" owner:self options:nil][0];
                [impDateView setBackgroundColor:[UIColor clearColor]];
                impDateView.tag = IMPORTANT_DATES_VIEW_TAG_CONSTANT + index;
                [self.contentView addSubview:impDateView];
            }
            
            impDateView.frame = CGRectMake(0.0  + (index * (self.frame.size.width/importantDateSet.count)), 0.0, (self.frame.size.width/importantDateSet.count), 140.0);
            
            NSDate *eventDate = mostImportantDates.eventDate;
            
            NSString *dateString = mostImportantDates.eventDateString;
            
            NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
            
            int monthNumber = [[dateArray objectAtIndex:1] intValue];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSString *monthName = [[dateFormatter shortMonthSymbols] objectAtIndex:(monthNumber-1)];
            
            impDateView.dayLabel.text = [[dateArray objectAtIndex:2] uppercaseString];
            impDateView.monthLabel.text = [monthName uppercaseString];
            
            impDateView.valueLabel.text = [mostImportantDates.eventName capitalizedString];
            
            impDateView.addEventActionBlock = ^(NSInteger tag) {
                
                NSDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:eventDate,@"kEventDate",mostImportantDates.eventName,@"kEventName",mostImportantDates.eventdateDescription,@"kEventDescription", mostImportantDates.eventDateString,@"kEventDateString", nil];
                
                [[STEventKitManager sharedManager] addEventToCalenderWithDetails:dictionary];
            };
        }
    }
    
    //Other Date View

    CGFloat originYValue = 0.0;
    CGFloat footerYValue = 0.0;
    
    if (mostImpDateSortedArray.count > 0) {
        footerYValue = 140.0;
        originYValue = 150.0;
    }
    
    NSOrderedSet *otherDateSet = self.calender.otherImportantDates;
    
    keySort = [NSSortDescriptor sortDescriptorWithKey:@"eventDate" ascending:YES];
    sortDescriptors = [NSArray arrayWithObject:keySort];
    NSArray *otherDateSortedArray = [otherDateSet sortedArrayUsingDescriptors:sortDescriptors];
    
    for (NSUInteger index = 0; index < otherDateSortedArray.count; index++) {
        @autoreleasepool {
            
            STOtherDatesView *otherDateView = (STOtherDatesView *)[self viewWithTag:OTHER_DATES_VIEW_TAG_CONSTANT + index];
            
            if (!otherDateView) {
                otherDateView =  (STOtherDatesView *)[[NSBundle mainBundle] loadNibNamed:@"STOtherDatesView" owner:self options:nil][0];
                otherDateView.tag = (OTHER_DATES_VIEW_TAG_CONSTANT + index);
                otherDateView.backgroundColor = [UIColor clearColor];
                [self.contentView addSubview:otherDateView];
            }
            
            STCOtherCalenderDates *otherDates = [otherDateSortedArray objectAtIndex:index];
            
            CGRect otherFrame = CGRectZero;
            
            if((index % 2) == 0) {
                otherFrame.origin.x = 0.0;
                otherFrame.origin.y = originYValue + ((index/2) * 70.0);
                otherFrame.size.width = ([self bounds].size.width/2.0);
                otherFrame.size.height = 70.0;
            }
            else {
                otherFrame.origin.x = ([self bounds].size.width/2.0);
                otherFrame.origin.y = originYValue + ((index/2) * 70.0);
                otherFrame.size.width = ([self bounds].size.width/2.0);
                otherFrame.size.height = 70.0;
            }
            
            otherDateView.frame = otherFrame;
            
            footerYValue = otherFrame.origin.y + 70.0;
            
            NSDate *eventDate = otherDates.eventDate;
            
            NSString *dateString = otherDates.eventDateString;
            
            NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
            
            int monthNumber = [[dateArray objectAtIndex:1] intValue];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSString *monthName = [[dateFormatter shortMonthSymbols] objectAtIndex:(monthNumber-1)];
            
            otherDateView.dayLabel.text = [[dateArray objectAtIndex:2] uppercaseString];
            otherDateView.monthLabel.text = [monthName uppercaseString];
            
            if([[otherDates.eventName capitalizedString] isEqualToString:@"Sat/Act Scores Due"]) {
                otherDateView.valueLabel.text = @"SAT/ACT Scores Due";
            } else if([[otherDates.eventName capitalizedString] isEqualToString:@"Sat Subject Test Scores Due"]) {
                otherDateView.valueLabel.text = @"SAT Subject Test Scores Due";
            } else {
                otherDateView.valueLabel.text = [otherDates.eventName capitalizedString];
            }
            
            otherDateView.addEventActionBlock = ^(NSInteger tag) {
                NSDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:eventDate,@"kEventDate",otherDates.eventName,@"kEventName",otherDates.eventdateDescription,@"kEventDescription",otherDates.eventDateString,@"kEventDateString", nil];
                
                [[STEventKitManager sharedManager] addEventToCalenderWithDetails:dictionary];
            };
        }
    }
    
    //Footer View
    
    STCalenderFooterView *footerDateView = (STCalenderFooterView *)[self viewWithTag:CALENDER_FOOTER_VIEW_TAG_CONSTANT];
    
    if (!footerDateView) {
        footerDateView =  (STCalenderFooterView *)[[NSBundle mainBundle] loadNibNamed:@"STCalenderFooterView" owner:self options:nil][0];
        footerDateView.tag = CALENDER_FOOTER_VIEW_TAG_CONSTANT;
        footerDateView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:footerDateView];
    }

    footerDateView.frame = CGRectMake(0.0, footerYValue, self.frame.size.width, 50.0);
    
    if ((mostImpDateSortedArray.count <= 0) && (otherDateSortedArray.count <= 0))
    {
        footerDateView.hidden = YES;
    } else {
         footerDateView.hidden = NO;
    }
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    
    BOOL hasDisclaimerAccepted = [currentUser.isDisclaimerAccepted boolValue];

    if(!hasDisclaimerAccepted) {
        [self showDisclaimerViewIfRequired];
    }
}

- (void) showDisclaimerViewIfRequired {
    
   /* STCalenderPopOverView *popOverView = (STCalenderPopOverView *)[self viewWithTag:CALENDER_POPOVER_VIEW_TAG_CONSTANT];
    
    if(!popOverView) {
        popOverView =  (STCalenderPopOverView *)[[NSBundle mainBundle] loadNibNamed:@"STCalenderPopOverView" owner:self options:nil][0];
        popOverView.tag = CALENDER_POPOVER_VIEW_TAG_CONSTANT;
        [self.contentView addSubview:popOverView];
        
        popOverView.removePopOverActionBlock = ^{
        };
    }
    
    popOverView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height); */
    
    self.disclaimerPopOverView = (UIScrollView *)[self viewWithTag:CALENDER_POPOVER_VIEW_TAG_CONSTANT];
    
    if(!self.disclaimerPopOverView) {
        
        self.disclaimerPopOverView = [[UIScrollView alloc] init];
        self.disclaimerPopOverView.tag = CALENDER_POPOVER_VIEW_TAG_CONSTANT;
        self.disclaimerPopOverView.bounces = NO;
    }
        
    self.disclaimerPopOverView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    
    UITextView *disclaimerTextView = (UITextView *)[self.disclaimerPopOverView viewWithTag:CALENDER_POPOVER_VIEW_TAG_CONSTANT+1];
    
    if(!disclaimerTextView) {
        disclaimerTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, self.disclaimerPopOverView.frame.size.width-40, [self disclaimerTextHeight])];
        disclaimerTextView.text = CALENDAR_DISCLAIMER_TEXT;
        disclaimerTextView.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:13.0];
        disclaimerTextView.textAlignment = NSTextAlignmentJustified;
        disclaimerTextView.textColor = [UIColor whiteColor];
        disclaimerTextView.backgroundColor = [UIColor clearColor];
        disclaimerTextView.tag = CALENDER_POPOVER_VIEW_TAG_CONSTANT+1;
        disclaimerTextView.scrollEnabled = NO;
        disclaimerTextView.userInteractionEnabled = NO;
        [self.disclaimerPopOverView addSubview:disclaimerTextView];
    } else {
        disclaimerTextView.frame = CGRectMake(20, 20, self.disclaimerPopOverView.frame.size.width-40, [self disclaimerTextHeight]);
    }
    
    UIButton *underStandButton = (UIButton *)[self.disclaimerPopOverView viewWithTag:CALENDER_POPOVER_VIEW_TAG_CONSTANT+2];
    
    if(!underStandButton) {
        
        underStandButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-90, disclaimerTextView.frame.origin.y + disclaimerTextView.frame.size.height + 20, 180, 60)];
        [underStandButton setTitle:@"I understand" forState:UIControlStateNormal];
        [underStandButton setTitleColor:[UIColor aquaColor] forState:UIControlStateNormal];
        underStandButton.titleLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:16];
        underStandButton.backgroundColor = [UIColor whiteColor];
        underStandButton.tag = CALENDER_POPOVER_VIEW_TAG_CONSTANT+2;
        [underStandButton addTarget:self action:@selector(disclaimerViewDismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.disclaimerPopOverView addSubview:underStandButton];
        
    } else {
        
        underStandButton.frame = CGRectMake(self.frame.size.width/2-90, disclaimerTextView.frame.origin.y + disclaimerTextView.frame.size.height + 20, 180, 60);
    }
    
    self.disclaimerPopOverView.contentSize = CGSizeMake(self.frame.size.width, underStandButton.frame.origin.y + underStandButton.frame.size.height + 20);
    self.disclaimerPopOverView.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:0.9];
    [self.contentView addSubview:self.disclaimerPopOverView];
    
}

- (CGFloat)disclaimerTextHeight {
    
    UITextView *disclaimerTextView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width - 30.0, 50.0)];
    disclaimerTextView.text = CALENDAR_DISCLAIMER_TEXT;
    disclaimerTextView.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:13.0];
    [disclaimerTextView sizeToFit];
    
    CGFloat disclaimerLabelHeight = disclaimerTextView.frame.size.height + 30.0;
    
    return disclaimerLabelHeight;
}

- (void)disclaimerViewDismiss {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.disclaimerPopOverView.alpha = 0.0;
    } completion:^(BOOL finished){
        self.disclaimerPopOverView.hidden = YES;
        [self.disclaimerPopOverView removeFromSuperview];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                        
            STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
            currentUser.isDisclaimerAccepted = [NSNumber numberWithBool:YES];
            
        }];
    }];
}

@end
