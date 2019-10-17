//
//  STPrivacyPolicyPopupView.h
//  Stipend
//
//  Created by sourcebits on 04/02/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextView.h"

@interface STPrivacyPolicyPopupView : UIView<UITextViewDelegate>

+ (STPrivacyPolicyPopupView *)loadFromNib;

+ (STPrivacyPolicyPopupView *)shareView;
- (void)showInView:(UIView *)view withMessageDetails:(NSDictionary *)messageDetails;

@property (weak, nonatomic) IBOutlet UILabel *boldTextLabel;
@property (weak, nonatomic) IBOutlet CustomTextView *normalTextView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *learnMoreButton;

@property (nonatomic, weak) IBOutlet UIView *popUpBackgroundView;

@property (nonatomic, copy) void (^closeActionBlock)(void);
@property (nonatomic, copy) void (^learnMoreActionBlock)(NSString *hyperlinkURL);
@property (nonatomic, copy) void (^linkActionBlock)(NSURL *hyperlinkURL);

- (IBAction)onCloseAction:(id)sender;
- (IBAction)onLearnMoreAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *learnMoreButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *learnMoreButtonBottomConstraint;

@property (strong, nonatomic) NSString *hyperlinkURL;

@end
