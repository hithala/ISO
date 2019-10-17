//
//  STProfileFooterView.h
//  Stipend
//
//  Created by Arun S on 11/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STProfileFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;

@property (nonatomic, strong) void (^finishActionBlock)(void);
@property (nonatomic, strong) void (^privacyActionBlock)(void);

- (IBAction)onFinishButtonAction:(id)sender;
- (IBAction)onPrivacyButtonAction:(id)sender;

@end
