//
//  STCalenderView.m
//  SwitchDemo
//
//  Created by mahesh on 18/06/15.
//  Copyright (c) 2015 Tarun Tyagi. All rights reserved.
//

#import "STCalenderView.h"

@implementation STCalenderView


+(STCalenderView *)loadFromNib {
    STCalenderView *cell = (STCalenderView *)[[[NSBundle mainBundle] loadNibNamed:@"STCalenderView" owner:self options:nil] lastObject];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
