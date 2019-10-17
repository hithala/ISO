//
//  STSliderPopupView.m
//  Stipend
//
//  Created by Ganesh kumar on 05/09/17.
//  Copyright © 2017 Sourcebits. All rights reserved.
//

#import "STSliderPopupView.h"

@implementation STSliderPopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateViewFor:(float)value {
    
    self.popUpValue.text = [NSString stringWithFormat:@"%f", value];

    CGRect badgeLabelRect = [self.popUpValue.text
                             boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.popUpValue.frame.size.height)
                             options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:@{NSFontAttributeName: self.popUpValue.font}
                             context:nil];
    
    int badgeLabelWidth = ceilf(badgeLabelRect.size.width);
    
    CGRect frameRect = self.frame;
    frameRect.size.width = badgeLabelWidth + 10;
    self.frame = frameRect;
}

@end
