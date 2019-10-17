//
//  SectionHeaderView.m
//  StipendTesting
//
//  Created by Ganesh Kumar on 28/05/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)clickAction:(UIButton *)sender {
    self.clickActionBlock(sender.tag);
}
@end
