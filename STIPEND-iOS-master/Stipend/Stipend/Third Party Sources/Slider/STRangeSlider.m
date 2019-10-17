//
//  STRangeSlider.h
//  Stipend
//
//  Created by Arun S on 16/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STRangeSlider.h"

@interface STRangeSlider (PrivateMethods)
-(float)xForValue:(float)value;
-(float)valueForX:(float)x;
-(void)updateTrackHighlight;
@end

@implementation STRangeSlider

@synthesize minimumValue, maximumValue, minimumRange, selectedMinimumValue, selectedMaximumValue, stepValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minThumbOn = false;
        _maxThumbOn = false;
        _padding = 10;
        stepValue = 1;
        
        _trackBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_bg"]];
        _trackBackground.center = CGPointMake(self.center.x, self.center.y/2.0);
        [self addSubview:_trackBackground];
        
        _track = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_active"]];
        _track.center = CGPointMake(self.center.x, self.center.y/2.0);
        [self addSubview:_track];
        
        _minThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_knob"] highlightedImage:[UIImage imageNamed:@"slider_knob"]];
        _minThumb.frame = CGRectMake(0,self.center.y/2.0, self.frame.size.height,self.frame.size.height);
        _minThumb.contentMode = UIViewContentModeCenter;
        [self addSubview:_minThumb];
        
        _maxThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_knob"] highlightedImage:[UIImage imageNamed:@"slider_knob"]];
        _maxThumb.frame = CGRectMake(0,self.center.y/2.0, self.frame.size.height,self.frame.size.height);
        _maxThumb.contentMode = UIViewContentModeCenter;
        [self addSubview:_maxThumb];
        
        _minValuePopupView = (STSliderPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"STSliderPopupView" owner:self options:0] firstObject];
        _minValuePopupView.frame = CGRectMake(0,((self.center.y/2.0) - 40.0), 40, 32.5);
        [self addSubview:_minValuePopupView];
        
        _maxValuePopupView = (STSliderPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"STSliderPopupView" owner:self options:0] firstObject];
        _maxValuePopupView.frame = CGRectMake(0,((self.center.y/2.0) - 40.0), 40, 32.5);
        [self addSubview:_maxValuePopupView];

    }
    
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];

    _minThumbOn = false;
    _maxThumbOn = false;
    _padding = 10;
    stepValue = 1;
    
    _trackBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_bg"]];
    _trackBackground.center = CGPointMake(self.center.x, self.center.y/2.0);
    [self addSubview:_trackBackground];
    
    _track = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_active"]];
    _track.center = CGPointMake(self.center.x, self.center.y/2.0);
    [self addSubview:_track];
    
    _minThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_knob"] highlightedImage:[UIImage imageNamed:@"slider_knob"]];
    _minThumb.frame = CGRectMake(0,((self.center.y/2.0) - 2.0), self.frame.size.height,self.frame.size.height);
    _minThumb.contentMode = UIViewContentModeCenter;
    [self addSubview:_minThumb];
    
    _maxThumb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_knob"] highlightedImage:[UIImage imageNamed:@"slider_knob"]];
    _maxThumb.frame = CGRectMake(0,((self.center.y/2.0) - 2.0), self.frame.size.height,self.frame.size.height);
    _maxThumb.contentMode = UIViewContentModeCenter;
    [self addSubview:_maxThumb];
    
    _minValuePopupView = (STSliderPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"STSliderPopupView" owner:self options:0] firstObject];
    _minValuePopupView.frame = CGRectMake(0,((self.center.y/2.0) - 40.0), 40, 32.5);
    [self addSubview:_minValuePopupView];

    _maxValuePopupView = (STSliderPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"STSliderPopupView" owner:self options:0] firstObject];
    _maxValuePopupView.frame = CGRectMake(0,((self.center.y/2.0) - 40.0), 40, 32.5);
    [self addSubview:_maxValuePopupView];
    
    _minValuePopupView.hidden = YES;
    _maxValuePopupView.hidden = YES;

}


-(void)layoutSubviews {
    
    @try {
        // Set the initial state
        _minThumb.center = CGPointMake([self xForValue:selectedMinimumValue], ((self.center.y/2.0) - 2.0));
        _maxThumb.center = CGPointMake([self xForValue:selectedMaximumValue], ((self.center.y/2.0) - 2.0));
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        NSString *minFormattedValue = [formatter stringFromNumber:[NSNumber numberWithInteger:selectedMinimumValue]];
        NSString *maxFormattedValue = [formatter stringFromNumber:[NSNumber numberWithInteger:selectedMaximumValue]];
        
        if(self.cellIndexPath.section == TEST_SCORE_SECTION) {
            if(self.cellIndexPath.row == 0) { //High School GPA
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%.2f", selectedMinimumValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%.2f", selectedMaximumValue];
            }
            else if(self.cellIndexPath.row == 1) { //Average SAT Score
                //            self.rangeSlider.minimumRange = 50.0;
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%@", minFormattedValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%@", maxFormattedValue];
            }
            else if(self.cellIndexPath.row == 2) { //Average ACT
                //            self.rangeSlider.minimumRange = 1.0;
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d", (int)selectedMinimumValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d", (int)selectedMaximumValue];
            }
        } else if(self.cellIndexPath.section == FRESHMEN_SECTION) {
            if(self.cellIndexPath.row == 0) { // Freshman Size
                //            self.rangeSlider.minimumRange = 400.0;
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%@", minFormattedValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%@", maxFormattedValue];
            }
            else if(self.cellIndexPath.row == 1) { //Acceptance Rate
                //            self.rangeSlider.minimumRange = 5.0;
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d%%", (int)selectedMinimumValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d%%", (int)selectedMaximumValue];
            }
        } else if(self.cellIndexPath.section == GRADUATION_RATE_SECTION) {
            if(self.cellIndexPath.row == 0) { //4 Year Graduation Rate
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d%%", (int)selectedMinimumValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d%%", (int)selectedMaximumValue];
            } else if(self.cellIndexPath.row == 1) { //4 Yr Graduation Rate
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d%%", (int)selectedMinimumValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d%%", (int)selectedMaximumValue];
            } else if(self.cellIndexPath.row == 2) { //1 Yr Retention Rate
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d%%", (int)selectedMinimumValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d%%", (int)selectedMaximumValue];
            }
        }
        else if (self.cellIndexPath.section == LOCATION_SECTION) {
            
            if(self.cellIndexPath.row == 0) { //Distance from Curretn Location
                //            self.rangeSlider.minimumRange = 200.0;
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%@", minFormattedValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%@", maxFormattedValue];
            }
        }
        else if (self.cellIndexPath.section == FINANCIAL_AID_SECTION) {
            
            if(self.cellIndexPath.row == 0) { // Total fees
                //            self.rangeSlider.minimumRange = 4000.0;
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"$%@", minFormattedValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"$%@", maxFormattedValue];
            }
            else if(self.cellIndexPath.row == 1) { // Receiving financial aid
                //            self.rangeSlider.minimumRange = 5.0;
                _minValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d%%", (int)selectedMinimumValue];
                _maxValuePopupView.popUpValue.text = [NSString stringWithFormat:@"%d%%", (int)selectedMaximumValue];
            }
        }
        
        _minValuePopupView.frame = CGRectMake([self xForValue:selectedMinimumValue], ((self.center.y/2.0) - 48.0), [self widthForLabel:_minValuePopupView.popUpValue], 32.5);
        _minValuePopupView.center = CGPointMake([self xForValue:selectedMinimumValue], ((self.center.y/2.0) - 40.0));
        
        _maxValuePopupView.frame = CGRectMake([self xForValue:selectedMaximumValue], ((self.center.y/2.0) - 48.0), [self widthForLabel:_maxValuePopupView.popUpValue], 32.5);
        _maxValuePopupView.center = CGPointMake([self xForValue:selectedMaximumValue], ((self.center.y/2.0) - 40.0));
        
        [self updateTrackHighlight];
    }
    @catch (NSException * e) {
        STLog(@"Exception: %@", e);
    }
}

-(float)xForValue:(float)value {
    float roundedValue = roundf(value / stepValue) * stepValue;
    return (self.frame.size.width-(_padding*2))*((roundedValue - minimumValue) / (maximumValue - minimumValue))+_padding;
}

-(float) valueForX:(float)x {
    float value = minimumValue + (x-_padding) / (self.frame.size.width-(_padding*2)) * (maximumValue - minimumValue);
    return roundf(value / stepValue) * stepValue;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_minThumbOn && !_maxThumbOn){
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    if(_minThumbOn){
        
        float newValue = [self valueForX:(touchPoint.x - distanceFromCenter)];
        
        if(!_maxThumbOn || newValue < selectedMinimumValue) {
            
            _maxThumbOn = NO;
            [self bringSubviewToFront:_minThumb];
            
            _minThumb.center = CGPointMake(MAX([self xForValue:minimumValue],MIN(touchPoint.x - distanceFromCenter, [self xForValue:selectedMaximumValue - minimumRange])), _minThumb.center.y);
            selectedMinimumValue = [self valueForX:_minThumb.center.x];
        }
        else
        {
            _minThumbOn = NO;
        }
    }
    
    if(_maxThumbOn){
        
        float newValue = [self valueForX:(touchPoint.x - distanceFromCenter)];
        
        if(!_minThumbOn || newValue < selectedMaximumValue) {
            
            _minThumbOn = NO;
            [self bringSubviewToFront:_maxThumb];

            _maxThumb.center = CGPointMake(MIN([self xForValue:maximumValue], MAX(touchPoint.x - distanceFromCenter, [self xForValue:selectedMinimumValue + minimumRange])), _maxThumb.center.y);
            selectedMaximumValue = [self valueForX:_maxThumb.center.x];
        }
        else
        {
            _maxThumbOn = NO;
        }
    }
    
    [self updateTrackHighlight];
    [self setNeedsLayout];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    
    if(CGRectContainsPoint(_minThumb.frame, touchPoint)){
        _minThumbOn = true;
        distanceFromCenter = touchPoint.x - _minThumb.center.x;
        
        _minValuePopupView.hidden = NO;
        _maxValuePopupView.hidden = YES;
    }
    
    if(CGRectContainsPoint(_maxThumb.frame, touchPoint)){
        _maxThumbOn = true;
        distanceFromCenter = touchPoint.x - _maxThumb.center.x;
        
        _minValuePopupView.hidden = YES;
        _maxValuePopupView.hidden = NO;
    }
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _minThumbOn = false;
    _maxThumbOn = false;
    
    _minValuePopupView.hidden = YES;
    _maxValuePopupView.hidden = YES;
    

    if(self.sliderEditingEndActionBlock) {
        self.sliderEditingEndActionBlock();
    }
}

-(void)updateTrackHighlight{

    _trackBackground.frame = CGRectMake(
                                        _padding,
                                        ((_trackBackground.center.y) - (_trackBackground.frame.size.height/2.0)),
                                        self.frame.size.width - (_padding * 2),
                                        _trackBackground.frame.size.height
                                        );
    
    _track.frame = CGRectMake(
                              _minThumb.center.x,
                              _track.center.y - (_track.frame.size.height/2.0),
                              _maxThumb.center.x - _minThumb.center.x,
                              _track.frame.size.height
                              );
}

- (int)widthForLabel:(UILabel *)label {
    
    CGRect badgeLabelRect = [label.text
                             boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, label.frame.size.height)
                             options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{NSFontAttributeName: label.font}
                             context:nil];
    
    int labelWidth = ceilf(badgeLabelRect.size.width) + 15;
    
    return labelWidth;
}

@end
