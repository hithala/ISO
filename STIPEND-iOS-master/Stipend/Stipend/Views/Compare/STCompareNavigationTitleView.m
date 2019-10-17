//
//  STCompareNavigationTitleView.m
//  Stipend
//
//  Created by Arun S on 08/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCompareNavigationTitleView.h"

@implementation STCompareNavigationTitleView


- (void) updateNavigationTitleWithCollegeName:(NSString *) title andImageName:(NSString *) imageName {
    
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    [self.titleButton setTitle:title forState:UIControlStateHighlighted];
    [self.titleButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.titleButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [self setNeedsUpdateConstraints];
    [self.titleButton layoutIfNeeded];
}

- (IBAction)onTitleBarButtonAction:(id)sender {
    
    if(self.onTitleActionBlock) {
        self.onTitleActionBlock();
    }
}

@end
