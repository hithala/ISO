//
//  STRangeSlider.h
//  Stipend
//
//  Created by Arun S on 16/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STSliderPopupView.h"

@interface STRangeSlider : UIControl{
    float minimumValue;
    float maximumValue;
    float minimumRange;
    float selectedMinimumValue;
    float selectedMaximumValue;
    float distanceFromCenter;

    float stepValue;
    
    float _padding;
    
    BOOL _maxThumbOn;
    BOOL _minThumbOn;
    
    UIImageView * _minThumb;
    UIImageView * _maxThumb;
    UIImageView * _track;
    UIImageView * _trackBackground;
    STSliderPopupView * _minValuePopupView;
    STSliderPopupView * _maxValuePopupView;
}

@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;
@property(nonatomic) float minimumRange;
@property(nonatomic) float selectedMinimumValue;
@property(nonatomic) float selectedMaximumValue;

@property(nonatomic) float stepValue;

@property (nonatomic,retain) NSIndexPath *cellIndexPath;

@property (nonatomic, copy) void (^sliderEditingEndActionBlock)(void);

@end
