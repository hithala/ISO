//
//  STIntroductionViewController.h
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STClickEffectButton.h"

@interface STIntroductionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView                       *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel                            *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel                            *taglineLabel;
@property (weak, nonatomic) IBOutlet STClickEffectButton              *facebookButton;
@property (weak, nonatomic) IBOutlet STClickEffectButton               *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton                           *signInButton;
@property (weak, nonatomic) IBOutlet UIButton                           *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton                       *skipSignUpButton;
@property (weak, nonatomic) IBOutlet UIButton                          *dismissButton;

@property (nonatomic,assign) NSUInteger                             selectedButtonTag;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint            *logoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint   *skipButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint   *skipButtonBottomConstraint;

@property (nonatomic,assign) BOOL                                     hasSkippedLogin;

@property (nonatomic, strong) void (^didUpdateCellActionBlock)(void);
@property (nonatomic, strong) void (^cancelActionBlock)(void);

- (IBAction)onWelcomeButtonsAction:(id)sender;

- (IBAction)onTermsAndConditionsAction:(id)sender;
- (IBAction)onPrivacyPolicyAction:(id)sender;

@end
