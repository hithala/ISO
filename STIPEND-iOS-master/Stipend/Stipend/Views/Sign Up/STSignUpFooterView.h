//
//  STSignUpFooterView.h
//  Stipend
//
//  Created by Arun S on 08/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSignUpFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton       *signUpButton;
@property (weak, nonatomic) IBOutlet UILabel   *passwordHintLabel;

@property (nonatomic, strong) void (^signUpActionBlock)(void);
@property (nonatomic, strong) void (^privacyPolicyActionBlock)(void);
@property (nonatomic, strong) void (^termsAndConditionsActionBlock)(void);

- (IBAction)onSignUpButtonAction:(id)sender;
- (IBAction)onPrivacyPolicyAction:(id)sender;
- (IBAction)onTermsAndConditionsAction:(id)sender;

@end
