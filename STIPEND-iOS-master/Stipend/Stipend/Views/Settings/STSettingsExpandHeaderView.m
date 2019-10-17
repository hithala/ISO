//
//  STSettingsExpandHeaderView.m
//  Stipend
//
//  Created by sourcebits on 31/12/15.
//  Copyright © 2015 Sourcebits. All rights reserved.
//

#import "STSettingsExpandHeaderView.h"

@implementation STSettingsExpandHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)clickAction:(UIButton *)sender {
    
    if(self.clickActionBlock) {
        self.clickActionBlock(self.tag);
    }
}

- (void) dealloc {
    
    self.clickActionBlock = nil;
}

@end
