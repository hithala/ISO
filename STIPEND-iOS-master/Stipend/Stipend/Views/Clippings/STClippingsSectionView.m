//
//  STClippingsSectionView.m
//  Stipend
//
//  Created by Ganesh Kumar on 28/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STClippingsSectionView.h"

@implementation STClippingsSectionView


- (IBAction)clickAction:(UIButton *)sender {
    
    if(self.clickActionBlock) {
        self.clickActionBlock(self.tag);
    }
}

- (void) dealloc {
    
    self.clickActionBlock = nil;
}

- (IBAction)deleteIconAction:(id)sender {
    
    self.leadingConstraint.constant -= 100;
    self.trailingConstraint.constant += 100;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self layoutIfNeeded];
                     }];
    
    if(self.deleteActionBlock) {
        self.deleteActionBlock(self.tag);
    }
    
}

- (IBAction)removeButtonAction:(id)sender {
    
    if(self.removeActionBlock) {
        self.removeActionBlock(self.tag);
    }
    
}


@end
