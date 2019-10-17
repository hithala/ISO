//
//  STSignInFooterView.h
//  Stipend
//
//  Created by Arun S on 08/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSignInFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

- (IBAction)onForgotPasswordAction:(id)sender;
- (IBAction)onSignInButtonAction:(id)sender;

@property (nonatomic, strong) void (^signInActionBlock)(void);
@property (nonatomic, strong) void (^forgotPasswordActionBlock)(void);

@end
