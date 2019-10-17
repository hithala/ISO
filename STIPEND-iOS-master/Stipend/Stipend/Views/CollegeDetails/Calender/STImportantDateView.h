//
//  STImportantDateView.h
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 23/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCMostImportantCalenderDates.h"

@interface STImportantDateView : UIView

@property (nonatomic,weak) NSOrderedSet *importantDatesSet;

@property (nonatomic, strong) IBOutlet UILabel          *dayLabel;
@property (nonatomic, strong) IBOutlet UILabel        *monthLabel;
@property (nonatomic, strong) IBOutlet UILabel        *valueLabel;
@property (nonatomic, strong) IBOutlet UIButton   *addEventButton;

@property (nonatomic, strong) void (^addEventActionBlock)(NSInteger tag);

- (IBAction)onCalenderButtonAction:(id)sender;

@end
