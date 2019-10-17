//
//  STExportEmailView.m
//  Stipend
//
//  Created by Soucebits on 29/09/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import "STExportEmailView.h"

@interface STExportEmailView ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UIView *emailSeparatorView;

@property (nonatomic, weak) IBOutlet UILabel *confirmEmailLabel;
@property (nonatomic, weak) IBOutlet UITextField *confirmEmailTextField;
@property (nonatomic, weak) IBOutlet UIView *confirmEmailSeparatorView;

@property (nonatomic, weak) IBOutlet UIView * popUpview;

@property (nonatomic, strong) UITextField *activeTextField;

@end

@implementation STExportEmailView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

#pragma mark Singleton Methods

+ (STExportEmailView *)loadFromNib{
    
    return [[NSBundle mainBundle] loadNibNamed:@"STExportEmailView" owner:self options:nil].firstObject;
}

+ (STExportEmailView *)shareView {
    
    static dispatch_once_t pred = 0;
    static STExportEmailView *shareView = nil;
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
    
    self.popUpview.layer.cornerRadius = 5.0f;
    [self.popUpview.layer setMasksToBounds:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)showInView:(UIView *)view {
    
    [self setFrame:view.frame];
    
    self.alpha = 0.0;
    self.hidden = NO;
    
    [self resetTextFields];
    
    BOOL doesContain = [view.subviews containsObject:self];
    if (!doesContain) {
        [view addSubview:self];
    }
    
    [self setNeedsDisplay];
    
    __weak STExportEmailView *weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 1.0;
    } completion:^(BOOL finished) {
        [weakSelf.emailTextField becomeFirstResponder];
    }];
}

#pragma mark TextField delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.activeTextField = textField;
    
    [self updateTextFields];
}

- (void) textFieldDidChange:(NSNotification *) notification {
   
     [self updateTextFields];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == self.emailTextField) {
        [self.confirmEmailTextField becomeFirstResponder];
    } else {
        [self sendButtonClick:nil];
    }
    
    [self updateTextFields];

    return NO;
}

- (void)updateTextFields {
   
    // Updating Email textfield highlight status
    if(self.activeTextField == self.emailTextField) {
        [self.emailLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
        [self.emailSeparatorView setBackgroundColor:[UIColor highlightedCellUnderlineColor]];
    } else {
        [self.emailLabel setTextColor:[UIColor cellLabelTextColor]];
        [self.emailSeparatorView setBackgroundColor:[UIColor cellLabelTextColor]];
    }
    
    NSString *emailString = self.emailTextField.text;
    NSString *emailLabelString = self.emailLabel.text;
    
    if(emailString && (![emailString isEqualToString:@""])) {
        self.emailLabel.hidden = NO;
    }
    else {
        self.emailLabel.hidden = YES;
    }
    
    if (!([emailLabelString rangeOfString:@"INVALID"].location == NSNotFound)) {
        self.emailLabel.text = [emailLabelString stringByReplacingOccurrencesOfString:@" INVALID" withString:@""];
    }
    
    // Updating Confirm Email textfield highlight status
    if(self.activeTextField == self.confirmEmailTextField) {
        [self.confirmEmailLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
        [self.confirmEmailSeparatorView setBackgroundColor:[UIColor highlightedCellUnderlineColor]];
    } else {
        [self.confirmEmailLabel setTextColor:[UIColor cellLabelTextColor]];
        [self.confirmEmailSeparatorView setBackgroundColor:[UIColor cellLabelTextColor]];
    }
    
    NSString *confirmEmailString = self.confirmEmailTextField.text;
    NSString *confirmEmailLabelString = self.confirmEmailLabel.text;
    
    if(confirmEmailString && (![confirmEmailString isEqualToString:@""])) {
        self.confirmEmailLabel.hidden = NO;
    }
    else {
        self.confirmEmailLabel.hidden = YES;
    }
    
    if (!([confirmEmailLabelString rangeOfString:@"INVALID"].location == NSNotFound)) {
        self.confirmEmailLabel.text = [confirmEmailLabelString stringByReplacingOccurrencesOfString:@" INVALID" withString:@""];
    }

}

- (void)resetTextFields {
    
    self.emailLabel.hidden = YES;
    self.emailTextField.text = @"";
    
    self.confirmEmailLabel.hidden = YES;
    self.confirmEmailTextField.text = @"";
}

- (void)cancelAction {
    
    if(self.cancelActionBlock) {
        self.cancelActionBlock();
    }

    self.activeTextField = nil;

    [self.emailTextField resignFirstResponder];
    [self.confirmEmailTextField resignFirstResponder];
}

- (IBAction)cancelButtonClick:(id)sender {

    [self cancelAction];
    
//    __weak STExportEmailView *weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CollegeHunch"
                                                                             message:@"Are you sure you want to cancel the Export spreadsheet transaction? If yes, then please try again later and you will not be charged"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf cancelAction];
//    }]];

    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]]) {
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]]) {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    [rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)sendButtonClick:(id)sender {
    
    self.activeTextField = nil;
    
    [self.emailTextField resignFirstResponder];
    [self.confirmEmailTextField resignFirstResponder];
    
    NSString *emailString = self.emailTextField.text;
    NSString *confirmEmailString = self.confirmEmailTextField.text;
    
    [self updateTextFields];
    
    if([emailString validateEmailAddress]) {
        
        if([emailString isEqualToString:confirmEmailString]) {
            
            if(self.sendActionBlock){
                self.sendActionBlock(emailString);
            }
        } else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Email Address Mismatch"
                                                                                     message:@"The email addresses do not match, please re-enter and confirm."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            
            id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
            if([rootViewController isKindOfClass:[UINavigationController class]]) {
                rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
            }
            if([rootViewController isKindOfClass:[UITabBarController class]]) {
                rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
            }
            [rootViewController presentViewController:alertController animated:YES completion:nil];
        }
        
    } else {
        
        self.emailLabel.textColor = [UIColor errorBGColor];
        self.emailLabel.text = [NSString stringWithFormat:@"%@ INVALID", self.emailLabel.text];
        self.emailSeparatorView.backgroundColor = [UIColor errorBGColor];
        
        self.confirmEmailLabel.textColor = [UIColor errorBGColor];
        self.confirmEmailLabel.text = [NSString stringWithFormat:@"%@ INVALID", self.confirmEmailLabel.text];
        self.confirmEmailSeparatorView.backgroundColor = [UIColor errorBGColor];
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
