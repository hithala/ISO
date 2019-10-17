//
//  STCollegeFooterView.m
//  Stipend
//
//  Created by Arun S on 23/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCollegeFooterView.h"

@implementation STCollegeFooterView

- (void) setFrame:(CGRect)frame {
    
    CGRect newFrame = frame;
    newFrame.size.height = 60.0;
    
    [super setFrame:newFrame];
    
}

- (IBAction)onBackToTopAction:(id)sender {
    
    if(self.backToTop) {
        self.backToTop();
    }
}

- (void)dealloc {
    self.backToTop = nil;
}

@end
