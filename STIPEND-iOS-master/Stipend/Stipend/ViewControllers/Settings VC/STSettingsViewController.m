//
//  STSettingsViewController.m
//  Stipend
//
//  Created by Mahesh A on 07/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//
@import StoreKit;

#import "STSettingsViewController.h"
#import "STIntroductionViewController.h"
#import "STSettingsDefaultCell.h"
#import "STSettingsOptionsCell.h"
#import "STSettingsSwitchCell.h"
#import "STLogoutCell.h"
#import "STUser.h"

#import "STSettingsExpandHeaderView.h"
#import "STSettingsDetailDisclosureHeaderView.h"
#import "STMapViewController.h"

#import "STTabBarController.h"
#import "STWebViewController.h"
#import "STPrivacyAndTermsViewController.h"

#define HEADER_VIEW_HEIGHT              25.0
#define FOOTER_VIEW_HEIGHT              25.0
#define ROW_HEIGHT                      50.0
#define SECTION_HEIGHT                  50.0

@interface STSettingsViewController ()<UITableViewDataSource>

@end

@implementation STSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    self.title = @"More";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.settingsDataSourceDictionary = [[NSMutableArray alloc] init];
//    self.settingsDataSourceDictionary = [self settingsDatasource];

    // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButtonAction:)];

    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

    [self.tableView registerNib:[UINib nibWithNibName:@"STSettingsDefaultCell" bundle:nil] forCellReuseIdentifier:@"STSettingsDefaultCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"STSettingsOptionsCell" bundle:nil] forCellReuseIdentifier:@"STSettingsOptionsCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"STSettingsSwitchCell" bundle:nil] forCellReuseIdentifier:@"STSettingsSwitchCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"STLogoutCell" bundle:nil] forCellReuseIdentifier:@"STLogoutCell"];

    [self updateHeaderAndFooterView];

}

- (void) updateHeaderAndFooterView {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT)];
    self.tableView.tableHeaderView = headerView;

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, FOOTER_VIEW_HEIGHT)];
    self.tableView.tableFooterView = footerView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.settingsDataSourceDictionary = [self settingsDatasource];
    [self.tableView reloadData];
}

// Left bar button item action
- (void)onMenuButtonAction:(id)sender {

    CGRect viewRect = self.view.frame;
    viewRect.size.width = (self.view.frame.size.width * 0.75);

    UIGraphicsBeginImageContext(viewRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.navigationController.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self.delegate capturedImage:image];
    [self.delegate showMenu];
}

- (NSMutableArray *) settingsDatasource {

    NSMutableArray *dataSourceDict = [NSMutableArray array];

    // My Details
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"My Details",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:NO],KEY_EXPAND, nil]];

    // Sort Type Details
    /* NSMutableArray *sortTypesArray = [NSMutableArray arrayWithObjects:@"Alphabetically",@"No. of Freshmen",@"Average GPA",@"Average SAT score",@"Average ACT Composite",@"Acceptance Rate",@"Distance", nil];

     NSInteger sortType = [[[[STUserManager sharedManager] getCurrentUserInDefaultContext] sortOrder] integerValue];
     NSString *sortString = sortTypeString(sortType);

     [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Sort Colleges",KEY_LABEL,sortString,KEY_VALUE,sortTypesArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND, nil]];
     */

    // User’s Default Map Details
    NSMutableArray *mapAppTypesArray = [NSMutableArray arrayWithObjects:@"Apple Maps",@"Google Maps",@"Always Ask", nil];

    NSInteger mapAppType = [[[[STUserManager sharedManager] getCurrentUserInDefaultContext] defaultMapAppType] integerValue];
    NSString *mapAppString = mapAppTypeString(mapAppType);

    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Default Map App",KEY_LABEL,mapAppString,KEY_VALUE,mapAppTypesArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND, nil]];

    // Map Details
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Map",KEY_LABEL,@"",KEY_VALUE, nil]];

    // Attribution Details
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Attribution",KEY_LABEL,@"",KEY_VALUE, nil]];

    // About CollegeHunch Details
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"About CollegeHunch",KEY_LABEL,@"",KEY_VALUE, nil]];

    // Terms of Use Details
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Terms of Use",KEY_LABEL,@"",KEY_VALUE, nil]];

    // Privacy Policy Details
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Privacy Policy",KEY_LABEL,@"",KEY_VALUE, nil]];

    // Rate the App Details
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Rate the App",KEY_LABEL,@"",KEY_VALUE, nil]];

    // Support Details
    [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Support",KEY_LABEL,@"",KEY_VALUE, nil]];

    // Log In / Log Out details
    if([[STUserManager sharedManager] isGuestUser]) {
        [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Login",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:NO],KEY_EXPAND, nil]];
    } else {
        [dataSourceDict addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Logout",KEY_LABEL,@"",KEY_VALUE,[NSNumber numberWithBool:NO],KEY_EXPAND, nil]];
    }

    return dataSourceDict;
}

- (void)onSortTypeAction {

    NSMutableDictionary *sortDetailDict = [self.settingsDataSourceDictionary objectAtIndex:1];

    BOOL isExpanded = [[sortDetailDict objectForKey:KEY_EXPAND] boolValue];

    [sortDetailDict setObject:[NSNumber numberWithBool:!isExpanded] forKey:KEY_EXPAND];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)onMapAppTypeAction {

    NSMutableDictionary *sortDetailDict = [self.settingsDataSourceDictionary objectAtIndex:1];

    BOOL isExpanded = [[sortDetailDict objectForKey:KEY_EXPAND] boolValue];

    [sortDetailDict setObject:[NSNumber numberWithBool:!isExpanded] forKey:KEY_EXPAND];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark UITableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.settingsDataSourceDictionary count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SECTION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if(section == 0 || section == 2 || section == 8) {
        return FOOTER_VIEW_HEIGHT;
    } else {
        return 1.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    NSDictionary *detailDict = [self.settingsDataSourceDictionary objectAtIndex:section];

    STLog(@"%@", [detailDict objectForKey:KEY_LABEL]);

    if(section == 1 || section == 2){

        STSettingsExpandHeaderView *expandView = [[NSBundle mainBundle] loadNibNamed:@"STSettingsExpandHeaderView" owner:self options:nil][0];

        expandView.titleLabel.text = [detailDict objectForKey:KEY_LABEL];
        expandView.valueLabel.text = [detailDict objectForKey:KEY_VALUE];
        expandView.tag = section;

        __weak STSettingsViewController *weakSelf = self;

        expandView.clickActionBlock = ^(NSInteger tag) {
            [weakSelf onSectionTapAction:tag];
        };

        return expandView;
    } else if (section == 9) {

        //STLogoutCell

        STSettingsDetailDisclosureHeaderView *detailDisclosureView = [[NSBundle mainBundle] loadNibNamed:@"STSettingsDetailDisclosureHeaderView" owner:self options:nil][0];

        detailDisclosureView.titleLabel.text = [detailDict objectForKey:KEY_LABEL];
        detailDisclosureView.titleLabel.textAlignment = NSTextAlignmentCenter;
        detailDisclosureView.titleLabel.textColor = [UIColor colorWithRed:240.0f/255.0f green:60.0f/255.0f blue:60.0f/255.0f alpha:1.0];
        detailDisclosureView.disclosureIcon.hidden = YES;
        detailDisclosureView.tag = section;

        __weak STSettingsViewController *weakSelf = self;

        detailDisclosureView.clickActionBlock = ^(NSInteger tag) {
            [weakSelf onSectionTapAction:tag];
        };

        return detailDisclosureView;

    } else {

        STSettingsDetailDisclosureHeaderView *detailDisclosureView = [[NSBundle mainBundle] loadNibNamed:@"STSettingsDetailDisclosureHeaderView" owner:self options:nil][0];

        detailDisclosureView.titleLabel.text = [detailDict objectForKey:KEY_LABEL];
        detailDisclosureView.titleLabel.textAlignment = NSTextAlignmentLeft;
        detailDisclosureView.titleLabel.textColor = [UIColor blackColor];
        detailDisclosureView.disclosureIcon.hidden = NO;
        detailDisclosureView.tag = section;

        __weak STSettingsViewController *weakSelf = self;

        detailDisclosureView.clickActionBlock = ^(NSInteger tag) {
            [weakSelf onSectionTapAction:tag];
        };

        return detailDisclosureView;
    }
}

- (void)onSectionTapAction:(NSInteger)section {

    NSDictionary *detailDict = [self.settingsDataSourceDictionary objectAtIndex:section];

    NSString *sectionName = [detailDict objectForKey:KEY_LABEL];

    if([sectionName isEqualToString:@"My Details"]) {

        if(STUserManager.sharedManager.isGuestUser) {
            [self showLoginController];
            return;
        }
        
        STMyDetailsViewController *myDetailsVC = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateViewControllerWithIdentifier:@"STMyDetailsViewController"];
        [self.navigationController pushViewController:myDetailsVC animated:YES];

    } else if ([sectionName isEqualToString:@"Sort Colleges"]){

        [self onSortTypeAction];

    } else if ([sectionName isEqualToString:@"Default Map App"]){

        [self onMapAppTypeAction];

    } else if ([sectionName isEqualToString:@"Map"]){

        STMapViewController *mapView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:mapView animated:YES];

    } else if ([sectionName isEqualToString:@"Attribution"]){

        STDataDefinitionsViewController *dataDefinitionVC = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateViewControllerWithIdentifier:@"STDataDefinitionsViewController"];
        [self.navigationController pushViewController:dataDefinitionVC animated:YES];

    } else if ([sectionName isEqualToString:@"About CollegeHunch"]){

        STAboutStipendViewController *aboutVC = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateViewControllerWithIdentifier:@"STAboutStipendViewController"];
        [self.navigationController pushViewController:aboutVC animated:YES];

    } else if ([sectionName isEqualToString:@"Terms of Use"]){

//        STTermsAndConditionsViewController *termsVC = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateViewControllerWithIdentifier:@"TermsAndConditionsStoryBoardID"];
//        [self.navigationController pushViewController:termsVC animated:YES];
        
        STPrivacyAndTermsViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STPrivacyAndTermsViewController"];
        webView.urlString = TERMS_OF_USE_URL;
        webView.titleText = @"Terms of Use";
        webView.isTermsOfUse = YES;
        [self.navigationController pushViewController:webView animated:YES];

    } else if ([sectionName isEqualToString:@"Privacy Policy"]){

//        STPrivayPolicyViewController *privacyVC = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateViewControllerWithIdentifier:@"PrivayPolicyStoryboardID"];
//        [self.navigationController pushViewController:privacyVC animated:YES];
        
//        STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
//        webView.urlString = PRIVACY_POLICY_URL;
//        webView.titleText = @"Privacy Policy";
//        [self.navigationController pushViewController:webView animated:YES];
        
        STPrivacyAndTermsViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STPrivacyAndTermsViewController"];
        webView.urlString = PRIVACY_POLICY_URL;
        webView.titleText = @"Privacy Policy";
        webView.isTermsOfUse = NO;
        [self.navigationController pushViewController:webView animated:YES];

    } else if ([sectionName isEqualToString:@"Rate the App"]){

        [self rateApp];

    } else if ([sectionName isEqualToString:@"Support"]){

        [self openFeedbackComposer];

    } else if ([sectionName isEqualToString:@"Logout"]){

        NSString *title = @"";
        NSString *titleText = @"";

        if ([[STUserManager sharedManager] isGuestUser]) {
            title = @"Are you sure you want to Reset the App? Your Favorites, Clippings and colleges in Compare will be lost and you will be taken back to the welcome screen";
            titleText = @"Reset App";
        }
        else {
            title = @"Are you sure you want to Logout?";
            titleText = @"Logout";
        }
        
        __weak STSettingsViewController *weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:title
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            alertController = [UIAlertController alertControllerWithTitle:@""
                                                                  message:title
                                                           preferredStyle:UIAlertControllerStyleAlert];
        }

        [alertController addAction:[UIAlertAction actionWithTitle:titleText style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf logoutAction];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];

    } else if ([sectionName isEqualToString:@"Login"]){
        [self showLoginController];
    }
}

- (void)showLoginController {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    STIntroductionViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"IntroductionViewController"];
    viewController.hasSkippedLogin = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:LOGIN_SCREEN_PRESENTED];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(section == 1) {

        NSMutableDictionary *settingsDict = [self.settingsDataSourceDictionary objectAtIndex:section];
        BOOL isExpanded = [[settingsDict objectForKey:KEY_EXPAND] boolValue];
        if(isExpanded) {
            NSMutableArray *valueArray = [settingsDict objectForKey:KEY_VALUES_ARRAY];
            return valueArray.count;
        }
        else {
            return 0;
        }
    } else if (section == 2) {

        NSMutableDictionary *settingsDict = [self.settingsDataSourceDictionary objectAtIndex:section];
        BOOL isExpanded = [[settingsDict objectForKey:KEY_EXPAND] boolValue];
        if(isExpanded) {
            NSMutableArray *valueArray = [settingsDict objectForKey:KEY_VALUES_ARRAY];
            return valueArray.count;
        }
        else {
            return 0;
        }
    }

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;

    if(indexPath.section == 1) {

        STSettingsOptionsCell *contentCell = (STSettingsOptionsCell *)[tableView dequeueReusableCellWithIdentifier:@"STSettingsOptionsCell"];

        NSMutableDictionary *sortDetailsDict = [self.settingsDataSourceDictionary objectAtIndex:indexPath.section];

        NSMutableArray *sortValuesArray = [sortDetailsDict objectForKey:KEY_VALUES_ARRAY];

        if(indexPath.row < [sortValuesArray count]) {
            contentCell.titleLabel.text = [sortValuesArray objectAtIndex:indexPath.row];

            NSString *title = [sortValuesArray objectAtIndex:indexPath.row];
            NSString *value = [sortDetailsDict objectForKey:KEY_VALUE];

            if(value && (![value isEqualToString:@""])) {
                if([value isEqualToString:title]) {
                    contentCell.checkMarkImageView.hidden = NO;
                }
                else {
                    contentCell.checkMarkImageView.hidden = YES;
                }
            }
            else {
                contentCell.checkMarkImageView.hidden = YES;
            }
        }

        contentCell.accessoryType = UITableViewCellAccessoryNone;
        cell = contentCell;

    } else if (indexPath.section == 2) {

        STSettingsOptionsCell *contentCell = (STSettingsOptionsCell *)[tableView dequeueReusableCellWithIdentifier:@"STSettingsOptionsCell"];

        NSMutableDictionary *sortDetailsDict = [self.settingsDataSourceDictionary objectAtIndex:indexPath.section];

        NSMutableArray *sortValuesArray = [sortDetailsDict objectForKey:KEY_VALUES_ARRAY];

        if(indexPath.row < [sortValuesArray count]) {
            contentCell.titleLabel.text = [sortValuesArray objectAtIndex:indexPath.row];

            NSString *title = [sortValuesArray objectAtIndex:indexPath.row];
            NSString *value = [sortDetailsDict objectForKey:KEY_VALUE];

            if(value && (![value isEqualToString:@""])) {
                if([value isEqualToString:title]) {
                    contentCell.checkMarkImageView.hidden = NO;
                }
                else {
                    contentCell.checkMarkImageView.hidden = YES;
                }
            }
            else {
                contentCell.checkMarkImageView.hidden = YES;
            }
        }

        contentCell.accessoryType = UITableViewCellAccessoryNone;
        cell = contentCell;

    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {

        if(indexPath.row == 0) {
            self.mapAppType = eMapAppTypeAppleMaps;
        }
        else if (indexPath.row == 1) {
            self.mapAppType = eMapAppTypeGoogleMaps;
        }
        else if (indexPath.row == 2) {
            self.mapAppType = eMapAppTypeAlwaysAsk;
        }

        NSMutableDictionary *userDetailDict = [self.settingsDataSourceDictionary objectAtIndex:indexPath.section];
        [userDetailDict setObject:mapAppTypeString(self.mapAppType) forKey:KEY_VALUE];
        [userDetailDict setObject:[NSNumber numberWithBool:NO] forKey:KEY_EXPAND];

        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
            localUser.defaultMapAppType = [NSNumber numberWithInteger:self.mapAppType];
        }];

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void) logoutAction {

    [STProgressHUD show];
    [[STNetworkAPIManager sharedManager] logout:^(id response) {
        
        [[STUserManager sharedManager] resetFilterWithCompletion:^(BOOL contextDidSave) {
            
            [STProgressHUD dismiss];
            [self navigateToMainView];
        }];
        
    } failure:^(NSError *error) {
        [STProgressHUD dismiss];
    }];
}

- (void)navigateToMainView {
    
    [[STNetworkAPIManager sharedManager] loginGuestUserWithDetails:nil success:^(id response) {
        [self performFinishAnimation];
    } failure:^(NSError *error) {
        
    }];
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

- (void)rateApp {
    
    NSString *appID = @"1033500835";
    NSString *rateURLString;
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (ver >= 7.0 && ver < 7.1) {
        rateURLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appID];
    } else if (ver >= 8.0 && ver < 11.0) {
        rateURLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&action=write-review",appID];
    } else if (ver >= 11.0) {
        rateURLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/CollegeHunch/id%@?mt=8&action=write-review", appID];
    } else {
        rateURLString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appID];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:rateURLString]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateURLString]];
    }
}

- (void) openFeedbackComposer {

    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = self;
        [composeViewController setToRecipients:@[@"info@collegehunch.com"]];
        [composeViewController setSubject:@"Request for Support"];
        composeViewController.title = @"Support";
        composeViewController.navigationBar.tintColor = [UIColor whiteColor];
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {

        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"CollegeHunch"
                                              message:@"Please configure mail services from device settings."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{

    switch (result) {
        case MFMailComposeResultCancelled:
            STLog(@"Email Cancelled");
            break;
        case MFMailComposeResultSaved:
            STLog(@"Email Saved");
            break;
        case MFMailComposeResultSent:
            STLog(@"Email Sent");
            break;
        case MFMailComposeResultFailed:
            STLog(@"Email Failed");
            break;
        default:
            STLog(@"Email Not Sent");
            break;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:COLLEGE_REORDER_PAGE_SEGUE_ID]) {
        //[self didCollegePageReOrderSegue:segue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dealloc Method
- (void)dealloc {
    STLog(@"Dealloc");
}


@end
