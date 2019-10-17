//
//  STCalenderPopOverView.h
//  Stipend
//
//  Created by Mahesh A on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCalenderPopOverView : UIView

@property (nonatomic, weak) IBOutlet UILabel         *valueLabel;
@property (nonatomic, weak) IBOutlet UIButton            *button;

@property (nonatomic, strong) void (^removePopOverActionBlock)(void);

- (IBAction)onUnderStandButtonAction:(id)sender;

@end
