//
//  STSignUpFooterView.m
//  Stipend
//
//  Created by Arun S on 08/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STSignUpFooterView.h"

@implementation STSignUpFooterView

- (void) awakeFromNib {
    
    [super awakeFromNib];
}

- (IBAction)onSignUpButtonAction:(id)sender {
    
    if(self.signUpActionBlock) {
        self.signUpActionBlock();
    }
}

- (IBAction)onTermsAndConditionsAction:(id)sender {
    
    if(self.termsAndConditionsActionBlock) {
        self.termsAndConditionsActionBlock();
    }
}

- (IBAction)onPrivacyPolicyAction:(id)sender {
    if(self.privacyPolicyActionBlock) {
        self.privacyPolicyActionBlock();
    }
}

- (void)dealloc {
    
    self.signUpActionBlock = nil;
    self.termsAndConditionsActionBlock = nil;
    self.privacyPolicyActionBlock = nil;
}

@end