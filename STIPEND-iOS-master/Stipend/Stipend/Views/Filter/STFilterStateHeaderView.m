//
//  STFilterStateHeaderView.m
//  Stipend
//
//  Created by sourcebits on 06/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFilterStateHeaderView.h"

@implementation STFilterStateHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.labelField.textColor = [UIColor cellTextFieldTextColor];
    self.labelField.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0f];
}
- (IBAction)onOverlayButtonAction:(id)sender {
    self.onHeaderActionBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
