//
//  STMyDetailsFooterView.m
//  Stipend
//
//  Created by Arun S on 23/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STMyDetailsFooterView.h"

@implementation STMyDetailsFooterView

- (IBAction)onPrivacyButtonAction:(id)sender {
    
    if(self.privacyActionBlock) {
        self.privacyActionBlock();
    }
}

@end
