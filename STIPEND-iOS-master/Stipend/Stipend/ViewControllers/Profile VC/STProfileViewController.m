//
//  STProfileViewController.m
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STProfileViewController.h"
#import "STProfileHeaderView.h"
#import "STProfileFooterView.h"
#import "STProfileCell.h"
#import "STAppDelegate.h"
#import "STPrivayPolicyViewController.h"
#import "STTabBarController.h"
#import "STPrivacyAndTermsViewController.h"

#define HEADER_VIEW_HEIGHT               30.0
#define ROW_HEIGHT                       50.0
#define SECTION_HEIGHT                   60.0
#define TOP_BARHEIGHT                    44.0

@interface STProfileViewController ()

@end

@implementation STProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Your Details";

    self.selectedUserType = eUserTypeNone;
    self.selectedGenderType = eGenderNone;
    
    self.profileDataSourceDictionary = [[NSMutableDictionary alloc] init];
    self.profileDataSourceDictionary = [self getProfileDataSource];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STProfileCell" bundle:nil] forCellReuseIdentifier:@"STProfileCell"];

    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureAction:)];
    [self.tapGesture setNumberOfTapsRequired:1];
    [self.tapGesture setNumberOfTouchesRequired:1];
    [self.tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:self.tapGesture];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self updateHeaderAndFooterView];
    
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(onSkipButtonAction:)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (IBAction)onSkipButtonAction:(id)sender {
    [self performFinishAnimation];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self validateFinishButton];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void) updateHeaderAndFooterView {
    
    STProfileHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"STProfileHeaderView" owner:self options:nil][0];
    headerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT);
    [headerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = headerView;
    
    STProfileFooterView* footerView = [[NSBundle mainBundle] loadNibNamed:@"STProfileFooterView" owner:self options:nil][0]; // getting desired view
    footerView.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 120.0);
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableFooterView = footerView;
    
    __weak STProfileViewController *weakSelf = self;//to break retain cycles..
    
    footerView.finishActionBlock = ^{
        [weakSelf onFinishButtonAction];
    };
    
    footerView.privacyActionBlock = ^{
        [weakSelf onPrivacyPolicyAction];
    };
}

- (void) onFinishButtonAction {
    
    if([self validate]) {
        
        NSString *genderTypeString = [[self.profileDataSourceDictionary objectForKey:GENDER_DETAILS] objectForKey:KEY_VALUE];
        NSString *userTypeString = [[self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS] objectForKey:KEY_VALUE];
        
        NSNumber *userType = [NSNumber numberWithInteger:userTypeIndex(userTypeString)];
        NSNumber *genderType = [NSNumber numberWithInteger:genderTypeIndex(genderTypeString)];

        NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:genderType,kGenderType,userType,kUserType, nil];
        
        if(![[STUserManager sharedManager] isGuestUser]) {
            [STProgressHUD show];
        }
        [[STNetworkAPIManager sharedManager] updateProfileWithDetails:details success:^(id response) {
            [self performFinishAnimation];
            if(![[STUserManager sharedManager] isGuestUser]) {
                [STProgressHUD dismiss];
            }
        } failure:^(NSError *error) {
            if(![[STUserManager sharedManager] isGuestUser]) {
                [STProgressHUD dismiss];

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

- (void) performFinishAnimation {
    
//    UIStoryboard *drawerMenuStoryboard = [UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil];
//    STDrawerBaseViewController *drawerBaseViewController = [drawerMenuStoryboard instantiateViewControllerWithIdentifier:@"DrawerBaseViewController"];
//    
//    UIView *overlayView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
//    [drawerBaseViewController.view addSubview:overlayView];
//    [[UIApplication sharedApplication] delegate].window.rootViewController = drawerBaseViewController;
//    
//    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        CGRect overlayFrame = overlayView.frame;
//        overlayFrame.origin.y += overlayFrame.size.height;
//        overlayView.frame = overlayFrame;
//    } completion:^(BOOL finished) {
//        overlayView.alpha = 0.0;
//        [overlayView removeFromSuperview];
//    }];
    
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

- (void) onPrivacyPolicyAction {
    
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
    UINavigationController *termsAndConditionsNavigationController = [[UINavigationController alloc] initWithRootViewController:webView];
    [self presentViewController:termsAndConditionsNavigationController animated:YES completion:nil];
}

- (void) onTapGestureAction:(UITapGestureRecognizer *) gestureRecognizer {
    [self.view endEditing:YES];
}

- (NSMutableDictionary *) getProfileDataSource {
    
    NSMutableDictionary *dataSourceDict = [NSMutableDictionary dictionary];
    
    NSMutableArray *userTypesArray = [NSMutableArray arrayWithArray:usersTypesArray];
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    
    NSInteger userType = 0;
    NSString *userTypeString = @"";
    
    NSInteger genderType = 0;
    NSString *genderTypeString = @"";

    if([[currentUser userType] integerValue] > 0) {
        userType = [[currentUser userType] integerValue];
        userTypeString = userTypeString(userType);
    }
    
    if([[currentUser genderType] integerValue]  > 0) {
        genderType = [[currentUser genderType] integerValue];
        genderTypeString = genderTypeString(genderType);
    }

    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"What type of user are you?",KEY_LABEL,userTypeString,KEY_VALUE,userTypesArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:USER_TYPE_DETAILS];
    
    NSMutableArray *genderArray = [NSMutableArray arrayWithArray:genderTypesArray];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Gender?",KEY_LABEL,genderTypeString,KEY_VALUE,genderArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_ISACTIVE, nil] forKey:GENDER_DETAILS];

    return dataSourceDict;
}

- (IBAction)onUserTypeButtonAction:(id)sender {
    
    NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
    BOOL userTypeExpanded = [[userDetailDict objectForKey:KEY_EXPAND] boolValue];
    [userDetailDict setObject:[NSNumber numberWithBool:!userTypeExpanded] forKey:KEY_EXPAND];
    [userDetailDict setObject:[NSNumber numberWithBool:!userTypeExpanded] forKey:KEY_ISACTIVE];

    if(!userTypeExpanded) {
        
        UIView *userTypeSeperatorView = [self.tableView viewWithTag:6666];
        CGRect seperatorFrame = userTypeSeperatorView.frame;
        seperatorFrame.size.height = 2.0;
        userTypeSeperatorView.frame = seperatorFrame;
        userTypeSeperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];

        NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];

        BOOL genderExpanded = [[genderDetailDict objectForKey:KEY_EXPAND] boolValue];
        NSInteger countOfRowsToInsert = [[userDetailDict objectForKey:KEY_VALUES_ARRAY] count];
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        if(genderExpanded) {
            
            UIView *genderSeperatorView = [self.tableView viewWithTag:7777];
            CGRect seperatorFrame = genderSeperatorView.frame;
            seperatorFrame.size.height = 1.0;
            genderSeperatorView.frame = seperatorFrame;
            genderSeperatorView.backgroundColor = [UIColor defaultCellUnderlineColor];

            [genderDetailDict setObject:[NSNumber numberWithBool:!genderExpanded] forKey:KEY_EXPAND];
            [genderDetailDict setObject:[NSNumber numberWithBool:NO] forKey:KEY_ISACTIVE];

            NSInteger countOfRowsToDelete = [[genderDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:1]];
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
        
        UIView *userTypeSeperatorView = [self.tableView viewWithTag:6666];
        CGRect seperatorFrame = userTypeSeperatorView.frame;
        seperatorFrame.size.height = 1.0;
        userTypeSeperatorView.frame = seperatorFrame;
        userTypeSeperatorView.backgroundColor = [UIColor defaultCellUnderlineColor];

        NSInteger countOfRowsToDelete = [[userDetailDict objectForKey:KEY_VALUES_ARRAY] count];
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (IBAction)onGenderTypeButtonAction:(id)sender {
    
    NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
    BOOL genderExpanded = [[genderDetailDict objectForKey:KEY_EXPAND] boolValue];
    [genderDetailDict setObject:[NSNumber numberWithBool:!genderExpanded] forKey:KEY_EXPAND];
    [genderDetailDict setObject:[NSNumber numberWithBool:!genderExpanded] forKey:KEY_ISACTIVE];

    if(!genderExpanded) {
        
        UIView *genderSeperatorView = [self.tableView viewWithTag:7777];
        CGRect seperatorFrame = genderSeperatorView.frame;
        seperatorFrame.size.height = 2.0;
        genderSeperatorView.frame = seperatorFrame;
        genderSeperatorView.backgroundColor = [UIColor highlightedCellUnderlineColor];
        
        NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
        BOOL userTypeExpanded = [[userDetailDict objectForKey:KEY_EXPAND] boolValue];
        
        NSInteger countOfRowsToInsert = [[genderDetailDict objectForKey:KEY_VALUES_ARRAY] count];
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:1]];
        }
        
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        if(userTypeExpanded) {
            
            UIView *userTypeSeperatorView = [self.tableView viewWithTag:6666];
            CGRect seperatorFrame = userTypeSeperatorView.frame;
            seperatorFrame.size.height = 1.0;
            userTypeSeperatorView.frame = seperatorFrame;
            userTypeSeperatorView.backgroundColor = [UIColor defaultCellUnderlineColor];

            [userDetailDict setObject:[NSNumber numberWithBool:NO] forKey:KEY_ISACTIVE];
            [userDetailDict setObject:[NSNumber numberWithBool:!userTypeExpanded] forKey:KEY_EXPAND];
            NSInteger countOfRowsToDelete = [[userDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
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
        
        UIView *genderSeperatorView = [self.tableView viewWithTag:7777];
        CGRect seperatorFrame = genderSeperatorView.frame;
        seperatorFrame.size.height = 1.0;
        genderSeperatorView.frame = seperatorFrame;
        genderSeperatorView.backgroundColor = [UIColor defaultCellUnderlineColor];

        NSInteger countOfRowsToDelete = [[genderDetailDict objectForKey:KEY_VALUES_ARRAY] count];
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:1]];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [[self.profileDataSourceDictionary allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if(section == 0) {
        
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
    else if(section == 1) {
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
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return SECTION_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, SECTION_HEIGHT)];
        baseView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 5.0, self.tableView.bounds.size.width - 40.0, 20.0)];
        titleLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:11.0];
        titleLabel.textColor = [UIColor placeHolderTextColor];

        UILabel *titleValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 30.0, self.tableView.bounds.size.width - 40.0, 30.0)];
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 60.0, self.tableView.bounds.size.width - 40.0, 1.0)];
        [seperatorView setBackgroundColor:[UIColor defaultCellUnderlineColor]];
        seperatorView.tag = 6666;
        
        UIButton *userTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [userTypeButton addTarget:self action:@selector(onUserTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [userTypeButton setTitle:@"" forState:UIControlStateNormal];
        userTypeButton.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, SECTION_HEIGHT);
        
        NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
        
        NSString *titleLabelString = [userDetailDict objectForKey:KEY_LABEL];
        titleLabel.text = [titleLabelString uppercaseString];
        
        NSString *titleString = @"";
        NSString *titleValue = [userDetailDict objectForKey:KEY_VALUE];

        if(titleValue && (![titleValue isEqualToString:@""])) {
            titleString = titleValue;
            [titleValueLabel setTextColor:[UIColor cellTextFieldTextColor]];
            titleValueLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:17.0];
            [titleLabel setHidden:NO];
        }
        else {
            titleString = [userDetailDict objectForKey:KEY_LABEL];
            [titleValueLabel setTextColor:[UIColor cellTextFieldTextColor]];
            titleValueLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:17.0];
            [titleLabel setHidden:YES];
        }
        
        titleValueLabel.text = titleString;
        
        [baseView addSubview:titleLabel];
        [baseView addSubview:titleValueLabel];
        [baseView addSubview:seperatorView];
        [baseView addSubview:userTypeButton];

        return baseView;
    }
    else if(section == 1) {
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, SECTION_HEIGHT)];
        baseView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 5.0, self.tableView.bounds.size.width - 40.0, 20.0)];
        titleLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:11.0];
        titleLabel.textColor = [UIColor placeHolderTextColor];
        
        UILabel *titleValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 30.0, self.tableView.bounds.size.width - 40.0, 30.0)];

        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 60.0, self.tableView.bounds.size.width - 40.0, 1.0)];
        [seperatorView setBackgroundColor:[UIColor defaultCellUnderlineColor]];
        seperatorView.tag = 7777;

        UIButton *genderTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [genderTypeButton addTarget:self action:@selector(onGenderTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [genderTypeButton setTitle:@"" forState:UIControlStateNormal];
        genderTypeButton.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, SECTION_HEIGHT);

        NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
        
        NSString *titleLabelString = [genderDetailDict objectForKey:KEY_LABEL];
        titleLabel.text = [titleLabelString uppercaseString];

        NSString *titleString = @"";
        NSString *titleValue = [genderDetailDict objectForKey:KEY_VALUE];
        
        if(titleValue && (![titleValue isEqualToString:@""])) {
            titleString = titleValue;
            [titleValueLabel setTextColor:[UIColor cellTextFieldTextColor]];
            titleValueLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:17.0];
            [titleLabel setHidden:NO];
        }
        else {
            titleString = [genderDetailDict objectForKey:KEY_LABEL];
            [titleValueLabel setTextColor:[UIColor cellTextFieldTextColor]];
            titleValueLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:17.0];
            [titleLabel setHidden:YES];
        }
        
        titleValueLabel.text = titleString;
        
        [baseView addSubview:titleLabel];
        [baseView addSubview:titleValueLabel];
        [baseView addSubview:seperatorView];
        [baseView addSubview:genderTypeButton];

        return baseView;
    }

    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STProfileCell" forIndexPath:indexPath];

    if(indexPath.section == 0) {

        NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
        NSMutableArray *typeArray = [userDetailDict objectForKey:KEY_VALUES_ARRAY];
        
        if(indexPath.row < [typeArray count]) {
            cell.labelField.text = [typeArray objectAtIndex:indexPath.row];
            cell.seperatorViewTrailingConstraint.constant = 0.0;
            cell.seperatorView.backgroundColor = [UIColor defaultCellUnderlineColor];

            NSString *title = [typeArray objectAtIndex:indexPath.row];
            NSString *value = [userDetailDict objectForKey:KEY_VALUE];

            if(value && (![value isEqualToString:@""])) {
                if([value isEqualToString:title]) {
                    cell.checkmarkView.hidden = NO;
                }
                else {
                    cell.checkmarkView.hidden = YES;
                }
            }
            else {
                cell.checkmarkView.hidden = YES;
            }
        }
    }
    else if(indexPath.section == 1) {
    
        NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
        NSMutableArray *typeArray = [genderDetailDict objectForKey:KEY_VALUES_ARRAY];
        
        if(indexPath.row < [typeArray count]) {
            cell.labelField.text = [typeArray objectAtIndex:indexPath.row];
            cell.seperatorViewTrailingConstraint.constant = 0.0;
            cell.seperatorView.backgroundColor = [UIColor defaultCellUnderlineColor];

            NSString *title = [typeArray objectAtIndex:indexPath.row];
            NSString *value = [genderDetailDict objectForKey:KEY_VALUE];
            
            if(value && (![value isEqualToString:@""])) {
                if([value isEqualToString:title]) {
                    cell.checkmarkView.hidden = NO;
                }
                else {
                    cell.checkmarkView.hidden = YES;
                }
            }
            else {
                cell.checkmarkView.hidden = YES;
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        
        if(indexPath.section == 0) {
            
            if(indexPath.row == 0) {
                self.selectedUserType = eUserTypeFreshmen;
            }
            else if (indexPath.row == 1) {
                self.selectedUserType = eUserTypeSophomore;
            }
            else if (indexPath.row == 2) {
                self.selectedUserType = eUserTypeJunior;
            }
            else if (indexPath.row == 3) {
                self.selectedUserType = eUserTypeSenior;
            }
            else if (indexPath.row == 4) {
                self.selectedUserType = eUserTypeParent;
            }
            else if (indexPath.row == 5) {
                self.selectedUserType = eUserTypeCounselor;
            }
            
            NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
            [userDetailDict setObject:userTypeString(self.selectedUserType) forKey:KEY_VALUE];
            [userDetailDict setObject:[NSNumber numberWithBool:NO] forKey:KEY_EXPAND];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        else if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                self.selectedGenderType = eGenderMale;
            }
            else if (indexPath.row == 1) {
                self.selectedGenderType = eGenderFemale;
            }
            
            NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
            [genderDetailDict setObject:genderTypeString(self.selectedGenderType) forKey:KEY_VALUE];
            [genderDetailDict setObject:[NSNumber numberWithBool:NO] forKey:KEY_EXPAND];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self validateFinishButton];
    }
    @catch (NSException *exception) {
        STLog(@"%@", exception);
    }
}

- (void) validateFinishButton {
    
    NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
    NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
    NSString *userType = [userDetailDict objectForKey:KEY_VALUE];
    NSString *gender = [genderDetailDict objectForKey:KEY_VALUE];
    
    STProfileFooterView* footerView = (STProfileFooterView *)self.tableView.tableFooterView;
    
    if(userType && (![userType isEqualToString:@""]) && gender && (![gender isEqualToString:@""])) {
        footerView.finishButton.enabled = YES;
    }
    else {
        footerView.finishButton.enabled = NO;
    }
}

- (BOOL) validate {
    
    BOOL isValid = NO;
    BOOL isUserTypeValid = NO;
    BOOL isGenderValid = NO;
    
    NSMutableDictionary *userDetailDict = [self.profileDataSourceDictionary objectForKey:USER_TYPE_DETAILS];
    NSMutableDictionary *genderDetailDict = [self.profileDataSourceDictionary objectForKey:GENDER_DETAILS];
    NSString *userType = [userDetailDict objectForKey:KEY_VALUE];
    NSString *gender = [genderDetailDict objectForKey:KEY_VALUE];
    
    if(userType && (![userType isEqualToString:@""])) {
            isUserTypeValid = YES;
            [userDetailDict setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
    }
    else {
        isUserTypeValid = NO;
        [userDetailDict setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    }
    
    if(gender && (![gender isEqualToString:@""])) {
        isGenderValid = YES;
        [genderDetailDict setObject:[NSNumber numberWithBool:YES] forKey:KEY_VALID];
    }
    else {
        isGenderValid = NO;
        [genderDetailDict setObject:[NSNumber numberWithBool:NO] forKey:KEY_VALID];
    }
    
    if(isUserTypeValid && isGenderValid) {
        isValid = YES;
    }
    else {
    }
    
    return isValid;
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
