//
//  STSignInFooterView.m
//  Stipend
//
//  Created by Arun S on 08/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STSignInFooterView.h"

@implementation STSignInFooterView

- (void) awakeFromNib {
    
    [super awakeFromNib];
}

- (IBAction)onForgotPasswordAction:(id)sender {
    
    if(self.forgotPasswordActionBlock) {
        self.forgotPasswordActionBlock();
    }
}

- (IBAction)onSignInButtonAction:(id)sender {
    
    if(self.signInActionBlock) {
        self.signInActionBlock();
    }
}

- (void)dealloc {
    
    self.signInActionBlock = nil;
    self.forgotPasswordActionBlock = nil;
}

@end
