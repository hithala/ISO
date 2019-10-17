//
//  STFilterRangeCell.h
//  Stipend
//
//  Created by Arun S on 18/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STRangeSlider.h"

@interface STFilterRangeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel            *titleLabel;
@property (weak, nonatomic) IBOutlet STRangeSlider     *rangeSlider;
@property (weak, nonatomic) IBOutlet UILabel        *maxSliderLabel;
@property (weak, nonatomic) IBOutlet UILabel        *minSliderLabel;
@property (nonatomic,retain) NSIndexPath             *cellIndexPath;

@property (nonatomic,retain) NSString                     *curRange;
@property (nonatomic,retain) NSString                        *range;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderMinLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderMaxLabelWidth;
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UILabel *popupViewLabel;

@property (nonatomic, strong) void (^didUpdateCellActionBlock)(id);
@property (nonatomic, strong) void (^didUpdatedCellActionBlock)(id);

- (IBAction)onSliderValueChanged:(id)sender;
- (void) updateSliderTextForCell;
- (void) setMinMaxValueAndCurrentMinMaxSliderValue;

@end
