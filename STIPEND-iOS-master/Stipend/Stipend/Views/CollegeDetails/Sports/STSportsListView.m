//
//  STSportsListView.m
//  SwitchDemo
//
//  Created by mahesh on 19/06/15.
//  Copyright (c) 2015 Tarun Tyagi. All rights reserved.
//

#import "STSportsListView.h"
#define CELL_SEPARATOR_VIEW_HEIGHT 0.5

@implementation STSportsListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    self.cellSeparatorViewHeightConstraint.constant = CELL_SEPARATOR_VIEW_HEIGHT;
}



@end
