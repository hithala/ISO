//
//  STForgotPasswordViewController.m
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STForgotPasswordViewController.h"
#import "STForgotPasswordFooterView.h"
#import "STForgotPasswordHeaderView.h"
#import "STLoginTextCell.h"

#define HEADER_VIEW_HEIGHT              220.0
#define ROW_HEIGHT                       70.0
#define TOP_BARHEIGHT                    44.0

@interface STForgotPasswordViewController ()

@end

@implementation STForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Forgot Password";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STLoginTextCell" bundle:nil] forCellReuseIdentifier:@"STLoginTextCell"];
    
    self.forgotPasswordDataSourceDictionary = [[NSMutableDictionary alloc] init];
    self.forgotPasswordDataSourceDictionary = [self getForgotPasswordDataSource];
    
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
    [self validateSendButton];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self updateResponderForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void) updateHeaderAndFooterView {
    
    STForgotPasswordHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"STForgotPasswordHeaderView" owner:self options:nil][0];
    headerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT);
    [headerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = headerView;
    
    CGFloat footerHeight = 0.0;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat cellHeight = (([[self.forgotPasswordDataSourceDictionary allKeys] count]) * ROW_HEIGHT);
    CGFloat headerHeight = HEADER_VIEW_HEIGHT;
    
    footerHeight = screenHeight - cellHeight - headerHeight - TOP_BARHEIGHT;
    
    STForgotPasswordFooterView* footerView = [[NSBundle mainBundle] loadNibNamed:@"STForgotPasswordFooterView" owner:self options:nil][0]; // getting desired view
    footerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, footerHeight);
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableFooterView = footerView;
    
    __weak STForgotPasswordViewController *weakSelf = self;//to break retain cycles..
    
    footerView.sendActionBlock = ^{
        [weakSelf onSendButtonAction];
    };
}

- (void) updateResponderForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    if(indexPath.row < ([[self.forgotPasswordDataSourceDictionary allKeys] count])) {
        STLoginTextCell *cell = (STLoginTextCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.valueField becomeFirstResponder];
    }
    else {
        [self.tableView endEditing:YES];
        [self onSendButtonAction];
    }
}

- (void) onSendButtonAction {
    
    if([self validate]) {
        
        NSString *emailID = [[self.forgotPasswordDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS] objectForKey:KEY_VALUE];
        NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:emailID,kEmailID, nil];
        
        [STProgressHUD show];
        [[STNetworkAPIManager sharedManager] forgotPasswordWithDetails:details success:^(id response) {
            [STProgressHUD dismiss];

            [self showAlertForEmailSent];
            
        } failure:^(NSError *error) {

            [STProgressHUD dismiss];

            if([error code] == 2000) {
                
                if([[error domain] isEqualToString:@"Email doesn't Exixts"]) {
                    
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Email Not Found"
                                                          message:@"The email address you entered is not registered with a CollegeHunch account. Please try again."
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
    else {
        
    }
}

- (void)showAlertForEmailSent {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Email Sent"
                                          message:@"Please check your email account and follow the instructions to reset your password."
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    __weak STForgotPasswordViewController *weakSelf = self;
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) onTapGestureAction:(UITapGestureRecognizer *) gestureRecognizer {
    [self.view endEditing:YES];
}

- (NSMutableDictionary *) getForgotPasswordDataSource {
    
    NSMutableDictionary *dataSourceDict = [NSMutableDictionary dictionary];
    
    if(self.emailAddress && (![self.emailAddress isEqualToString:@""])) {
        [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"EMAIL ADDRESS",KEY_LABEL,self.emailAddress,KEY_VALUE,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:EMAIL_ADDRESS_DETAILS];
    }
    else {
        [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"EMAIL ADDRESS",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:EMAIL_ADDRESS_DETAILS];
    }
    
    return dataSourceDict;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ([[self.forgotPasswordDataSourceDictionary allKeys] count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id contentCell = nil;
    __weak STForgotPasswordViewController *weakSelf = self;//to break retain cycles..
    
    if(indexPath.row == 0) { // Email Address
        
        STLoginTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STLoginTextCell" forIndexPath:indexPath];
        cell.astreikImageView.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSMutableDictionary *emailAddressDetails = [self.forgotPasswordDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
        
        cell.valueLabel.text = [emailAddressDetails objectForKey:KEY_LABEL];
        cell.valueField.text = [emailAddressDetails objectForKey:KEY_VALUE];
        cell.valueField.returnKeyType = UIReturnKeyDone;
        cell.valueField.keyboardType = UIKeyboardTypeEmailAddress;

        cell.valueField.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0];
        cell.valueLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:11.0];

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
        
        UIColor *placeHolderColor = [UIColor placeHolderTextColor];

        cell.valueField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[[emailAddressDetails objectForKey:KEY_LABEL] capitalizedString] attributes:@{NSForegroundColorAttributeName: placeHolderColor,
                                                                                                                                                                         NSFontAttributeName : [UIFont fontType:eFontTypeAvenirRoman FontForSize:18.0]}];
        
        cell.cellIndexPath = indexPath;
        
        cell.didUpdateCellActionBlock = ^(id cell) {
            [weakSelf didUpdateValueInCell:cell];
        };
        
        cell.didStartEditingActionBlock = ^(id cell) {
            
            STLoginTextCell *updatingCell = cell;
            NSIndexPath *curIndexPath = updatingCell.cellIndexPath;
            
            if(curIndexPath.row == 0) {
                NSMutableDictionary *emailAddressDetails = [self.forgotPasswordDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
                [emailAddressDetails setObject:[NSNumber numberWithBool:YES] forKey:KEY_ISACTIVE];
                [updatingCell.valueLabel setText:[emailAddressDetails objectForKey:KEY_LABEL]];
            }
            
            [updatingCell.valueLabel setTextColor:[UIColor highlightedCellUnderlineColor]];
            updatingCell.seperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
            updatingCell.seperatorHeightConstraint.constant = 2.0;
        };
        
        cell.didEndEditingActionBlock = ^(id cell) {
            
            STLoginTextCell *updatingCell = cell;
            NSIndexPath *curIndexPath = updatingCell.cellIndexPath;
            
            if(curIndexPath.row == 0) {
                NSMutableDictionary *emailAddressDetails = [self.forgotPasswordDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
                [emailAddressDetails setObject:[NSNumber numberWithBool:NO] forKey:KEY_ISACTIVE];
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

        contentCell = cell;
    }
    
    return contentCell;
}

- (void) didUpdateValueInCell:(id) cell {
    
    STLoginTextCell *updatingCell = cell;
    
    if(updatingCell.cellIndexPath.row == 0) {
        NSMutableDictionary *emailAddressDetails = [self.forgotPasswordDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
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
    else {
    }
    
    [self validateSendButton];
}

- (void) validateSendButton {
    
    NSMutableDictionary *emailAddressDetails = [self.forgotPasswordDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
    NSString *emailId = [emailAddressDetails objectForKey:KEY_VALUE];
    
    STForgotPasswordFooterView* footerView = (STForgotPasswordFooterView *)self.tableView.tableFooterView;
    
    if(emailId && (![emailId isEqualToString:@""])) {
        footerView.sendButton.enabled = YES;
    }
    else {
        footerView.sendButton.enabled = NO;
    }
}

- (BOOL) validate {
    
    BOOL isEmailValid = NO;
    
    NSMutableDictionary *emailAddressDetails = [self.forgotPasswordDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
    NSString *emailId = [emailAddressDetails objectForKey:KEY_VALUE];
    
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
    
    
    if(isEmailValid) {
        isEmailValid = YES;
    }
    else {
        
        NSArray *indexPathArray;
        
        if(!isEmailValid) {
            indexPathArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil];
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }
    
    return isEmailValid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.view removeGestureRecognizer:self.tapGesture];
    self.forgotPasswordDataSourceDictionary = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
