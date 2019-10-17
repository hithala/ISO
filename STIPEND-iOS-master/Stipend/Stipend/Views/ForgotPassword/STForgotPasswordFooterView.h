//
//  STForgotPasswordFooterView.h
//  Stipend
//
//  Created by Arun S on 11/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STForgotPasswordFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, strong) void (^sendActionBlock)(void);

- (IBAction)onSendButtonAction:(id)sender;

@end
