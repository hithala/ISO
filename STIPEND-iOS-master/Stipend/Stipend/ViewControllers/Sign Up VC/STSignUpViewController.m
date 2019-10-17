//
//  STSignUpViewController.m
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STSignUpViewController.h"
#import "STSignUpFooterView.h"
#import "STLoginTextCell.h"
#import "STNameTextCell.h"
#import "STTermsAndConditionsViewController.h"
#import "STProfileViewController.h"
#import "STPrivayPolicyViewController.h"
#import "STPrivacyAndTermsViewController.h"

#define HEADER_VIEW_HEIGHT              30.0
#define ROW_HEIGHT                      70.0
#define TOP_BARHEIGHT                   44.0

@interface STSignUpViewController ()

@end

@implementation STSignUpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Sign Up";

    [self.tableView registerNib:[UINib nibWithNibName:@"STNameTextCell" bundle:nil] forCellReuseIdentifier:@"STNameTextCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STLoginTextCell" bundle:nil] forCellReuseIdentifier:@"STLoginTextCell"];
    
    self.signUpDataSourceDictionary = [[NSMutableDictionary alloc] init];
    self.signUpDataSourceDictionary = [self getSignUpDataSource];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureAction:)];
    [self.tapGesture setNumberOfTapsRequired:1];
    [self.tapGesture setNumberOfTouchesRequired:1];
    [self.tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:self.tapGesture];

    [self updateHeaderAndFooterView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    
    if(SCREEN_HEIGHT < 667.0) {
        self.tableView.scrollEnabled = YES;
    } else {
        self.tableView.scrollEnabled = NO;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self validateSignUpButton];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateResponderForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void) updateResponderForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    if(indexPath.row < (([[self.signUpDataSourceDictionary allKeys] count] - 1))) {
        
        if(indexPath.row == 0) {
            STNameTextCell *cell = (STNameTextCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.firstNameField becomeFirstResponder];
        }
        else {
            STLoginTextCell *cell = (STLoginTextCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell.valueField becomeFirstResponder];
        }
    }
    else {
        [self.tableView endEditing:YES];
        [self onSignUpButtonAction];
    }
}

- (void) updateHeaderAndFooterView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = headerView;
    
    CGFloat footerHeight = 0.0;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat cellHeight = (([[self.signUpDataSourceDictionary allKeys] count] - 1) * ROW_HEIGHT);
    CGFloat headerHeight = HEADER_VIEW_HEIGHT;
    
    footerHeight = screenHeight - cellHeight - headerHeight - TOP_BARHEIGHT;
    
    if(footerHeight < 180.0) {
        footerHeight = 180.0;
    }
    
    STSignUpFooterView* footerView = [[NSBundle mainBundle] loadNibNamed:@"STSignUpFooterView" owner:self options:nil][0];
    footerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, footerHeight);
    footerView.passwordHintLabel.hidden = YES;
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableFooterView = footerView;
    
    __weak STSignUpViewController *weakSelf = self;//to break retain cycles..
    
    footerView.signUpActionBlock = ^{
        [weakSelf onSignUpButtonAction];
    };
    
    footerView.termsAndConditionsActionBlock = ^{
        [weakSelf onTermsAndConditionsAction];
    };

    footerView.privacyPolicyActionBlock = ^{
        [weakSelf onPrivacyPolicyAction];
    };

}

- (void)onTermsAndConditionsAction {
    
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

- (void)onPrivacyPolicyAction {
   
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

- (void) onSignUpButtonAction {
    
    if([self validate]) {
        
        NSString *fName = [[self.signUpDataSourceDictionary objectForKey:FIRST_NAME_DETAILS] objectForKey:KEY_VALUE];
        NSString *lName = [[self.signUpDataSourceDictionary objectForKey:LAST_NAME_DETAILS] objectForKey:KEY_VALUE];
        NSString *emailID = [[self.signUpDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS] objectForKey:KEY_VALUE];
        NSString *password = [[self.signUpDataSourceDictionary objectForKey:PASSWORD_DETAILS] objectForKey:KEY_VALUE];

        NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:fName,kFirstName,lName,kLastName,emailID,kEmailID,password,kPassword, nil];

        __weak STSignUpViewController *weakSelf = self;

        [STProgressHUD show];
        [[STNetworkAPIManager sharedManager] signUpUserWithDetails:details success:^(id response) {
            [STProgressHUD dismiss];
            [weakSelf performSegueWithIdentifier:PROFILE_SEGUE_ID sender:self];
        } failure:^(NSError *error) {
            
            [STProgressHUD dismiss];

            if([error code] == 2000) {
                
                if([[error domain] isEqualToString:@"Email alredy Exists"]) {
                    [weakSelf showAlertForEmailAlreadyExists];
                }
            } else {
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Network Error"
                                                      message:@"Cannot connect to Server. Please try again."
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
    }
    else {
    }
}

- (void)showAlertForEmailAlreadyExists {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Email Already in Use"
                                          message:@"The email address you entered has already been registered with a CollegeHunch account."
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    __weak STSignUpViewController *weakSelf = self;
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *signInAction = [UIAlertAction actionWithTitle:@"Sign In" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf performSegueWithIdentifier:SIGNIN_SEGUE_ID sender:self];
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:signInAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) onTapGestureAction:(UITapGestureRecognizer *) gestureRecognizer {
    [self.view endEditing:YES];
}

- (NSMutableDictionary *) getSignUpDataSource {
    
    NSMutableDictionary *dataSourceDict = [NSMutableDictionary dictionary];
    
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"FIRST NAME",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:FIRST_NAME_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"LAST NAME",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:LAST_NAME_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"EMAIL ADDRESS",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:EMAIL_ADDRESS_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"PASSWORD",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:PASSWORD_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"CONFIRM PASSWORD",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:CONFIRM_PASSWORD_DETAILS];
    
    return dataSourceDict;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ([[self.signUpDataSourceDictionary allKeys] count] - 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id contentCell;
    __weak STSignUpViewController *weakSelf = self;

    if(indexPath.row == 0) { // First Name and Last Name
        
        STNameTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STNameTextCell" forIndexPath:indexPath];
        
        NSMutableDictionary *firstNameDetails = [self.signUpDataSourceDictionary objectForKey:FIRST_NAME_DETAILS];
        NSMutableDictionary *lastNameDetails = [self.signUpDataSourceDictionary objectForKey:LAST_NAME_DETAILS];

        cell.firstNameField.textColor = [UIColor cellTextFieldTextColor];
        cell.firstNameField.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0];
        cell.firstNameField.returnKeyType = UIReturnKeyNext;

        cell.firstNameLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:11.0];

        cell.firstNameLabel.text = [firstNameDetails objectForKey:KEY_LABEL];
        cell.firstNameField.text = [firstNameDetails objectForKey:KEY_VALUE];

        NSString *fName = [firstNameDetails objectForKey:KEY_VALUE];

        if([[firstNameDetails objectForKey:KEY_VALID] boolValue]) {
            cell.firstNameLabel.text = [firstNameDetails objectForKey:KEY_LABEL];
            
            BOOL isActive = [[firstNameDetails objectForKey:KEY_ISACTIVE] boolValue];
            
            if(isActive) {
                [cell.firstNameLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
                cell.firstNameSeperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
                cell.firstNameSeperatorHeightConstraint.constant = 2.0;
            }
            else {
                [cell.firstNameLabel setTextColor:[UIColor cellLabelTextColor]];
                cell.firstNameSeperatorView.backgroundColor = [UIColor cellLabelTextColor];
                cell.firstNameSeperatorHeightConstraint.constant = 1.0;
            }
        }
        else {
            cell.firstNameLabel.textColor = [UIColor errorBGColor];
            cell.firstNameLabel.text = [NSString stringWithFormat:@"%@ INVALID",[firstNameDetails objectForKey:KEY_LABEL]];
            cell.firstNameSeperatorView.backgroundColor = [UIColor errorBGColor];
            cell.firstNameSeperatorHeightConstraint.constant = 1.0;
        }

        cell.lastNameField.textColor = [UIColor cellTextFieldTextColor];
        cell.lastNameField.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0];
        cell.lastNameLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:11.0];

        cell.lastNameLabel.text = [lastNameDetails objectForKey:KEY_LABEL];
        cell.lastNameField.text = [lastNameDetails objectForKey:KEY_VALUE];
        cell.lastNameField.returnKeyType = UIReturnKeyNext;

        NSString *lName = [lastNameDetails objectForKey:KEY_VALUE];

        if([[lastNameDetails objectForKey:KEY_VALID] boolValue]) {
            cell.lastNameLabel.text = [lastNameDetails objectForKey:KEY_LABEL];
            
            BOOL isActive = [[firstNameDetails objectForKey:KEY_ISACTIVE] boolValue];
            
            if(isActive) {
                [cell.lastNameLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
                cell.lastNameSeperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
                cell.lastNameSeperatorHeightConstraint.constant = 2.0;
            }
            else {
                [cell.lastNameLabel setTextColor:[UIColor cellLabelTextColor]];
                cell.lastNameSeperatorView.backgroundColor = [UIColor cellLabelTextColor];
                cell.lastNameSeperatorHeightConstraint.constant = 1.0;
            }
        }
        else {
            cell.lastNameLabel.textColor = [UIColor errorBGColor];
            cell.lastNameLabel.text = [NSString stringWithFormat:@"%@ INVALID",[lastNameDetails objectForKey:KEY_LABEL]];
            cell.lastNameSeperatorView.backgroundColor = [UIColor errorBGColor];
            cell.lastNameSeperatorHeightConstraint.constant = 1.0;
        }

        if(fName && (![fName isEqualToString:@""])) {
            cell.firstNameLabel.hidden = NO;
        }
        else {
            cell.firstNameLabel.hidden = YES;
        }
        
        if(lName && (![lName isEqualToString:@""])) {
            cell.lastNameLabel.hidden = NO;
        }
        else {
            cell.lastNameLabel.hidden = YES;
        }

        UIColor *placeHolderColor = [UIColor placeHolderTextColor];
        cell.firstNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[firstNameDetails objectForKey:KEY_LABEL] capitalizedString] attributes:@{NSForegroundColorAttributeName: placeHolderColor,
                                                                                                                          NSFontAttributeName : [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0]}];
        
        cell.lastNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[lastNameDetails objectForKey:KEY_LABEL] capitalizedString] attributes:@{NSForegroundColorAttributeName: placeHolderColor,
                                                                                                                        NSFontAttributeName : [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0]}];
        
        cell.cellIndexPath = indexPath;

        cell.didUpdateCellActionBlock = ^(id cell) {
            [weakSelf didUpdateValueInCell:cell];
        };

        cell.didStartEditingActionBlock = ^(id cell, BOOL isFirstField) {
            
            STNameTextCell *updatingCell = cell;
            
            if(isFirstField) {
            
                NSMutableDictionary *firstNameDetails = [self.signUpDataSourceDictionary objectForKey:FIRST_NAME_DETAILS];
                [firstNameDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_ISACTIVE];
                [updatingCell.firstNameLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
                updatingCell.firstNameSeperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
                updatingCell.firstNameSeperatorHeightConstraint.constant = 2.0;
            }
            else {
                NSMutableDictionary *lastNameDetails = [self.signUpDataSourceDictionary objectForKey:LAST_NAME_DETAILS];
                [lastNameDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_ISACTIVE];
                [updatingCell.lastNameLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
                updatingCell.lastNameSeperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
                updatingCell.lastNameSeperatorHeightConstraint.constant = 2.0;
            }
        };
        
        cell.didEndEditingActionBlock = ^(id cell, BOOL isFirstField) {
            
            STNameTextCell *updatingCell = cell;
            
            if(isFirstField) {
                
                NSMutableDictionary *firstNameDetails = [self.signUpDataSourceDictionary objectForKey:FIRST_NAME_DETAILS];
                [firstNameDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_ISACTIVE];
                [updatingCell.firstNameLabel setTextColor:[UIColor cellLabelTextColor]];
                updatingCell.firstNameSeperatorView.backgroundColor = [UIColor defaultCellUnderlineColor];
                updatingCell.firstNameSeperatorHeightConstraint.constant = 1.0;
            }
            else {
                NSMutableDictionary *lastNameDetails = [self.signUpDataSourceDictionary objectForKey:LAST_NAME_DETAILS];
                [lastNameDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_ISACTIVE];
                [updatingCell.lastNameLabel setTextColor:[UIColor cellLabelTextColor]];
                updatingCell.lastNameSeperatorView.backgroundColor = [UIColor defaultCellUnderlineColor];
                updatingCell.lastNameSeperatorHeightConstraint.constant = 1.0;
            }
        };

        cell.didClickReturnActionBlock = ^(id cell) {
            STNameTextCell *updatingCell = cell;
            
            if([updatingCell.firstNameField isFirstResponder]) {
                [updatingCell.lastNameField becomeFirstResponder];
            }
            else {
                NSIndexPath *curIndexPath = updatingCell.cellIndexPath;
                NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(curIndexPath.row + 1) inSection:curIndexPath.section];
                [self updateResponderForRowAtIndexPath:nextIndexPath];
            }
        };

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        contentCell = cell;
    }
    else {                                       //Email
        
        STLoginTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STLoginTextCell" forIndexPath:indexPath];

        cell.valueField.textColor = [UIColor cellTextFieldTextColor];
        cell.valueField.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0];
        cell.valueLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:11.0];

        UIColor *placeHolderColor = [UIColor placeHolderTextColor];

        if(indexPath.row == 1) { // Email Address
            
            NSMutableDictionary *emailAddressDetails = [self.signUpDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
            
            cell.valueLabel.text = [emailAddressDetails objectForKey:KEY_LABEL];
            cell.valueField.text = [emailAddressDetails objectForKey:KEY_VALUE];
            cell.valueField.returnKeyType = UIReturnKeyNext;
            cell.valueField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.valueField.secureTextEntry = NO;

            
            if([[emailAddressDetails objectForKey:KEY_VALID] boolValue]) {
                cell.valueLabel.text = [emailAddressDetails objectForKey:KEY_LABEL];
                
                BOOL isActive = [[emailAddressDetails objectForKey:KEY_ISACTIVE] boolValue];
                
                if(isActive) {
                    [cell.valueLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
                    cell.seperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
                    cell.seperatorHeightConstraint.constant = 2.0;
                }
                else {
                    [cell.valueLabel setTextColor:[UIColor cellLabelTextColor]];
                    cell.seperatorView.backgroundColor = [UIColor cellLabelTextColor];
                    cell.seperatorHeightConstraint.constant = 1.0;
                }
            }
            else {
                cell.valueLabel.textColor = [UIColor errorBGColor];
                cell.valueLabel.text = [NSString stringWithFormat:@"%@ INVALID",[emailAddressDetails objectForKey:KEY_LABEL]];
                cell.seperatorView.backgroundColor = [UIColor errorBGColor];
                cell.seperatorHeightConstraint.constant = 1.0;
            }
            
            NSString *emailID = [emailAddressDetails objectForKey:KEY_VALUE];
            
            if(emailID && (![emailID isEqualToString:@""])) {
                cell.valueLabel.hidden = NO;
            }
            else {
                cell.valueLabel.hidden = YES;
            }
            
            cell.valueField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[emailAddressDetails objectForKey:KEY_LABEL] capitalizedString] attributes:@{NSForegroundColorAttributeName: placeHolderColor,
                                                                                                                                                                             NSFontAttributeName : [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0]}];
        }
        else if(indexPath.row == 2) { // Password
            
            NSMutableDictionary *passwordDetails = [self.signUpDataSourceDictionary objectForKey:PASSWORD_DETAILS];
            
            cell.valueField.text = [passwordDetails objectForKey:KEY_VALUE];
            cell.valueField.textColor = [UIColor blackColor];
            cell.valueField.returnKeyType = UIReturnKeyNext;
            cell.valueField.secureTextEntry = YES;
            
            cell.valueLabel.text = [passwordDetails objectForKey:KEY_LABEL];
            
            if([[passwordDetails objectForKey:KEY_VALID] boolValue]) {
                cell.valueLabel.text = [passwordDetails objectForKey:KEY_LABEL];
                
                BOOL isActive = [[passwordDetails objectForKey:KEY_ISACTIVE] boolValue];
                
                if(isActive) {
                    [cell.valueLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
                    cell.seperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
                    cell.seperatorHeightConstraint.constant = 2.0;
                }
                else {
                    [cell.valueLabel setTextColor:[UIColor cellLabelTextColor]];
                    cell.seperatorView.backgroundColor = [UIColor cellLabelTextColor];
                    cell.seperatorHeightConstraint.constant = 1.0;
                }
            }
            else {
                cell.valueLabel.textColor = [UIColor errorBGColor];
                cell.valueLabel.text = [NSString stringWithFormat:@"%@ INVALID",[passwordDetails objectForKey:KEY_LABEL]];
                cell.seperatorView.backgroundColor = [UIColor errorBGColor];
                cell.seperatorHeightConstraint.constant = 1.0;
            }
            
            NSString *password = [passwordDetails objectForKey:KEY_VALUE];
            
            if(password && (![password isEqualToString:@""])) {
                cell.valueLabel.hidden = NO;
            }
            else {
                cell.valueLabel.hidden = YES;
            }
            
            cell.valueField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[passwordDetails objectForKey:KEY_LABEL] capitalizedString] attributes:@{NSForegroundColorAttributeName: placeHolderColor,
                                                                                                                                                                         NSFontAttributeName : [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0]}];
        }
        else if(indexPath.row == 3) { // Confirm Password
            
            NSMutableDictionary *confirmPasswordDetails = [self.signUpDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS];
            
            cell.valueField.text = [confirmPasswordDetails objectForKey:KEY_VALUE];
            cell.valueField.textColor = [UIColor blackColor];
            cell.valueField.returnKeyType = UIReturnKeyDone;
            cell.valueField.secureTextEntry = YES;
            
            cell.valueLabel.text = [confirmPasswordDetails objectForKey:KEY_LABEL];
            
            if([[confirmPasswordDetails objectForKey:KEY_VALID] boolValue]) {
                cell.valueLabel.text = [confirmPasswordDetails objectForKey:KEY_LABEL];
                
                BOOL isActive = [[confirmPasswordDetails objectForKey:KEY_ISACTIVE] boolValue];
                
                if(isActive) {
                    [cell.valueLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
                    cell.seperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
                    cell.seperatorHeightConstraint.constant = 2.0;
                }
                else {
                    [cell.valueLabel setTextColor:[UIColor cellLabelTextColor]];
                    cell.seperatorView.backgroundColor = [UIColor cellLabelTextColor];
                    cell.seperatorHeightConstraint.constant = 1.0;
                }
            }
            else {
                cell.valueLabel.textColor = [UIColor errorBGColor];
                cell.valueLabel.text = [NSString stringWithFormat:@"%@ INVALID",[confirmPasswordDetails objectForKey:KEY_LABEL]];
                cell.seperatorView.backgroundColor = [UIColor errorBGColor];
                cell.seperatorHeightConstraint.constant = 1.0;
            }
            
            NSString *password = [confirmPasswordDetails objectForKey:KEY_VALUE];
            
            if(password && (![password isEqualToString:@""])) {
                cell.valueLabel.hidden = NO;
            }
            else {
                cell.valueLabel.hidden = YES;
            }
            
            cell.valueField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[confirmPasswordDetails objectForKey:KEY_LABEL] capitalizedString] attributes:@{NSForegroundColorAttributeName: placeHolderColor,
                                                                                                                                                                         NSFontAttributeName : [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0]}];
        }
        
        
        cell.cellIndexPath = indexPath;
        
        cell.didUpdateCellActionBlock = ^(id cell) {
            [weakSelf didUpdateValueInCell:cell];
        };
        
        cell.didStartEditingActionBlock = ^(id cell) {
            
            STLoginTextCell *updatingCell = cell;
            NSIndexPath *curIndexPath = updatingCell.cellIndexPath;
            
            if(curIndexPath.row == 1) {
                NSMutableDictionary *emailAddressDetails = [self.signUpDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
                [emailAddressDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_ISACTIVE];
                [updatingCell.valueLabel setText:[emailAddressDetails objectForKey:KEY_LABEL]];
            }
            else if(curIndexPath.row == 2) {
                
                NSMutableDictionary *passwordDetails = [self.signUpDataSourceDictionary objectForKey:PASSWORD_DETAILS];
                [passwordDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_ISACTIVE];
                [updatingCell.valueLabel setText:[passwordDetails objectForKey:KEY_LABEL]];
                STSignUpFooterView *footerView = (STSignUpFooterView *)[weakSelf.tableView tableFooterView];
                footerView.passwordHintLabel.hidden = NO;
            }
            else if(curIndexPath.row == 3) {
                
                NSMutableDictionary *confirmPasswordDetails = [self.signUpDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS];
                [confirmPasswordDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_ISACTIVE];
                [updatingCell.valueLabel setText:[confirmPasswordDetails objectForKey:KEY_LABEL]];
                STSignUpFooterView *footerView = (STSignUpFooterView *)[weakSelf.tableView tableFooterView];
                footerView.passwordHintLabel.hidden = NO;
            }
            
            [updatingCell.valueLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
            updatingCell.seperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
            updatingCell.seperatorHeightConstraint.constant = 2.0;
        };
        
        cell.didEndEditingActionBlock = ^(id cell) {
            
            STLoginTextCell *updatingCell = cell;
            NSIndexPath *curIndexPath = updatingCell.cellIndexPath;
            
            if(curIndexPath.row == 1) {
                NSMutableDictionary *emailAddressDetails = [self.signUpDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
                [emailAddressDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_ISACTIVE];
            }
            else if(curIndexPath.row == 2) {
                
                NSMutableDictionary *passwordDetails = [self.signUpDataSourceDictionary objectForKey:PASSWORD_DETAILS];
                [passwordDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_ISACTIVE];
            }
            else if(curIndexPath.row == 3) {
                
                NSMutableDictionary *confirmPasswordDetails = [self.signUpDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS];
                [confirmPasswordDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_ISACTIVE];
            }

            STSignUpFooterView *footerView = (STSignUpFooterView *)[weakSelf.tableView tableFooterView];
            footerView.passwordHintLabel.hidden = YES;
            
            [updatingCell.valueLabel setTextColor:[UIColor cellLabelTextColor]];
            updatingCell.seperatorView.backgroundColor = [UIColor defaultCellUnderlineColor];
            updatingCell.seperatorHeightConstraint.constant = 1.0;
        };

        cell.didClickReturnActionBlock = ^(id cell) {
            STLoginTextCell *updatingCell = cell;
            NSIndexPath *curIndexPath = updatingCell.cellIndexPath;
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(curIndexPath.row + 1) inSection:curIndexPath.section];
            [self updateResponderForRowAtIndexPath:nextIndexPath];
        };

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        contentCell = cell;
    }
    

    return contentCell;
}

- (void) didUpdateValueInCell:(id) cell {
    
    if([cell isKindOfClass:[STNameTextCell class]]) {
        
        STNameTextCell *updatingCell = cell;
        
        if(updatingCell.cellIndexPath.row == 0) {
            NSMutableDictionary *firstNameDetails = [self.signUpDataSourceDictionary objectForKey:FIRST_NAME_DETAILS];
            NSMutableDictionary *lastNameDetails = [self.signUpDataSourceDictionary objectForKey:LAST_NAME_DETAILS];
            [firstNameDetails setObject:updatingCell.firstNameField.text forKey:KEY_VALUE];
            [lastNameDetails setObject:updatingCell.lastNameField.text forKey:KEY_VALUE];
            
            if(![[firstNameDetails objectForKey:KEY_VALID] boolValue]) {
                [firstNameDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
                updatingCell.firstNameLabel.text = [firstNameDetails objectForKey:KEY_LABEL];
            }
            
            BOOL isActive = [[firstNameDetails objectForKey:KEY_ISACTIVE] boolValue];
            
            if(isActive) {
                [updatingCell.firstNameLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
            }
            else {
                [updatingCell.firstNameLabel setTextColor:[UIColor cellLabelTextColor]];
            }

            if(![[lastNameDetails objectForKey:KEY_VALID] boolValue]) {
                [lastNameDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
                updatingCell.lastNameLabel.text = [lastNameDetails objectForKey:KEY_LABEL];
            }
            
            isActive = [[lastNameDetails objectForKey:KEY_ISACTIVE] boolValue];
            
            if(isActive) {
                [updatingCell.lastNameLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
            }
            else {
                [updatingCell.lastNameLabel setTextColor:[UIColor cellLabelTextColor]];
            }
        }
        else {
        }
    }
    else {
        STLoginTextCell *updatingCell = cell;
        
        if(updatingCell.cellIndexPath.row == 1) {      //Email
            NSMutableDictionary *emailAddressDetails = [self.signUpDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
            [emailAddressDetails setObject:updatingCell.valueField.text forKey:KEY_VALUE];
            [updatingCell.valueField setTextColor:[UIColor blackColor]];//reset color
            
            if(![[emailAddressDetails objectForKey:KEY_VALID] boolValue]) {
                [emailAddressDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
                updatingCell.valueLabel.text = [emailAddressDetails objectForKey:KEY_LABEL];
            }
            
            BOOL isActive = [[emailAddressDetails objectForKey:KEY_ISACTIVE] boolValue];
            
            if(isActive) {
                [updatingCell.valueLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
            }
            else {
                [updatingCell.valueLabel setTextColor:[UIColor cellLabelTextColor]];
            }
        }
        else if(updatingCell.cellIndexPath.row == 2) {
            
            NSMutableDictionary *passwordDetails = [self.signUpDataSourceDictionary objectForKey:PASSWORD_DETAILS];
            [passwordDetails setObject:updatingCell.valueField.text forKey:KEY_VALUE];
            
            if(![[passwordDetails objectForKey:KEY_VALID] boolValue]) {
                [passwordDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
                updatingCell.valueLabel.text = [passwordDetails objectForKey:KEY_LABEL];
            }
            
            BOOL isActive = [[passwordDetails objectForKey:KEY_ISACTIVE] boolValue];
            
            if(isActive) {
                [updatingCell.valueLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
            }
            else {
                [updatingCell.valueLabel setTextColor:[UIColor cellLabelTextColor]];
            }
        }
        else if(updatingCell.cellIndexPath.row == 3) {
            NSMutableDictionary *confirmPasswordDetails = [self.signUpDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS];
            
            [confirmPasswordDetails setObject:updatingCell.valueField.text forKey:KEY_VALUE];
            
            if(![[confirmPasswordDetails objectForKey:KEY_VALID] boolValue]) {
                [confirmPasswordDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
                updatingCell.valueLabel.text = [confirmPasswordDetails objectForKey:KEY_LABEL];
            }
            BOOL isActive = [[confirmPasswordDetails objectForKey:KEY_ISACTIVE] boolValue];
            
            if(isActive) {
                [updatingCell.valueLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
            }
            else {
                [updatingCell.valueLabel setTextColor:[UIColor cellLabelTextColor]];
            }
        }
        else {
        }
    }
    
    [self validateSignUpButton];
}

- (void) validateSignUpButton {
    
    NSMutableDictionary *fNameDetails = [self.signUpDataSourceDictionary objectForKey:FIRST_NAME_DETAILS];
    NSMutableDictionary *lfNameDetails = [self.signUpDataSourceDictionary objectForKey:LAST_NAME_DETAILS];
    NSMutableDictionary *emailAddressDetails = [self.signUpDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
    NSMutableDictionary *passwordDetails = [self.signUpDataSourceDictionary objectForKey:PASSWORD_DETAILS];
    NSMutableDictionary *confirmpasswordDetails = [self.signUpDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS];

    NSString *fName = [fNameDetails objectForKey:KEY_VALUE];
    NSString *lName = [lfNameDetails objectForKey:KEY_VALUE];
    NSString *emailId = [emailAddressDetails objectForKey:KEY_VALUE];
    NSString *password = [passwordDetails objectForKey:KEY_VALUE];
    NSString *confirmpassword = [confirmpasswordDetails objectForKey:KEY_VALUE];

    STSignUpFooterView* footerView = (STSignUpFooterView *)self.tableView.tableFooterView;
    
    if((fName && (![fName isEqualToString:@""])) && (lName && (![lName isEqualToString:@""])) && (emailId && (![emailId isEqualToString:@""])) && (password && (![password isEqualToString:@""])) && (confirmpassword && (![confirmpassword isEqualToString:@""]))) {
        footerView.signUpButton.enabled = YES;
    }
    else {
        footerView.signUpButton.enabled = NO;
    }
}

- (BOOL) validate {
    
    BOOL isValid = NO;
    BOOL isFirstNameValid = NO;
    BOOL isLastNameValid = NO;
    BOOL isEmailValid = NO;
    BOOL isPasswordValid = NO;
    BOOL isConfirmPasswordValid = NO;

    NSMutableDictionary *fNameDetails = [self.signUpDataSourceDictionary objectForKey:FIRST_NAME_DETAILS];
    NSMutableDictionary *lfNameDetails = [self.signUpDataSourceDictionary objectForKey:LAST_NAME_DETAILS];
    NSMutableDictionary *emailAddressDetails = [self.signUpDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
    NSMutableDictionary *passwordDetails = [self.signUpDataSourceDictionary objectForKey:PASSWORD_DETAILS];
    NSMutableDictionary *confirmpasswordDetails = [self.signUpDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS];
   
    NSString *fName = [fNameDetails objectForKey:KEY_VALUE];
    NSString *lName = [lfNameDetails objectForKey:KEY_VALUE];
    NSString *emailId = [emailAddressDetails objectForKey:KEY_VALUE];
    NSString *password = [passwordDetails objectForKey:KEY_VALUE];
    NSString *confirmpassword = [confirmpasswordDetails objectForKey:KEY_VALUE];
    
    if(fName && (![fName isEqualToString:@""])) {
        isFirstNameValid = YES;
        [fNameDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
    }
    else {
        isFirstNameValid = NO;
        [fNameDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    }
    
    if(lName && (![lName isEqualToString:@""])) {
        isLastNameValid = YES;
        [lfNameDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
    }
    else{
        isLastNameValid = NO;
        [lfNameDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    }

    if(emailId && (![emailId isEqualToString:@""])) {
        if([emailId validateEmailAddress]) {
            isEmailValid = YES;
            [emailAddressDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
        }
        else {
            isEmailValid = NO;
            [emailAddressDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
        }
    }
    else {
        isEmailValid = NO;
        [emailAddressDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    }
    
    if(password && (![password isEqualToString:@""])) {
        
        if([password isValidPassword]) {
            isPasswordValid = YES;
            [passwordDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
        }
        else {
            isPasswordValid = NO;
            [passwordDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
        }
    }
    else {
        isPasswordValid = NO;
        [passwordDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    }
    
    if(confirmpassword && (![confirmpassword isEqualToString:@""])) {
        
        if([confirmpassword isValidPassword]) {
            isConfirmPasswordValid = YES;
            [confirmpasswordDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
        }
        else {
            isConfirmPasswordValid = NO;
            [confirmpasswordDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
        }
    }
    else {
        isConfirmPasswordValid = NO;
        [confirmpasswordDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    }
    
    if(isEmailValid && isPasswordValid && isConfirmPasswordValid && isFirstNameValid && isLastNameValid) {
        
        if([password isEqualToString:confirmpassword]) {
            isValid = YES;
        }
        else {
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Password Mismatch"
                                                  message:@"The passwords do not match, please re-enter and confirm."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else {
        
        NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
        
        if(!isFirstNameValid || !isLastNameValid) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        
        if(!isEmailValid) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
        }
        
        if(!isPasswordValid) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:2 inSection:0]];
        }
        
        if(!isConfirmPasswordValid) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:3 inSection:0]];
        }
        
        if([indexPathArray count] > 0) {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }
    
    return isValid;
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:PROFILE_SEGUE_ID]) {
        STProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.navigationItem.hidesBackButton = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.view removeGestureRecognizer:self.tapGesture];
    self.signUpDataSourceDictionary = nil;
}

@end
