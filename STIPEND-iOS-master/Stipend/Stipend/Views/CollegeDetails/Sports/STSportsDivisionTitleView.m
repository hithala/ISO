//
//  STSportsDivisionTitleView.m
//  Stipend
//
//  Created by Mahesh on 22/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STSportsDivisionTitleView.h"

#define CELL_SEPARATOR_VIEW_HEIGHT 0.5

@implementation STSportsDivisionTitleView

- (void)layoutSubviews {

    self.cellSeparatorViewHeightConstraint.constant = CELL_SEPARATOR_VIEW_HEIGHT;
    [super layoutSubviews];
}

@end
