//
//  STFilterMajorHeaderView.m
//  Stipend
//
//  Created by Ganesh Kumar on 25/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import "STFilterMajorHeaderView.h"

@implementation STFilterMajorHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)haderViewSelectionAction:(id)sender {
    
    if(self.headerViewClickActionBlock != nil) {
        self.headerViewClickActionBlock();
    }
}

- (IBAction)selectionAction:(id)sender {
    
    if(self.majorSelectionActionBlock != nil) {
        self.majorSelectionActionBlock();
    }
}

@end
