//
//  STCalenderPopOverView.m
//  Stipend
//
//  Created by Mahesh A on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCalenderPopOverView.h"

@implementation STCalenderPopOverView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.button.layer.cornerRadius = 2.0;
    self.button.clipsToBounds = TRUE;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (IBAction)onUnderStandButtonAction:(id)sender {
    self.removePopOverActionBlock();
    
    STCalenderPopOverView *weakSelf = self;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.alpha = 0.0;
    } completion:^(BOOL finished){
        weakSelf.hidden = YES;
        [weakSelf removeFromSuperview];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                        
            STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
            currentUser.isDisclaimerAccepted = [NSNumber numberWithBool:YES];
            
        }];
    }];
}

- (void)dealloc {
    self.removePopOverActionBlock = nil;
}


@end
