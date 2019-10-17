//
//  STCompareViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 13/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#define TUTORIALVIEW_TAG                1111

#import "STCompareViewController.h"
#import "STCompareSectionsViewController.h"
#import "STAddCollegeViewController.h"
#import "STEditCollegeViewController.h"

#import "STCompareCollectionViewLayout.h"

#import "STCollegeAttributeCollectionCell.h"
#import "STCollegeDataCollectionCell.h"

#import "STCompareNavigationTitleView.h"

#import "STTutorialView.h"
#import "STCompareItem.h"

#import "STExportEmailView.h"

@interface STCompareViewController ()

@property (nonatomic, strong) SKPaymentTransaction *transaction;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic,assign) BOOL progressHUdVisible;
@end

@implementation STCompareViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Compare";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.selectedSectionIndex = 0;
    
    [self.compareCollectionView registerNib:[UINib nibWithNibName:@"STCollegeAttributeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"STCollegeAttributeCollectionCell"];
    [self.compareCollectionView registerNib:[UINib nibWithNibName:@"STCollegeDataCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"STCollegeDataCollectionCell"];
    
    [self.compareCollectionView setBounces:NO];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.compareCollectionView setContentOffset:CGPointZero animated:NO];

    self.index = 0;
    
    __weak STCompareViewController *weakSelf = self;

    if(!([[STUserManager sharedManager] isGuestUser]) && !([STUserManager sharedManager].compareUpdates)) {
        [STProgressHUD show];
        [[STNetworkAPIManager sharedManager] getCompareCollegesForCurrentUserWithSuccess:^(id response) {
            [STProgressHUD dismiss];
            [STUserManager sharedManager].compareUpdates = true;
            [weakSelf fetchCompareDetails];
        } failure:^(NSError *error) {
            [STProgressHUD dismiss];
        }];
    } else {
        [self fetchCompareDetails];
    }
}

- (void) fetchCompareDetails {
    
    self.localContext = [NSManagedObjectContext MR_context];
    
    [self getCollegesToCompare];
    [self getCollegesSectionsToCompare];
    [self updateView];
    
    STCompareCollectionViewLayout *layout = (STCompareCollectionViewLayout *)self.compareCollectionView.collectionViewLayout;
    [layout resetLayoutAttributes];
    
    [self updateCollegeDetailsIfAny];
    
    [self.compareCollectionView reloadData];
    
    if(!STUserManager.sharedManager.isGuestUser) {
        [self showTutorialView];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
//    [self updateView];
}

- (void)showTutorialView {
    
    NSNumber *isCompareTutorialScreenSeen =  [[NSUserDefaults standardUserDefaults] objectForKey:COMPARE_TUTORIAL_SCREEN_SEEN];
    
    __weak STCompareViewController *weakSelf = self;

    if((![isCompareTutorialScreenSeen boolValue]) && (self.compareItems && ([self.compareItems count] > 0))) {
        
        STTutorialView *tutorialView = [STTutorialView shareView];
        [tutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeCompareScreen];
        
        __weak STTutorialView *weakTutorialView = tutorialView;
        
        tutorialView.tutorialActionBlock = ^(NSNumber *nextIndex){
            
            [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeNone];
            [weakTutorialView removeFromSuperview];
            
            [weakSelf showExportTutorialView];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:COMPARE_TUTORIAL_SCREEN_SEEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
        };
    } else {
        [self showExportTutorialView];
    }
}


- (void)showExportTutorialView {
    
    NSNumber *isExportTutorialScreenSeen =  [[NSUserDefaults standardUserDefaults] objectForKey:EXPORT_TUTORIAL_SCREEN_SEEN];

    if(![isExportTutorialScreenSeen boolValue]) {
        
        STTutorialView *tutorialView = [STTutorialView shareView];
        [tutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeExportSpreadsheet];
        
        __weak STTutorialView *weakTutorialView = tutorialView;
        
        tutorialView.tutorialActionBlock = ^(NSNumber *nextIndex){
            
            [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeNone];
            [weakTutorialView removeFromSuperview];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:EXPORT_TUTORIAL_SCREEN_SEEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
        };
    }
}


- (void) getCollegesSectionsToCompare {
    
    NSMutableDictionary *sectionDetails = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CompareSections" ofType:@"plist"]];
    self.sectionDetailsArray = [sectionDetails objectForKey:@"CompareSections"];
    
    [self updateNavigationTitleViewForSectionAtIndex:self.selectedSectionIndex];
}

- (void) updateNavigationTitleViewForSectionAtIndex:(NSInteger) sectionIndex {
    
    if(self.compareItems && ([self.compareItems count] > 0)) {
        
//        [self updateNavigationTitleWithUserInteractionEnabled:YES andImageHidden:YES];
    }
    else {
        self.navigationItem.titleView = nil;
        self.selectedSectionIndex = 0;
    }
}

- (void)updateNavigationTitleWithUserInteractionEnabled:(BOOL)isEnabled andImageHidden:(BOOL)isImagehidden {
        
    if(self.compareItems && ([self.compareItems count] > 0)) {
        
        NSDictionary *sectionDetails = [self.sectionDetailsArray objectAtIndex:self.selectedSectionIndex];
        NSString *title = [sectionDetails objectForKey:@"sectionName"];
        NSString *imageName = [sectionDetails objectForKey:@"selectedImageName"];
        
        NSString *titleString = [NSString stringWithFormat:@"  %@",title];

        STCompareNavigationTitleView *customTitleView = nil;
        
        __weak STCompareViewController *weakSelf = self;
        
        if(!customTitleView) {
            
            customTitleView = [[NSBundle mainBundle] loadNibNamed:@"STCompareNavigationTitleView" owner:self options:nil][0];
            customTitleView.frame = CGRectMake(0.0, 0.0, 250.0, 44.0);
            customTitleView.backgroundColor = [UIColor clearColor];
            
            customTitleView.userInteractionEnabled = isEnabled;
            customTitleView.imageView.hidden = isImagehidden;
            
            CGFloat shareButtonWidth = 40;
            CGFloat editButtonWidth = 40;
            
            CGFloat navigationTitleWidth = [UIScreen mainScreen].bounds.size.width - (shareButtonWidth + editButtonWidth + 20);

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, navigationTitleWidth, 50.0)];
            label.text = titleString;
            label.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:16.0];
            [label setNumberOfLines:0];
            [label sizeToFit];
            
            CGFloat labelWidth = label.frame.size.width + 25 + 25;
            
            if(labelWidth > navigationTitleWidth) {
                
                if (@available(iOS 11.0, *)) {
                    [customTitleView.widthAnchor constraintEqualToConstant:navigationTitleWidth].active = true;
                    [customTitleView.heightAnchor constraintEqualToConstant:50].active = true;
                } else {
                    customTitleView.frame = CGRectMake(0.0, 0.0, navigationTitleWidth, 50.0);
                }
                //customTitleView.buttonWidthConstraint.constant = navigationTitleWidth;
               // customTitleView.buttonTrailingConstraint.constant = 5;
                customTitleView.buttonTopConstraint.constant = 13;
            } else {
                
                if (@available(iOS 11.0, *)) {
                    [customTitleView.widthAnchor constraintEqualToConstant:labelWidth].active = true;
                    [customTitleView.heightAnchor constraintEqualToConstant:50].active = true;
                } else {
                    customTitleView.frame = CGRectMake(0.0, 0.0, labelWidth, 50.0);
                }
               // customTitleView.buttonWidthConstraint.constant = labelWidth + 30.0;
               // customTitleView.buttonTrailingConstraint.constant = -5;
                customTitleView.buttonTopConstraint.constant = 16;

            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.titleView = customTitleView;
            });
            
            customTitleView.onTitleActionBlock = ^{
                [weakSelf presentCompareSectionsViewController];
            };
            
            customTitleView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            
            
         /*   customTitleView.alpha = 0.0;
            
            __weak STCompareViewController *weakSelf = self;
            [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            } completion:^(BOOL finished) {
                customTitleView.alpha = 1.0;
                weakSelf.navigationItem.titleView = customTitleView;
            }]; */

        }
        
        if(sectionDetails) {
            [customTitleView updateNavigationTitleWithCollegeName:titleString andImageName:imageName];
        }
    }
    else {
        self.navigationItem.titleView = nil;
    }
}

- (void) presentCompareSectionsViewController {
    
    STCompareSectionsViewController *controller = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:COMPARE_SECTION_STORYBOARD_ID];
    
    __weak STCompareViewController *weakSelf = self;

    controller.doneActionBlock = ^(NSInteger index) {
        weakSelf.selectedSectionIndex = index;
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void) getCollegesToCompare {
    
    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:self.localContext];
    self.compareItems = [[localUser compareItems] mutableCopy];

    if(self.compareItems && ([self.compareItems count] > 0)) {
    }
}
- (void) updateCollegeDetailsIfAny {
    
    if (self.compareItems && ([self.compareItems count] > 0) && self.index < [self.compareItems count]) {
        
        STCompareItem *item = [self.compareItems objectAtIndex:self.index];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", item.collegeID];
        STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
        
        if([college.shouldUpdate boolValue] == YES) {
            STLog(@"update college");
            
            NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObject:college.collegeID forKey:kCollegeID];
            if (!self.progressHUdVisible)
            {
                [STProgressHUD show];
                self.progressHUdVisible = true;
            }
            
            [[STNetworkAPIManager sharedManager] fetchCollegeWithDetails:details success:^(id response) {
                
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    STCollege *localCollege = [college MR_inContext:localContext];
                    localCollege.shouldUpdate = [NSNumber numberWithBool:NO];
                    
                } completion:^(BOOL success, NSError *error) {
                    
                    self.index++;
                    [self updateCollegeDetailsIfAny];
                    
                }];
            } failure:^(NSError *error) {
                self.progressHUdVisible = false;
                [STProgressHUD dismiss];
            }];
        } else {
            
            self.index++;
            [self updateCollegeDetailsIfAny];
        }
    } else {
        self.progressHUdVisible = false;
        [STProgressHUD dismiss];
        [self.compareCollectionView reloadData];

    }
}

- (void) updateView {
    dispatch_async(dispatch_get_main_queue(), ^{
    [self updateNavigationTitleWithUserInteractionEnabled:YES andImageHidden:NO];
    });
    self.currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    NSNumber *paymentStatus = [[NSUserDefaults standardUserDefaults] objectForKey:EXPORT_PAYMENT_STATUS];
//    NSNumber *emailDeliveryStatus = [[NSUserDefaults standardUserDefaults] objectForKey:EXPORT_MAIL_DELIVERY_STATUS];
    
    if(self.compareItems && ([self.compareItems count] > 0)) {
        
        self.compareCollectionView.hidden = NO;
        self.emptyView.hidden = YES;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(addOREditButtonAction:)];
        
        if([paymentStatus boolValue]) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_share"] style:UIBarButtonItemStylePlain target:self action:@selector(onShareButtonAction:)];
        } else {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_share_locked"] style:UIBarButtonItemStylePlain target:self action:@selector(onShareButtonAction:)];
        }
        
//        [self updateNavigationTitleWithUserInteractionEnabled:YES andImageHidden:NO];
        
    } else {
        
        self.compareCollectionView.hidden = YES;
        self.emptyView.hidden = NO;
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addOREditButtonAction:)];
        
        if([paymentStatus boolValue]) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_share"] style:UIBarButtonItemStylePlain target:self action:@selector(onShareButtonAction:)];
        } else {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_share_locked"] style:UIBarButtonItemStylePlain target:self action:@selector(onShareButtonAction:)];
        }
        
//        [self updateNavigationTitleWithUserInteractionEnabled:YES andImageHidden:NO];

    }
}

- (void) addOREditButtonAction:(UIBarButtonItem *) sender {
 
    if([[sender title] isEqualToString:@"Add"]) {
        STAddCollegeViewController *addController = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:ADD_COMPARE_STORYBOARD_ID];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addController];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else {
        STAddCollegeViewController *editController = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:EDIT_COMPARE_STORYBOARD_ID];
        
        [self.navigationController pushViewController:editController animated:YES];
    }
}

// Left bar button item action
- (void)onShareButtonAction:(id)sender {
    
    NSNumber *paymentStatus = [[NSUserDefaults standardUserDefaults] objectForKey:EXPORT_PAYMENT_STATUS];
    
    __weak STCompareViewController *weakSelf = self;
    
    if(self.compareItems && ([self.compareItems count] > 0)) {
        
        if(![paymentStatus boolValue]) {
            
            [STProgressHUD show];
            
            [[STInAppPurchaseManager sharedInstance] buyProductForIdentifier:EXPORT_NC_PRODUCT_IDENTIFIER withCompletionHandler:^(BOOL success, SKPaymentTransaction *transaction, NSString *message) {
                
                [STProgressHUD dismiss];

                if(!success) {

                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@"CollegeHunch"
                                                          message: message
                                                          preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];

                } else if ([transaction.payment.productIdentifier isEqualToString:EXPORT_NC_PRODUCT_IDENTIFIER]) {
                    weakSelf.transaction = transaction;
                    [weakSelf updateView];
                    [weakSelf exportPopUpView];
                }
            }];
            
        } else {
            [weakSelf exportPopUpView];
        }
    } else {
        
        [STProgressHUD showInfoWithStatus:@"Please add atleast one college to compare spreadsheet to export"];
    }
}

- (void)exportPopUpView {
    
    STExportEmailView * emailPopUpView = [STExportEmailView shareView];
    
    [emailPopUpView showInView:[[[UIApplication sharedApplication] delegate] window]];
    
    __weak STExportEmailView * weakEmailPopUpView = emailPopUpView;
    __weak STCompareViewController * weakSelf = self;
    
    emailPopUpView.cancelActionBlock = ^(){
        [weakEmailPopUpView removeFromSuperview];
    };
    
    emailPopUpView.sendActionBlock = ^(NSString * emailID) {
        
        [weakEmailPopUpView removeFromSuperview];
        
        [weakSelf sendCollegesToEmailId:emailID];
    };
}

- (void)sendCollegesToEmailId:(NSString *)emailId {
    
    if(self.compareItems.count > 0) {
        
        NSMutableArray *colleges = [NSMutableArray new];
        
        for(STCompareItem *item in self.compareItems) {
            [colleges addObject:item.collegeID];
        }
        
        [STProgressHUD show];
        
        __weak STCompareViewController *weakSelf = self;
        
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:EXPORT_PAYMENT_STATUS];
//        [[NSUserDefaults standardUserDefaults] synchronize];

        [[STNetworkAPIManager sharedManager] exportColleges:colleges toEmailId:emailId success:^(id response) {
            STLog(@"%@", response);
            [STProgressHUD dismiss];
            
            if([[response objectForKey:@"ErrorCode"] integerValue] == 0) {
                
                [STProgressHUD showImage:[UIImage imageNamed:@"toast_added"] andStatus:[response objectForKey:@"Message"]];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:EXPORT_MAIL_DELIVERY_STATUS];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
//                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:EXPORT_PAYMENT_STATUS];
//                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } else {
                
//                [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:[response objectForKey:@"Message"]];
                
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"CollegeHunch"
                                                      message:[response objectForKey:@"Message"]
                                                      preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:EXPORT_MAIL_DELIVERY_STATUS];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
//                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:EXPORT_PAYMENT_STATUS];
//                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            [weakSelf updateView];
            
            if(self.transaction) {
                [[STNetworkAPIManager sharedManager] updateExportTransactionDetails:self.transaction forMailId:emailId success:^(id response) {
                    STLog(@"%@", response);
                    
                } failure:^(NSError *error) {
                    STLog(@"%@", error);
                }];
            }
            
        } failure:^(NSError *error) {
            STLog(@"%@", error);
            [STProgressHUD dismiss];
            
//            [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Due to network or other failure, spreadsheet was not sent. Please try again later and you will not be charged"];
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"CollegeHunch"
                                                  message:@"Due to network or other failure, spreadsheet was not sent. Please try again later and you will not be charged"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:EXPORT_MAIL_DELIVERY_STATUS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:EXPORT_PAYMENT_STATUS];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
             [weakSelf updateView];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark COLLECTION VIEW DATASOURCE

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    if(self.compareItems && ([self.compareItems count] > 0)) {
        NSMutableDictionary *sectionDetails = [self.sectionDetailsArray objectAtIndex:self.selectedSectionIndex];
        return ([[sectionDetails objectForKey:@"attributeArray"] count] + 1); // + 1 for base item
    }
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(self.compareItems && ([self.compareItems count] > 0)) {
        return (self.compareItems.count + 1); // + 1 for base item
    }
    
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            STCollegeDataCollectionCell *dateCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STCollegeDataCollectionCell" forIndexPath:indexPath];
            dateCell.backgroundColor = [UIColor colorWithWhite:230.0/255.0 alpha:1.0];
            dateCell.valueName.text = @"";
            
            return dateCell;
        } else {
            STCollegeAttributeCollectionCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STCollegeAttributeCollectionCell" forIndexPath:indexPath];
            contentCell.labelName.textColor = [UIColor cellTextFieldTextColor];
            contentCell.labelName.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:11.0];
            
            contentCell.backgroundColor = [UIColor colorWithWhite:230.0/255.0 alpha:1.0];

            NSInteger itemIndex = (indexPath.row - 1);
            STCompareItem *item = [self.compareItems objectAtIndex:itemIndex];
            NSNumber *collegeID = item.collegeID;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@",collegeID];
            STCollege *college = [STCollege MR_findFirstWithPredicate:predicate inContext:self.localContext];
            contentCell.labelName.text = [college.collegeName uppercaseString];
            
            return contentCell;
        }
    }
    else {
        if ([indexPath row] == 0) {

            STCollegeDataCollectionCell *dateCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STCollegeDataCollectionCell" forIndexPath:indexPath];
            dateCell.valueName.textColor = [UIColor cellTextFieldTextColor];
            dateCell.valueName.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:11.0];

            dateCell.backgroundColor = [UIColor colorWithWhite:230.0/255.0 alpha:1.0];

            NSMutableDictionary *sectionDetails = [self.sectionDetailsArray objectAtIndex:self.selectedSectionIndex];
            NSMutableArray *attributeArray = [sectionDetails objectForKey:@"attributeArray"];
            
            NSInteger itemIndex = (indexPath.section - 1);
            dateCell.valueName.text = [[[attributeArray objectAtIndex:itemIndex] objectForKey:@"attributeName"] uppercaseString];

            return dateCell;
        }
        else {
            
            STCollegeAttributeCollectionCell *contentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STCollegeAttributeCollectionCell" forIndexPath:indexPath];
            contentCell.labelName.textColor = [UIColor cellTextFieldTextColor];
            contentCell.labelName.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:12.0];
            contentCell.labelName.textAlignment = NSTextAlignmentCenter;

            contentCell.backgroundColor = [UIColor whiteColor];
            
            NSString *value = [self getValueOfItemAtIndex:([indexPath section] - 1) forSection:([indexPath row] - 1)];
            contentCell.labelName.text = value;

            if((self.compareItems.count) < ([indexPath row] - 1)) {
                contentCell.rightSeperatorWidthConstraint.constant = 0.25;
            }
            else {
                contentCell.rightSeperatorWidthConstraint.constant = 0.5;
            }
            
            return contentCell;
        }
    }
}

- (NSString *) getValueOfItemAtIndex:(NSInteger) index forSection:(NSInteger) section {
    
    NSString *value = @"";
    
    NSMutableDictionary *sectionDetails = [self.sectionDetailsArray objectAtIndex:self.selectedSectionIndex];
    NSMutableArray *attributeArray = [sectionDetails objectForKey:@"attributeArray"];
    
    switch (self.selectedSectionIndex) {
        case 0:// Summary
            value = [self getSummaryItemForAttribute:[[attributeArray objectAtIndex:index] objectForKey:@"attributeName"] atIndex:section];
            break;
        case 1:// Test Scores
            value = [self getTestScoreItemForAttribute:[[attributeArray objectAtIndex:index] objectForKey:@"attributeName"] atIndex:section];
            break;
        case 2:// Freshman
            value = [self getFreshmanItemForAttribute:[[attributeArray objectAtIndex:index] objectForKey:@"attributeName"] atIndex:section forSectionIndex:self.selectedSectionIndex];
            break;
        case 3:// Admission
            value = [self getAdmissionItemForAttribute:[[attributeArray objectAtIndex:index] objectForKey:@"attributeName"] atIndex:section];
            break;
        case 4:// Fees Instate
            value = [self getFeesAndFinancialAidInStateItemForAttribute:[[attributeArray objectAtIndex:index] objectForKey:@"attributeName"] atIndex:section];
            break;
        case 5:// Fees OutState
            value = [self getFeesAndFinancialAidOutStateItemForAttribute:[[attributeArray objectAtIndex:index] objectForKey:@"attributeName"] atIndex:section];
            break;
        case 6:// Weather
            value = [self getWeatherItemForAttribute:[[attributeArray objectAtIndex:index] objectForKey:@"attributeName"] atIndex:section];
            break;
        default:
            break;
    }
    
    return value;
}

- (NSString *) getSummaryItemForAttribute:(NSString *) attribute atIndex:(NSInteger) index {
    
    // get college at index
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

    STCompareItem *comapreItem = [self.compareItems objectAtIndex:index];
    NSNumber *collegeID = comapreItem.collegeID;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    if([attribute isEqualToString:@"Freshmen"]) {
        
        if(college.totalFreshmens.intValue > 0) {
            return [formatter stringFromNumber:college.totalFreshmens];
        }
    }
    else if([attribute isEqualToString:@"Undergraduates"]) {
        
        if(college.totalUndergrads.intValue > 0) {
            return [formatter stringFromNumber:college.totalUndergrads];
        }
    }
    else if([attribute isEqualToString:@"Acceptance Rate"]) {
        
        if(college.acceptanceRate.floatValue > 0.0) {
            return [NSString stringWithFormat:@"%@ %%",college.acceptanceRate];
        }
    }
    else if([attribute isEqualToString:@"Average GPA"]) {
        
        if(college.averageGPA.floatValue > 0.0) {
            return [NSString stringWithFormat:@"%.2f", [college.averageGPA floatValue]];
        }
    }
    else if([attribute isEqualToString:@"Average SAT"]) {
        
        if(college.averageSATNew.intValue > 0) {
            return [NSString stringWithFormat:@"%@",college.averageSATNew];
//            return [NSString stringWithFormat:@"%@ / %@", college.averageSAT, college.averageSATNew];
        }
    }
    else if([attribute isEqualToString:@"Average ACT"]) {
        
        if(college.averageACT.intValue > 0) {
            return [NSString stringWithFormat:@"%@",college.averageACT];
        }
    }
    else if([attribute isEqualToString:@"Type"]) {
        
        if(college.collegeType) {
            NSInteger collegeType = [college.collegeType integerValue];
            
            if(collegeType == eCollegeTypeUniversity) {
                return [NSString stringWithFormat:@"University"];
            }
            else if(collegeType == eCollegeTypeCollege) {
                return [NSString stringWithFormat:@"College"];
            }
            else if(collegeType == eCollegeTypeSchool) {
                return [NSString stringWithFormat:@"School"];
            }
            
        }
    }
    else if([attribute isEqualToString:@"Location"]) {
        
        if(college.place) {
            return college.place;
        }
    }
    else if([attribute isEqualToString:@"Environment"]) {
        
        if(college.collegeAreaType) {
            NSInteger areaType = [college.collegeAreaType integerValue];
            
            if(areaType == eCollegeAreaTypeCity) {
                return [NSString stringWithFormat:@"City"];
            }
            else if(areaType == eCollegeAreaTypeTown) {
                return [NSString stringWithFormat:@"Town"];
            }
            else if(areaType == eCollegeAreaTypeRural) {
                return [NSString stringWithFormat:@"Rural"];
            }
        }
    }  else if([attribute isEqualToString:@"Undergrads Off Campus"]) {
        
        return [self getFreshmanItemForAttribute:attribute atIndex:index forSectionIndex:2];
        
    } else if([attribute isEqualToString:@"Graduation Rate 4Yr / 6Yr"]) {
        
        return [self getFreshmanItemForAttribute:attribute atIndex:index forSectionIndex:2];
        
    } else if([attribute isEqualToString:@"Religious Affiliation"]) {
        
        return [self getFreshmanItemForAttribute:attribute atIndex:index forSectionIndex:2];
    }
    
    return @"";
}

- (NSString *) getTestScoreItemForAttribute:(NSString *) attribute atIndex:(NSInteger) index {
    // get college at index
    
    STCompareItem *comapreItem = [self.compareItems objectAtIndex:index];
    NSNumber *collegeID = comapreItem.collegeID;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    NSMutableDictionary *sectionDetails = [self.sectionDetailsArray objectAtIndex:self.selectedSectionIndex];
    
    NSNumber *sectionID = [sectionDetails objectForKey:@"sectionID"];
    STCTestScoresAndGrades *testScoresAndGrades = [self getCollegeSectionForSectionID:sectionID inCollege:college];

    NSOrderedSet *averageScorees = testScoresAndGrades.averageScores;
    NSOrderedSet *barChartSet = testScoresAndGrades.testScoresBarCharts;
    
    if([attribute isEqualToString:@"Average GPA"]) {
        
        if(averageScorees && ([averageScorees count] > 0)) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Average GPA"];
            
            NSOrderedSet *itemsSet = [averageScorees filteredOrderedSetUsingPredicate:predicate];
            
            if(itemsSet && [itemsSet count] > 0) {
                STCAverageScoreItem *item =  itemsSet[0];
                
                if(item) {
                    if(college.averageGPA.intValue > 0) {
                        return [NSString stringWithFormat:@"%.2f", [college.averageGPA floatValue]];
                    }
                }
            }
        }
    }
    else if([attribute isEqualToString:@"Average ACT Composite"]) {
        
        if(averageScorees && ([averageScorees count] > 0)) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Average ACT"];
            
            NSOrderedSet *itemsSet = [averageScorees filteredOrderedSetUsingPredicate:predicate];
            
            if(itemsSet && [itemsSet count] > 0) {
                STCAverageScoreItem *item =  itemsSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"%@", item.value];
                    }
                }
            }
        }
    }
    else if([attribute isEqualToString:@"ACT Composite 25th %"]) {
        
        if(barChartSet && ([barChartSet count] > 0)) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"ACT SCORE"];
            
            NSOrderedSet *itemsSet = [barChartSet filteredOrderedSetUsingPredicate:predicate];
            
            if(itemsSet && [itemsSet count] > 0) {
                STCTestScoresBarChart *item =  itemsSet[0];
                
                if(item) {
                    if(item.percentageLowValue.intValue > 0) {
                        return [NSString stringWithFormat:@"%@", item.percentageLowValue];
                    }
                }
            }
        }
    }
    else if([attribute isEqualToString:@"ACT Composite 75th %"]) {
     
        if(barChartSet && ([barChartSet count] > 0)) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"ACT SCORE"];
            
            NSOrderedSet *itemsSet = [barChartSet filteredOrderedSetUsingPredicate:predicate];
            
            if(itemsSet && [itemsSet count] > 0) {
                STCTestScoresBarChart *item =  itemsSet[0];
                
                if(item) {
                    if(item.percentageHighValue.intValue > 0) {
                        return [NSString stringWithFormat:@"%@", item.percentageHighValue];
                    }
                }
            }
        }
    }
    else if([attribute isEqualToString:@"Avg SAT Combined"]) {
        
        if(averageScorees && ([averageScorees count] > 0)) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Average SAT"];
            
            NSOrderedSet *itemsSet = [averageScorees filteredOrderedSetUsingPredicate:predicate];
            
            if(itemsSet && [itemsSet count] > 0) {
                STCAverageScoreItem *item =  itemsSet[0];
                
                if(item) {
//                    return [NSString stringWithFormat:@"%@", item.value];
                    if(college.averageSATNew.intValue > 0) {
                        return [NSString stringWithFormat:@"%@", college.averageSATNew];
                    }
                }
            }
        }
    }
    else if([attribute isEqualToString:@"SAT Reading and Writing 25th %"]) {
        
        if(barChartSet && ([barChartSet count] > 0)) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"SAT SCORE"];
            NSOrderedSet *itemsSet = [barChartSet filteredOrderedSetUsingPredicate:predicate];
            
            if(itemsSet && [itemsSet count] > 0) {
                STCTestScoresBarChart *item =  itemsSet[0];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Critical Reading"];
                if([item.newScoresAvailable boolValue]) {
                    predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Reading and Writing"];
                }

                NSOrderedSet *barCharItemsSet = [item.barChartItems filteredOrderedSetUsingPredicate:predicate];
                
                if(barCharItemsSet && ([barCharItemsSet count] > 0)) {
                    STCBarChartItem *barChartItem = barCharItemsSet[0];
                    if(barChartItem.lowerValue.intValue > 0) {
                        return [NSString stringWithFormat:@"%@", barChartItem.lowerValue];
                    }
                }
            }
        }
    }
    else if([attribute isEqualToString:@"SAT Reading and Writing 75th %"]) {
        
        if(barChartSet && ([barChartSet count] > 0)) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"SAT SCORE"];
            NSOrderedSet *itemsSet = [barChartSet filteredOrderedSetUsingPredicate:predicate];
            
            if(itemsSet && [itemsSet count] > 0) {
                STCTestScoresBarChart *item =  itemsSet[0];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Critical Reading"];
                if([item.newScoresAvailable boolValue]) {
                    predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Reading and Writing"];
                }
                
                NSOrderedSet *barCharItemsSet = [item.barChartItems filteredOrderedSetUsingPredicate:predicate];
                
                if(barCharItemsSet && ([barCharItemsSet count] > 0)) {
                    STCBarChartItem *barChartItem = barCharItemsSet[0];
                    if(barChartItem.upperValue.intValue > 0) {
                        return [NSString stringWithFormat:@"%@", barChartItem.upperValue];
                    }
                }
            }
        }
    }
    else if([attribute isEqualToString:@"SAT Math 25th %"]) {
     
        if(barChartSet && ([barChartSet count] > 0)) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"SAT SCORE"];
            NSOrderedSet *itemsSet = [barChartSet filteredOrderedSetUsingPredicate:predicate];
            
            if(itemsSet && [itemsSet count] > 0) {
                STCTestScoresBarChart *item =  itemsSet[0];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Math"];
                
                NSOrderedSet *barCharItemsSet = [item.barChartItems filteredOrderedSetUsingPredicate:predicate];

                if(barCharItemsSet && ([barCharItemsSet count] > 0)) {
                    STCBarChartItem *barChartItem = barCharItemsSet[0];
                    if(barChartItem.lowerValue.intValue > 0) {
                        return [NSString stringWithFormat:@"%@", barChartItem.lowerValue];
                    }
                }
            }
        }
    }
    else if([attribute isEqualToString:@"SAT Math 75th %"]) {
     
        if(barChartSet && ([barChartSet count] > 0)) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"SAT SCORE"];
            NSOrderedSet *itemsSet = [barChartSet filteredOrderedSetUsingPredicate:predicate];
            
            if(itemsSet && [itemsSet count] > 0) {
                STCTestScoresBarChart *item =  itemsSet[0];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Math"];
                
                NSOrderedSet *barCharItemsSet = [item.barChartItems filteredOrderedSetUsingPredicate:predicate];
                
                if(barCharItemsSet && ([barCharItemsSet count] > 0)) {
                    STCBarChartItem *barChartItem = barCharItemsSet[0];
                    if(barChartItem.upperValue.intValue > 0) {
                        return [NSString stringWithFormat:@"%@", barChartItem.upperValue];
                    }
                }
            }
        }
    }

    return @"";
}

- (NSString *) getFreshmanItemForAttribute:(NSString *) attribute atIndex:(NSInteger) index forSectionIndex:(NSInteger) sectionIndex {
    // get college at index
    
    STCompareItem *comapreItem = [self.compareItems objectAtIndex:index];
    NSNumber *collegeID = comapreItem.collegeID;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    NSMutableDictionary *sectionDetails = [self.sectionDetailsArray objectAtIndex:sectionIndex];
    
    NSNumber *sectionID = [sectionDetails objectForKey:@"sectionID"];
    STCFreshman *freshman = [self getCollegeSectionForSectionID:sectionID inCollege:college];
    STCFreshmanGenderDetails *genderDetails = freshman.genderDetails;
    
    NSOrderedSet *freshmanDetailItems = freshman.freshmanDetailItems;
    STCFreshmanGraduationDetails *graduationDetails = freshman.graduationDetails;
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

    if([attribute isEqualToString:@"Acceptance Rate"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"ACCEPTANCE RATE"];
        
        NSOrderedSet *itemsSet = [freshmanDetailItems filteredOrderedSetUsingPredicate:predicate];
        
        if(itemsSet && [itemsSet count] > 0) {
            STCFreshmanDetailItem *item =  itemsSet[0];
            
            if(item) {
                if(item.value.floatValue > 0.0) {
                    return [NSString stringWithFormat:@"%.1f%%", [item.value floatValue]];
                }
            }
        }
    }
    else if([attribute isEqualToString:@"Freshmen"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"TOTAL ENROLLED"];
        NSOrderedSet *itemsSet = [freshmanDetailItems filteredOrderedSetUsingPredicate:predicate];
        
        if(itemsSet && [itemsSet count] > 0) {
            STCFreshmanDetailItem *item =  itemsSet[0];
            
            if(item) {
                if(item.value.intValue > 0) {
                    return [formatter stringFromNumber:item.value]; //[NSString stringWithFormat:@"%@", item.value];
                }
            }
        }
    }
    else if([attribute isEqualToString:@"Full-time Undergrads"]) {
        if(college.totalUndergrads.intValue > 0) {
            return [formatter stringFromNumber:college.totalUndergrads];
        }
    }
    else if([attribute isEqualToString:@"Applicants"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"TOTAL APPLICANTS"];
        
        NSOrderedSet *itemsSet = [freshmanDetailItems filteredOrderedSetUsingPredicate:predicate];
        
        if(itemsSet && [itemsSet count] > 0) {
            STCFreshmanDetailItem *item =  itemsSet[0];
            
            if(item) {
                if(item.value.intValue > 0) {
                    return [formatter stringFromNumber:item.value];
                }
            }
        }
    }
    else if([attribute isEqualToString:@"% Out of State"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"FROM OUT OF STATE"];
        NSOrderedSet *itemsSet = [freshmanDetailItems filteredOrderedSetUsingPredicate:predicate];
        
        if(itemsSet && [itemsSet count] > 0) {
            STCFreshmanDetailItem *item =  itemsSet[0];
            
            if(item) {
                if(item.value.intValue > 0) {
                    return [NSString stringWithFormat:@"%@ %%", item.value];
                }
            }
        }
    }
    else if([attribute isEqualToString:@"% Men"]) {
        
        if(genderDetails.malePercentage.intValue > 0) {
            return [NSString stringWithFormat:@"%@ %%",genderDetails.malePercentage];
        }
    }
    else if([attribute isEqualToString:@"% Women"]) {
        
        if(genderDetails.femalePercentage.intValue > 0) {
            return [NSString stringWithFormat:@"%@ %%",genderDetails.femalePercentage];
        }
    }
    else if([attribute isEqualToString:@"Religious Affiliation"]) {
        
        if(freshman.religiousAffiliation) {
            return [NSString stringWithFormat:@"%@",freshman.religiousAffiliation];
        }
    }
    else if([attribute isEqualToString:@"Average Financial Aid"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"AVERAGE FINANCIAL AID"];
        NSOrderedSet *itemsSet = [freshmanDetailItems filteredOrderedSetUsingPredicate:predicate];
        
        if(itemsSet && [itemsSet count] > 0) {
            STCFreshmanDetailItem *item =  itemsSet[0];
            
            if(item) {
                if(item.value.intValue > 0) {
                    return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                }
            }
        }
    }
    else if([attribute isEqualToString:@"% Receiving Financial Aid"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"RECEIVING FINANCIAL AID"];
        NSOrderedSet *itemsSet = [freshmanDetailItems filteredOrderedSetUsingPredicate:predicate];
        
        if(itemsSet && [itemsSet count] > 0) {
            STCFreshmanDetailItem *item =  itemsSet[0];
            
            if(item) {
                return [NSString stringWithFormat:@"%@ %%", item.value];
            }
        }
    } else if([attribute isEqualToString:@"% Undergrads Off Campus"] || [attribute isEqualToString:@"Undergrads Off Campus"]) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Undergrads Off Campus"];
        NSOrderedSet *itemsSet = [freshmanDetailItems filteredOrderedSetUsingPredicate:predicate];
        
        if(itemsSet && [itemsSet count] > 0) {
            STCFreshmanDetailItem *item =  itemsSet[0];
            
            if(item) {
                if(item.value.intValue > 0) {
                    return [NSString stringWithFormat:@"%@ %%", item.value];
                }
            }
        }
        
    } else if([attribute isEqualToString:@"Graduation Rate 4Yr / 6Yr"]) {
        
       /* NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"6-YEAR GRADUATION RATE"];
        NSOrderedSet *itemsSet = [freshmanDetailItems filteredOrderedSetUsingPredicate:predicate];
        
        if(itemsSet && [itemsSet count] > 0) {
            STCFreshmanDetailItem *item =  itemsSet[0];
            
            if(item) {
                if(item.value.intValue > 0) {
                    return [NSString stringWithFormat:@"%@ %%", item.value];
                }
            }
        } */

        return [NSString stringWithFormat:@"%@ %%  /  %@ %%", graduationDetails.fourYearGraduationRate, graduationDetails.sixYearGraduationRate];

    } else if([attribute isEqualToString:@"Undergrads 25 Or Older"]) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Undergrads 25 or Older"];
        NSOrderedSet *itemsSet = [freshmanDetailItems filteredOrderedSetUsingPredicate:predicate];
        
        if(itemsSet && [itemsSet count] > 0) {
            STCFreshmanDetailItem *item =  itemsSet[0];
            
            if(item) {
                if(item.value.intValue > 0) {
                    return [NSString stringWithFormat:@"%@ %%", item.value];
                }
            }
        }
        
    }

    return @""; //Undergrads 25 Or Older
}

- (NSString *) getAdmissionItemForAttribute:(NSString *) attribute atIndex:(NSInteger) index {
    // get college at index
    
    STCompareItem *comapreItem = [self.compareItems objectAtIndex:index];
    NSNumber *collegeID = comapreItem.collegeID;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    NSMutableDictionary *sectionDetails = [self.sectionDetailsArray objectAtIndex:self.selectedSectionIndex];
    
    NSNumber *sectionID = [sectionDetails objectForKey:@"sectionID"];
    STCAdmissions *admissions = [self getCollegeSectionForSectionID:sectionID inCollege:college];

    NSOrderedSet *admissionItems = admissions.admissionItems;

    if(admissionItems.count > 0) {
        
        if([attribute isEqualToString:@"Early Decision"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Early Decision"];
            
            NSOrderedSet *admissionSet = [admissionItems filteredOrderedSetUsingPredicate:predicate];
            
            if(admissionSet && ([admissionSet count] > 0)) {
                
                STCAdmissionItem *admissionItem =  admissionSet[0];
                
                if(admissionItem && ([admissionItem.items count] > 0)) {
                    STCItem *item = admissionItem.items[0];
                    return [NSString stringWithFormat:@"%@", [item.badgeText capitalizedString]];
                }
            }
        }
        else if([attribute isEqualToString:@"Early Action"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Early Action"];
            NSOrderedSet *admissionSet = [admissionItems filteredOrderedSetUsingPredicate:predicate];
            
            if(admissionSet && ([admissionSet count] > 0)) {
                
                STCAdmissionItem *admissionItem =  admissionSet[0];
                
                if(admissionItem && ([admissionItem.items count] > 0)) {
                    STCItem *item = admissionItem.items[0];
                    return [NSString stringWithFormat:@"%@", [item.badgeText capitalizedString]];
                }
            }
        }
        else if([attribute isEqualToString:@"Rolling"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Rolling"];
            NSOrderedSet *admissionSet = [admissionItems filteredOrderedSetUsingPredicate:predicate];
            
            if(admissionSet && ([admissionSet count] > 0)) {
                
                STCAdmissionItem *admissionItem =  admissionSet[0];
                
                if(admissionItem && ([admissionItem.items count] > 0)) {
                    STCItem *item = admissionItem.items[0];
                    return [NSString stringWithFormat:@"%@", [item.badgeText capitalizedString]];
                }
            }
        }
        else if([attribute isEqualToString:@"Common Application"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Common Application"];
            NSOrderedSet *admissionSet = [admissionItems filteredOrderedSetUsingPredicate:predicate];
            
            if(admissionSet && ([admissionSet count] > 0)) {
                
                STCAdmissionItem *admissionItem =  admissionSet[0];
                
                if(admissionItem && ([admissionItem.items count] > 0)) {
                    STCItem *item = admissionItem.items[0];
                    return [NSString stringWithFormat:@"%@", [item.badgeText capitalizedString]];
                }
            }
        }
    }
    
    return @"";
}

- (NSString *) getFeesAndFinancialAidInStateItemForAttribute:(NSString *) attribute atIndex:(NSInteger) index {
    // get college at index
    
    STCompareItem *comapreItem = [self.compareItems objectAtIndex:index];
    NSNumber *collegeID = comapreItem.collegeID;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    NSMutableDictionary *sectionDetails = [self.sectionDetailsArray objectAtIndex:self.selectedSectionIndex];
    
    NSNumber *sectionID = [sectionDetails objectForKey:@"sectionID"];
    STCFeesAndFinancialAid *feesAndFinancialAid = [self getCollegeSectionForSectionID:sectionID inCollege:college];
    
    NSOrderedSet *inStateFees = feesAndFinancialAid.inStateFees;
    
    if(inStateFees.count > 0) {
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

        if([attribute isEqualToString:@"Application Fee"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Application Fee"];
            
            NSOrderedSet *inStateItemSet = [inStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(inStateItemSet && ([inStateItemSet count] > 0)) {
                
                STCInStateFees *item =  inStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Tuition"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Tuition & Fees In State"];
            NSOrderedSet *inStateItemSet = [inStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(inStateItemSet && ([inStateItemSet count] > 0)) {
                
                STCInStateFees *item =  inStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Books & Supplies"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Books & Supplies"];
            NSOrderedSet *inStateItemSet = [inStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(inStateItemSet && ([inStateItemSet count] > 0)) {
                
                STCInStateFees *item =  inStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Room & Board"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Room & Board"];
            NSOrderedSet *inStateItemSet = [inStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(inStateItemSet && ([inStateItemSet count] > 0)) {
                
                STCInStateFees *item =  inStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Total Fees"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Total Cost"];
            NSOrderedSet *inStateItemSet = [inStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(inStateItemSet && ([inStateItemSet count] > 0)) {
                
                STCInStateFees *item =  inStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Personal Expenses"]) {
            //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Miscellaneous"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Personal Expenses"];

            NSOrderedSet *inStateItemSet = [inStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(inStateItemSet && ([inStateItemSet count] > 0)) {
                
                STCInStateFees *item =  inStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Average Financial Aid"]) {
            
            if(feesAndFinancialAid.averageFinancialAid.intValue > 0) {
                return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:feesAndFinancialAid.averageFinancialAid]];
            }
        }
        else if([attribute isEqualToString:@"% Receiving Financial Aid"]) {
            
            if(feesAndFinancialAid.receivingFinancialAid.intValue > 0) {
                return [NSString stringWithFormat:@"%@ %%",feesAndFinancialAid.receivingFinancialAid];
            }
        }
    }

    return @"";
}

- (NSString *) getFeesAndFinancialAidOutStateItemForAttribute:(NSString *) attribute atIndex:(NSInteger) index {
    // get college at index
    
    STCompareItem *comapreItem = [self.compareItems objectAtIndex:index];
    NSNumber *collegeID = comapreItem.collegeID;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    NSMutableDictionary *sectionDetails = [self.sectionDetailsArray objectAtIndex:self.selectedSectionIndex];
    
    NSNumber *sectionID = [sectionDetails objectForKey:@"sectionID"];
    STCFeesAndFinancialAid *feesAndFinancialAid = [self getCollegeSectionForSectionID:sectionID inCollege:college];
    
    NSOrderedSet *outStateFees = feesAndFinancialAid.outStateFees;

    if(outStateFees.count > 0) {
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

        if([attribute isEqualToString:@"Application Fee"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Application Fee"];
            
            NSOrderedSet *outStateItemSet = [outStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(outStateItemSet && ([outStateItemSet count] > 0)) {
                
                STCOutStateFees *item =  outStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Tuition"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Tuition & Fees Out of State"];
            NSOrderedSet *outStateItemSet = [outStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(outStateItemSet && ([outStateItemSet count] > 0)) {
                
                STCOutStateFees *item =  outStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Books & Supplies"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Books & Supplies"];
            NSOrderedSet *outStateItemSet = [outStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(outStateItemSet && ([outStateItemSet count] > 0)) {
                
                STCOutStateFees *item =  outStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Room & Board"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Room & Board"];
            NSOrderedSet *outStateItemSet = [outStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(outStateItemSet && ([outStateItemSet count] > 0)) {
                
                STCOutStateFees *item =  outStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Total Fees"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Total Cost"];
            NSOrderedSet *outStateItemSet = [outStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(outStateItemSet && ([outStateItemSet count] > 0)) {
                
                STCOutStateFees *item =  outStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Personal Expenses"]) {
            //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Miscellaneous"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",@"Personal Expenses"];
            NSOrderedSet *outStateItemSet = [outStateFees filteredOrderedSetUsingPredicate:predicate];
            
            if(outStateItemSet && ([outStateItemSet count] > 0)) {
                
                STCOutStateFees *item =  outStateItemSet[0];
                
                if(item) {
                    if(item.value.intValue > 0) {
                        return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:item.value]];
                    }
                }
            }
        }
        else if([attribute isEqualToString:@"Average Financial Aid"]) {
            
            if(feesAndFinancialAid.averageFinancialAid.intValue > 0) {
                return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:feesAndFinancialAid.averageFinancialAid]];
            }
        }
        else if([attribute isEqualToString:@"% Receiving Financial Aid"]) {
            
            if(feesAndFinancialAid.receivingFinancialAid.intValue > 0) {
                return [NSString stringWithFormat:@"%@ %%",feesAndFinancialAid.receivingFinancialAid];
            }
        }
    }

    return @"";
}

- (NSString *) getWeatherItemForAttribute:(NSString *) attribute atIndex:(NSInteger) index {
    // get college at index
    
    STCompareItem *comapreItem = [self.compareItems objectAtIndex:index];
    NSNumber *collegeID = comapreItem.collegeID;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    NSMutableDictionary *sectionDetails = [self.sectionDetailsArray objectAtIndex:self.selectedSectionIndex];

    NSNumber *sectionID = [sectionDetails objectForKey:@"sectionID"];
    STCWeather *weatherSection = [self getCollegeSectionForSectionID:sectionID inCollege:college];
    STCAverageWeather *averageWeather = weatherSection.averageWeather;
    NSOrderedSet *averageaWeatherItems = averageWeather.averageWeatherItems;
        
    if(averageaWeatherItems.count > 0) {
        
        if([attribute isEqualToString:@"Fall Avg Low"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Fall"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                return [NSString stringWithFormat:@"%@%@", item.lowValue, @"\u00B0"];
            }
        }
        else if([attribute isEqualToString:@"Fall Avg High"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Fall"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                return [NSString stringWithFormat:@"%@%@", item.highValue, @"\u00B0"];
            }
        }
        else if([attribute isEqualToString:@"Fall Avg Precipitation"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Fall"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                if([item.precipitationValue integerValue] == 1) {
                    return [NSString stringWithFormat:@"%@ inch",item.precipitationValue];
                }
                else {
                    return [NSString stringWithFormat:@"%@ inches",item.precipitationValue];
                }
            }
        }
        else if([attribute isEqualToString:@"Winter Avg Low"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Winter"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                return [NSString stringWithFormat:@"%@%@", item.lowValue, @"\u00B0"];
            }
        }
        else if([attribute isEqualToString:@"Winter Avg High"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Winter"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                return [NSString stringWithFormat:@"%@%@", item.highValue, @"\u00B0"];
            }
        }
        else if([attribute isEqualToString:@"Winter Avg Precipitation"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Winter"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                if([item.precipitationValue integerValue] == 1) {
                    return [NSString stringWithFormat:@"%@ inch",item.precipitationValue];
                }
                else {
                    return [NSString stringWithFormat:@"%@ inches",item.precipitationValue];
                }
            }
        }
        else if([attribute isEqualToString:@"Summer Avg Low"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Summer"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                return [NSString stringWithFormat:@"%@%@", item.lowValue, @"\u00B0"];
            }
        }
        else if([attribute isEqualToString:@"Summer Avg High"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Summer"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                return [NSString stringWithFormat:@"%@%@", item.highValue, @"\u00B0"];
            }
        }
        else if([attribute isEqualToString:@"Summer Avg Precipitation"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Summer"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                if([item.precipitationValue integerValue] == 1) {
                    return [NSString stringWithFormat:@"%@ inch",item.precipitationValue];
                }
                else {
                    return [NSString stringWithFormat:@"%@ inches",item.precipitationValue];
                }
            }
        }
        else if([attribute isEqualToString:@"Spring Avg Low"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Spring"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                return [NSString stringWithFormat:@"%@%@", item.lowValue, @"\u00B0"];
            }
        }
        else if([attribute isEqualToString:@"Spring Avg High"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Spring"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                return [NSString stringWithFormat:@"%@%@", item.highValue, @"\u00B0"];
            }
        }
        else if([attribute isEqualToString:@"Spring Avg Precipitation"]) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",@"Spring"];
            STCAverageWeatherItem *item =  [averageaWeatherItems filteredOrderedSetUsingPredicate:predicate][0];
            
            if(item) {
                if([item.precipitationValue integerValue] == 1) {
                    return [NSString stringWithFormat:@"%@ inch",item.precipitationValue];
                }
                else {
                    return [NSString stringWithFormat:@"%@ inches",item.precipitationValue];
                }
            }
        }
    }
    
    return @"";
}

- (id) getCollegeSectionForSectionID:(NSNumber *) sectionID inCollege:(STCollege *) college {
    
    NSOrderedSet *collegeSections = college.collegeSections;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sectionID == %@",sectionID];
    NSOrderedSet *filteredSet = [collegeSections filteredOrderedSetUsingPredicate:predicate];
    
    if(filteredSet && ([filteredSet count] > 0)) {
        return filteredSet[0];
    }
    
    return nil;
}

- (void)dealloc {
    
    STLog(@"compare dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.compareItems = nil;
    self.sectionDetailsArray = nil;
    self.delegate = nil;
}

@end
