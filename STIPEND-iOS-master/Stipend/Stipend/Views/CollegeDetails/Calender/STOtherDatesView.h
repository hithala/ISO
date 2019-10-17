//
//  STOtherDatesView.h
//  SwitchDemo
//
//  Created by mahesh on 18/06/15.
//  Copyright (c) 2015 Tarun Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STOtherDatesView : UIView

@property (nonatomic, strong) IBOutlet UILabel          *dayLabel;
@property (nonatomic, strong) IBOutlet UILabel        *monthLabel;
@property (nonatomic, strong) IBOutlet UILabel        *valueLabel;
@property (nonatomic, strong) IBOutlet UIButton   *addEventButton;

@property (nonatomic, strong) void (^addEventActionBlock)(NSInteger tag);

- (IBAction)onCalenderButtonAction:(id)sender;

@end
