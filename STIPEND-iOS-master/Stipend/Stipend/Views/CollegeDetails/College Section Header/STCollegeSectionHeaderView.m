//
//  STCollegeSectionHeaderView.m
//  Stipend
//
//  Created by Ganesh Kumar on 28/05/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STCollegeSectionHeaderView.h"

@implementation STCollegeSectionHeaderView

- (void) awakeFromNib {
    
    [super awakeFromNib];
    
    self.viewSeparatorHeightConstraint.constant = 0.5f;
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.longPressGesture.minimumPressDuration = 1.0f;
    [self addGestureRecognizer:self.longPressGesture];
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if(self.longPressActionBlock) {
            self.longPressActionBlock(self.tag);
        }
    }
}

- (IBAction)clickAction:(UIButton *)sender {
    
    if(self.clickActionBlock) {
        self.clickActionBlock(self.tag);
    }
}

- (void) dealloc {
    
    [self removeGestureRecognizer:self.longPressGesture];
    self.clickActionBlock = nil;
    self.longPressActionBlock = nil;
}

@end
