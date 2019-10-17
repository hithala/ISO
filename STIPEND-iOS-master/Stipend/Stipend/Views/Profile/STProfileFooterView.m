//
//  STProfileFooterView.m
//  Stipend
//
//  Created by Arun S on 11/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STProfileFooterView.h"

@implementation STProfileFooterView

- (void) awakeFromNib {
    
    [super awakeFromNib];
}

- (IBAction)onFinishButtonAction:(id)sender {
    
    if(self.finishActionBlock) {
        self.finishActionBlock();
    }
}

- (IBAction)onPrivacyButtonAction:(id)sender {
    
    if(self.privacyActionBlock) {
        self.privacyActionBlock();
    }
}

- (void)dealloc {
    self.finishActionBlock = nil;
    self.privacyActionBlock = nil;
}

@end
