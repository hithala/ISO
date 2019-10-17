//
//  STAddCollegeSectionView.m
//  Stipend
//
//  Created by Ganesh Kumar on 10/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAddCollegeSectionView.h"

@implementation STAddCollegeSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewSeparatorHeightConstraint.constant = 0.5f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setFrame:(CGRect)frame {
    
    CGRect newFrame = frame;
    newFrame.size.height = 40.0;
    
    [super setFrame:newFrame];
}


- (IBAction)onSelectAllAction:(id)sender {
 
    if(self.selectAllAction) {
        self.selectAllAction();
    }
}

@end
