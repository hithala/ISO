//
//  STFilterRangeCell.m
//  Stipend
//
//  Created by Arun S on 18/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFilterRangeCell.h"

@implementation STFilterRangeCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.font =[UIFont fontType:eFontTypeAvenirHeavy FontForSize:13.0];
    self.titleLabel.textColor = [UIColor cellTextFieldTextColor];
    
    self.maxSliderLabel.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:12.0];
    self.maxSliderLabel.textColor = [UIColor rangeLabelColor];

    self.minSliderLabel.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:11.0];
    self.minSliderLabel.textColor = [UIColor rangeLabelColor];
    
    self.sliderMinLabelWidth.constant = 45.0;
    self.sliderMaxLabelWidth.constant = 45.0;
    
    self.popupView.hidden = YES;
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.cellIndexPath = nil;
    self.curRange = nil;
    self.range = nil;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self setMinMaxValueAndCurrentMinMaxSliderValue];
    [self.rangeSlider setNeedsLayout];
    self.rangeSlider.cellIndexPath = self.cellIndexPath;
    
    __weak STFilterRangeCell *weakSelf = self;//to break retain cycles..

    self.rangeSlider.sliderEditingEndActionBlock = ^{
        if(weakSelf.didUpdatedCellActionBlock) {
            weakSelf.didUpdatedCellActionBlock(weakSelf);
        }
    };
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onSliderValueChanged:(id)sender {
    
    [self updateSliderTextForCell];
    
    if(self.didUpdateCellActionBlock) {
        self.didUpdateCellActionBlock(self);
    }

//    self.popupView.center = self.rangeSlider._minThumb.center; //62
//    STLog(@"slider value: %@", NSStringFromCGRect(self.rangeSlider._minThumb.frame));
    self.popupView.hidden = YES;
}

- (void) setCellIndexPath:(NSIndexPath *)cellIndexPath {
    
    _cellIndexPath = cellIndexPath;
    
    if((_cellIndexPath.section == TEST_SCORE_SECTION) || (_cellIndexPath.section == FRESHMEN_SECTION) || (_cellIndexPath.section == GRADUATION_RATE_SECTION)) {

        self.sliderMinLabelWidth.constant = 45.0;
        self.sliderMaxLabelWidth.constant = 45.0;
    }
    else if (_cellIndexPath.section == LOCATION_SECTION) { //Distance from Curretn Location
        
        self.sliderMinLabelWidth.constant = 60.0;
        self.sliderMaxLabelWidth.constant = 65.0;
    }
    else if (_cellIndexPath.section == FINANCIAL_AID_SECTION) {
        
        if(self.cellIndexPath.row == 0) { // Total fees
            self.sliderMinLabelWidth.constant = 50.0;
            self.sliderMaxLabelWidth.constant = 55.0;
        } else { // Receiving financial aid
            self.sliderMinLabelWidth.constant = 45.0;
            self.sliderMaxLabelWidth.constant = 45.0;
        }
    }
}

- (void) setMinMaxValueAndCurrentMinMaxSliderValue {
    
    NSArray *rangeArr = [self.range componentsSeparatedByString:@","];
    
    NSString *minRange = @"";
    NSString *maxRange = @"";
    
    if(rangeArr && ([rangeArr count] > 0)) {
        minRange = rangeArr[0];
        self.rangeSlider.minimumValue = [minRange floatValue];
        if([rangeArr count] > 1) {
            maxRange = rangeArr[1];
            self.rangeSlider.maximumValue = [maxRange floatValue];
        }
    }
    
    NSArray *curRangeArr = [self.curRange componentsSeparatedByString:@","];
    
    NSString *lowerValue = @"";
    NSString *upperValue = @"";
    
    if(curRangeArr && ([curRangeArr count] > 0)) {
        lowerValue = curRangeArr[0];
        self.rangeSlider.selectedMinimumValue = [lowerValue floatValue];
        if([rangeArr count] > 1) {
            upperValue = curRangeArr[1];
            self.rangeSlider.selectedMaximumValue = [upperValue floatValue];
        }
    }

    if(self.cellIndexPath.section == TEST_SCORE_SECTION) {
        if(self.cellIndexPath.row == 0) { //High School GPA
            self.rangeSlider.minimumRange = 0.05;
            self.rangeSlider.stepValue = 0.10;
        }
        else if(self.cellIndexPath.row == 1) { //Average SAT Score
            self.rangeSlider.minimumRange = 50.0;
            self.rangeSlider.stepValue = 100;
        }
        else if(self.cellIndexPath.row == 2) { //Average ACT
            self.rangeSlider.minimumRange = 1.0;
            self.rangeSlider.stepValue = 1;
        }
    } else if(self.cellIndexPath.section == FRESHMEN_SECTION) {
         if(self.cellIndexPath.row == 0) { // Freshman Size
            self.rangeSlider.minimumRange = 400.0;
            self.rangeSlider.stepValue = 100;
        }
        else if(self.cellIndexPath.row == 1) { //Acceptance Rate
            self.rangeSlider.minimumRange = 5.0;
            self.rangeSlider.stepValue = 5;
        }
    } else if(self.cellIndexPath.section == GRADUATION_RATE_SECTION) { //Graduation Rate & Retention Rate
        self.rangeSlider.minimumRange = 5.0;
        self.rangeSlider.stepValue = 5;
    }
    else if (self.cellIndexPath.section == LOCATION_SECTION) {
        
        if(self.cellIndexPath.row == 0) { //Distance from Curretn Location
            self.rangeSlider.minimumRange = 200.0;
            self.rangeSlider.stepValue = 50;
        }
    }
    else if (self.cellIndexPath.section == FINANCIAL_AID_SECTION) {
        
        if(self.cellIndexPath.row == 0) { // Total fees
            self.rangeSlider.minimumRange = 4000.0;
            self.rangeSlider.stepValue = 1000;
        }
        else if(self.cellIndexPath.row == 1) { // Receiving financial aid
            self.rangeSlider.minimumRange = 5.0;
            self.rangeSlider.stepValue = 5;
        }
    }

    [self updateSliderTextForCell];
}

- (void) updateSliderTextForCell {
    
    if(self.cellIndexPath.section == TEST_SCORE_SECTION) {
        
        if(self.cellIndexPath.row == 0) {//High School GPA
            self.minSliderLabel.text = [NSString stringWithFormat:@"%.2f",self.rangeSlider.selectedMinimumValue];
            self.maxSliderLabel.text = [NSString stringWithFormat:@"%.2f",self.rangeSlider.selectedMaximumValue];
        }
        else if(self.cellIndexPath.row == 1) {//Average SAT Score
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            self.minSliderLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:self.rangeSlider.selectedMinimumValue]];
            self.maxSliderLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:self.rangeSlider.selectedMaximumValue]];
        }
        else if(self.cellIndexPath.row == 2) {//Average ACT
            self.minSliderLabel.text = [NSString stringWithFormat:@"%.0f",self.rangeSlider.selectedMinimumValue];
            self.maxSliderLabel.text = [NSString stringWithFormat:@"%.0f",self.rangeSlider.selectedMaximumValue];
        }
    } else if (self.cellIndexPath.section == FRESHMEN_SECTION) {
        
         if(self.cellIndexPath.row == 0) {// Freshman Size
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            self.minSliderLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:self.rangeSlider.selectedMinimumValue]];
            self.maxSliderLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:self.rangeSlider.selectedMaximumValue]];
        }
        else if(self.cellIndexPath.row == 1) {//Acceptance Rate
            self.minSliderLabel.text = [NSString stringWithFormat:@"%.0f %%",self.rangeSlider.selectedMinimumValue];
            self.maxSliderLabel.text = [NSString stringWithFormat:@"%.0f %%",self.rangeSlider.selectedMaximumValue];
        }
    } else if (self.cellIndexPath.section == GRADUATION_RATE_SECTION) {
        
         if(self.cellIndexPath.row == 0) {//4 Year Graduation Rate
            self.minSliderLabel.text = [NSString stringWithFormat:@"%.0f %%",self.rangeSlider.selectedMinimumValue];
            self.maxSliderLabel.text = [NSString stringWithFormat:@"%.0f %%",self.rangeSlider.selectedMaximumValue];
        }
        else if(self.cellIndexPath.row == 1) {//6 Year Graduation Rate
            self.minSliderLabel.text = [NSString stringWithFormat:@"%.0f %%",self.rangeSlider.selectedMinimumValue];
            self.maxSliderLabel.text = [NSString stringWithFormat:@"%.0f %%",self.rangeSlider.selectedMaximumValue];
        }
        else if(self.cellIndexPath.row == 2) {//1 Year Retention Rate
            self.minSliderLabel.text = [NSString stringWithFormat:@"%.0f %%",self.rangeSlider.selectedMinimumValue];
            self.maxSliderLabel.text = [NSString stringWithFormat:@"%.0f %%",self.rangeSlider.selectedMaximumValue];
        }
    }
    else if (self.cellIndexPath.section == LOCATION_SECTION) {
        
        if(self.cellIndexPath.row == 0) {//Distance from Curretn Location
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSString *minFormattedValue = [NSString stringWithFormat:@"%@ miles", [formatter stringFromNumber:[NSNumber numberWithInteger:self.rangeSlider.selectedMinimumValue]]];
            NSString *maxFormattedValue = [NSString stringWithFormat:@"%@ miles", [formatter stringFromNumber:[NSNumber numberWithInteger:self.rangeSlider.selectedMaximumValue]]];
            
            self.minSliderLabel.text = minFormattedValue;
            self.maxSliderLabel.text = maxFormattedValue;
        }
    }
    else if (self.cellIndexPath.section == FINANCIAL_AID_SECTION) {
        
        if(self.cellIndexPath.row == 0) { // Total fees
            
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSString *minFormattedValue = [NSString stringWithFormat:@"$ %@", [formatter stringFromNumber:[NSNumber numberWithInteger:self.rangeSlider.selectedMinimumValue]]];
            NSString *maxFormattedValue = [NSString stringWithFormat:@"$ %@", [formatter stringFromNumber:[NSNumber numberWithInteger:self.rangeSlider.selectedMaximumValue]]];
            
            self.minSliderLabel.text = minFormattedValue;
            self.maxSliderLabel.text = maxFormattedValue;

        }
        else if(self.cellIndexPath.row == 1) { // Receiving financial aid
            self.minSliderLabel.text = [NSString stringWithFormat:@"%.0f %%",self.rangeSlider.selectedMinimumValue];
            self.maxSliderLabel.text = [NSString stringWithFormat:@"%.0f %%",self.rangeSlider.selectedMaximumValue];
        }
    }
}

@end
