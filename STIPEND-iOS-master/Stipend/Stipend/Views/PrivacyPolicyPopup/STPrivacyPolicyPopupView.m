//
//  STPrivacyPolicyPopupView.m
//  Stipend
//
//  Created by sourcebits on 04/02/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import "STPrivacyPolicyPopupView.h"

@implementation STPrivacyPolicyPopupView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark Singleton Methods

+ (STPrivacyPolicyPopupView *)loadFromNib{

    return [[NSBundle mainBundle] loadNibNamed:@"STPrivacyPolicyPopupView" owner:self options:nil].firstObject;
}

+ (STPrivacyPolicyPopupView *)shareView {

static dispatch_once_t pred = 0;
static STPrivacyPolicyPopupView *shareView = nil;
    dispatch_once(&pred, ^{
        shareView = [self loadFromNib];
    });
    return shareView;
}

#pragma mark Initialize Method
- (void)awakeFromNib{
    [super awakeFromNib];
    self.hidden = YES;
    self.alpha = 0.0;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50f];
    self.popUpBackgroundView.backgroundColor = [UIColor clearColor];
}

- (void)showInView:(UIView *)view withMessageDetails:(NSDictionary *)messageDetails {
    
    [self setFrame:view.frame];
    
    self.alpha = 0.0;
    self.hidden = NO;
    
    BOOL doesContain = [view.subviews containsObject:self];
    if (!doesContain) {
        [view addSubview:self];
    }
    
    
    NSString *privacyBoldText = @"";
    NSString *privacyNormalText = @"";
    NSString *privacyUrl = @"";
    
    [self.closeButton setHidden:NO];
    [self.learnMoreButton setTitle:@"Learn more" forState:UIControlStateNormal];
    
    if ([messageDetails.allKeys containsObject:@"privacyBold"]) {
        privacyBoldText = [messageDetails objectForKey:@"privacyBold"];
    }
    
    if ([messageDetails.allKeys containsObject:@"privacyText"]) {
        privacyNormalText = [messageDetails objectForKey:@"privacyText"];
    }
    
    if ([messageDetails.allKeys containsObject:@"privacyUrl"]) {
        privacyUrl = [messageDetails objectForKey:@"privacyUrl"];
    }
    
    
    if ([privacyUrl isEqual: [NSNull null]])
    {
        self.learnMoreButton.hidden = YES;
        self.learnMoreButtonBottomConstraint.constant = 20;
        self.learnMoreButtonHeightConstraint.constant = 0;
        
    } else {
        
        if (privacyUrl.length <= 0)
        {
            self.learnMoreButton.hidden = YES;
            self.learnMoreButtonBottomConstraint.constant = 20;
            self.learnMoreButtonHeightConstraint.constant = 0;
        } else {
            
            self.learnMoreButton.hidden = NO;
        }
    }
    
    self.boldTextLabel.text = privacyBoldText;
    
    self.normalTextView.text = privacyNormalText;

    self.hyperlinkURL = privacyUrl;
    
    [self setNeedsDisplay];
    
    __weak STPrivacyPolicyPopupView *weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)onCloseAction:(id)sender {
    
    if(self.closeActionBlock) {
        self.closeActionBlock();
    }
}

- (IBAction)onLearnMoreAction:(id)sender {
    
    if(self.learnMoreActionBlock) {
        self.learnMoreActionBlock(self.hyperlinkURL);
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if(self.linkActionBlock) {
        self.linkActionBlock(URL);
    }
    return NO;
}

@end
