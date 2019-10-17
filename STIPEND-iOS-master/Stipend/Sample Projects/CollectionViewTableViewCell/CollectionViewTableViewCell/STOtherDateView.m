//
//  STOtherDateView.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STOtherDateView.h"

#define SCREEN_OFFSET           15.0
#define TOP_SPACE_CONSTANT      0.0
#define CALENDER_VIEW_HEIGHT_CONSTANT  65.0

@implementation STOtherDateView




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)loadViews {
    CGFloat calenderViewOffsetX = SCREEN_OFFSET;
    CGFloat calenderViewOffsetY = TOP_SPACE_CONSTANT;
    CGFloat calenderViewWidthConstant = (self.frame.size.width - (3 * SCREEN_OFFSET))/ 2.0;
    for (int index = 0; index < 7; index++) {
        
        if (index % 2 == 0) {
            calenderViewOffsetY = (index/2) * CALENDER_VIEW_HEIGHT_CONSTANT ;//(index/2) * CALENDER_VIEW_HEIGHT_CONSTANT + ((index/2 + 1) * TOP_SPACE_CONSTANT);
            if (calenderViewOffsetY <= 0) {
                calenderViewOffsetY = TOP_SPACE_CONSTANT;
            }
            calenderViewOffsetX = SCREEN_OFFSET;
        }else {
            calenderViewOffsetX = calenderViewWidthConstant + (2 * SCREEN_OFFSET);
        }

        STCalenderView *calenderView = [STCalenderView loadFromNib];
        calenderView.backgroundColor = [UIColor clearColor];
        calenderView.frame = CGRectMake(calenderViewOffsetX, calenderViewOffsetY, calenderViewWidthConstant, 65.0);
        [self addSubview:calenderView];
        
    }
}

@end
