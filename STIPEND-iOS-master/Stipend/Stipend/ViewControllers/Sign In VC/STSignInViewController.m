//
//  STSignInViewController.m
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STSignInViewController.h"
#import "STSignUpViewController.h"
#import "STForgotPasswordViewController.h"
#import "STProfileViewController.h"
#import "STSignInFooterView.h"
#import "STLoginTextCell.h"
#import "STNetworkAPIManager+LoginAPI.h"
#import "STTabBarController.h"

#define HEADER_VIEW_HEIGHT              50.0
#define ROW_HEIGHT                      70.0
#define TOP_BARHEIGHT                   44.0

@interface STSignInViewController ()

@end

@implementation STSignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Sign In";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self.tableView registerNib:[UINib nibWithNibName:@"STLoginTextCell" bundle:nil] forCellReuseIdentifier:@"STLoginTextCell"];

    self.signInDataSourceDictionary = [[NSMutableDictionary alloc] init];
    self.signInDataSourceDictionary = [self getSignInDataSource];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureAction:)];
    [self.tapGesture setNumberOfTapsRequired:1];
    [self.tapGesture setNumberOfTouchesRequired:1];
    [self.tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:self.tapGesture];
    
    [self updateHeaderAndFooterView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
   
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([self isMovingToParentViewController])
    {
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        
        if([[navigationArray objectAtIndex:self.navigationController.viewControllers.count - 2] isKindOfClass:[STSignUpViewController class]])
        {
            [navigationArray removeObjectAtIndex:self.navigationController.viewControllers.count - 2];
            self.navigationController.viewControllers = navigationArray;
        }
    }

    [self validateSignInButton];
    self.navigationController.navigationBarHidden = NO;
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
    
    if(indexPath.row < ([[self.signInDataSourceDictionary allKeys] count])) {
        STLoginTextCell *cell = (STLoginTextCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.valueField becomeFirstResponder];
    }
    else {
        [self.tableView endEditing:YES];
        [self onSignInButtonAction];
    }
}

- (void) updateHeaderAndFooterView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = headerView;
    
    CGFloat footerHeight = 0.0;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat cellHeight = (([[self.signInDataSourceDictionary allKeys] count]) * ROW_HEIGHT);
    CGFloat headerHeight = HEADER_VIEW_HEIGHT;
    
    footerHeight = screenHeight - cellHeight - headerHeight - TOP_BARHEIGHT;
    
    STSignInFooterView* footerView = [[NSBundle mainBundle] loadNibNamed:@"STSignInFooterView" owner:self options:nil][0]; // getting desired view
    footerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, footerHeight);
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableFooterView = footerView;
    
    __weak STSignInViewController *weakSelf = self;//to break retain cycles..

    footerView.signInActionBlock = ^{
        [weakSelf onSignInButtonAction];
    };
    
    footerView.forgotPasswordActionBlock = ^{
        [weakSelf onForgotPasswordButtonAction];
    };
}

- (void) onSignInButtonAction {
    
    [self.view endEditing:YES];
    if([self validate]) {
        
        NSString *emailID = [[self.signInDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS] objectForKey:KEY_VALUE];
        NSString *password = [[self.signInDataSourceDictionary objectForKey:PASSWORD_DETAILS] objectForKey:KEY_VALUE];
        
        NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:emailID,kEmailID,password,kPassword, nil];
        
        [STProgressHUD show];
        [[STNetworkAPIManager sharedManager] loginUserWithDetails:details success:^(id response) {            
            [STProgressHUD dismiss];
            [self navigateToNextController];

        } failure:^(NSError *error) {
            [STProgressHUD dismiss];

            if([error code] == 2000) {
                
                if([[error domain] isEqualToString:@"Not valid EmailId and Password"]) {
                    
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Login Error"
                                                          message:@"You entered an invalid Email or Password. Please try again."
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
            else {

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
}

- (void) navigateToNextController {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:IS_NEW_USER];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self performFinishAnimation];
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

- (void) onForgotPasswordButtonAction {
    
    [self.view endEditing:YES];
    [self performSegueWithIdentifier:FORGOTPASSWORD_SEGUE_ID sender:self];
}

- (void) onTapGestureAction:(UITapGestureRecognizer *) gestureRecognizer {
    [self.view endEditing:YES];
}

- (NSMutableDictionary *) getSignInDataSource {
    
    NSMutableDictionary *dataSourceDict = [NSMutableDictionary dictionary];
    
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"EMAIL ADDRESS",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:EMAIL_ADDRESS_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"PASSWORD",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:PASSWORD_DETAILS];
    
    return dataSourceDict;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ([[self.signInDataSourceDictionary allKeys] count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STLoginTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STLoginTextCell" forIndexPath:indexPath];
    cell.astreikImageView.hidden = YES;
    
    __weak STSignInViewController *weakSelf = self;//to break retain cycles..

    cell.valueField.textColor = [UIColor cellTextFieldTextColor];
    cell.valueField.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0];
    cell.valueLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:11.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIColor *placeHolderColor = [UIColor placeHolderTextColor];

    if(indexPath.row == 0) { // Email Address
        
        NSMutableDictionary *emailAddressDetails = [self.signInDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
        
        cell.valueLabel.text = [emailAddressDetails objectForKey:KEY_LABEL];
        cell.valueField.text = [emailAddressDetails objectForKey:KEY_VALUE];
        cell.valueField.returnKeyType = UIReturnKeyNext;
        cell.valueField.keyboardType = UIKeyboardTypeEmailAddress;

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
    else if(indexPath.row == 1) { // Password
        
        NSMutableDictionary *passwordDetails = [self.signInDataSourceDictionary objectForKey:PASSWORD_DETAILS];
        
        cell.valueField.text = [passwordDetails objectForKey:KEY_VALUE];
        cell.valueField.returnKeyType = UIReturnKeyDone;
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
    
    cell.cellIndexPath = indexPath;
    
    cell.didUpdateCellActionBlock = ^(id cell) {
        [weakSelf didUpdateValueInCell:cell];
    };

    cell.didStartEditingActionBlock = ^(id cell) {
        
        STLoginTextCell *updatingCell = cell;
        NSIndexPath *curIndexPath = updatingCell.cellIndexPath;
        
        if(curIndexPath.row == 0) {
            NSMutableDictionary *emailAddressDetails = [self.signInDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
            [emailAddressDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_ISACTIVE];
            [updatingCell.valueLabel setText:[emailAddressDetails objectForKey:KEY_LABEL]];
        }
        else if(curIndexPath.row == 1) {
            
            NSMutableDictionary *passwordDetails = [self.signInDataSourceDictionary objectForKey:PASSWORD_DETAILS];
            [passwordDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_ISACTIVE];
            [updatingCell.valueLabel setText:[passwordDetails objectForKey:KEY_LABEL]];
        }
        
        [updatingCell.valueLabel setTextColor:[UIColor highlightedCellUnderlineColor]];

        updatingCell.seperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
        updatingCell.seperatorHeightConstraint.constant = 2.0;
    };

    cell.didEndEditingActionBlock = ^(id cell) {
        
        STLoginTextCell *updatingCell = cell;
        NSIndexPath *curIndexPath = updatingCell.cellIndexPath;
        
        if(curIndexPath.row == 0) {
            NSMutableDictionary *emailAddressDetails = [self.signInDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
            [emailAddressDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_ISACTIVE];
        }
        else if(curIndexPath.row == 1) {
            
            NSMutableDictionary *passwordDetails = [self.signInDataSourceDictionary objectForKey:PASSWORD_DETAILS];
            [passwordDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_ISACTIVE];
        }
        
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

    return cell;
}

- (void) didUpdateValueInCell:(id) cell {
    
    STLoginTextCell *updatingCell = cell;
    
    if(updatingCell.cellIndexPath.row == 0) {
        NSMutableDictionary *emailAddressDetails = [self.signInDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
        [emailAddressDetails setObject:updatingCell.valueField.text forKey:KEY_VALUE];
        
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
    else if(updatingCell.cellIndexPath.row == 1) {
                
        NSMutableDictionary *passwordDetails = [self.signInDataSourceDictionary objectForKey:PASSWORD_DETAILS];
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
    else {
    }
    
    [self validateSignInButton];
}

- (void) validateSignInButton {
    
    NSMutableDictionary *emailAddressDetails = [self.signInDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
    NSMutableDictionary *passwordDetails = [self.signInDataSourceDictionary objectForKey:PASSWORD_DETAILS];
    NSString *emailId = [emailAddressDetails objectForKey:KEY_VALUE];
    NSString *password = [passwordDetails objectForKey:KEY_VALUE];

    STSignInFooterView* footerView = (STSignInFooterView *)self.tableView.tableFooterView;

    if(emailId && (![emailId isEqualToString:@""]) && password && (![password isEqualToString:@""])) {
        footerView.signInButton.enabled = YES;
    }
    else {
        footerView.signInButton.enabled = NO;
    }
}

- (BOOL) validate {
    
    BOOL isValid = NO;
    BOOL isEmailValid = NO;
    BOOL isPasswordValid = NO;
    
    NSMutableDictionary *emailAddressDetails = [self.signInDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
    NSMutableDictionary *passwordDetails = [self.signInDataSourceDictionary objectForKey:PASSWORD_DETAILS];
    NSString *emailId = [emailAddressDetails objectForKey:KEY_VALUE];
    NSString *password = [passwordDetails objectForKey:KEY_VALUE];
    
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
        isPasswordValid = YES;
        [passwordDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
    }
    else {
        isPasswordValid = NO;
        [passwordDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    }

    if(isEmailValid && isPasswordValid) {
        isValid = YES;
    }
    else {
        
        NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
        
        if(!isEmailValid) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        
        if(!isPasswordValid) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
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

    if ([[segue identifier] isEqualToString:FORGOTPASSWORD_SEGUE_ID]) {

        STForgotPasswordViewController *forgotPasswordController = [segue destinationViewController];

        NSMutableDictionary *emailAddressDetails = [self.signInDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
        NSString *emailID = [emailAddressDetails objectForKey:KEY_VALUE];
        
        if(emailID && (![emailID isEqualToString:@""])) {
            [forgotPasswordController setEmailAddress:emailID];
        }
    }
    else if([[segue identifier] isEqualToString:PROFILE_SEGUE_ID]) {
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
    self.signInDataSourceDictionary = nil;
}

@end
