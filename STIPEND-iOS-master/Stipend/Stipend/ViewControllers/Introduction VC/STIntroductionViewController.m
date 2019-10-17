//
//  STIntroductionViewController.m
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STIntroductionViewController.h"
#import "STTermsAndConditionsViewController.h"
#import "STPrivayPolicyViewController.h"
#import "STProfileViewController.h"
#import "STSocialLoginManager.h"
#import "STTabBarController.h"
#import "STPrivacyAndTermsViewController.h"

#define FACBOOK_BUTTON_TAG                    100
#define TWITTER_BUTTON_TAG                    101
#define SIGNIN_BUTTON_TAG                     102
#define SIGNUP_BUTTON_TAG                     103
#define SKIP_BUTTON_TAG                       104
#define TERMSANDCONDITION_ALERTVIEW_ID        @"kTermsAndConditionKey"

@interface STIntroductionViewController ()

@end

@implementation STIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    CGFloat viewHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if(viewHeight < 568) {
        self.logoTopConstraint.constant = 10;
    } else if(viewHeight == 568) { // iPhone 5
        self.logoTopConstraint.constant = self.hasSkippedLogin ? 60 : 50;
    } else if(viewHeight == 667) { // iPhone 6
        self.logoTopConstraint.constant = self.hasSkippedLogin ? 100 : 80;
    } else if(viewHeight == 736) { // iPhone 6+
        self.logoTopConstraint.constant = self.hasSkippedLogin ? 120 : 100;
    } else if(viewHeight == 812) { // iPhone X
        self.logoTopConstraint.constant = self.hasSkippedLogin ? 150 : 120;
    }
    
    if(self.hasSkippedLogin) {
        self.skipSignUpButton.hidden = YES;
        self.skipButtonBottomConstraint.constant = 0.0;
        self.skipButtonHeightConstraint.constant = 0.0;
        self.dismissButton.hidden = NO;
    }
}

- (IBAction)dismissPresentedViewController {
    if(self.cancelActionBlock != nil) {
        self.cancelActionBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onWelcomeButtonsAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    self.selectedButtonTag = button.tag;
    
    if(self.selectedButtonTag == SIGNIN_BUTTON_TAG) {
        
        [self onAgreeButtonAction:self.selectedButtonTag];
        
    } else if(self.selectedButtonTag == SIGNUP_BUTTON_TAG) {
        [self showTermsAndConditionAlertViewAction:self.selectedButtonTag];

    } else if(self.selectedButtonTag == SKIP_BUTTON_TAG) {
        [self showSkipTermsAndConditionAlertViewAction:self.selectedButtonTag];
        
    } else if(self.selectedButtonTag == FACBOOK_BUTTON_TAG || self.selectedButtonTag == TWITTER_BUTTON_TAG) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isFirstTime = [[userDefaults objectForKey:TERMSANDCONDITION_ALERTVIEW_ID] boolValue];
        
        if(!isFirstTime) {
            [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:TERMSANDCONDITION_ALERTVIEW_ID];
            [userDefaults synchronize];
            [self showTermsAndConditionAlertViewAction:self.selectedButtonTag];
            
        } else {
            
            UIButton *button = (UIButton *)sender;
            if (button.tag == TWITTER_BUTTON_TAG) {
                button.enabled = NO;
            }
            [self onAgreeButtonAction:self.selectedButtonTag];
        }
    } else {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isFirstTime = [[userDefaults objectForKey:TERMSANDCONDITION_ALERTVIEW_ID] boolValue];
        
        if (!isFirstTime && (self.selectedButtonTag != SIGNUP_BUTTON_TAG)) {
            [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:TERMSANDCONDITION_ALERTVIEW_ID];
            [userDefaults synchronize];
            [self showTermsAndConditionAlertViewAction:self.selectedButtonTag];
        } else if (self.selectedButtonTag == SIGNUP_BUTTON_TAG) {
            [self showTermsAndConditionAlertViewAction:self.selectedButtonTag];
        }
        else {
            UIButton *button = (UIButton *)sender;
            if (button.tag == TWITTER_BUTTON_TAG) {
                button.enabled = NO;
            }
            [self onAgreeButtonAction:self.selectedButtonTag];
        }

    }
}

- (void) navigateToNextController {
    
    BOOL isNewUser = [[[NSUserDefaults standardUserDefaults] objectForKey:IS_NEW_USER] boolValue];
    
    if(isNewUser) {
        [self performSegueWithIdentifier:PROFILE_SEGUE_ID sender:self];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:IS_NEW_USER];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [self performFinishAnimation];
    }
}

- (void) performFinishAnimation {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isLoginScreenPresented = [userDefaults boolForKey:LOGIN_SCREEN_PRESENTED];
    
    if(isLoginScreenPresented) {
        [userDefaults setBool:NO forKey:LOGIN_SCREEN_PRESENTED];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    UIStoryboard *tabBarMenuStoryboard = [UIStoryboard storyboardWithName:@"TabBarMenu" bundle:nil];
    STTabBarController *tabBarController = [tabBarMenuStoryboard instantiateViewControllerWithIdentifier:@"TabBarControllerID"];
    
    UIView *overlayView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    [tabBarController.view addSubview:overlayView];
    [[UIApplication sharedApplication] delegate].window.rootViewController = tabBarController;
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect overlayFrame = overlayView.frame;
        overlayFrame.origin.y += overlayFrame.size.height;
        overlayView.frame = overlayFrame;
    } completion:^(BOOL finished) {
        overlayView.alpha = 0.0;
        [overlayView removeFromSuperview];
    }];
}

- (IBAction)onTermsAndConditionsAction:(id)sender {
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
//    STTermsAndConditionsViewController *termsAndConditionsViewController = [storyboard instantiateViewControllerWithIdentifier:@"TermsAndConditionsStoryBoardID"];
//    termsAndConditionsViewController.isFromIntroductionViewController = YES;
//
//    UINavigationController *termsAndConditionsNavigationController = [[UINavigationController alloc] initWithRootViewController:termsAndConditionsViewController];
//    [self presentViewController:termsAndConditionsNavigationController animated:YES completion:nil];

    STPrivacyAndTermsViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STPrivacyAndTermsViewController"];
    webView.urlString = TERMS_OF_USE_URL;
    webView.titleText = @"Terms of Use";
    webView.isTermsOfUse = YES;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:navController animated:YES completion:nil];
}

- (IBAction)onPrivacyPolicyAction:(id)sender {

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
//
//    STPrivayPolicyViewController *privacyPolicyViewController = [storyboard instantiateViewControllerWithIdentifier:@"PrivayPolicyStoryboardID"];
//    privacyPolicyViewController.isFromIntroductionViewController = YES;
//
//    UINavigationController *termsAndConditionsNavigationController = [[UINavigationController alloc] initWithRootViewController:privacyPolicyViewController];
//    [self presentViewController:termsAndConditionsNavigationController animated:YES completion:nil];
    
    STPrivacyAndTermsViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STPrivacyAndTermsViewController"];
    webView.urlString = PRIVACY_POLICY_URL;
    webView.titleText = @"Privacy Policy";
    webView.isTermsOfUse = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - UIAlertController

- (void)showTermsAndConditionAlertViewAction:(NSUInteger)tagIndex{
    self.selectedButtonTag = tagIndex;
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Terms & Conditions"
                                          message:@"I agree to the Terms & Conditions & ￼Privacy Policy"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    __weak STIntroductionViewController *weakSelf = self;
    UIAlertAction *disagreeAction = [UIAlertAction actionWithTitle:@"Disagree" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        if(weakSelf.selectedButtonTag != SIGNUP_BUTTON_TAG) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:TERMSANDCONDITION_ALERTVIEW_ID];
            [userDefaults synchronize];
        }
    }];
    
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf onAgreeButtonAction:self.selectedButtonTag];
    }];
    
    [alertController addAction:disagreeAction];
    [alertController addAction:agreeAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showSkipTermsAndConditionAlertViewAction:(NSUInteger)tagIndex {
    
    self.selectedButtonTag = tagIndex;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CollegeHunch" message:@"You can view college data without signing up. But if you want to use any of the App’s account-specific features, such as saving colleges to favorites, adding colleges to a spreadsheet, or sorting or filtering colleges by criteria you choose, you must sign up in order for the App to save your preferences" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak STIntroductionViewController *weakSelf = self;
    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf skipButtonAction];
    }];

    UIAlertAction *signUpAction = [UIAlertAction actionWithTitle:@"Sign Up" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        weakSelf.selectedButtonTag = SIGNUP_BUTTON_TAG;
        [weakSelf showTermsAndConditionAlertViewAction:self.selectedButtonTag];
    }];

    [alertController addAction:continueAction];
    [alertController addAction:signUpAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onAgreeButtonAction:(NSUInteger)selectedIndex{
    switch (selectedIndex) {
        case SIGNUP_BUTTON_TAG:
            [self signUpAction];
            break;
        case SIGNIN_BUTTON_TAG:
            [self signInAction];
            break;
        case SKIP_BUTTON_TAG:
            [self skipButtonAction];
            break;
        case FACBOOK_BUTTON_TAG:
            [self connectWithFacebookAction];
            break;
        case TWITTER_BUTTON_TAG:
            [self connectWithTwitterAction];
            break;
        default:
            break;
    }
}

- (void)signInAction {
    [self performSegueWithIdentifier:SIGNIN_SEGUE_ID sender:self];
}

- (void)signUpAction {
    [self performSegueWithIdentifier:SIGNUP_SEGUE_ID sender:self];
}

- (void)skipButtonAction {
    
    self.hasSkippedLogin = YES;
    
    [[STNetworkAPIManager sharedManager] loginGuestUserWithDetails:nil success:^(id response) {
//        [self performSegueWithIdentifier:PROFILE_SEGUE_ID sender:self];
        [self performFinishAnimation];
    } failure:^(NSError *error) {
        
    }];
}

- (void)connectWithFacebookAction {
    
    [self.view setUserInteractionEnabled:NO];
    [STProgressHUD show];

    [[STSocialLoginManager sharedManager] connectToFacebookAccount];
    [STSocialLoginManager sharedManager].socialLoginSuccess = ^(NSMutableDictionary *details) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view setUserInteractionEnabled:YES];
            self.hasSkippedLogin = NO;
            
            [[STNetworkAPIManager sharedManager] connectFacebookUserWithDetails:details success:^(id response) {
                [STProgressHUD dismiss];
                [self navigateToNextController];
            } failure:^(NSError *error) {
                [STProgressHUD dismiss];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error" message:@"Cannot connect to Server. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        });
    };
    
    [STSocialLoginManager sharedManager].socialLoginFailed = ^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view setUserInteractionEnabled:YES];
            [STProgressHUD dismiss];
            if (error){
                [self showErrorMessage:@"There was problem requesting access from Facebook."];
            } else if(!error){
                [self showErrorMessage:@"Please grant CollegeHunch access to Facebook in your Settings."];
            } else{
                [self showErrorMessage:@"Please grant CollegeHunch access to Facebook in your Settings."];
            }
        });
    };
}

- (void)showErrorMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"CollegeHunch"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)connectWithTwitterAction {
    
    [self.view setUserInteractionEnabled:NO];
    [[STSocialLoginManager sharedManager] connectToTwitterAccount];
    [STSocialLoginManager sharedManager].socialLoginSuccess = ^(NSMutableDictionary *details) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view setUserInteractionEnabled:YES];
            self.hasSkippedLogin = NO;
            UIButton *button = (UIButton *)[self.view viewWithTag:TWITTER_BUTTON_TAG];
            button.enabled = YES;
            [STProgressHUD show];
            
            [[STNetworkAPIManager sharedManager] connectTwitterUserWithDetails:details success:^(id response) {
                [STProgressHUD dismiss];
                [self navigateToNextController];
                
            } failure:^(NSError *error) {
                [STProgressHUD dismiss];
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Network Error"
                                                      message:@"Cannot connect to Server. Please try again."
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        });
    };
    
    [STSocialLoginManager sharedManager].socialLoginFailed = ^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view setUserInteractionEnabled:YES];
            [STProgressHUD dismiss];
            UIButton *button = (UIButton *)[self.view viewWithTag:TWITTER_BUTTON_TAG];
            button.enabled = YES;
            [self showErrorMessage:@"Error connecting to Twitter. Please try again."];
        });
    };
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:PROFILE_SEGUE_ID]) {
        STProfileViewController *profileViewController = [segue destinationViewController];
        
        if(self.hasSkippedLogin) {
            profileViewController.navigationItem.hidesBackButton = NO;
        }
        else {
            profileViewController.navigationItem.hidesBackButton = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
