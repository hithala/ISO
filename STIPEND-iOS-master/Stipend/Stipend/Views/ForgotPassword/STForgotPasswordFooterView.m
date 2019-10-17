//
//  STForgotPasswordFooterView.m
//  Stipend
//
//  Created by Arun S on 11/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STForgotPasswordFooterView.h"

@implementation STForgotPasswordFooterView

- (void) awakeFromNib {
    
    [super awakeFromNib];
}

- (IBAction)onSendButtonAction:(id)sender {
    
    if(self.sendActionBlock) {
        self.sendActionBlock();
    }
}

- (void)dealloc {
    
    self.sendActionBlock = nil;
}

@end
