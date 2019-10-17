//
//  STMyDetailsViewController.m
//  Stipend
//
//  Created by Mahesh A on 12/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STMyDetailsViewController.h"

#import "STUserDetailsViewCell.h"
#import "STEditDetailsViewCell.h"
#import "STProfileCell.h"
#import "STProfileDetailsViewCell.h"
#import "STMyDetailsHeaderView.h"
#import "STMyDetailsFooterView.h"
#import "STPrivayPolicyViewController.h"
#import "STPrivacyAndTermsViewController.h"

#define HEADER_VIEW_HEIGHT              130.0
#define ROW_HEIGHT_EDIT_MODE_SECTION_0   50.0
#define ROW_HEIGHT_VIEW_MODE_SECTION_0   80.0
#define SECTION_HEIGHT                   50.0
#define TOP_BARHEIGHT                    44.0


@interface STMyDetailsViewController ()

@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, strong) NSString *selectedGenderTitle;
@property (nonatomic, strong) NSString *selectedUserTypeTitle;

@property (nonatomic, assign) BOOL isDetailsTypeSelected;

@end

@implementation STMyDetailsViewController

@synthesize leftBarButtonItem;
@synthesize rightBarButtonItem;
@synthesize selectedGenderTitle, selectedUserTypeTitle, isDetailsTypeSelected;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"My Details";
    
    isDetailsTypeSelected = NO;
    self.selectionMode = kViewMode;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

    leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];

    rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    rightBarButtonItem.title = @"Edit";
    rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.profileDataSourceDictionary = [[NSMutableDictionary alloc] init];
    self.profileDataSourceDictionary = [self getProfileDataSource];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureAction:)];
    [self.tapGesture setNumberOfTapsRequired:1];
    [self.tapGesture setNumberOfTouchesRequired:1];
    [self.tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:self.tapGesture];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STProfileCell" bundle:nil] forCellReuseIdentifier:@"STProfileCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STMyDetailsHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MyDetailsHeaderView"];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
}

- (void) onTapGestureAction:(UITapGestureRecognizer *) gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)leftBarButtonAction:(id)sender {
    self.selectionMode = kViewMode;
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = NO;

    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.title = @"Edit";
    
    self.profileDataSourceDictionary = [self getProfileDataSource];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:UITableViewRowAnimationFade];
    
    __weak STMyDetailsViewController *weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf setupFooterView];
    });
}

- (IBAction)rightBarButtonAction:(id)sender {
    
    if (self.selectionMode == kViewMode) {
        self.selectionMode = kEditMode;
        
        [self validateDoneBetton];
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.rightBarButtonItem.title = @"Save";
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:UITableViewRowAnimationFade];
        
        self.tableView.tableFooterView = nil;
        
    }
    else {
        
        [self.view endEditing:YES];
        [self updateUserProfile];
        [self setupFooterView];
    }
}

- (void) updateUserProfile {
    
    if ([self validate]){
        
        //Call API
        NSMutableDictionary *details = [NSMutableDictionary dictionary];
        
        NSString *genderTypeString = [[self.profileDataSourceDictionary objectForKey:GENDER_DETAILS] objectForKey:KEY_VALUE];
        NSString *userTypeString = [[self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS] objectForKey:KEY_VALUE];
        
        
        NSNumber *genderType = [NSNumber numberWithInteger:genderTypeIndex(genderTypeString)];
        NSNumber *userType = [NSNumber numberWithInteger:userTypeIndex(userTypeString)];
        
        NSString *newPasswordText =  [[self.profileDataSourceDictionary objectForKey:NEW_PASSWORD_DETAILS] objectForKey:KEY_VALUE];
        
        NSString *oldPasswordText =  [[self.profileDataSourceDictionary objectForKey:OLD_PASSWORD_DETAILS] objectForKey:KEY_VALUE];
        
        if (![genderTypeString isEqualToString:@"None"]){
            [details setObject:genderType forKey:kGenderType];
        }
        
        if (![userTypeString isEqualToString:@"None"]) {
            [details setObject:userType forKey:kUserType];
        }
        
        NSInteger loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] integerValue];
        
        if(loginType == eLoginTypeNormalUser) {
            
            if(oldPasswordText.length > 0) {
                [details setObject:oldPasswordText forKey:kOldPassword];
            }
            
            if(newPasswordText.length > 0) {
                [details setObject:newPasswordText forKey:kPassword];
            }
        }

        if(![[STUserManager sharedManager] isGuestUser]) {
            [STProgressHUD show];
        }
        
        [[STNetworkAPIManager sharedManager] updateProfileWithDetails:details success:^(id response) {
            self.navigationItem.rightBarButtonItem.title = @"Edit";
            
            if(![[STUserManager sharedManager] isGuestUser]) {
                [STProgressHUD dismiss];
            }
            
            [self performFinishAnimation];
            
        } failure:^(NSError *error) {
            if(![[STUserManager sharedManager] isGuestUser]) {
                [STProgressHUD dismiss];
                
                if([error code] == 2000) {
                    
                    if([[error domain] isEqualToString:@"Password doesn't match"]) {

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

                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"Network Error"
                                                          message:@"Cannot connect to Server. Please try again."
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        }];
    }
}

- (void)performFinishAnimation {
    
    self.selectionMode = kViewMode;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = NO;
    
    //Save and Reset the table view cell before reload the table view
    [[self.profileDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS] setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    [[self.profileDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS] setObject:@"" forKey:KEY_VALUE];
    [[self.profileDataSourceDictionary objectForKey:NEW_PASSWORD_DETAILS] setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    [[self.profileDataSourceDictionary objectForKey:NEW_PASSWORD_DETAILS] setObject:@"" forKey:KEY_VALUE];
    [[self.profileDataSourceDictionary objectForKey:OLD_PASSWORD_DETAILS] setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    [[self.profileDataSourceDictionary objectForKey:OLD_PASSWORD_DETAILS] setObject:@"" forKey:KEY_VALUE];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:UITableViewRowAnimationFade];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    //[self setupFooterView];
    
    __weak STMyDetailsViewController *weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf setupFooterView];
    });
}

- (NSMutableDictionary *) getProfileDataSource {
    
    NSMutableDictionary *dataSourceDict = [NSMutableDictionary dictionary];
    
    STUser *user = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:user.emailID,KEY_VALUE,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:EMAIL_ADDRESS_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",KEY_VALUE,[NSNumber numberWithBool:NO],KEY_VALID, nil] forKey:OLD_PASSWORD_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",KEY_VALUE,[NSNumber numberWithBool:NO],KEY_VALID, nil] forKey:CONFIRM_PASSWORD_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"",KEY_VALUE,[NSNumber numberWithBool:NO],KEY_VALID, nil] forKey:NEW_PASSWORD_DETAILS];
    
    NSMutableArray *userTypesArray = [NSMutableArray arrayWithArray:usersTypesArray];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"User",KEY_LABEL,userTypeString([user.userType integerValue]),KEY_VALUE,userTypesArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:USER_TYPE_DETAILS];//userTypeString([self.user.userType integerValue])
    
    NSMutableArray *genderArray = [NSMutableArray arrayWithArray:genderTypesArray];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Gender",KEY_LABEL,genderTypeString([user.genderType integerValue]),KEY_VALUE,genderArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:GENDER_DETAILS];
    
    return dataSourceDict;
}

/// Setup Footer view for privacy policy action

- (void) setupFooterView {
    
    STMyDetailsFooterView* footerView = [[NSBundle mainBundle] loadNibNamed:@"STMyDetailsFooterView" owner:self options:nil][0]; // getting desired view
    footerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width,50.0f);
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableFooterView = footerView;
    
    __weak STMyDetailsViewController *weakSelf = self;//to break retain cycles..
    
    footerView.privacyActionBlock = ^{
        [weakSelf onPrivacyPolicyAction];
    };
}

- (void) onPrivacyPolicyAction {
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
//
//    STPrivayPolicyViewController *privacyPolicyViewController = [storyboard instantiateViewControllerWithIdentifier:@"PrivayPolicyStoryboardID"];
//    privacyPolicyViewController.isFromIntroductionViewController = YES;
//
//    UINavigationController *privacyNavigationController = [[UINavigationController alloc] initWithRootViewController:privacyPolicyViewController];
//    [self presentViewController:privacyNavigationController animated:YES completion:nil];
    
    STPrivacyAndTermsViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STPrivacyAndTermsViewController"];
    webView.urlString = PRIVACY_POLICY_URL;
    webView.titleText = @"Privacy Policy";
    webView.isTermsOfUse = NO;
    UINavigationController *termsAndConditionsNavigationController = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:termsAndConditionsNavigationController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:{
            NSNumber *loginType = [[STUserManager sharedManager] loginType];
            if (self.selectionMode == kViewMode || [loginType integerValue])
                return 1;
            else
                return [self.profileDataSourceDictionary allKeys].count - 2;
        }
            break;
        case 1:{
            if (self.selectionMode == kViewMode)
                return 0;
            else {
                NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
                BOOL isExpanded = [[userDetailDict objectForKey:KEY_EXPAND] boolValue];
                if(isExpanded) {
                    NSMutableArray *valueArray = [userDetailDict objectForKey:KEY_VALUES_ARRAY];
                    return valueArray.count;
                }
                else {
                    return 0;
                }
            }
        }
            break;
        case 2:
            if (self.selectionMode == kViewMode)
                return 0;
            else {
                NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
                BOOL isExpanded = [[genderDetailDict objectForKey:KEY_EXPAND] boolValue];
                if(isExpanded) {
                    NSMutableArray *valueArray = [genderDetailDict objectForKey:KEY_VALUES_ARRAY];
                    return valueArray.count;
                }
                else {
                    return 0;
                }
            }
            break;
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    STMyDetailsHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MyDetailsHeaderView"];
    
    __weak STMyDetailsViewController *weakSelf = self;
    STUser *user = [[STUserManager sharedManager] getCurrentUserInDefaultContext];

    if(section == 1) {

        if (self.selectionMode == kViewMode) {
            headerView.ibLabelField.text = [[self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS] objectForKey:KEY_LABEL];
            if([user.userType isEqual:[NSNull null]]) {
                headerView.ibLabelValue.text = @"";
            } else {
                headerView.ibLabelValue.text =[[self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS] objectForKey:KEY_VALUE];
            }
        } else {
            headerView.ibLabelField.text = [[self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS] objectForKey:KEY_LABEL];
            if ([[[self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS] objectForKey:KEY_EXPAND] boolValue]) {
                headerView.ibLabelValue.hidden = YES;
            }else{
                headerView.ibLabelValue.hidden = NO;
                headerView.ibLabelValue.text =[[self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS] objectForKey:KEY_VALUE];
            }
        }
        headerView.headerViewButtonActionBlock = ^{
            if (weakSelf.selectionMode == kEditMode){
                [weakSelf headerViewButtonAction:section];
            }
        };
        return headerView;
    }else if(section == 2){
        
        if (self.selectionMode == kViewMode) {
            headerView.ibLabelField.text = [[self.profileDataSourceDictionary objectForKey:GENDER_DETAILS] objectForKey:KEY_LABEL];
            if([user.genderType isEqual:[NSNull null]]) {
                headerView.ibLabelValue.text = @"";
            } else {
                headerView.ibLabelValue.text =[[self.profileDataSourceDictionary objectForKey:GENDER_DETAILS] objectForKey:KEY_VALUE];
            }
        } else {
            headerView.ibLabelField.text = [[self.profileDataSourceDictionary objectForKey:GENDER_DETAILS] objectForKey:KEY_LABEL];
             if ([[[self.profileDataSourceDictionary objectForKey:GENDER_DETAILS] objectForKey:KEY_EXPAND] boolValue]) {
                 headerView.ibLabelValue.hidden = YES;
             }else{
                 headerView.ibLabelValue.hidden = NO;
                 headerView.ibLabelValue.text =[[self.profileDataSourceDictionary objectForKey:GENDER_DETAILS] objectForKey:KEY_VALUE];
             }
        }
        headerView.headerViewButtonActionBlock = ^{
            if (weakSelf.selectionMode == kEditMode){
                [weakSelf headerViewButtonAction:section];
            }
        };
        return headerView;
    }
    return nil;
}

- (void)headerViewButtonAction:(NSInteger)section {
    if (section == 1){
        NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
        BOOL userTypeExpanded = [[userDetailDict objectForKey:KEY_EXPAND] boolValue];
        [userDetailDict setObject:[NSNumber numberWithBool:!userTypeExpanded] forKey:KEY_EXPAND];
        
        if(!userTypeExpanded) {
            
            NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
            BOOL genderExpanded = [[genderDetailDict objectForKey:KEY_EXPAND] boolValue];
            
            NSInteger countOfRowsToInsert = [[userDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            if(genderExpanded) {
                [genderDetailDict setObject:[NSNumber numberWithBool:!genderExpanded] forKey:KEY_EXPAND];
                NSInteger countOfRowsToDelete = [[genderDetailDict objectForKey:KEY_VALUES_ARRAY] count];
                for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                    [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section + 1]];
                }
            }
            
            [self.tableView beginUpdates];
            if(genderExpanded) {
                [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            }
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        else {
            NSInteger countOfRowsToDelete = [[userDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            
        }

        
    }else if (section == 2){
        
        NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
        BOOL genderExpanded = [[genderDetailDict objectForKey:KEY_EXPAND] boolValue];
        [genderDetailDict setObject:[NSNumber numberWithBool:!genderExpanded] forKey:KEY_EXPAND];
        
        if(!genderExpanded) {
            
            NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
            BOOL userTypeExpanded = [[userDetailDict objectForKey:KEY_EXPAND] boolValue];
            
            NSInteger countOfRowsToInsert = [[genderDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            if(userTypeExpanded) {
                [userDetailDict setObject:[NSNumber numberWithBool:!userTypeExpanded] forKey:KEY_EXPAND];
                NSInteger countOfRowsToDelete = [[userDetailDict objectForKey:KEY_VALUES_ARRAY] count];
                for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                    [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section - 1]];
                }
            }
            
            
            [self.tableView beginUpdates];
            if(userTypeExpanded) {
                [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            }
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        else {
            NSInteger countOfRowsToDelete = [[genderDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id contentCell = nil;
    __weak STMyDetailsViewController *weakSelf = self;//to break retain cycles..
    switch (indexPath.section) {
        case 0: {
            NSNumber *loginType = [[STUserManager sharedManager] loginType];
            if (self.selectionMode == kViewMode || [loginType integerValue]) {
                STUserDetailsViewCell  *cell = (STUserDetailsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UserDetailsIdentifier" forIndexPath:indexPath];
                cell.ibOverlayView.hidden = YES;
                NSMutableDictionary *emailDetails = [self.profileDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];

                STUser *user = [[STUserManager sharedManager] getCurrentUserInDefaultContext];

                if([loginType integerValue] == eLoginTypeFacebook) {
                    cell.ibAvatarImageView.image = [UIImage imageNamed:@"connect_fb"];
                    cell.ibUserEmailLabelValue.text = @"Logged in via Facebook";
                    cell.ibUserProfileNameLabel.text = user.firstName;
                } else if ([loginType integerValue] == eLoginTypeTwitter) {
                    cell.ibAvatarImageView.image = [UIImage imageNamed:@"connect_tw"];
                    cell.ibUserEmailLabelValue.text = @"Logged in via Twitter";
                    cell.ibUserProfileNameLabel.text = user.firstName;
                } else if ([loginType integerValue] == eLoginTypeNormalUser){
                    cell.ibAvatarImageView.image = [UIImage imageNamed:@"profileIcon"];
                    cell.ibUserEmailLabelValue.text =[emailDetails objectForKey:KEY_VALUE];
                    cell.ibUserProfileNameLabel.text = [NSString stringWithFormat:@"%@ %@",user.firstName,user.lastName];
                } else{
                    cell.ibOverlayView.hidden = NO;
                }
                contentCell = cell;
            } else {
               STEditDetailsViewCell  *cell  = (STEditDetailsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EditUserDetailsCellIdentifier" forIndexPath:indexPath];
                cell.cellIndexPath = indexPath;
                
                if (indexPath.row == 0) {
                    [cell loadTextFieldType:eEmailField];
                    NSMutableDictionary *emailDetails = [self.profileDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS];
                    cell.ibContentTextField.text = [emailDetails objectForKey:KEY_VALUE];
                } else if (indexPath.row == 1) {//old password
                    [cell loadTextFieldType:eOldPasswordField];
                    NSMutableDictionary *passwordDetails = [self.profileDataSourceDictionary objectForKey:OLD_PASSWORD_DETAILS];
                    cell.ibContentTextField.text = [passwordDetails objectForKey:KEY_VALUE];
                } else if (indexPath.row == 2) {// New password
                    [cell loadTextFieldType:ePasswordField];
                    NSMutableDictionary *passwordDetails = [self.profileDataSourceDictionary objectForKey:NEW_PASSWORD_DETAILS];
                    cell.ibContentTextField.text = [passwordDetails objectForKey:KEY_VALUE];
                } else {
                    [cell loadTextFieldType:eConfirmPasswordField];
                    NSMutableDictionary *passwordDetails = [self.profileDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS];
                    cell.ibContentTextField.text = [passwordDetails objectForKey:KEY_VALUE];
                }
                
                cell.didUpdateCellActionBlock = ^(id cell) {
                    [weakSelf didUpdateValueInCell:cell];
                };
                
                cell.didClickReturnActionBlock = ^(id cell) {
                    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
                    [weakSelf updateResponderForRowAtIndexPath:nextIndexPath];
                };
                contentCell = cell;
            }
        }
            break;
        case 1:{

            STProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STProfileCell" forIndexPath:indexPath];
            
            NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
            NSMutableArray *typeArray = [userDetailDict objectForKey:KEY_VALUES_ARRAY];
            
            if(indexPath.row < [typeArray count]) {
                cell.labelField.text = [typeArray objectAtIndex:indexPath.row];
                cell.seperatorViewTrailingConstraint.constant = -8.0;
                cell.seperatorView.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:0.50];

                NSString *title = [typeArray objectAtIndex:indexPath.row];
                
                NSString *value = [userDetailDict objectForKey:KEY_VALUE];
                
                if(value && (![value isEqualToString:@""])) {
                    if([value isEqualToString:title]) {
                        cell.checkmarkView.hidden = NO;
                        selectedUserTypeTitle = value;
                    }
                    else {
                        cell.checkmarkView.hidden = YES;
                    }
                }
                else {
                    cell.checkmarkView.hidden = YES;
                }
            }
            contentCell = cell;
        }
            break;
        case 2:{

            STProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STProfileCell" forIndexPath:indexPath];
            
            NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
            NSMutableArray *typeArray = [genderDetailDict objectForKey:KEY_VALUES_ARRAY];
            
            if(indexPath.row < [typeArray count]) {
                cell.labelField.text = [typeArray objectAtIndex:indexPath.row];
                cell.seperatorViewTrailingConstraint.constant = -8.0;
                cell.seperatorView.backgroundColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:0.50];

                NSString *title = [typeArray objectAtIndex:indexPath.row];
                NSString *value = [genderDetailDict objectForKey:KEY_VALUE];
                
                if(value && (![value isEqualToString:@""])) {
                    if([value isEqualToString:title]) {
                        cell.checkmarkView.hidden = NO;
                        selectedGenderTitle = value;
                    }
                    else {
                        cell.checkmarkView.hidden = YES;
                    }
                }
                else {
                    cell.checkmarkView.hidden = YES;
                }
            }
            contentCell = cell;
        }
            break;
        default:
            break;
    }
    return contentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
        return 20;
    
    return SECTION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            NSNumber *loginType = [[STUserManager sharedManager] loginType];
            
            if (self.selectionMode == kViewMode || [loginType integerValue] ) {
                return ROW_HEIGHT_VIEW_MODE_SECTION_0;
            }else {
                return ROW_HEIGHT_EDIT_MODE_SECTION_0;
            }
        }
            break;
            
        default:
            break;
    }
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STProfileCell *cell = (STProfileCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    @try {
        
        if (indexPath.section == 2) {
            if (cell.checkmarkView.hidden){
                [[self.profileDataSourceDictionary objectForKey:GENDER_DETAILS] setObject:cell.labelField.text forKey:KEY_VALUE];
                [[self.profileDataSourceDictionary objectForKey:GENDER_DETAILS] setObject:[NSNumber numberWithBool:NO] forKey:KEY_EXPAND];
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            }
        } else if (indexPath.section == 1){
            NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
            [userDetailDict setObject:cell.labelField.text forKey:KEY_VALUE];
            [userDetailDict setObject:[NSNumber numberWithBool:NO] forKey:KEY_EXPAND];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self validateDoneBetton];
    }
    @catch (NSException *exception) {
        STLog(@"%@", exception);
    }
}

#pragma mark EditUserDetails
- (void) didUpdateValueInCell:(id) cell {
    
    STEditDetailsViewCell *contentCell = (STEditDetailsViewCell *)cell;
    NSString *text = contentCell.ibContentTextField.text;

    switch (contentCell.type) {
        case eEmailField:{
            if (text.length) {
                [[self.profileDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS] setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
            }else{
                [[self.profileDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS] setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
            }
            [[self.profileDataSourceDictionary objectForKey:EMAIL_ADDRESS_DETAILS] setObject:text forKey:KEY_VALUE];
        }
            break;
        case eOldPasswordField:{
            if (text.length) {
                [[self.profileDataSourceDictionary objectForKey:OLD_PASSWORD_DETAILS] setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
            }else{
               [[self.profileDataSourceDictionary objectForKey:OLD_PASSWORD_DETAILS] setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
            }
            [[self.profileDataSourceDictionary objectForKey:OLD_PASSWORD_DETAILS] setObject:text forKey:KEY_VALUE];
        }
            break;
        case ePasswordField:{
            if (text.length) {
                [[self.profileDataSourceDictionary objectForKey:NEW_PASSWORD_DETAILS] setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
            }else{
                [[self.profileDataSourceDictionary objectForKey:NEW_PASSWORD_DETAILS] setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
            }
            [[self.profileDataSourceDictionary objectForKey:NEW_PASSWORD_DETAILS] setObject:text forKey:KEY_VALUE];
        }
            break;
        case eConfirmPasswordField:{
            if (text.length) {
                [[self.profileDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS] setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
            }else{
                [[self.profileDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS] setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
            }
            [[self.profileDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS] setObject:text forKey:KEY_VALUE];
        }
            break;
        default:
            break;
    }
    
    [self validateDoneBetton];
}

- (void) updateResponderForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    if(indexPath.row < (([[self.profileDataSourceDictionary allKeys] count] - 2))) {
        
        STEditDetailsViewCell *cell = (STEditDetailsViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.ibContentTextField becomeFirstResponder];
    }
    else {
        [self.tableView endEditing:YES];
    }
}

- (void) validateDoneBetton {
    
    if(self.selectionMode == kEditMode) {
        
        NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
        NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
        
        NSString *userType = [userDetailDict objectForKey:KEY_VALUE];
        NSString *gender = [genderDetailDict objectForKey:KEY_VALUE];
        
        STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
        NSString *oldGenderType = genderTypeString([[currentUser genderType] integerValue]);
        NSString *oldUserType = userTypeString([[currentUser userType] integerValue]);;
        
        BOOL isValid = NO;
        
        if(([userType isEqualToString:oldUserType]) && ([gender isEqualToString:oldGenderType])) {
            isValid = NO;
        }
        else {
            isValid = YES;
        }
        
        if(!isValid) {
            
            NSInteger loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] integerValue];
            
            if(loginType == eLoginTypeNormalUser) {
                NSMutableDictionary *oldPasswordDetails = [self.profileDataSourceDictionary objectForKey:OLD_PASSWORD_DETAILS];
                NSMutableDictionary *newPasswordDetails = [self.profileDataSourceDictionary objectForKey:NEW_PASSWORD_DETAILS];
                NSMutableDictionary *confirmPasswordDetails = [self.profileDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS];
                
                NSString *oldPassword = [oldPasswordDetails objectForKey:KEY_VALUE];
                NSString *newPassword = [newPasswordDetails objectForKey:KEY_VALUE];
                NSString *confirmPassword = [confirmPasswordDetails objectForKey:KEY_VALUE];
                
                if((oldPassword && (![oldPassword isEqualToString:@""])) || (newPassword && (![newPassword isEqualToString:@""])) || (confirmPassword && (![confirmPassword isEqualToString:@""]))) {
                    
                    isValid = YES;
                }
            }
        }


        if(isValid) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        
        [self.navigationController.navigationBar setNeedsDisplay];
    }
}

- (BOOL) validate {
    
    if(self.selectionMode == kEditMode) {
        
        NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
        NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
        
        NSString *userType = [userDetailDict objectForKey:KEY_VALUE];
        NSString *gender = [genderDetailDict objectForKey:KEY_VALUE];
        
        STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
        NSString *oldGenderType = genderTypeString([[currentUser genderType] integerValue]);
        NSString *oldUserType = userTypeString([[currentUser userType] integerValue]);;
        
        BOOL isValid = NO;
        
        if(([userType isEqualToString:oldUserType]) && ([gender isEqualToString:oldGenderType])) {
            isValid = NO;
        }
        else {
            isValid = YES;
        }
        
       // if(!isValid) {
            
            NSInteger loginType = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_TYPE] integerValue];
            
            if(loginType == eLoginTypeNormalUser) {
                
                NSMutableDictionary *oldPasswordDetails = [self.profileDataSourceDictionary objectForKey:OLD_PASSWORD_DETAILS];
                NSMutableDictionary *newPasswordDetails = [self.profileDataSourceDictionary objectForKey:NEW_PASSWORD_DETAILS];
                NSMutableDictionary *confirmPasswordDetails = [self.profileDataSourceDictionary objectForKey:CONFIRM_PASSWORD_DETAILS];
                
                NSString *oldPassword = [oldPasswordDetails objectForKey:KEY_VALUE];
                NSString *newPassword = [newPasswordDetails objectForKey:KEY_VALUE];
                NSString *confirmPassword = [confirmPasswordDetails objectForKey:KEY_VALUE];
                
                if((oldPassword && ([oldPassword isEqualToString:@""])) && (newPassword && ([newPassword isEqualToString:@""])) && (confirmPassword && ([confirmPassword isEqualToString:@""]))) {
                    
                    isValid = YES;
                }
                else {
                    
                    if((![newPassword isValidPassword]) && (![confirmPassword isValidPassword])) {
                        isValid = NO;
                        
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"Password Error"
                                                              message:@"The passwords must be at least six characters and atleast one number."
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    else if(![newPassword isEqualToString:confirmPassword]) {
                        isValid = NO;
                        
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@"Password Mismatch"
                                                              message:@"The passwords do not match, please re-enter and confirm.."
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:okAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    else {
                        isValid = YES;
                    }
                }
            }
        //}
        
        return isValid;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.view removeGestureRecognizer:self.tapGesture];
    self.profileDataSourceDictionary = nil;
}

@end
