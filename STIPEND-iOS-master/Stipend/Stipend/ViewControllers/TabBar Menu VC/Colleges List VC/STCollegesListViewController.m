//
//  STCollegesListViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 12/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCollegesListViewController.h"
#import "STFilterViewController.h"
#import "STCollegePageReorderViewController.h"
#import "STCollegeDetailViewController.h"
#import "STLocationViewController.h"
#import "STCollege.h"
#import "STFavoriteCell.h"
#import "STNavigationtitle.h"
#import "STRecentSearchItem.h"
#import "STFilter.h"
#import "STFilterCollegeType.h"
#import "STFilterRangeItem.h"
#import "STFavorites.h"
#import "STDefaultCollege.h"
#import "STPrivacyPolicyManager.h"
#import "STFilterAdmissionType.h"

#import "STTutorialView.h"
#import "STIntroductionViewController.h"

#define DEFAULT_HEADER_VIEW_HEIGHT      self.view.bounds.size.height/2
#define TABLEVIEW_FOOTER_HEIGHT         70.0
#define SECTION_HEADER_HEIGHT           70.0
#define SECTION_FOOTER_HEIGHT           40.0
#define SEARCH_ROW_HEIGHT               60.0
#define RECENT_SEARCH_ROW_HEIGHT        50.0
#define BLUR_VIEW_HEIGHT                150.0
#define ADDRESS_ROW_HEIGHT              100.0
#define SUB_HEADER_HEIGHT               150.0

#define TAB_BAR_HEIGHT                  self.tabBarController.tabBar.frame.size.height; //49.0

#define MAX_RECENT_SEARCH_COUNT         10
#define MAX_NEARBY_DISTANCE             500000


@interface STCollegesListViewController () {
}

@property (nonatomic, assign) BOOL isCollegeSelected;

@end

@implementation STCollegesListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollegesData:) name:UIApplicationWillEnterForegroundNotification object:nil];

    [self.searchResultTableview registerNib:[UINib nibWithNibName:@"STFavoriteCell" bundle:nil] forCellReuseIdentifier:@"FavoriteCell"];
    
    [[STLocationManager sharedManager] startUpdatingLocation];
    
    // Checking for new privacy message if any
    [[STPrivacyPolicyManager sharedManager] setupInitialStatusForPrivacyPolicyIfNeed];
    
    // Checking for default college if any
    [self showDefaultCollege];
    [self checkForRatingStatus];
    
    // Checking for new privacy message if any
//    [[STPrivacyPolicyManager sharedManager] checkIfPrivacyMessageIsUpdatedAndShowInView:self.tabBarController.view];
}

- (void)updateCollegesData:(NSNotification *)notification {
    
    if([[STUserManager sharedManager] lastUpdatedDate] != nil) {
        
        NSDate *lastUpdatedDate = [[STUserManager sharedManager] lastUpdatedDate];
        NSDate *currentDate = [NSDate date];
        
        NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:lastUpdatedDate];
        double secondsInAnHour = 3600;
        NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
        
        if(hoursBetweenDates > 24) {
           
            [[STUserManager sharedManager] setHasLoadedCollegeList:NO];
            [[STUserManager sharedManager] setShouldReloadData:NO];
            
            [self fetchCollegeLists];
        }
    }
    
    // Checking for default college if any
    [self showDefaultCollege];
    [self checkForRatingStatus];
    
    // Checking for new privacy message if any
//    [[STPrivacyPolicyManager sharedManager] checkIfPrivacyMessageIsUpdatedAndShowInView:self.tabBarController.view];
    [self checkIfPrivacyPopupUpdated];
}

- (void) checkForRatingStatus {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int ratingCount = [[userDefaults objectForKey:RATING_STATUS_KEY] intValue];
    NSDate *appV26LunchDate = (NSDate *)[userDefaults objectForKey:APP_v26_LAUNCH_DATE];
    
    if(appV26LunchDate) {
        
        NSInteger days = [[[NSCalendar currentCalendar] components: NSCalendarUnitDay
                                                           fromDate: appV26LunchDate
                                                             toDate: [NSDate date]
                                                            options: 0] day];
        BOOL presentPopup = NO;

        NSInteger noOfWeeks = days / 7;
        
        if(ratingCount == 0 && noOfWeeks >= 1) { // 1 weeks
            presentPopup = YES;
        } else if(ratingCount == 1 && noOfWeeks >= 3) { // 3 weeks
            presentPopup = YES;
        } else if(ratingCount == 2 && noOfWeeks >= 12) { // 3 months
            presentPopup = YES;
        }

        if(presentPopup) {
            if (NSClassFromString(@"SKStoreReviewController") != nil) {
                [SKStoreReviewController requestReview];
                ratingCount ++;
            }
        }
    } else {
//        NSString *str = @"9/25/2017"; // Release date of v2.0
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *date = [NSDate date]; //[formatter dateFromString:str];
        [userDefaults setObject:date forKey:APP_v26_LAUNCH_DATE];
        ratingCount = 0;
    }

    [userDefaults setObject:[NSNumber numberWithInt:ratingCount] forKey:RATING_STATUS_KEY];
    [userDefaults synchronize];
}

- (void) showDefaultCollege {
    
    [[STNetworkAPIManager sharedManager] fetchDefaultCollege:^(id response) {
       
        NSNumber * collegeID = [response objectForKey:@"collegeID"];
        NSString * date = [response objectForKey:@"date"];
        
        STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
        
        STDefaultCollege *defaultCollege = currentUser.defaultCollege;
        NSNumber * lastSeenCollegeID = defaultCollege.collegeID;
        NSString * lastSeenDate = defaultCollege.seenDate;
        
        if(((![date isEqualToString:lastSeenDate]) || ([collegeID intValue] != [lastSeenCollegeID intValue])) && collegeID.intValue > 0) {

            NSNumber *lastSeenCollege =  currentUser.lastSeenCollege;

            if([lastSeenCollege integerValue] > 0) {
                
                if(collegeID && ([collegeID intValue] != [lastSeenCollege intValue])) {
                    [self presentSimilarSchoolWithCollegeID:collegeID];
                }
                
            } else {
                
                // For new user, update "lastSeenCollege" with default college
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                    localUser.lastSeenCollege = collegeID;
                }];
            }
            
            
            // Update user details with default College and date
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@", localUser];
                
                STDefaultCollege *defaultCollegeItem = [STDefaultCollege MR_findFirstWithPredicate:predicate inContext:localContext];
                
                if(!defaultCollegeItem) {
                    defaultCollegeItem = [STDefaultCollege MR_createEntityInContext:localContext];
                }
                
                defaultCollegeItem.user = localUser;
                defaultCollegeItem.collegeID = collegeID;
                defaultCollegeItem.seenDate = date;
                
            }];
        }
    } failure:^(NSError *error) {
    }];
}

- (void) checkIfPrivacyPopupUpdated {
    [[STPrivacyPolicyManager sharedManager] checkIfPrivacyMessageIsUpdatedAndShowInView:self.tabBarController.view];
}

- (void) updateSearchResultTableHeaderView {
    
    UIView *tableHeaderView = [self.view viewWithTag:1125];
    
    if(!tableHeaderView) {
        
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.searchResultTableview.bounds.size.width, 50.0)];
        tableHeaderView.tag = 1125;
        tableHeaderView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 15.0, self.searchResultTableview.bounds.size.width - 30.0, 25.0)];
        titleLabel.tag = 1126;
        titleLabel.font = [UIFont fontType:eFontTypeAvenirHeavy FontForSize:14.0];
        titleLabel.text = @"RECENT SEARCHES";
        titleLabel.textColor = [UIColor cellLabelTextColor];
        
        [tableHeaderView addSubview:titleLabel];
        self.searchResultTableview.tableHeaderView = tableHeaderView;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkAndSyncDataIfAny];

//    [self fetchCollegeLists];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)checkAndSyncDataIfAny {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    __block BOOL favoritesSyncStatus = [[userDefaults objectForKey:FAVORITES_SYNC_STATUS] boolValue];
    __block BOOL compareSyncStatus = [[userDefaults objectForKey:COMPARE_SYNC_STATUS] boolValue];
    __block BOOL clippingsSyncStatus = [[userDefaults objectForKey:CLIPPINGS_SYNC_STATUS] boolValue];

    BOOL favoritesUpdates = [STUserManager sharedManager].favoritesUpdates;
    BOOL compareUpdates = [STUserManager sharedManager].compareUpdates;
    BOOL clippingsUpdate = [STUserManager sharedManager].clippingsUpdate;

    __weak STCollegesListViewController *weakSelf = self;

    if((![[STUserManager sharedManager] isGuestUser]) && (!favoritesSyncStatus || !compareSyncStatus || !clippingsSyncStatus)) {
        
        [STProgressHUD show];
        if(!favoritesSyncStatus) {
            [[STNetworkAPIManager sharedManager] syncFavoriteCollegesForCurrentUserWithSuccess:^(id response) {
                [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:FAVORITES_SYNC_STATUS];
                [weakSelf checkAndSyncDataIfAny];
            } failure:^(NSError *error) {
                STLog(@"****** ERROR IN UPDATING FAVORITES *****");
                favoritesSyncStatus = YES;
                [weakSelf checkAndSyncDataIfAny];
            }];
        } else if(!compareSyncStatus) {
            [[STNetworkAPIManager sharedManager] syncCompareCollegesForCurrentUserWithSuccess:^(id response) {
                [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:COMPARE_SYNC_STATUS];
                [weakSelf checkAndSyncDataIfAny];
            } failure:^(NSError *error) {
                STLog(@"****** ERROR IN UPDATING COMPARE COLLEGES *****");
                compareSyncStatus = YES;
                [weakSelf checkAndSyncDataIfAny];
            }];
        } else if(!clippingsSyncStatus) {
            [[STNetworkAPIManager sharedManager] updateClippingsForCurrentUserWithSuccess:^(id response) {
                [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:CLIPPINGS_SYNC_STATUS];
                [weakSelf checkAndSyncDataIfAny];
            } failure:^(NSError *error) {
                STLog(@"****** ERROR IN UPDATING CLIPPINGS *****");
                clippingsSyncStatus = YES;
                [weakSelf checkAndSyncDataIfAny];
            }];
        }
    } else if((![[STUserManager sharedManager] isGuestUser]) && (!favoritesUpdates || !compareUpdates || !clippingsUpdate)) {

        [STProgressHUD show];
        if(!favoritesUpdates) {
            [[STNetworkAPIManager sharedManager] getFavoriteCollegesForCurrentUserWithSuccess:^(id response) {
                [STUserManager sharedManager].favoritesUpdates = true;
                [weakSelf checkAndSyncDataIfAny];
            } failure:^(NSError *error) {
                STLog(@"****** ERROR IN FECTHING FAVORITES *****");
                [STUserManager sharedManager].favoritesUpdates = true;
                [weakSelf checkAndSyncDataIfAny];
            }];
        } else if(!compareUpdates) {
            [[STNetworkAPIManager sharedManager] getCompareCollegesForCurrentUserWithSuccess:^(id response) {
                [STUserManager sharedManager].compareUpdates = true;
                [weakSelf checkAndSyncDataIfAny];
            } failure:^(NSError *error) {
                STLog(@"****** ERROR IN FECTHING COMPARE COLLEGES *****");
                [STUserManager sharedManager].compareUpdates = true;
                [weakSelf checkAndSyncDataIfAny];
            }];
        } else if(!clippingsUpdate) {
            [[STNetworkAPIManager sharedManager] getClippingsForCurrentUserWithSuccess:^(id response) {
                [STUserManager sharedManager].clippingsUpdate = true;
                [weakSelf checkAndSyncDataIfAny];
            } failure:^(NSError *error) {
                STLog(@"****** ERROR IN FECTHING CLIPPINGS *****");
                [STUserManager sharedManager].clippingsUpdate = true;
                [weakSelf checkAndSyncDataIfAny];
            }];
        }
    } else {
        [STProgressHUD dismiss];
        [self fetchCollegeLists];
    }
}

- (IBAction)onReloadAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if(button.tag == eActionTypeResetFilter) {
        [[STUserManager sharedManager] resetFilterWithCompletion:^(BOOL contextDidSave) {
            [self fetchCollegeLists];
        }];
    }
    else {
        [self fetchCollegeLists];
    }
}

- (void) fetchCollegeLists {

    if(![[STUserManager sharedManager] hasLoadedCollegeList]) {
        
        [STProgressHUD show];
        self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = NO;
        NSMutableDictionary *details = [NSMutableDictionary dictionary];
        [details setObject:[NSNumber numberWithInteger:0] forKey:kFetchOffset];
        [details setObject:[NSNumber numberWithInteger:40] forKey:kFetchSize];
        
        NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

        NSString *previousVersionNo = [[NSUserDefaults standardUserDefaults] objectForKey:PREVIOUS_VERSION_NO];
        
        if(previousVersionNo && [previousVersionNo isEqualToString:appVersionString]) {
            if([[NSUserDefaults standardUserDefaults] objectForKey:LAST_UPDATED_DATE]) {
                NSString *lastUpdatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_UPDATED_DATE];
                [details setObject:lastUpdatedDate forKey:kLastUpdatedDate];
            }
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:appVersionString forKey:PREVIOUS_VERSION_NO];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:LAST_UPDATED_DATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        __weak STCollegesListViewController *weakSelf = self;
        
        [[STNetworkAPIManager sharedManager] fetchCollegeListsWithDetails:details success:^(id response) {
            [[STUserManager sharedManager] setHasLoadedCollegeList:YES];
            [[STUserManager sharedManager] setShouldReloadData:YES];
            [[STUserManager sharedManager] setLastUpdatedDate:[NSDate date]];
            
            [STProgressHUD dismiss];
            [weakSelf fetchAllColleges];
//            [weakSelf fetchMajorsData];
            self.networkErrorView.hidden = YES;
        } failure:^(NSError *error) {
            [STProgressHUD dismiss];
            
            self.networkErrorView.hidden = NO;
            self.errorTitleLabel.text = @"Unable to load Colleges";
            self.errorSubTitleLabel.text = @"Check your network connection and try agian";
            [self.reloadButton setTitle:@"Reload" forState:UIControlStateNormal];
            [self.reloadButton setTag:eActionTypeReloadCollege];
            self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = YES;
        }];
    }
    else {
        [self fetchAllColleges];
    }
}

- (void) fetchMajorsData {

    NSMutableDictionary *details = [NSMutableDictionary dictionary];
    [details setObject:[NSNumber numberWithInteger:0] forKey:kFetchOffset];
    [details setObject:[NSNumber numberWithInteger:40] forKey:kFetchSize];
    
    NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *previousVersionNo = [[NSUserDefaults standardUserDefaults] objectForKey:PREVIOUS_VERSION_NO];
    
    if(previousVersionNo && [previousVersionNo isEqualToString:appVersionString]) {
        if([[NSUserDefaults standardUserDefaults] objectForKey:LAST_MAJORS_UPDATED_DATE]) {
            NSString *lastUpdatedDate = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_MAJORS_UPDATED_DATE];
            [details setObject:lastUpdatedDate forKey:kLastUpdatedDate];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:appVersionString forKey:PREVIOUS_VERSION_NO];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LAST_MAJORS_UPDATED_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[STNetworkAPIManager sharedManager] fetchCollegeMajorsListWithDetails:details success:^(id response) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void) fetchAllColleges {
    
    BOOL isFilterApplied = [[STUserManager sharedManager] isFilterApplied];
    BOOL shouldReloadData = [[STUserManager sharedManager] shouldReloadData];
    
    if(!shouldReloadData) {
        return;
    }
    else {
        [[STUserManager sharedManager] setShouldReloadData:NO];
    }
    
    if(!isFilterApplied) {
        
        self.collegeList = [self getCollegeListWithoutApplyingFilter];
        
        STLog(@"colleges list : %ld", (unsigned long)self.collegeList.count);
        
        if(self.collegeList && ([self.collegeList count] > 0)) {
            
            STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
            NSNumber *lastSeenCollege =  currentUser.lastSeenCollege;
            
            if([lastSeenCollege integerValue] > 0) {
                NSNumber *selectedCollegeID = lastSeenCollege;
                self.selectedCollegeIndex = [self getIndexOfCollegeWithID:selectedCollegeID];
            }
            else {
                self.selectedCollegeIndex = [self getIndexOfCollegeForUserLocation];
            }
            
            [self initializeCollegeListView];
            [self updateCollgeListViewWithCollegeAtIndex:self.selectedCollegeIndex];
        }
        else {
            STLog(@"*********** NO COLLEGE **********");
        }
    }
    else {
        
        self.collegeList = [self getCollegeListAfterApplylingFilter];
        
        STLog(@"colleges list : %ld", (unsigned long)self.collegeList.count);

        if(self.collegeList && ([self.collegeList count] > 0)) {
            
            STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
            NSNumber *lastSeenCollege =  currentUser.lastSeenCollege;
            
            if([lastSeenCollege integerValue] > 0) {
                NSNumber *selectedCollegeID = lastSeenCollege;
                self.selectedCollegeIndex = [self getIndexOfCollegeWithID:selectedCollegeID];
            }
            else {
                self.selectedCollegeIndex = 0;
            }
            
            self.networkErrorView.hidden = YES;
            [self initializeCollegeListView];
            [self updateCollgeListViewWithCollegeAtIndex:self.selectedCollegeIndex];
        }
        else {
            
            [self.pageController willMoveToParentViewController:nil];
            [[self.pageController view] removeFromSuperview];
            [self.pageController removeFromParentViewController];
            self.pageController = nil;
            
            self.networkErrorView.hidden = NO;
            self.errorTitleLabel.text = @"No colleges found";
            self.errorSubTitleLabel.text = @"Reduce the amount of filters you have and try again.";
            self.reloadButton.hidden = YES;
            [self.reloadButton setTitle:@"Reset Filter" forState:UIControlStateNormal];
            [self.reloadButton setTag:eActionTypeResetFilter];
            
//            self.navigationItem.titleView = nil;
            self.navigationItem.leftBarButtonItem = nil;
            
            UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [filterButton setBackgroundImage:[UIImage imageNamed:@"navbar_filter_active"]
                              forState:UIControlStateNormal];
            [filterButton addTarget:self action:@selector(onFilterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            filterButton.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
            
            UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
            self.navigationItem.rightBarButtonItem = filterBarButton;
            
//            UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenuItems:)];
//
//            [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:menuBarButtonItem, nil] animated:YES];
            
            self.navigationItem.rightBarButtonItems = nil;
            self.navigationItem.rightBarButtonItem = filterBarButton;
        }
    }
    self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = YES;

}

- (NSArray *) getCollegeListWithoutApplyingFilter {
    
    NSInteger sortType = [[[[STUserManager sharedManager] getCurrentUserInDefaultContext] sortOrder] integerValue];
    
    NSFetchRequest *fetchRequest;
    
    
    BOOL hasLocationAccess = [[STLocationManager sharedManager] hasAccessToLocationServices];
    
    if(!hasLocationAccess && (sortType == 7)) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            STUser *localUser = [[[STUserManager sharedManager] getCurrentUserInDefaultContext] MR_inContext:localContext];
            localUser.sortOrder = [NSNumber numberWithInteger:0];
        }];
        
        sortType = 0;
    }

    switch (sortType) {
        case 0:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"collegeName" ascending:YES];
            break;
        case 1:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"totalFreshmens,collegeName" ascending:YES];
            break;
        case 2:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"averageGPA,collegeName" ascending:YES];
            break;
        case 3:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"averageSATNew,collegeName" ascending:YES];
            break;
        case 4:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"averageACT,collegeName" ascending:YES];
            break;
        case 5:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"acceptanceRate,collegeName" ascending:YES];
            break;
        case 6:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"sixYrGraduationRate,collegeName" ascending:YES];
            break;
        case 7:
        default:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"collegeID" ascending:YES];
            break;
    }
    
    NSArray *collegeList;
    
    if(sortType == 7) {
        
        [fetchRequest setPropertiesToFetch:@[@"collegeID", @"collegeName", @"place", @"appleLattitude",@"appleLongitude"]];
        [fetchRequest setResultType: NSDictionaryResultType];
        
        STUser *localUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
        
        if ([localUser.isAdmin boolValue] == NO) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isActive == %@", [NSNumber numberWithBool:YES]];
            [fetchRequest setPredicate:predicate];
        }
        
        NSArray *collegeArray = [STCollege MR_executeFetchRequest:fetchRequest];
        
        CLLocation *currentLocation = [[STLocationManager sharedManager] currentLocation];//[[CLLocation alloc] initWithLatitude:40.7127 longitude:-74.0059];//New York Lat Lon
        
        if(currentLocation != nil) {
            NSArray *sortByDistanceArray = [collegeArray sortedArrayUsingComparator:^(id a,id b) {
                NSDictionary *collegeOneDetails = (NSDictionary *)a;
                NSDictionary *collegeTwoDetails = (NSDictionary *)b;
                
                @autoreleasepool {
                    
                    CLLocation *collegeOneLocation = [[CLLocation alloc] initWithLatitude:[[collegeOneDetails objectForKey:@"appleLattitude"] doubleValue] longitude:[[collegeOneDetails objectForKey:@"appleLongitude"] doubleValue]];
                    CLLocation *collegeTwoLocation = [[CLLocation alloc] initWithLatitude:[[collegeTwoDetails objectForKey:@"appleLattitude"] doubleValue] longitude:[[collegeTwoDetails objectForKey:@"appleLongitude"] doubleValue]];
                    
                    CLLocationDistance distanceA = [collegeOneLocation distanceFromLocation:currentLocation];
                    CLLocationDistance distanceB = [collegeTwoLocation distanceFromLocation:currentLocation];
                    if (distanceA < distanceB) {
                        return NSOrderedAscending;
                    } else if (distanceA > distanceB) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }
            }];
            collegeList = [NSMutableArray arrayWithArray:sortByDistanceArray];
        }
        else {
            collegeList = [NSMutableArray arrayWithArray:collegeArray];
        }
    }
    else {
        
        [fetchRequest setPropertiesToFetch:@[@"collegeID", @"collegeName", @"place", @"appleLattitude", @"appleLongitude"]];
        [fetchRequest setResultType: NSDictionaryResultType];
        
        STUser *localUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
        
        if ([localUser.isAdmin boolValue] == NO) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isActive == %@", [NSNumber numberWithBool:YES]];
            [fetchRequest setPredicate:predicate];
        }
        
        collegeList = [STCollege MR_executeFetchRequest:fetchRequest];
    }

    STLog(@"List of colleges without filter: %lu", collegeList.count);

    return collegeList;
}

- (NSArray *) getCollegeListAfterApplylingFilter {
    
//    [STProgressHUD show];
    
    STFilter *filter = [STFilter MR_findAll].firstObject;
    
    NSString *predicateString;
    
    // State Code value
    
    if(![filter.stateCode isEqualToString:@"All"]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND state == \"%@\"", predicateString, filter.stateCode];
        } else {
            
            NSArray *stateCodesList = [filter.stateCode componentsSeparatedByString:@","];
            
            if(stateCodesList.count > 1) {
                NSString *stateString;
                
                for(NSString *stateCode in stateCodesList) {
                    if(stateString.length == 0) {
                        stateString = [NSString stringWithFormat:@"state == \"%@\"", stateCode];
                    } else {
                        stateString = [NSString stringWithFormat:@"%@ OR state == \"%@\"", stateString, stateCode];
                    }
                }
                
                predicateString = [NSString stringWithFormat:@"(%@)", stateString];

            } else {
                predicateString = [NSString stringWithFormat:@"state == \"%@\"", [stateCodesList objectAtIndex:0]];
            }
        }
    }
    
    // Religious Affiliation value
    
    if(![filter.religiousAffiliation isEqualToString:@"All"]) {
        
        NSArray *religiousList = [filter.religiousAffiliation componentsSeparatedByString:@","];
        
        if(religiousList.count > 1) {
            NSString *religiousString;
            
            for(NSString *religious in religiousList) {
                if(religiousString.length == 0) {
                    religiousString = [NSString stringWithFormat:@"religiousAffiliation == \"%@\"", religious];
                } else {
                    religiousString = [NSString stringWithFormat:@"%@ OR religiousAffiliation == \"%@\"", religiousString, religious];
                }
            }
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND (%@)", predicateString, religiousString];
            } else {
                predicateString = [NSString stringWithFormat:@"(%@)", religiousString];
            }
        } else {
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND religiousAffiliation == \"%@\"", predicateString, [religiousList objectAtIndex:0]];
            } else {
                predicateString = [NSString stringWithFormat:@"religiousAffiliation == \"%@\"", [religiousList objectAtIndex:0]];
            }
        }
    }
    
    // Test Optional
    
    if([filter.testOptional boolValue]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND testOptional == %@", predicateString, filter.testOptional];
        } else {
            predicateString = [NSString stringWithFormat:@"testOptional == %@", filter.testOptional];
        }
    }
    
    // College type values
    
    if([filter.collegeType.isUniversity boolValue] && [filter.collegeType.isCollege boolValue]) {
       
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND (collegeType == %@ OR collegeType == %@)", predicateString, @"1", @"2"];
        } else {
            predicateString = [NSString stringWithFormat:@"(collegeType == %@ OR collegeType == %@)", @"1", @"2"];
        }
    } else {
        
        if([filter.collegeType.isUniversity boolValue]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, @"collegeType == 1"];
            } else {
                predicateString = [NSString stringWithFormat:@"%@", @"collegeType == 1"];
            }
        }
        
        if([filter.collegeType.isCollege boolValue]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, @"collegeType == 2"];
            } else {
                predicateString = [NSString stringWithFormat:@"%@", @"collegeType == 2"];
            }
        }
    }

    
    // College Area type values
    
    if([filter.collegeType.isCity boolValue] && [filter.collegeType.isTown boolValue] && [filter.collegeType.isRural boolValue]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND (collegeAreaType == %@ OR collegeAreaType == %@ OR collegeAreaType == %@)", predicateString, @"1", @"2", @"3"];
        } else {
            predicateString = [NSString stringWithFormat:@"(collegeAreaType == %@ OR collegeAreaType == %@ OR collegeAreaType == %@)", @"1", @"2", @"3"];
        }
        
    } else if ([filter.collegeType.isCity boolValue] && [filter.collegeType.isTown boolValue]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND (collegeAreaType == %@ OR collegeAreaType == %@)", predicateString, @"1", @"2"];
        } else {
            predicateString = [NSString stringWithFormat:@"(collegeAreaType == %@ OR collegeAreaType == %@)", @"1", @"2"];
        }
        
    } else if([filter.collegeType.isTown boolValue] && [filter.collegeType.isRural boolValue]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND (collegeAreaType == %@ OR collegeAreaType == %@)", predicateString, @"2", @"3"];
        } else {
            predicateString = [NSString stringWithFormat:@"(collegeAreaType == %@ OR collegeAreaType == %@)", @"2", @"3"];
        }
        
    } else if ([filter.collegeType.isCity boolValue] && [filter.collegeType.isRural boolValue]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND (collegeAreaType == %@ OR collegeAreaType == %@)", predicateString, @"1", @"3"];
        } else {
            predicateString = [NSString stringWithFormat:@"(collegeAreaType == %@ OR collegeAreaType == %@)", @"1", @"3"];
        }
        
    } else {
        
        if([filter.collegeType.isCity boolValue]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, @"collegeAreaType == 1"];
            } else {
                predicateString = [NSString stringWithFormat:@"%@", @"collegeAreaType == 1"];
            }
        }
        
        if([filter.collegeType.isTown boolValue]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, @"collegeAreaType == 2"];
            } else {
                predicateString = [NSString stringWithFormat:@"%@", @"collegeAreaType == 2"];
            }
        }
        
        if([filter.collegeType.isRural boolValue]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, @"collegeAreaType == 3"];
            } else {
                predicateString = [NSString stringWithFormat:@"%@", @"collegeAreaType == 3"];
            }
        }
    }
    
    
    // College Access type values
    
    if([filter.collegeType.isPublic boolValue] && [filter.collegeType.isPrivate boolValue]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND (collegeAccessType == %@ OR collegeAccessType == %@)", predicateString, @"1", @"2"];
        } else {
            predicateString = [NSString stringWithFormat:@"(collegeAccessType == %@ OR collegeAccessType == %@)", @"1", @"2"];
        }
    } else {
        
        if([filter.collegeType.isPublic boolValue]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, @"collegeAccessType == 1"];
            } else {
                predicateString = [NSString stringWithFormat:@"%@", @"collegeAccessType == 1"];
            }
        }
        
        if([filter.collegeType.isPrivate boolValue]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, @"collegeAccessType == 2"];
            } else {
                predicateString = [NSString stringWithFormat:@"%@", @"collegeAccessType == 2"];
            }
        }
    }
    
    
     // College Admission type values
    
    NSNumber *trueBool = [NSNumber numberWithBool:YES];
    
    if([filter.admissionType.isEarlyDecision boolValue] && [filter.admissionType.isEarlyAction boolValue] && [filter.admissionType.isCommonApp boolValue]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND (earlyDecision == %@ AND earlyAction == %@ AND commonApplicationAccepted == %@)", predicateString, trueBool, trueBool, trueBool];
        } else {
            predicateString = [NSString stringWithFormat:@"(earlyDecision == %@ AND earlyAction == %@ AND commonApplicationAccepted == %@)", trueBool, trueBool, trueBool];
        }
    } else if ([filter.admissionType.isEarlyDecision boolValue] && [filter.admissionType.isEarlyAction boolValue]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND (earlyDecision == %@ AND earlyAction == %@)", predicateString, trueBool, trueBool];
        } else {
            predicateString = [NSString stringWithFormat:@"(earlyDecision == %@ AND earlyAction == %@)", trueBool, trueBool];
        }
        
    } else if([filter.admissionType.isEarlyAction boolValue] && [filter.admissionType.isCommonApp boolValue]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND (earlyAction == %@ AND commonApplicationAccepted == %@)", predicateString, trueBool, trueBool];
        } else {
            predicateString = [NSString stringWithFormat:@"(earlyAction == %@ AND commonApplicationAccepted == %@)", trueBool, trueBool];
        }
        
    } else if ([filter.admissionType.isEarlyDecision boolValue] && [filter.admissionType.isCommonApp boolValue]) {
        
        if(predicateString.length > 0) {
            predicateString = [NSString stringWithFormat:@"%@ AND (earlyDecision == %@ AND commonApplicationAccepted == %@)", predicateString, trueBool, trueBool];
        } else {
            predicateString = [NSString stringWithFormat:@"(earlyDecision == %@ AND commonApplicationAccepted == %@)", trueBool, trueBool];
        }
        
    } else {
        
        if([filter.admissionType.isEarlyDecision boolValue]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, @"earlyDecision == 1"];
            } else {
                predicateString = [NSString stringWithFormat:@"%@", @"earlyDecision == 1"];
            }
        }
        
        if([filter.admissionType.isEarlyAction boolValue]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, @"earlyAction == 1"];
            } else {
                predicateString = [NSString stringWithFormat:@"%@", @"earlyAction == 1"];
            }
        }
        
        if([filter.admissionType.isCommonApp boolValue]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND %@", predicateString, @"commonApplicationAccepted == 1"];
            } else {
                predicateString = [NSString stringWithFormat:@"%@", @"commonApplicationAccepted == 1"];
            }
        }
    }
    
    double minDistanceItem = 0.0f;
    double maxDistanceItem = 0.0f;
    
    for(STFilterRangeItem *rangeItem in filter.filterRangeItems) {
        
        if([rangeItem.rangeName isEqualToString:@"HIGH SCHOOL GPA"]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND averageGPA >= %@ AND averageGPA <= %@",predicateString,rangeItem.curLowerValue, rangeItem.curUpperValue];
            } else {
                predicateString = [NSString stringWithFormat:@"averageGPA >= %@ AND averageGPA <= %@",rangeItem.curLowerValue, rangeItem.curUpperValue];
            }
            
        }  else if([rangeItem.rangeName isEqualToString:@"AVERAGE SAT SCORE"]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND averageSATNew >= %@ AND averageSATNew <= %@",predicateString,rangeItem.curLowerValue, rangeItem.curUpperValue];
            } else {
                predicateString = [NSString stringWithFormat:@"averageSATNew >= %@ AND averageSATNew <= %@",rangeItem.curLowerValue, rangeItem.curUpperValue];
            }
            
        } else if([rangeItem.rangeName isEqualToString:@"AVERAGE ACT COMPOSITE"]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND averageACT >= %@ AND averageACT <= %@",predicateString,rangeItem.curLowerValue, rangeItem.curUpperValue];
            } else {
                predicateString = [NSString stringWithFormat:@"averageACT >= %@ AND averageACT <= %@",rangeItem.curLowerValue, rangeItem.curUpperValue];
            }
            
        } else if([rangeItem.rangeName isEqualToString:@"ACCEPTANCE RATE"]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND acceptanceRate >= %@ AND acceptanceRate <= %@",predicateString,rangeItem.curLowerValue, rangeItem.curUpperValue];
            } else {
                predicateString = [NSString stringWithFormat:@"acceptanceRate >= %@ AND acceptanceRate <= %@",rangeItem.curLowerValue, rangeItem.curUpperValue];
            }
            
        } else if([rangeItem.rangeName isEqualToString:@"TOTAL FEES"]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND totalFees >= %@ AND totalFees <= %@",predicateString,rangeItem.curLowerValue, rangeItem.curUpperValue];
            } else {
                predicateString = [NSString stringWithFormat:@"totalFees >= %@ AND totalFees <= %@",rangeItem.curLowerValue, rangeItem.curUpperValue];
            }
            
        } else if([rangeItem.rangeName isEqualToString:@"RECEIVING FINANCIAL AID"]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND receivingFinancialAid >= %@ AND receivingFinancialAid <= %@",predicateString,rangeItem.curLowerValue, rangeItem.curUpperValue];
            } else {
                predicateString = [NSString stringWithFormat:@"receivingFinancialAid >= %@ AND receivingFinancialAid <= %@",rangeItem.curLowerValue, rangeItem.curUpperValue];
            }
        } else if([rangeItem.rangeName isEqualToString:@"SIZE OF FRESHMEN CLASS"]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND totalFreshmens >= %@ AND totalFreshmens <= %@",predicateString,rangeItem.curLowerValue, rangeItem.curUpperValue];
            } else {
                predicateString = [NSString stringWithFormat:@"totalFreshmens >= %@ AND totalFreshmens <= %@",rangeItem.curLowerValue, rangeItem.curUpperValue];
            }
        }
        else if ([rangeItem.rangeName isEqualToString:@"DISTANCE FROM CURRENT LOCATION"]) {
            minDistanceItem = ([rangeItem.curLowerValue doubleValue] * 1609.34);
            maxDistanceItem = ([rangeItem.curUpperValue doubleValue] * 1609.34);
        }
        else if([rangeItem.rangeName isEqualToString:@"4-YEAR GRADUATION RATE"]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND fourYrGraduationRate >= %@ AND fourYrGraduationRate <= %@",predicateString,rangeItem.curLowerValue, rangeItem.curUpperValue];
            } else {
                predicateString = [NSString stringWithFormat:@"fourYrGraduationRate >= %@ AND fourYrGraduationRate <= %@",rangeItem.curLowerValue, rangeItem.curUpperValue];
            }
            
        } else if([rangeItem.rangeName isEqualToString:@"6-YEAR GRADUATION RATE"]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND sixYrGraduationRate >= %@ AND sixYrGraduationRate <= %@",predicateString,rangeItem.curLowerValue, rangeItem.curUpperValue];
            } else {
                predicateString = [NSString stringWithFormat:@"sixYrGraduationRate >= %@ AND sixYrGraduationRate <= %@",rangeItem.curLowerValue, rangeItem.curUpperValue];
            }
            
        } else if([rangeItem.rangeName isEqualToString:@"1-YEAR RETENTION RATE"]) {
            
            if(predicateString.length > 0) {
                predicateString = [NSString stringWithFormat:@"%@ AND oneYrRetentionRate >= %@ AND oneYrRetentionRate <= %@",predicateString,rangeItem.curLowerValue, rangeItem.curUpperValue];
            } else {
                predicateString = [NSString stringWithFormat:@"oneYrRetentionRate >= %@ AND oneYrRetentionRate <= %@",rangeItem.curLowerValue, rangeItem.curUpperValue];
            }
        }
    }
    
    BOOL hasLocationAccess = [[STLocationManager sharedManager] hasAccessToLocationServices];
    
    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    
    NSInteger sortType = [localUser.sortOrder integerValue]; //[filter.sortOrder integerValue];
    
    STLog(@"%@", sortTypeString(sortType));

    if(!hasLocationAccess && (sortType == 7)) {
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            STFilter *localFilter = [filter MR_inContext:localContext];
            localFilter.sortOrder = [NSNumber numberWithInt:0];
        }];
        
        sortType = 0;
    }
    
    NSFetchRequest *fetchRequest;
    
    switch (sortType) {
        case 0:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"collegeName" ascending:YES];
            break;
        case 1:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"totalFreshmens,collegeName" ascending:YES];
            break;
        case 2:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"averageGPA,collegeName" ascending:YES];
            break;
        case 3:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"averageSATNew,collegeName" ascending:YES];
            break;
        case 4:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"averageACT,collegeName" ascending:YES];
            break;
        case 5:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"acceptanceRate,collegeName" ascending:YES];
            break;
        case 6:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"sixYrGraduationRate,collegeName" ascending:YES];
            break;
        case 7:
        default:
            fetchRequest = [STCollege MR_requestAllSortedBy:@"collegeID" ascending:YES];
            break;
    }
    
//    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    
    if ([localUser.isAdmin boolValue] == NO) {
        predicateString = [NSString stringWithFormat:@"%@ AND isActive == %@",predicateString, [NSNumber numberWithBool:YES]];
    }
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicateString]];
    
    if([filter.favoriteOnly boolValue]) {
        
        [fetchRequest setPropertiesToFetch:@[@"collegeID", @"collegeName", @"place", @"appleLattitude",@"appleLongitude",@"totalFreshmens",@"averageGPA",@"averageSATNew",@"averageACT",@"acceptanceRate"]];
    }
    else {
        [fetchRequest setPropertiesToFetch:@[@"collegeID", @"collegeName", @"place", @"appleLattitude",@"appleLongitude"]];
    }
    
    [fetchRequest setResultType: NSDictionaryResultType];
    
    NSMutableArray *filtereList = [NSMutableArray arrayWithArray:[STCollege MR_executeFetchRequest:fetchRequest]];
    
    CLLocationDistance maxDistance = maxDistanceItem;
    CLLocationDistance minDistance = minDistanceItem;
    CLLocation *targetLocation = [[STLocationManager sharedManager] currentLocation];
//    CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:40.7127 longitude:-74.0059];//New York Lat Lon
    
    NSArray *collegeArray;
    
    if(targetLocation != nil && (minDistanceItem != 0 || (maxDistanceItem/1609.34) != 5000)) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *collegeDetails, NSDictionary *bindings) {
            
            @autoreleasepool {
                
                double lattitude = [[collegeDetails objectForKey:@"appleLattitude"] doubleValue];
                double longitude = [[collegeDetails objectForKey:@"appleLongitude"] doubleValue];
                
                CLLocation *collegeLocation = [[CLLocation alloc] initWithLatitude:lattitude longitude:longitude];
                
                return ([collegeLocation distanceFromLocation:targetLocation] <= maxDistance && ([collegeLocation distanceFromLocation:targetLocation] >= minDistance));
            }
        }];
        
        collegeArray = [filtereList filteredArrayUsingPredicate:predicate];
    }
    else {
        collegeArray = [NSMutableArray arrayWithArray:filtereList];
    }
    
    NSMutableArray *newFilteredList = [NSMutableArray array];

    if([filter.favoriteOnly boolValue]) {
        
        NSPredicate *favPredicate = [NSPredicate predicateWithFormat:@"user == %@", [[STUserManager sharedManager] getCurrentUserInDefaultContext]];
        NSArray *favoriteList = [STFavorites MR_findAllSortedBy:@"collegeID" ascending:YES withPredicate:favPredicate];
        
        NSMutableArray *favFilteredList = [NSMutableArray array];
        for (STFavorites *favItem in favoriteList) {
            NSPredicate *favPredicate = [NSPredicate predicateWithFormat:@"collegeID == %@", favItem.collegeID];
            NSArray *filteredArray = [collegeArray filteredArrayUsingPredicate:favPredicate];
            if(filteredArray && ([filteredArray count] > 0)) {
                [favFilteredList addObject:[filteredArray objectAtIndex:0]];
            }
        }
        
        NSMutableArray *sortDescriptorArray = [NSMutableArray array];

        switch (sortType) {
            case 0: {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collegeName" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];
                break;
            }
            case 1: {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalFreshmens" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collegeName" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];

                break;
            }
            case 2: {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"averageGPA" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collegeName" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];

                break;
            }
            case 3: {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"averageSATNew" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collegeName" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];

                break;
            }
            case 4: {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"averageACT" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collegeName" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];

                break;
            }
            case 5: {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"acceptanceRate" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collegeName" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];

                break;
            }
            case 6: {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sixYrGraduationRate" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"collegeName" ascending:YES];
                [sortDescriptorArray addObject:sortDescriptor];
                
                break;
            }
            case 7:
            default:
                break;
        }
        
        newFilteredList = [NSMutableArray arrayWithArray:[favFilteredList sortedArrayUsingDescriptors:sortDescriptorArray]];
    }
    else {
        newFilteredList = [NSMutableArray arrayWithArray:collegeArray];
    }
    
    NSMutableArray *collegeList;
    
    if(sortType == 7) {
        
        CLLocation *currentLocation = [[STLocationManager sharedManager] currentLocation];
        
        if(currentLocation != nil) {
            NSArray *sortByDistanceArray = [newFilteredList sortedArrayUsingComparator:^(id a,id b) {
                NSDictionary *collegeOneDetails = (NSDictionary *)a;
                NSDictionary *collegeTwoDetails = (NSDictionary *)b;
                
                @autoreleasepool {
                    
                    CLLocation *collegeOneLocation = [[CLLocation alloc] initWithLatitude:[[collegeOneDetails objectForKey:@"appleLattitude"] doubleValue] longitude:[[collegeOneDetails objectForKey:@"appleLongitude"] doubleValue]];
                    CLLocation *collegeTwoLocation = [[CLLocation alloc] initWithLatitude:[[collegeTwoDetails objectForKey:@"appleLattitude"] doubleValue] longitude:[[collegeTwoDetails objectForKey:@"appleLongitude"] doubleValue]];
                    
                    CLLocationDistance distanceA = [collegeOneLocation distanceFromLocation:currentLocation];
                    CLLocationDistance distanceB = [collegeTwoLocation distanceFromLocation:currentLocation];
                    if (distanceA < distanceB) {
                        return NSOrderedAscending;
                    } else if (distanceA > distanceB) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }
            }];
            
            collegeList = [NSMutableArray arrayWithArray:sortByDistanceArray];
        }
        else {
            STLog(@"********* NO LOCATION *********");
            collegeList = [NSMutableArray arrayWithArray:newFilteredList];
        }
    } else {
        collegeList = [NSMutableArray arrayWithArray:newFilteredList];
    }

    // Majors

    NSMutableArray *majorCollegeList = [NSMutableArray array];

    if(filter.majors.count > 0) {

        BOOL majorsDataStatus = [[[NSUserDefaults standardUserDefaults] objectForKey:MAJORS_FETCH_STATUS] boolValue];
        
        NSOrderedSet *filterMajors = filter.majors;

        if(majorsDataStatus) {
            
//            STLog(@"Before majors time: %@", [NSDate date]);
            
            for(NSDictionary *collegeDetails in collegeList) {
                
                NSNumber *collegeId = [collegeDetails objectForKey:@"collegeID"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeId];
                STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
                
                NSOrderedSet *broadMajors = college.broadMajors;
                
                for(STBroadMajor *broadMajor in broadMajors) {
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code=%@", broadMajor.code];
                    
                    STBroadMajor *filterBroadMajor = [filterMajors filteredOrderedSetUsingPredicate:predicate].firstObject;
                    
                    if(filterBroadMajor) {
                        NSOrderedSet *collegeMajors = broadMajor.specificMajors;
                        NSOrderedSet *filterMajors = filterBroadMajor.specificMajors;
                        
//                        STLog(@"Broad major: %@", filterBroadMajor.code);

                        for(STSpecificMajor *specificMajor in filterMajors) {
                            
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code=%@", specificMajor.code];
                            
                            
                            STSpecificMajor *filterSpecificMajor = [collegeMajors filteredOrderedSetUsingPredicate:predicate].firstObject;
                            
                            if(filterSpecificMajor) {
//                                STLog(@"specific major: %@", filterSpecificMajor.code);
//                                STLog(@"College: %@, id: %@", [collegeDetails objectForKey:@"collegeName"], collegeId);
                                [majorCollegeList addObject:collegeDetails];
                                
                            }
                        }
                    }
                }
            }
        } else {
            
            NSMutableArray *majorCodes = [NSMutableArray new];
            
            for(STBroadMajor *broadMajor in filterMajors) {
                
                NSOrderedSet *specificMajors = broadMajor.specificMajors;
                
                for(STSpecificMajor *specificMajor in specificMajors) {
                    [majorCodes addObject:specificMajor.code];
                }
            }
            
            NSDictionary *response = [[STNetworkAPIManager sharedManager] getCollegesForMajorsCodes:majorCodes];
            
            if(response) {
                NSInteger errorCode = [[response objectForKey:kErrorCode] integerValue];
                if(errorCode == 0) {
                    NSArray *majorsCollegeList = [response objectForKey:kColleges];
                    for(NSDictionary *collegeDetails in collegeList) {
                        
                        NSNumber *collegeId = [collegeDetails objectForKey:@"collegeID"];
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeId];
                        
                        NSArray *filterList = [majorsCollegeList filteredArrayUsingPredicate:predicate];
                        
                        if(filterList.count > 0) {
                            [majorCollegeList addObject:collegeDetails];
                        }
                    }
                }
            }
        }
//        STLog(@"After majors time %@", [NSDate date]);
    } else {
        majorCollegeList = [NSMutableArray arrayWithArray:collegeList];
    }

//    STLog(@"List of colleges - before");
//    for(NSDictionary *dict in majorCollegeList) {
//        STLog(@"%@, %@", [dict objectForKey:@"collegeName"], [dict objectForKey:@"collegeID"]);
//    }
//    STLog(@"List of colleges - after");
//    STLog(@"List of colleges after filter: %lu", collegeList.count);
    STLog(@"List of colleges after filter: %lu", majorCollegeList.count);

    [STProgressHUD dismiss];
    return majorCollegeList;
}

- (void) initializeCollegeListView {
    
    if(!self.pageController) {
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        self.pageController.dataSource = self;
        self.pageController.delegate = self;
        [[self.pageController view] setFrame:[[self view] bounds]];
        
        [self addChildViewController:self.pageController];
        [[self view] addSubview:[self.pageController view]];
        [self.pageController didMoveToParentViewController:self];
    }
    
    [self setUpNavigationbar];
}

- (void) updateCollgeListViewWithCollegeAtIndex:(NSInteger) index {
    
    STCollegeDetailViewController *initialViewController = [self viewControllerAtIndex:index];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    @try {
        if(viewControllers.count > 0) {
            
            [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            
            NSNumber *collegeID = [[self.collegeList objectAtIndex:index] objectForKey:@"collegeID"];
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                localUser.lastSeenCollege = collegeID;
            }];
        }
    }
    @catch (NSException *exception) {
        STLog(@"%@", exception.reason);
    }
}

#pragma mark COLLECTION VIEW DATASOURCE

- (STCollegeDetailViewController *)viewControllerAtIndex:(NSUInteger)index {

    if(self.collegeList && ([self.collegeList count] > 0)) {
        NSDictionary *collegeDetails = [self.collegeList objectAtIndex:index];
        
//        STCollegeDetailViewController *detailViewController = [[STCollegeDetailViewController alloc] initWithNibName:@"STCollegeDetailViewController" bundle:nil];

        UIStoryboard *tabBarStoryBoard = [UIStoryboard storyboardWithName:@"TabBarMenu" bundle:nil];
        
         STCollegeDetailViewController *detailViewController = [tabBarStoryBoard instantiateViewControllerWithIdentifier:@"STCollegeDetailViewController"];
        
        detailViewController.collegeID = [collegeDetails objectForKey:@"collegeID"];
        detailViewController.index = index;
        
        __weak STCollegesListViewController *weakSelf = self;

        detailViewController.sortActionBlock = ^{
            [weakSelf fetchCollegeLists];
        };
        
        
        detailViewController.mapClickedAction = ^(NSDictionary *locationDetails, NSNumber *collegeID) {
            [weakSelf collegeLocationDetails:locationDetails andCollegeID:collegeID];
        };
        
        detailViewController.similarSchoolAction = ^(NSNumber *collegeID) {
            [weakSelf presentSimilarSchoolWithCollegeID:collegeID];
        };
        
        detailViewController.updateNavigationBarWithCollegeDetails = ^(NSNumber *collegeID) {
            [weakSelf updateNavigationBarWithCollegeID:collegeID];
        };
        
        detailViewController.privacyPopupActionBlock = ^{
            [weakSelf checkIfPrivacyPopupUpdated];
        };
        
        return detailViewController;
    }
       
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(STCollegeDetailViewController *)viewController index];

    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(STCollegeDetailViewController *)viewController index];
    index++;
    
    if (index == self.collegeList.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {

    self.navigationController.navigationBar.userInteractionEnabled = NO;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    self.navigationController.navigationBar.userInteractionEnabled = YES;

    if(completed) {
        STLog(@"completed");
        
        STCollegeDetailViewController *controller = [pageViewController.viewControllers lastObject];
        NSNumber *collegeID = [controller collegeID];

        self.selectedCollegeIndex = [self getIndexOfCollegeWithID:collegeID];

        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
            localUser.lastSeenCollege = collegeID;
        }];
        
        if((self.selectedCollegeIndex > 0) && (self.selectedCollegeIndex < [self.collegeList count])) {
            STCollegeDetailViewController *previousVC = [previousViewControllers lastObject];
            if(previousVC) {
                [previousVC resetValues];
            }
        }
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 1;
}

- (void)collegeLocationDetails:(NSDictionary *)locationDetails andCollegeID:(NSNumber *)collegeID {
    
    STLocationViewController *locationViewController = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationViewController"];
    locationViewController.locationDetails = locationDetails;
    locationViewController.collegeID = collegeID;
    
    [self.navigationController pushViewController:locationViewController animated:YES];
}

#pragma mark SETUP NAV BAR

- (void)updateNavigationBarWithCollegeID:(NSNumber *)collegeID {

    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@",collegeID]];
    
    
    if(college) {
        
        STNavigationtitle *customTitleView = nil;

        if(!customTitleView) {
            
            customTitleView = [[NSBundle mainBundle] loadNibNamed:@"STNavigationtitle" owner:self options:nil][0];
            customTitleView.frame = CGRectMake(0.0, 0.0, ([UIScreen mainScreen].bounds.size.width - 100.0), 44.0);
            customTitleView.backgroundColor = [UIColor clearColor];
            customTitleView.isPresenting = NO;
//            self.navigationItem.titleView = customTitleView;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customTitleView];
            
        }
        
        if([college isKindOfClass:[STCollege class]]) {
            
            [customTitleView updateNavigationTitleWithCollegeName:college.collegeName andPlace:college.place];
        }
    } else {
        
//        self.navigationItem.titleView = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)setUpNavigationbar {
    
    __weak STCollegesListViewController *weakSelf = self;
    
   // UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenuItems:)];
    //[self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:menuBarButtonItem, nil] animated:YES];
    
    self.navigationItem.hidesBackButton = YES;
    
    
    BOOL isFilterApplied = [[STUserManager sharedManager] isFilterApplied];
    
    UIButton *filterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    if(!isFilterApplied) {
        [filterButton setBackgroundImage:[UIImage imageNamed:@"navbar_filter"]
                                forState:UIControlStateNormal];
    }
    else {
        [filterButton setBackgroundImage:[UIImage imageNamed:@"navbar_filter_active"]
                                forState:UIControlStateNormal];
    }
    
    [filterButton addTarget:self action:@selector(onFilterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    filterButton.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
    [filterButton setContentMode:UIViewContentModeCenter];

    UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_searchicon"] style:UIBarButtonItemStylePlain target:self action:@selector(onSearchFieldAction:)];
    

    self.rightBarButtonItems = [NSArray arrayWithObjects:filterBarButton, searchBarButton, nil];
    [self.navigationItem setRightBarButtonItems:self.rightBarButtonItems animated:NO];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.searchResultTableview.alpha = 0.0;
    } completion:^(BOOL finished) {
        weakSelf.searchResultTableview.hidden = YES;
    }];
}

#pragma mark NAV BAR ACTIONS

- (void)showMenuItems:(id)sender {
    
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

- (void)onSearchFieldAction:(id)sender {
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    [self showSearchBar];
}

- (void) showSearchBar {

    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.searchBar.placeholder = @"Search";
    self.searchBar.tintColor = [UIColor cursorColor];
    self.searchBar.keyboardType = UIKeyboardTypeASCIICapable;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(searchBarCancelButtonClicked:)];
    }
    
    if ([self.searchBar respondsToSelector:@selector(setReturnKeyType:)]) {
        self.searchBar.returnKeyType = UIReturnKeyDone; // This returnType will support in iOS 7.1 and above.
    }
    
    
    
    [self updateSearchResultTableHeaderView];
    [self.view bringSubviewToFront:self.searchResultTableview];
    self.searchResultTableview.backgroundColor = [UIColor whiteColor];
    self.searchResultTableview.hidden = NO;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        self.searchResultTableview.alpha = 1.0;
        [self.searchBar becomeFirstResponder];
    }
    else{
    __weak STCollegesListViewController *weakSelf = self;

    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.searchResultTableview.alpha = 1.0;
    } completion:^(BOOL finished) {
        [weakSelf.searchBar becomeFirstResponder];
    }];
    }
    
}

- (void)onFilterButtonAction:(id)sender {
    
    if(STUserManager.sharedManager.isGuestUser) {
        [self showLoginController];
        return;
    }
    
    STFilterViewController *filterViewController = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"FilterStoryBoardNavID"];
    [self presentViewController:filterViewController animated:YES completion:nil];
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

#pragma mark KEYBORAD NOTIFICATIONS

- (void)keyboardDidShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.searchTableBottomConstraint.constant = kbSize.height - TAB_BAR_HEIGHT;
    
    [self.searchResultTableview setNeedsUpdateConstraints];
    [self.searchResultTableview layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.searchTableBottomConstraint.constant = 0.0;
    [self.searchResultTableview setNeedsUpdateConstraints];
    [self.searchResultTableview layoutIfNeeded];

    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad && !self.isCollegeSelected) {
//        [self updateCollgeListViewWithCollegeAtIndex:self.selectedCollegeIndex];
//        self.navigationItem.rightBarButtonItem = nil;
    }

    self.isCollegeSelected = NO;
}

#pragma mark SEARCH BAR DELEGATES

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self updateCollgeListViewWithCollegeAtIndex:self.selectedCollegeIndex];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if(self.searchArray.count > 0) {
        NSDictionary *itemDict = [self.searchArray objectAtIndex:0];
        
        if([itemDict isKindOfClass:[STRecentSearchItem class]]) {
            STRecentSearchItem *item = [self.searchArray objectAtIndex:0];
            [self updateCollgeToCollegeWithID:item.collegeID];
        } else {
            [self updateCollgeToCollegeWithID:[itemDict objectForKey:@"collegeID"]];
        }
    }
    else {
        [self updateCollgeListViewWithCollegeAtIndex:self.selectedCollegeIndex];
    }

    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self initializeRecentSearch];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self resetSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSString *trimmedString = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(trimmedString.length == 0) {
        [self initializeRecentSearch];
    }
    else {
        
        NSMutableArray *searchStrings = (NSMutableArray *)[trimmedString componentsSeparatedByString:@" "];
        if([searchStrings containsObject:@""]) {
            [searchStrings removeObject:@""];
        }
        
        NSMutableArray *subpredicates = [NSMutableArray array];

        for(NSString *string in searchStrings) {
            
            NSPredicate *subPredicate = [NSPredicate predicateWithFormat:@"collegeName contains[cd] %@", string];
            [subpredicates addObject:subPredicate];
        }
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeName CONTAINS[c] %@", searchBar.text];
        
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];

        NSArray *searchResultArray = [self.collegeList filteredArrayUsingPredicate:predicate];
        self.searchArray = [NSMutableArray arrayWithArray:searchResultArray];
        
        [self toggleSearch:NO];

        if([self.searchArray count] == 0) {
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
            messageLabel.text = @"No Results";
            messageLabel.textColor = [UIColor lightGrayColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont fontType:eFontTypeAvenirMedium FontForSize:25];
            [messageLabel sizeToFit];
            
            self.searchResultTableview.backgroundView = messageLabel;
            
        }
        else {
            self.searchResultTableview.backgroundView = nil;
        }
    }
}

- (void) initializeRecentSearch {

    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSMutableOrderedSet *recentSearchSet = [NSMutableOrderedSet orderedSetWithOrderedSet:currentUser.recentSearch];
    self.searchArray = [NSMutableArray arrayWithArray:[[recentSearchSet reversedOrderedSet] array]];
    self.searchBar.text = @"";
    [self toggleSearch:YES];
}

- (void) toggleSearch:(BOOL) showRecentSearch {
    
    if(showRecentSearch) {
        self.showRecentSearches = YES;
        
        UIView *headerView = self.searchResultTableview.tableHeaderView;
        UILabel *titleLabel = (UILabel *)[headerView viewWithTag:1126];
        [titleLabel setText:@"RECENT SEARCHES"];
        [self.searchResultTableview reloadData];
    }
    else {
        self.showRecentSearches = NO;

        UIView *headerView = self.searchResultTableview.tableHeaderView;
        UILabel *titleLabel = (UILabel *)[headerView viewWithTag:1126];
        [titleLabel setText:@"SEARCH RESULTS"];

        [self.searchResultTableview reloadData];
    }
}

- (void) resetSearch {
    
    [self.searchArray removeAllObjects];
    [self.searchResultTableview reloadData];
    self.navigationItem.titleView = nil;
    [self setUpNavigationbar];
}

#pragma mark SEARCH TABLE VIEW DATASOURCE

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.showRecentSearches) {
        return RECENT_SEARCH_ROW_HEIGHT;
    }
    else {
        return SEARCH_ROW_HEIGHT;
    }
    
    return SEARCH_ROW_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *searchCellIdentifier = @"searchCell";
    static NSString *favoriteCellIdentifier = @"FavoriteCell";
    
    UITableViewCell *cell;
    
    if(!self.showRecentSearches) {
        
        STFavoriteCell *favoriteCell = [tableView dequeueReusableCellWithIdentifier:favoriteCellIdentifier];
        favoriteCell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        NSDictionary *collegeDetails = [self.searchArray objectAtIndex:indexPath.row];
        favoriteCell.ibCollegeName.text = [collegeDetails objectForKey:@"collegeName"];
        
        NSString *placeString;
        
        if(![self isNullValueForObject:[collegeDetails objectForKey:@"place"]]) {
            placeString = [NSString stringWithFormat:@"%@", [collegeDetails objectForKey:@"place"]];
        }
        
        favoriteCell.ibCollegePlace.text = placeString;
        cell = favoriteCell;
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:searchCellIdentifier];
            cell.textLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:17.0f];
            cell.textLabel.textColor = [UIColor cellTextFieldTextColor];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;

        STRecentSearchItem *searchItem = [self.searchArray objectAtIndex:indexPath.row];
        NSNumber *collegeID = searchItem.collegeID;
        
        STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
        
        if(college) {
            cell.textLabel.text = college.collegeName;
        }
    }
    
    return cell;
}

- (BOOL) isNullValueForObject:(id) object {
    
    if(object && (![object isEqual:[NSNull null]])) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSMutableArray *selCollegeArray = [NSMutableArray array];
    NSNumber *selCollegeID;
    
    self.isCollegeSelected = YES;
    
    if(self.searchArray.count > 0) {
        
        if(!self.showRecentSearches) {
            
            NSDictionary *selectedCollegeDetails = [self.searchArray objectAtIndex:indexPath.row];
            [self addItemToRecentSearchItem:selectedCollegeDetails];
            selCollegeID = [selectedCollegeDetails objectForKey:@"collegeID"];
        }
        else { // Recent Search Items Click
            
            STRecentSearchItem *item = [self.searchArray objectAtIndex:indexPath.row];
            selCollegeID = item.collegeID;
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", selCollegeID];
        selCollegeArray = [NSMutableArray arrayWithArray:[self.collegeList filteredArrayUsingPredicate:predicate]];
        
        if(selCollegeArray && ([selCollegeArray count] > 0)) {
            [self updateCollgeToCollegeWithID:selCollegeID];
            [self.searchBar resignFirstResponder];
        }
        else {
            //Alert
            [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Selected college not in filter list"];
            
        }
    }
    else {
        
        [self updateCollgeListViewWithCollegeAtIndex:self.selectedCollegeIndex];
        [self.searchBar resignFirstResponder];
    }
}

- (void) updateCollgeToCollegeWithID:(NSNumber *) collegeID {
    
    self.navigationItem.titleView = nil;
    NSInteger index = [self getIndexOfCollegeWithID:collegeID];
    self.selectedCollegeIndex = index;
    [self updateCollgeListViewWithCollegeAtIndex:self.selectedCollegeIndex];
}

- (void) addItemToRecentSearchItem:(NSDictionary *) collegeDetails {
    
    if(collegeDetails) {

        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", [collegeDetails objectForKey:@"collegeID"]];
            STCollege *localCollege = [STCollege MR_findFirstWithPredicate:predicate inContext:localContext];
            STRecentSearchItem *searchItem = [STRecentSearchItem MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", localCollege.collegeID]];
            
            NSMutableOrderedSet *recentSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[localUser recentSearch]];

            if(!searchItem) {
                searchItem = [STRecentSearchItem MR_createEntityInContext:localContext];
                searchItem.collegeID = localCollege.collegeID;
                searchItem.user = localUser;
                [recentSet addObject:searchItem];
            }
            else {
                for (STRecentSearchItem *item in recentSet) {
                    if([searchItem.collegeID isEqualToNumber:[item collegeID]]) {
                        [recentSet removeObject:item];
                        [searchItem MR_deleteEntityInContext:localContext];
                        break;
                    }
                }
                
                STRecentSearchItem *newSearchItem = [STRecentSearchItem MR_createEntityInContext:localContext];
                newSearchItem.collegeID = localCollege.collegeID;
                newSearchItem.user = localUser;
                [recentSet addObject:newSearchItem];
            }

            if([recentSet count] > MAX_RECENT_SEARCH_COUNT) {
                STRecentSearchItem *lastItem = [recentSet objectAtIndex:0];
                [lastItem MR_deleteEntityInContext:localContext];
                [recentSet removeObjectAtIndex:0];
            }
            
            localUser.recentSearch = recentSet;

        } completion:^(BOOL success, NSError *error) {
            
        }];
    }
}

- (void) presentSimilarSchoolWithCollegeID:(NSNumber *) collegeID {
    
   // STCollegeDetailViewController *detailViewController = [[STCollegeDetailViewController alloc] initWithNibName:@"STCollegeDetailViewController" bundle:nil];
    
    UIStoryboard *tabBarStoryBoard = [UIStoryboard storyboardWithName:@"TabBarMenu" bundle:nil];
    
    STCollegeDetailViewController *detailViewController = [tabBarStoryBoard instantiateViewControllerWithIdentifier:@"STCollegeDetailViewController"];
    
    detailViewController.collegeID = collegeID;
    detailViewController.isPresenting = YES;
    
    __weak STCollegesListViewController *weakSelf = self;

    detailViewController.mapClickedAction = ^(NSDictionary *locationDetails, NSNumber *collegeID) {
        [weakSelf collegeLocationDetails:locationDetails andCollegeID:collegeID];
    };

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    detailViewController.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (NSUInteger) getIndexOfCollegeWithID:(NSNumber *) collegeID {
    
    NSUInteger index = [self.collegeList indexOfObjectPassingTest:
                        ^BOOL(NSDictionary *dict, NSUInteger idx, BOOL *stop)
                        {
                            return [[dict objectForKey:@"collegeID"] isEqual:collegeID];
                        }
                        ];
    
    if (index != NSNotFound) {
        return index;
    }
    
    return 0;
}

- (NSUInteger)getIndexOfCollegeForUserLocation {
    
    BOOL hasLocationAccess = [[STLocationManager sharedManager] hasAccessToLocationServices];
    
    if(hasLocationAccess) {
        
        CLLocation *currentUserLocation = [[STLocationManager sharedManager] currentLocation];
        
        STCollege *closestCollege;
        CLLocationDistance closestLocationDistance = -1;
        
         NSArray *collegeList = [STCollege MR_findAll];
        
        for (STCollege *college in collegeList) {
            
            double lattitude = [college.appleLattitude doubleValue];
            double longitude = [college.appleLongitude doubleValue];
            
            CLLocation *collegeLocation = [[CLLocation alloc] initWithLatitude:lattitude longitude:longitude];
            
            if (!closestCollege) {
                closestCollege = college;
                closestLocationDistance = [currentUserLocation distanceFromLocation:collegeLocation];
                continue;
            }
            
            CLLocationDistance currentDistance = [currentUserLocation distanceFromLocation:collegeLocation];
            
            if (currentDistance < closestLocationDistance) {
                closestCollege = college;
                closestLocationDistance = currentDistance;
            }
        }

        return [self getIndexOfCollegeWithID:closestCollege.collegeID];
    } else {
        
        //         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeName CONTAINS[c] %@", searchBar.text];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeName == %@", @"Ohio State University, Columbus, The"];
        STCollege *defaultCollege = [STCollege MR_findAllWithPredicate:predicate].firstObject;

        if(defaultCollege) {
            return [self getIndexOfCollegeWithID:defaultCollege.collegeID];
        }
    }
    return 0;
}

- (void)dealloc {

    STLog(@"college dealloc");

    self.pageController = nil;
    self.searchBar = nil;
    self.searchArray = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    self.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
