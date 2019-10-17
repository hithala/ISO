//
//  STCollegeDetailViewController.m
//  Stipend
//
//  Created by Arun S on 10/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

@import EventKit;

#import "STCollegeDetailViewController.h"
#import "STCollegeDetailViewController+ShareAdditions.h"
#import "STCollegePageReorderViewController.h"
#import "STLocationViewController.h"
#import "STWebViewController.h"
#import "STPrivacyPolicyPopupView.h"

#import "STSocialLoginManager.h"
#import "STEventKitManager.h"

#import "STCollegeHeaderView.h"
#import "STCollegeFooterView.h"
#import "STCollegeSectionHeaderView.h"
#import "STCollegeSectionFooterView.h"
#import "STClippingsDragNDropView.h"

#import "STAdmissionsSwitchView.h"

#import "STPieChartView.h"

#import "STGenderView.h"

#import "STSportsDivisionTitleView.h"
#import "STSportsListView.h"

#import "STDefaultCell.h"

#import "STSeeMoreCell.h"

#import "STCollegeLocationCell.h"

#import "STQuickFactsViewCell.h"

#import "STCallAndMailCell.h"
#import "STAddressCell.h"

#import "STCollegeRankingsViewCell.h"

#import "STAdmissionRecommendationCell.h"
#import "STAdmissionSwitchViewCell.h"
#import "STAdmissionCodeViewCell.h"

#import "STIntendedStudyPieChartCell.h"
#import "STIntendedStudyDetailsCell.h"
#import "STBroadMajorCell.h"

#import "STMostRepresentedStatesCell.h"

#import "STFreshmenGeographicsCell.h"
#import "STFreshmenReligiousCell.h"
#import "STFreshmenEthnicityCell.h"
#import "STFreshmenDetailsCell.h"
#import "STFreshmanGenderCell.h"
#import "STFreshmenGreekLifeCell.h"

#import "STFinancialDetailsCell.h"
#import "STFinancialAidNetIncomeCell.h"

#import "STSportsDetailsCell.h"
#import "STSportsMascotCell.h"

#import "STTestScoresBarChartCell.h"
#import "STTestScoresPieChartCell.h"
#import "STTestScoresDetailCell.h"
#import "STTestScoresHSCRCell.h"

#import "STCalenderDetailsCell.h"
#import "STWeatherDetailCell.h"

#import "STCollege.h"

#import "STShareImageView.h"

#import "STFavorites.h"
#import "STCompareItem.h"

#import "STTutorialView.h"

#import "STNavigationtitle.h"
#import "STSortCollegesTableView.h"

#import "STFilter.h"

#import "STPrivayPolicyViewController.h"

#import "STCollegeDataSource.h"
#import "STFreshmanRateView.h"
#import "STFreshmanRateCell.h"

#import "RetentionRatePopupView.h"
#import "STIntroductionViewController.h"
#import "STHintPopUpView.h"

#import "STSpecificMajorsViewController.h"
#import "STPrivacyAndTermsViewController.h"

#define DEFAULT_HEADER_VIEW_HEIGHT      (([UIScreen mainScreen].bounds.size.height- 64.0)/2.0)
#define TABLEVIEW_FOOTER_HEIGHT         60.0
#define SECTION_HEADER_HEIGHT           60.0
#define SECTION_FOOTER_HEIGHT           30.0
#define ROW_HEIGHT                      50.0
#define BLUR_VIEW_HEIGHT                150.0
#define ADDRESS_ROW_HEIGHT              130.0
#define SUB_HEADER_HEIGHT               150.0
#define FRESHMEN_DETAILS_ROW_HEIGHT     60.0

#define SECTION_BASE_TAG                9999

#define TUTORIALVIEW_TAG                1111

#define HEADER_VIEW_TAG                 2000

#define PIE_CHART_ROW_HEIGHT            200.0
#define INTENDED_STUDY_CELL_1           70.0

#define TAG_GEOGRAPHICS                 100
#define TAG_ETHNICITY                   101
#define TAG_INTENDED_STUDY              102

#define GEOGRAPHICS_DETAILS             @"kGeographicsKey"
#define ETHNICITY_DETAILS               @"kEthnicityKey"

#define KEY_TEXT_ARRAY                  @"kTextArrayKey"
#define KEY_PERCENTAGE_ARRAY            @"kPercentageArrayKey"

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_EXPAND                      @"kExpandKey"


#define KEY_COLLEGE_ID                  @"kCollegeIDKey"
#define KEY_COLLEGE_NAME                @"kCollegeNameKey"

#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_VALUES_DICT                 @"kValuesDictKey"
#define KEY_VALID                       @"kValidKey"
#define KEY_ICON                        @"kIconKey"
#define KEY_ICON_TYPE                   @"kIconTypeKey"

#define KEY_MALE_PERCENTAGE             @"kMalePercentageKey"
#define KEY_FEM_PERCENTAGE              @"kFemalePercentageKey"
#define KEY_PERCENTAGE                  @"kPercentageKey"

#define KEY_SELECTED_INDEX              @"kSelectedIndexKey"

#define TILE_CLOSE                      @"tile_close"
#define TILE_OPEN                       @"tile_open"

#define KEY_SEEMORE                     @"kSeeMoreKey"
#define KEY_SEEMORE_PRESENT             @"kSeeMorePresentKey"

#define SUMMARY_DETAILS                 @"kSummaryDetailsKey"
#define LOCATION_DETAILS                @"kLocationDetailsKey"
#define SIMILAR_SCHOOLS_DETAILS         @"kSimilarSchoolsDetailsKey"
#define TEST_SCORES_DETAILS             @"kTestScoresDetailsKey"
#define FRESHMAN_PROFILE_DETAILS        @"kFreshmanProfileDetailsKey"
#define ADMISSIONS_DETAILS              @"kAdmissionsDetailsKey"
#define CALENDAR_DETAILS                @"kCalendarDetailsKey"
#define INTENDED_STUDY_DETAILS          @"kIntendedStudyDetailsKey"
#define FEES_FINANCIAL_AID_DETAILS      @"kFees&FinancialAidDetailsKey"
#define SPORTS_DETAILS                  @"kSportsDetailsKey"
#define WEATHER_DETAILS                 @"kWeatherDetailsKey"
#define COLLEGE_RANKINGS_DETAILS        @"kCollegeRankingsDetailsKey"
#define PROMINENT_ALUMNI_DETAILS        @"KProminentAlumniDetailsKey"
#define LINKS_ADDRESSES_DETAILS         @"kLinks&AddressesDetailsKey"
#define QUICK_FACTS_DETAILS             @"kQuickFactsDetailsKey"

#define COLLEGE_LATITUDE                @"kCollegeLatitudeKey"
#define COLLEGE_LONGITUDE               @"kCollegeLongitudeKey"
#define COLLEGE_NAME                    @"kCollegeNameKey"
#define COLLEGE_LOCATION_NAME           @"kCollegeLocationNameKey"

#define IMPORTANT_DATE_VIEW_HEIGHT_CONSTANT  140.0
#define OTHER_DATE_VIEW_HEIGHT_CONSTANT      70.0
#define CALENDER_FOOTER_VIEW_HEIGHT_CONSTANT 70.0

@interface STCollegeDetailViewController ()

@property (assign) CGFloat kTableViewHeaderHeight;
@property (strong, nonatomic) UIView *headerBackgroundView;

@property (strong, nonatomic) UIView *summaryView;

@property (strong, nonatomic) RetentionRatePopupView* ratePopupView;
@property (strong, nonatomic) STHintPopUpView* hintPopupView;

@end

@implementation STCollegeDetailViewController

- (void)viewDidLoad {
        
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    CGFloat headerHeight = (DEFAULT_HEADER_VIEW_HEIGHT + SUB_HEADER_HEIGHT);
    
    self.kTableViewHeaderHeight = headerHeight;
    
    [self.mainTableView setBackgroundColor:[UIColor whiteColor]];
    
    [self registerNibs];
    
    self.headerBackgroundView = self.mainTableView.tableHeaderView;
    
    self.mainTableView.tableHeaderView = nil;
//    self.mainTableView.rowHeight = ROW_HEIGHT;
//    self.mainTableView.estimatedRowHeight = ROW_HEIGHT;
    
    [self.mainTableView addSubview:self.headerBackgroundView];
    
    self.mainTableView.contentInset = UIEdgeInsetsMake(self.kTableViewHeaderHeight, 0, 0, 0);
    self.mainTableView.contentOffset = CGPointMake(0, -self.kTableViewHeaderHeight);
    
    self.scrollOffset = CGPointMake(0.0, -self.kTableViewHeaderHeight);

    [self updateHeaderView];
    
    NSNumber *isTutorialScreensSeen =  [[NSUserDefaults standardUserDefaults] objectForKey:TUTORIAL_SCREENS_SEEN];
    
    if([isTutorialScreensSeen boolValue]) {
        if(self.privacyPopupActionBlock) {
            self.privacyPopupActionBlock();
        }
    }
}

// Registering Custom Nib's
- (void)registerNibs {
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STDefaultCell" bundle:nil] forCellReuseIdentifier:@"STDefaultCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STCollegeLocationCell" bundle:nil] forCellReuseIdentifier:@"STCollegeLocationCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STSeeMoreCell" bundle:nil] forCellReuseIdentifier:@"STSeeMoreCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STAddressCell" bundle:nil] forCellReuseIdentifier:@"STAddressCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STCallAndMailCell" bundle:nil] forCellReuseIdentifier:@"STCallAndMailCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STCollegeRankingsViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"STCollegeRankingsViewCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STAdmissionCodeViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"STAdmissionCodeViewCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STAdmissionSwitchViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"STAdmissionSwitchViewCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STAdmissionRecommendationCell" bundle:nil] forCellReuseIdentifier:@"STAdmissionRecommendationCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STIntendedStudyPieChartCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"STIntendedStudyPieChartCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STIntendedStudyDetailsCell" bundle:nil] forCellReuseIdentifier:@"STIntendedStudyDetailsCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STBroadMajorCell" bundle:nil] forCellReuseIdentifier:@"STBroadMajorCell"];

    [self.mainTableView registerNib:[UINib nibWithNibName:@"STFreshmenGeographicsCell" bundle:nil] forCellReuseIdentifier:@"STFreshmenGeographicsCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STFreshmenEthnicityCell" bundle:nil] forCellReuseIdentifier:@"STFreshmenEthnicityCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STFreshmanGenderCell" bundle:nil] forCellReuseIdentifier:@"STFreshmanGenderCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STFreshmanRateCell" bundle:nil] forCellReuseIdentifier:@"STFreshmanRateCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STMostRepresentedStatesCell" bundle:nil] forCellReuseIdentifier:@"STMostRepresentedStatesCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STFreshmenDetailsCell" bundle:nil] forCellReuseIdentifier:@"STFreshmenDetailsCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STFreshmenReligiousCell" bundle:nil] forCellReuseIdentifier:@"STFreshmenReligiousCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STFreshmenGreekLifeCell" bundle:nil] forCellReuseIdentifier:@"STFreshmenGreekLifeCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STQuickFactsViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"STQuickFactsViewCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STFinancialDetailsCell" bundle:nil] forCellReuseIdentifier:@"STFinancialDetailsCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STFinancialAidNetIncomeCell" bundle:nil] forCellReuseIdentifier:@"STFinancialAidNetIncomeCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STSportsDetailsCell" bundle:nil] forCellReuseIdentifier:@"STSportsDetailsCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STSportsMascotCell" bundle:nil] forCellReuseIdentifier:@"STSportsMascotCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STCalenderDetailsCell" bundle:nil] forCellReuseIdentifier:@"STCalenderDetailsCell"];
    
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STTestScoresDetailCell" bundle:nil] forCellReuseIdentifier:@"STTestScoresDetailCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STTestScoresPieChartCell" bundle:nil] forCellReuseIdentifier:@"STTestScoresPieChartCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STTestScoresBarChartCell" bundle:nil] forCellReuseIdentifier:@"STTestScoresBarChartCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STTestScoresHSCRCell" bundle:nil] forCellReuseIdentifier:@"STTestScoresHSCRCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"STWeatherDetailCell" bundle:nil] forCellReuseIdentifier:@"STWeatherDetailCell"];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if(self.scrollOffset.y == 0 || self.scrollOffset.y == -71)
    {
        self.scrollOffset = CGPointMake(0.0, -self.kTableViewHeaderHeight);
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", self.collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    if(college) {
        if([college.shouldUpdate boolValue] == NO) {
            [self updateCollege:college];
        }
    }
}

- (void) viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self updateCollegeWithID:self.collegeID];
}

- (IBAction)onReloadAction:(id)sender {
    [self updateCollegeWithID:self.collegeID];
}

- (void) initializeValues {
    
    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    self.collegeSections = [localUser.sections mutableCopy];
    
    [self updateHeaderAndFooterView];
}

- (void) updateTitleBarOfPresentingController {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", self.collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
    
    if(college) {
        
        STNavigationtitle *customTitleView = nil;
        if(!customTitleView) {
            
            customTitleView = [[NSBundle mainBundle] loadNibNamed:@"STNavigationtitle" owner:self options:nil][0];
            customTitleView.frame = CGRectMake(0.0, 0.0, ([UIScreen mainScreen].bounds.size.width - 40.0), 44.0);
            customTitleView.isPresenting = YES;
            customTitleView.backgroundColor = [UIColor clearColor];
//            self.navigationItem.titleView = customTitleView;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customTitleView];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissPresentedViewController)];
        }
        
        if([college isKindOfClass:[STCollege class]]) {
            
            [customTitleView updateNavigationTitleWithCollegeName:college.collegeName andPlace:college.place];
        }
    }
}

- (void)updateCollegeWithID:(NSNumber *)collegeID {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
   
    if(college) {
        
        if(!self.isPresenting) {
            self.updateNavigationBarWithCollegeDetails(collegeID);
        }
        else {
            [self updateTitleBarOfPresentingController];
        }
        
        if([college.shouldUpdate boolValue] == YES) {
            STLog(@"update college");
            
            NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObject:collegeID forKey:kCollegeID];
            [self fetchAndUpdateCollege:college withDetails:details];
        }
        else {
            
            if(self.isPresenting) {
                if([college.shouldUpdate boolValue] == NO) {
                    [self updateCollege:college];
                }
            }
        }
    }
    else {
        
    }
}

- (void) fetchAndUpdateCollege:(STCollege *) college withDetails:(NSMutableDictionary *) details {
    
    [STProgressHUD show];

    [[STNetworkAPIManager sharedManager] fetchCollegeWithDetails:details success:^(id response) {
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            STCollege *localCollege = [college MR_inContext:localContext];
            localCollege.shouldUpdate = [NSNumber numberWithBool:NO];
            
        } completion:^(BOOL success, NSError *error) {
            
            [STProgressHUD dismiss];
            
            self.networkErrorView.hidden = YES;
            self.mainTableView.hidden = NO;
            
            [self updateCollege:college];
        }];
    } failure:^(NSError *error) {
        [STProgressHUD dismiss];
        self.networkErrorView.hidden = NO;
        self.mainTableView.hidden = YES;
    }];
}

- (void) updateCollege:(STCollege *) college {
    
    self.college = college;
    [self initializeValues];
    
    STLog(@"*** College ID : %@ ***", college.collegeID);
    
    BOOL isFavorite = [self isCollegeFavoritedByUser];
    self.college.isFavorite = [NSNumber numberWithBool:isFavorite];

    BOOL isAddedToCompare = [self isCollegeAddedToCompare];
    self.college.isAddedToCompare = [NSNumber numberWithBool:isAddedToCompare];

    [self updateDetailControllerControls];
    
    [self.mainTableView reloadData];
    
    if(!self.isPresenting) {
        self.updateNavigationBarWithCollegeDetails(college.collegeID);
    }
    else {
        [self updateTitleBarOfPresentingController];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mainTableView setContentOffset:self.scrollOffset animated:NO];
    });
    
    [self showAllTutorialViews];
    
    
}



- (void)onPrivacyPolicyAction:(id)sender {
    
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

- (void)showAllTutorialViews {
    
    NSNumber *isTutorialScreensSeen =  [[NSUserDefaults standardUserDefaults] objectForKey:TUTORIAL_SCREENS_SEEN];
    
    if(![isTutorialScreensSeen boolValue]) {
        
        STCollegeHeaderView *headerView = (STCollegeHeaderView *)[self.headerBackgroundView.subviews firstObject];
        
        //(STCollegeHeaderView *)self.mainTableView.tableHeaderView;
        
        STTutorialView *tutorialView = [STTutorialView shareView];
        tutorialView.headerView = headerView;
        tutorialView.tabBar = self.tabBarController.tabBar;
        [tutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeSwipe];
        
        
        __weak STCollegeDetailViewController *weakSelf = self;
        __weak STTutorialView *weakTutorialView = tutorialView;
        
        tutorialView.tutorialActionBlock = ^(NSNumber *nextIndex){
            
            if ([nextIndex integerValue] == 1){
                [weakSelf setTableViewContentOffSetForType:kTutorialViewTypeSort];
                [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeSort];
            }
            else if ([nextIndex integerValue] == 2){
                [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeOrganize];
            }
            else if ([nextIndex integerValue] == 3){
                [weakSelf setTableViewContentOffSetForType:kTutorialViewTypeFavoties];
                [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeFavoties];
            }
            else if ([nextIndex integerValue] == 4){
                [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeCompare];
            }
            else if ([nextIndex integerValue] == 5){
                [weakSelf setTableViewContentOffSetForType:kTutorialViewTypeFilter];
                [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeFilter];
            }
            else if ([nextIndex integerValue] == 6){
                [weakSelf setTableViewContentOffSetForType:kTutorialViewTypeClippings];
                [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeClippings];
            }
            else if ([nextIndex integerValue] == 7){
                [weakSelf setTableViewContentOffSetForType:kTutorialViewTypePayScale];
                [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypePayScale];
            }
            else if ([nextIndex integerValue] == 8){
                
                [weakSelf setTableViewContentOffSetForType:kTutorialViewTypeNone];
                [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeNone];
                [weakTutorialView removeFromSuperview];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:TUTORIAL_SCREENS_SEEN];
                [[NSUserDefaults standardUserDefaults] synchronize];

                if(self.privacyPopupActionBlock) {
                    self.privacyPopupActionBlock();
                }
            }
        };
    }
}

- (void)showTestScoresTutorialView {
    
    [self setTableViewContentOffSetForType:kTutorialViewTypeTestScores];
    
    STTutorialView *tutorialView = [STTutorialView shareView];
    [tutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeTestScores];
    
    __weak STTutorialView *weakTutorialView = tutorialView;
    
    tutorialView.tutorialActionBlock = ^(NSNumber *nextIndex){
        
        [self setTableViewContentOffSetForType:kTutorialViewTypeResetTestScore];
        [weakTutorialView showInView:self.tabBarController.view withTutorialType:kTutorialViewTypeNone];
        [weakTutorialView removeFromSuperview];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:TEST_SCORE_TUTORIAL_SEEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
}

- (void)setTableViewContentOffSetForType:(TutorialViewType)type{
    
    //__weak STCollegeDetailViewController *weakSelf = self;
    
    NSInteger section = 0;
    
    if(type == kTutorialViewTypeSort) {
        
        if(section < [self.mainTableView numberOfSections]) {
            CGRect sectionRect = [self.mainTableView rectForSection:section];
            CGFloat actualHeight = sectionRect.origin.y - 100.0;
            [self.mainTableView setContentOffset:CGPointMake(0, actualHeight) animated:YES];
        }
    } else if(type == kTutorialViewTypeClippings) {
        
        if(section < [self.mainTableView numberOfSections]) {
            CGRect sectionRect = [self.mainTableView rectForSection:section];
            CGFloat actualHeight = sectionRect.origin.y;
            [self.mainTableView setContentOffset:CGPointMake(0, actualHeight) animated:YES];
        }
        
    } else if (type == kTutorialViewTypePayScale) {
        
        section = 4;
        
        if(section < [self.mainTableView numberOfSections]) {
            CGRect sectionRect = [self.mainTableView rectForSection:section];
            CGFloat actualHeight = sectionRect.origin.y;
            [self.mainTableView setContentOffset:CGPointMake(0, actualHeight) animated:YES];
        }
        
    } else if (type == kTutorialViewTypeFavoties) {
        
        CGPoint bottomOffset = CGPointMake(0, -self.kTableViewHeaderHeight+110);
        [self.mainTableView setContentOffset:bottomOffset animated:YES];
        
    } else if (type == kTutorialViewTypeNone || type == kTutorialViewTypeFilter){
        
        CGPoint bottomOffset = CGPointMake(0, -self.kTableViewHeaderHeight);
        [self.mainTableView setContentOffset:bottomOffset animated:YES];
        
    } else if (type == kTutorialViewTypeTestScores || type == kTutorialViewTypeResetTestScore) {
      
        for (STSections *sectionDetails in self.collegeSections) {
            NSNumber *sectionIndex = sectionDetails.index;
            NSString *sectionTitle = sectionDetails.sectionItem.sectionTitle;
            if ([sectionTitle isEqualToString:@"Test Scores & Grades"]) {
                section = sectionIndex.integerValue;
                break;
            }
        }

        if (type == kTutorialViewTypeTestScores) {
            
            if(section < [self.mainTableView numberOfSections]) {
                CGRect sectionRect = [self.mainTableView rectForSection:section];
                CGFloat actualHeight = sectionRect.origin.y + 270;
                [self.mainTableView setContentOffset:CGPointMake(0, actualHeight) animated:YES];
            }
        } else {
            if(section < [self.mainTableView numberOfSections]) {
                CGRect sectionRect = [self.mainTableView rectForSection:section];
                CGFloat actualHeight = sectionRect.origin.y;
                [self.mainTableView setContentOffset:CGPointMake(0, actualHeight) animated:YES];
            }
        }
    } else {
        
        [self.mainTableView setContentOffset:CGPointMake(0, self.tableHeaderHeight - 120.0) animated:YES];
    }
}


- (void) backButtonAction {
    
    if(self.presentedCollegesStack && ([self.presentedCollegesStack count] > 0)) {
        NSNumber *collegeID = [self.presentedCollegesStack lastObject];

        [self.presentedCollegesStack removeLastObject];
        if(self.presentedCollegesStack && ([self.presentedCollegesStack count] == 0)) {
            self.navigationItem.leftBarButtonItem = nil;
        }

        [self updatePresentationViewWithCollegeID:collegeID];
    }
}

- (void) updatePresentationViewWithCollegeID:(NSNumber *) collegeID {
    
    self.collegeID = collegeID;
    [self updateCollegeWithID:collegeID];
}

- (void)dismissPresentedViewController {
    self.presentedCollegesStack = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) updateHeaderAndFooterView {
        
    @try {
        
        //Header View
        STCollegeHeaderView *headerView = (STCollegeHeaderView *)[self.headerBackgroundView viewWithTag:HEADER_VIEW_TAG];
        
        if(!headerView) {
            headerView = [[NSBundle mainBundle] loadNibNamed:@"STCollegeHeaderView" owner:self options:nil][0];
            [self.headerBackgroundView addSubview:headerView];
        }
        
        CGFloat headerHeight = (DEFAULT_HEADER_VIEW_HEIGHT + SUB_HEADER_HEIGHT);
        headerView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, headerHeight);
        headerView.headerViewHeight = headerHeight;
        headerView.tag = HEADER_VIEW_TAG;
        self.tableHeaderHeight = headerHeight;
        
        self.summaryView = headerView.summaryView;
        
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView updateCollegeSummaryForCollegeID:self.collegeID];
        
        STCollegeDetailViewController *weakSelf = self;
        
        headerView.reorderActionBlock = ^{
            [weakSelf reorderAction];
        };
        
        //    headerView.shareActionBlock = ^{
        //        [weakSelf shareAction];
        //    };
        
        headerView.sortActionBlock = ^{
            
            [weakSelf sortAction];
        };
        
        headerView.compareActionBlock = ^{
            [weakSelf compareAction];
        };
        
        headerView.favoriteActionBlock = ^{
            [weakSelf favouriteAction];
        };
        
        
        UIView *hh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
        hh.backgroundColor = [UIColor clearColor];
        
        self.mainTableView.tableHeaderView = hh;
        
        //Footer View
        STCollegeFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"STCollegeFooterView" owner:self options:nil][0];
        footerView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, TABLEVIEW_FOOTER_HEIGHT);
        
        footerView.backToTop = ^{
            [self backToTopAction];
        };
        
        self.mainTableView.tableFooterView = footerView;
    }
    @catch(NSException *exception) {
        STLog(@"Exception: %@", exception);
    }
}

- (void)viewWillLayoutSubviews
{
    [self updateHeaderView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
//
//    if(offset.y > (self.tableHeaderHeight + 20.0)) {
//        STCollegeHeaderView *headerView = (STCollegeHeaderView *)self.mainTableView.tableHeaderView;
//        if([headerView isSummaryHidden]) {
//            [headerView toggleSumaryViewWithAnimation:NO];
//        }
//    }
//    
    self.scrollOffset = offset;
    
    [self updateHeaderView];
}

- (void)updateHeaderView
{
    CGRect headerRect = CGRectMake(0, -self.kTableViewHeaderHeight, [UIScreen mainScreen].bounds.size.width, self.kTableViewHeaderHeight);
    
    if (self.mainTableView.contentOffset.y < -self.kTableViewHeaderHeight){
        headerRect.origin.y = self.mainTableView.contentOffset.y;
        headerRect.size.height = -self.mainTableView.contentOffset.y;
    }
    
//    STLog(@"content offset y position : %f", self.mainTableView.contentOffset.y);
    
    
    if (self.mainTableView.contentOffset.y < -self.kTableViewHeaderHeight) {
        
        CGFloat height = self.kTableViewHeaderHeight;
        CGFloat position = 0.0;
        CGFloat alphaPercent = 0.0;
        
        position = (-self.mainTableView.contentOffset.y - height) / (height/6);
        alphaPercent = 1.0 - MIN(position, 1.0);
        
//        STLog(@"offset percentage : %f", alphaPercent);
        
        self.summaryView.alpha = alphaPercent;
    }
    
    
    self.headerBackgroundView.frame = headerRect;
    
}


- (BOOL) isCollegeFavoritedByUser {
 
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND user == %@", self.collegeID, currentUser];

    STFavorites *favorites = [STFavorites MR_findFirstWithPredicate:predicate];
    if(favorites) {
        return YES;
    }

    return NO;
}

- (BOOL) isCollegeAddedToCompare {

    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@ AND user == %@", self.collegeID, currentUser];
    
    STCompareItem *compareItem = [STCompareItem MR_findFirstWithPredicate:predicate];
    
    if(compareItem) {
        return YES;
    }
    
    return NO;
}

- (void) updateDetailControllerControls {
    
    STCollegeHeaderView *headerView = (STCollegeHeaderView *)[self.headerBackgroundView.subviews firstObject];
   // STCollegeHeaderView *headerView = (STCollegeHeaderView *)self.mainTableView.tableHeaderView;
    [headerView updateFavoriteButtonWithStatus:[self.college.isFavorite boolValue]];
    [headerView updateCompareButtonWithStatus:[self.college.isAddedToCompare boolValue]];
}

- (void)reorderAction {
    
    if(STUserManager.sharedManager.isGuestUser) {
        [self showLoginController];
        return;
    }
    
    STCollegePageReorderViewController *reorderPage = [[UIStoryboard storyboardWithName:@"Settings" bundle:nil] instantiateViewControllerWithIdentifier:@"CollegePageReorderStoryboardID"];
    reorderPage.isPresenting = YES;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:reorderPage];
    
    [self presentViewController:navController animated:YES completion:nil];
}
/*
- (void)shareAction {
    
    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", self.collegeID]];
    
    STShareImageView *shareImageView = [[NSBundle mainBundle] loadNibNamed:@"STShareImageView" owner:self options:nil].firstObject;
    shareImageView.ibTextLabel.text = college.collegeName;
    shareImageView.ibDetailLabel.text = [NSString stringWithFormat:@"%@,%@",college.city,college.state];
    [self createShareScreenShotImageFromTableView:shareImageView];
    [[STSocialLoginManager sharedManager] presentActivityViewController:self withShareImage:nil];
} */

- (void)sortAction {
    
    if(self.isPresenting) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CollegeHunch" message:@"In order to sort colleges, please close this screen." preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        if(STUserManager.sharedManager.isGuestUser) {
            [self showLoginController];
            return;
        }
        
        UIView *popupBackgroundView = [[UIView alloc] initWithFrame:self.tabBarController.view.bounds];
        popupBackgroundView.tag = 2201;
        popupBackgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5f];
        
        STSortCollegesTableView *popupView = [[NSBundle mainBundle] loadNibNamed:@"STSortCollegesTableView" owner:self options:nil][0];
        popupView.frame = CGRectMake(30, 0, (self.tabBarController.view.frame.size.width - 60.0), (61.0 + 8 * 44.0 + 54.0));
        popupView.center = self.tabBarController.view.center;
        popupView.layer.cornerRadius = 4.0f;
        [popupView configureView];
        
        [popupBackgroundView addSubview:popupView];
        [self.tabBarController.view addSubview:popupBackgroundView];
        
        
        popupView.cancelActionBlock = ^{
            UIView *popupBackgroundView = [self.tabBarController.view viewWithTag:2201];
            
            popupBackgroundView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                popupBackgroundView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished){
                popupBackgroundView.hidden = YES;
                [popupBackgroundView removeFromSuperview];
            }];
        };
        
        popupView.completeActionBlock = ^(SortType sortType) {
            
            STLog(@"%@", sortTypeString(sortType));
            
            [[STUserManager sharedManager] setShouldReloadData:YES];
//            BOOL isFilterApplied = [[STUserManager sharedManager] isFilterApplied];
            BOOL shouldSaveChanges = NO;

            if(sortType == eSortTypeDistance) {
                
                BOOL hasLocationAccess = [[STLocationManager sharedManager] hasAccessToLocationServices];
                
                if(hasLocationAccess) {
                    shouldSaveChanges = YES;
                    
                } else {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CollegeHunch" message:@"Please grant access to location services from device settings." preferredStyle: UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            } else {
                shouldSaveChanges = YES;
            }
            
            if(shouldSaveChanges) {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    
                    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                    localUser.sortOrder = [NSNumber numberWithInteger:sortType];
                    
                } completion:^(BOOL contextDidSave, NSError *error) {
                    
                    if(self.sortActionBlock) {
                        self.sortActionBlock();
                    }
                }];
            }
        };
        
        popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            popupView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            
        }];
    }
}

- (void)compareAction {
 
    if(STUserManager.sharedManager.isGuestUser) {
        [self showLoginController];
        return;
    }

    NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.collegeID,kCollegeID, nil];
    [details setObject:[NSNumber numberWithBool:YES] forKey:kShouldUpdateDatabase];

    STCollegeDetailViewController *weakSelf = self;
    
    if(![[STUserManager sharedManager] isGuestUser]) {
        [STProgressHUD show];
    }
    
    if([self.college.isAddedToCompare boolValue]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            [[STNetworkAPIManager sharedManager] removeCollegeFromCompareWithDetails:details success:^(id response) {
                weakSelf.college.isAddedToCompare = [NSNumber numberWithBool:NO];
                [weakSelf updateDetailControllerControls];
                if(![[STUserManager sharedManager] isGuestUser]) {
                    [STProgressHUD dismiss];
                }
                
                [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Removed from Compare"];
            } failure:^(NSError *error) {
                STLog(@"FAILED");
                if(![[STUserManager sharedManager] isGuestUser]) {
                    [STProgressHUD dismiss];
                    [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Failed to remove from Compare"];
                }
            }];
        });
    }
    else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSInteger itemsInCompare = [self getCompareListCount];
            
            if(itemsInCompare >= 15) {
                [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"You may only compare 15 colleges at once."];
            }
            else {
                [[STNetworkAPIManager sharedManager] addCollegeToCompareWithDetails:details success:^(id response) {
                    weakSelf.college.isAddedToCompare = [NSNumber numberWithBool:YES];
                    [weakSelf updateDetailControllerControls];
                    if(![[STUserManager sharedManager] isGuestUser]) {
                        [STProgressHUD dismiss];
                        [STProgressHUD showImage:[UIImage imageNamed:@"toast_added"] andStatus:@"Added to Compare"];
                        
                        
                    }
                } failure:^(NSError *error) {
                    STLog(@"FAILED");
                    if(![[STUserManager sharedManager] isGuestUser]) {
                        [STProgressHUD dismiss];
                        [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Failed to add to Compare"];
                    }
                }];
            }
        });
    }
}

- (NSInteger)getCompareListCount {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@",[[STUserManager sharedManager] getCurrentUserInDefaultContext]];
    NSArray *compareList = [STCompareItem MR_findAllWithPredicate:predicate];
    
    return compareList.count;
}

- (void)favouriteAction {
    
    if(STUserManager.sharedManager.isGuestUser) {
        [self showLoginController];
        return;
    }
    
    NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.collegeID,kCollegeID, nil];
    [details setObject:[NSNumber numberWithBool:YES] forKey:kShouldUpdateDatabase];

    STCollegeDetailViewController *weakSelf = self;
    
    if(![[STUserManager sharedManager] isGuestUser]) {
        [STProgressHUD show];
    }
    
    if([self.college.isFavorite boolValue]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[STNetworkAPIManager sharedManager] removeCollegeFromFavouriteWithDetails:details success:^(id response) {
                weakSelf.college.isFavorite = [NSNumber numberWithBool:NO];
                [weakSelf updateDetailControllerControls];
                if(![[STUserManager sharedManager] isGuestUser]) {
                    [STProgressHUD dismiss];
                }
                
                [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Removed from Favorites"];
            } failure:^(NSError *error) {
                STLog(@"FAILED");
                if(![[STUserManager sharedManager] isGuestUser]) {
                    [STProgressHUD dismiss];
                    [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Failed to remove from Favorites"];
                }
            }];
        });
    }
    else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[STNetworkAPIManager sharedManager] addCollegeToFavoriteWithDetails:details success:^(id response) {
                weakSelf.college.isFavorite = [NSNumber numberWithBool:YES];
                [weakSelf updateDetailControllerControls];
                if(![[STUserManager sharedManager] isGuestUser]) {
                    [STProgressHUD dismiss];
                    [STProgressHUD showImage:[UIImage imageNamed:@"toast_added"] andStatus:@"Added to Favorites"];
                    
                }
            } failure:^(NSError *error) {
                STLog(@"FAILED");
                if(![[STUserManager sharedManager] isGuestUser]) {
                    [STProgressHUD dismiss];
                    [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Failed to add to Favorites"];
                }
            }];
        });

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

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    
    if(offset.y > (self.tableHeaderHeight + 20.0)) {
        STCollegeHeaderView *headerView = (STCollegeHeaderView *)self.mainTableView.tableHeaderView;
                if([headerView isSummaryHidden]) {
            [headerView toggleSumaryViewWithAnimation:NO];
        }
    }
    
    self.scrollOffset = offset;
}
*/

- (void)backToTopAction {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.scrollOffset = CGPointMake(0.0, -self.kTableViewHeaderHeight);
        [self.mainTableView setContentOffset:self.scrollOffset animated:YES];
    }];
}

- (void) showClippingsViewForSection:(NSMutableDictionary *) details {
    
    if(STUserManager.sharedManager.isGuestUser) {
        [self showLoginController];
        return;
    }

    STCollegeDetailViewController *weakSelf = self;
    
    STClippingsDragNDropView *dragNDropView = (STClippingsDragNDropView *)[[NSBundle mainBundle] loadNibNamed:@"STClippingsDragNDropView" owner:self options:nil][0];
    [dragNDropView updateViewWithDetails:details];
    [self.tabBarController.view addSubview:dragNDropView];
    dragNDropView.frame = [[UIScreen mainScreen] bounds];
    dragNDropView.alpha = 0.0;
    
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        dragNDropView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    dragNDropView.completeActionBlock = ^(NSMutableDictionary * details) {
        [weakSelf saveClippedSectionWithDetails:details];
    };
    
    dragNDropView.cancelActionBlock = ^{
        [weakSelf hideClippingsView];
    };
}

- (void) saveClippedSectionWithDetails:(NSMutableDictionary *) collegeSection {
    
    [[STNetworkAPIManager sharedManager] addCollegeSectionToClippingsWithDetails:collegeSection success:^(id response) {
        

    } failure:^(NSError *error) {

    }];
}

- (void) hideClippingsView {
    
}

#pragma mark tableview delagate method

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    STSections *sectionDetails = [self.collegeSections objectAtIndex:section];
    NSNumber *sectionID = sectionDetails.sectionItem.sectionID;
    STCollegeSections *collegeSection = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
    
    if(collegeSection) {
        
        NSString *sectionName = sectionDetails.sectionItem.sectionTitle;

        if(([sectionName isEqualToString:@"Fast Facts"]) ||([sectionName isEqualToString:@"Calendar"]) || ([sectionName isEqualToString:@"Fees And Financial Aid"]) || [sectionName isEqualToString:@"Test Scores & Grades"] || ([sectionName isEqualToString:@"PayScale ROI Rank"]) || ([sectionName isEqualToString:@"Weather"]) || ([sectionName isEqualToString:@"Intended Study"]) || ([sectionName isEqualToString:@"Popular Majors"])) {
        }
        else {
            
            BOOL isExpanded = [collegeSection.isExpanded boolValue];
            
            if(isExpanded) {
                return 30.0f;
            }
        }
    }
    
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    @try {
        
        STCollegeSectionFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"STCollegeSectionFooterView" owner:self options:nil][0];
        NSInteger colorIndex = (section % 2);
        footerView.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
        
        STSections *sectionDetails = [self.collegeSections objectAtIndex:section];
        NSString *sectionTitle = sectionDetails.sectionItem.sectionTitle;
        
        if ([sectionTitle isEqualToString:@"Links And Addresses"] || [sectionTitle isEqualToString:@"Similar Schools"] || [sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"] || [sectionTitle isEqualToString:@"Sports"] || [sectionTitle isEqualToString:@"Weather"] || [sectionTitle isEqualToString:@"Notable Alumini"] || [sectionTitle isEqualToString:@"Test Scores & Grades"]) {
            
            footerView.topViewSeparator.hidden = YES;
        }
        else {
            footerView.topViewSeparator.hidden = NO;
        }
        
        return footerView;
        
    } @catch (NSException *exception) {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return  SECTION_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    STSections *sectionDetails = [self.collegeSections objectAtIndex:section];
    NSString *sectionName = sectionDetails.sectionItem.sectionTitle;
    NSString *sectionImageName = sectionDetails.sectionItem.imageName;
    NSNumber *sectionID = sectionDetails.sectionItem.sectionID;
    
    if([sectionName isEqualToString:@"Freshman Profile"]) {
        sectionName = @"Freshmen Profile";
    }
    
    if ([sectionName isEqualToString:@"Notable Alumini"]) {
        sectionName = @"Notable Alumni";
    }
    
    if ([sectionName isEqualToString:@"Intended Study"]) {
        sectionName = @"Popular Majors";
    }

    STCollegeSections *collegeSection = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];

    if(collegeSection) {
        STCollegeSectionHeaderView *sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:@"STCollegeSectionHeaderView" owner:self options:nil][0];
        sectionHeaderView.tag = (section + SECTION_BASE_TAG);
        
        NSInteger colorIndex = (section % 2);
        sectionHeaderView.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
        
        BOOL isExpanded = NO;
        
        if(collegeSection) {
            isExpanded = [collegeSection.isExpanded boolValue];
        }
        
        sectionHeaderView.ibSectionHeaderName.text = sectionName;
        sectionHeaderView.ibSectionHeaderIcon.image = [UIImage imageNamed:sectionImageName];
        
        if(isExpanded) {
            sectionHeaderView.overlayView.hidden = YES;
            sectionHeaderView.ibSectionHeaderArrow.image = [UIImage imageNamed:TILE_CLOSE];
            
            sectionHeaderView.ibSectionHeaderIcon.alpha = 1.0;
            sectionHeaderView.ibSectionHeaderName.alpha = 1.0;
            
        } else {
            sectionHeaderView.overlayView.hidden = YES;
            sectionHeaderView.ibSectionHeaderArrow.image = [UIImage imageNamed:TILE_OPEN];
            
            sectionHeaderView.ibSectionHeaderIcon.alpha = 0.5;
            sectionHeaderView.ibSectionHeaderName.alpha = 0.5;
        }
        
        __weak STCollegeDetailViewController *weakSelf = self;
        
        sectionHeaderView.clickActionBlock = ^(NSInteger tag){
            [weakSelf onSectionTapAction:(tag - SECTION_BASE_TAG)];
        };
        
        sectionHeaderView.longPressActionBlock = ^(NSInteger tag){
            
            NSMutableDictionary *details = [NSMutableDictionary dictionary];
            [details setObject:sectionImageName forKey:KEY_SECTION_ICON];
            [details setObject:sectionID forKey:KEY_SECTION_ID];
            [details setObject:sectionName forKey:KEY_SECTION_NAME];
            [details setObject:collegeSection.isExpanded forKey:KEY_EXPAND];
            
            [details setObject:weakSelf.college.collegeName forKey:kCollegeName];
            [details setObject:weakSelf.collegeID forKey:kCollegeID];

            [weakSelf showClippingsViewForSection:details];
        };
        
        NSString *sectionTitle =  sectionName;
        
        if (([sectionTitle isEqualToString:@"Location"]) || ([sectionTitle isEqualToString:@"Admissions"]) || ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) || ([sectionTitle isEqualToString:@"Freshmen Profile"] || [sectionTitle isEqualToString:@"Freshman Profile"]) || ([sectionTitle isEqualToString:@"Fast Facts"]) || ([sectionTitle isEqualToString:@"Fees And Financial Aid"]) || ([sectionTitle isEqualToString:@"Sports"]) || ([sectionTitle isEqualToString:@"Calendar"]) || ([sectionTitle isEqualToString:@"Test Scores & Grades"]) || ([sectionTitle isEqualToString:@"Weather"])) {
            if(isExpanded) {
                sectionHeaderView.viewSeparator.hidden = YES;
            }
            else {
                sectionHeaderView.viewSeparator.hidden = NO;
            }
        }
        else {
            sectionHeaderView.viewSeparator.hidden = NO;
        }
        
        if ([sectionTitle isEqualToString:@"PayScale ROI Rank"]) {
            sectionHeaderView.payScaleRankView.hidden = NO;
            sectionHeaderView.overlayView.hidden = YES;
            
            sectionHeaderView.ibSectionHeaderIcon.alpha = 0.5;
            sectionHeaderView.ibSectionHeaderName.alpha = 0.5;
            
            sectionHeaderView.payScaleRankView.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
            
            STCRankings *ranking = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            STCRankingItem *item = [ranking.rankingItems firstObject];
            
            if(item.rank && ([item.rank integerValue] > 0)) {
                sectionHeaderView.payScaleLabel.text = [NSString stringWithFormat:@"%@",item.rank];
            }
            else {
                if(item.rankingURL) {
                    sectionHeaderView.payScaleLabel.textColor = [UIColor cellTextFieldTextColor];
                    sectionHeaderView.payScaleLabel.text = @"NR";
                }
                else {
                    sectionHeaderView.payScaleLabel.textColor = [UIColor cellLabelTextColor];
                    sectionHeaderView.payScaleLabel.text = @"NR";
                }
            }

        } else {
            sectionHeaderView.payScaleRankView.hidden = YES;
        }
        
        return sectionHeaderView;
    }
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.collegeSections.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STSections *sectionDetails = [self.collegeSections objectAtIndex:indexPath.section];
    NSNumber *sectionID = sectionDetails.sectionItem.sectionID;
    NSString *sectionTitle = sectionDetails.sectionItem.sectionTitle;
    
    STCollegeSections *collegeSection = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
    
    if(collegeSection) {
        
        CGFloat rowHeight = [[STCollegeDataSource sharedInstance] heightForRowAtIndexPath:indexPath forSectionID:sectionID andSectionTitle:sectionTitle andCollegeID:self.college.collegeID];
        return rowHeight;
    } else {
        return 0.0f;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    STSections *sectionDetails = [self.collegeSections objectAtIndex:section];
    NSNumber *sectionID = sectionDetails.sectionItem.sectionID;
    NSString *sectionTitle = sectionDetails.sectionItem.sectionTitle;
    
    STCollegeSections *collegeSection = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
    
    if(collegeSection) {
        
        NSInteger noOfRows = [[STCollegeDataSource sharedInstance] numberOfRowsForSectionID:sectionID andSectionTitle:sectionTitle andCollegeID:collegeSection.collegeID];
        return noOfRows;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STSections *sectionDetails = [self.collegeSections objectAtIndex:indexPath.section];
    NSNumber *sectionID = sectionDetails.sectionItem.sectionID;
    NSString *sectionTitle = sectionDetails.sectionItem.sectionTitle;
    
    STCollegeSections *collegeSection = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
    
    __weak STCollegeDetailViewController *weakSelf = self;
    __weak UITableView *weakTableview = self.mainTableView;

    if(collegeSection) {
        
        NSInteger colorIndex = (indexPath.section % 2);
        
        UITableViewCell *cell;
        
        if ([sectionTitle isEqualToString:@"Location"]) {
            
            STCLocation *collegeLocation = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            if(indexPath.row == 0) {
                
                STCollegeLocationCell *locationCell = [tableView dequeueReusableCellWithIdentifier:@"STCollegeLocationCell"];
                locationCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                [locationCell updateMapWithLatitude:[collegeLocation.lattitude doubleValue] andLongitude:[collegeLocation.longitude doubleValue]];
                
                locationCell.mapClickAction = ^{
                    [weakSelf mapClickAction:collegeLocation];
                };
                
                cell = locationCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else {
                
                STDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
                defaultCell.ibCellTitleLabel.text = [NSString stringWithFormat:@"More about %@", collegeSection.college.place];
                defaultCell.backgroundColor = [UIColor whiteColor];

                cell = defaultCell;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;

            }
        } else if ([sectionTitle isEqualToString:@"Fast Facts"]) {
            
            STQuickFactsViewCell *quickFactsCell = [tableView dequeueReusableCellWithIdentifier:@"STQuickFactsViewCell"];
            quickFactsCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
            
            STCQuickFacts *collegeQuickFacts = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            quickFactsCell.ibTopLabelValue.text = collegeQuickFacts.quickFactsText;
            quickFactsCell.ibTopLabelValue.textAlignment = NSTextAlignmentLeft;
            cell = quickFactsCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }  else if ([sectionTitle isEqualToString:@"Notable Alumini"]) {
            
            STCProminentAlumini *alumini = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            BOOL isSeeMore = [alumini.hasSeeMore boolValue];
            
            if(isSeeMore) {
                
                if(indexPath.row == 5) {
                    
                    STSeeMoreCell *seeMoreCell = [tableView dequeueReusableCellWithIdentifier:@"STSeeMoreCell"];
                    [seeMoreCell.ibTapButton setBackgroundColor:[UIColor whiteColor]];
                    seeMoreCell.ibTapButton.tag = indexPath.section;
                    [seeMoreCell.ibTapButton setTitle:@"See More..." forState:UIControlStateNormal];
                    seeMoreCell.topCellSeparatorView.hidden = YES;
                    seeMoreCell.clickActionBlock = ^(NSInteger tag) {
                        [weakSelf seeMoreClicked:tag];
                    };
                    
                    cell = seeMoreCell;
                }
                else {
                    
                    STDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
                    
                    STCAluminiItem *item = [alumini.aluminiItems objectAtIndex:indexPath.row];
                    defaultCell.ibCellTitleLabel.text = item.key;
                    
                    defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 15.0f;
                    
                    if(indexPath.row == 4) {
                        defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 0.0;
                    }
                    else {
                        defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 15.0;
                    }
                    
                    defaultCell.backgroundColor = [UIColor whiteColor];
                    cell = defaultCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
            }
            else {
                
                STDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
                STCAluminiItem *item = [alumini.aluminiItems objectAtIndex:indexPath.row];
                defaultCell.ibCellTitleLabel.text = item.key;
                
                if(indexPath.row == ([alumini.aluminiItems count] - 1)) {
                    defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 0.0;
                }
                else {
                    defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 15.0;
                }
                
                defaultCell.backgroundColor = [UIColor whiteColor];
                cell = defaultCell;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
        } else if ([sectionTitle isEqualToString:@"Similar Schools"]) {
            
            STCSimilarSchools *similarSchool = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            BOOL isSeeMore = [similarSchool.hasSeeMore boolValue];
            
            if(isSeeMore) {
                
                if(indexPath.row == 5) {
                    
                    STSeeMoreCell *seeMoreCell = [tableView dequeueReusableCellWithIdentifier:@"STSeeMoreCell"];
                    [seeMoreCell.ibTapButton setBackgroundColor:[UIColor whiteColor]];
                    seeMoreCell.ibTapButton.tag = indexPath.section;
                    [seeMoreCell.ibTapButton setTitle:@"See More..." forState:UIControlStateNormal];
                    seeMoreCell.topCellSeparatorView.hidden = YES;
                    seeMoreCell.clickActionBlock = ^(NSInteger tag) {
                        [weakSelf seeMoreClicked:tag];
                    };
                    
                    cell = seeMoreCell;
                }
                else {
                    
                    STDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
                    
                    STCSimilarSchoolItem *item = [similarSchool.simlarSchoolItems objectAtIndex:indexPath.row];
                    defaultCell.ibCellTitleLabel.text = item.name;
                    
                    defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 15.0f;
                    
                    if(indexPath.row == 4) {
                        defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 0.0;
                    }
                    else {
                        defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 15.0;
                    }
                    
                    defaultCell.backgroundColor = [UIColor whiteColor];
                    cell = defaultCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
            }
            else {
                
                STDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
                
                STCSimilarSchoolItem *item = [similarSchool.simlarSchoolItems objectAtIndex:indexPath.row];
                defaultCell.ibCellTitleLabel.text = item.name;
                
                if(indexPath.row == ([similarSchool.simlarSchoolItems count] - 1)) {
                    defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 0.0;
                }
                else {
                    defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 15.0;
                }
                
                defaultCell.backgroundColor = [UIColor whiteColor];
                cell = defaultCell;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
        } else if ([sectionTitle isEqualToString:@"Admissions"]) {
            
            if (indexPath.row == 0) {
                
                STCAdmissions *admission = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
                NSOrderedSet *admissionCodes = admission.admissionCodes;

                STAdmissionCodeViewCell *admissionCodeViewCell = [tableView dequeueReusableCellWithIdentifier:@"STAdmissionCodeViewCell"];
                [admissionCodeViewCell updateCellWithDetails:admissionCodes];
                admissionCodeViewCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                
                cell = admissionCodeViewCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            } else {
                
                STCAdmissions *admission = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
                STCAdmissionItem *admissionItem = [admission.admissionItems objectAtIndex:(indexPath.row - 1)];
                
                if(admissionItem.items.count > 1) {
                    
                    STAdmissionRecommendationCell *recommendationCell = [tableView dequeueReusableCellWithIdentifier:@"STAdmissionRecommendationCell"];
                    [recommendationCell updateCellWithDetails:admissionItem];
                    recommendationCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                    
                    cell = recommendationCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                }
                else {
                    
                    STCItem *item = admissionItem.items[0];
                    
                    STAdmissionSwitchViewCell *admissionSwitchViewCell = [tableView dequeueReusableCellWithIdentifier:@"STAdmissionSwitchViewCell"];
                    admissionSwitchViewCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                    [admissionSwitchViewCell updateCellWithDetails:item];
                    cell = admissionSwitchViewCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
        else if ([sectionTitle isEqualToString:@"Links And Addresses"]) {
            
            STCLinksAndAddresses *linksAndAddress = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            NSInteger linksAndAddressCount = (linksAndAddress.linksAndAddressesItems.count);
            
            if(indexPath.row == linksAndAddressCount) {
                
                STAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"STAddressCell"];
                
                addressCell.cellIcon.image = [UIImage imageNamed:@"address"];
                addressCell.addressTextview.text = [[STCollegeDataSource sharedInstance] getCollegeAddressForCollegeID:self.college.collegeID];
                
                cell = addressCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else if ((indexPath.row == (linksAndAddressCount + 1)) || (indexPath.row == (linksAndAddressCount + 2))) {
                
                STCallAndMailCell *callAndMailCell = [tableView dequeueReusableCellWithIdentifier:@"STCallAndMailCell"];
                
                callAndMailCell.tag = indexPath.section;
                callAndMailCell.clickButton.tag = indexPath.row;

                NSInteger itemIndex = (indexPath.row - 1) - linksAndAddressCount;
                NSString *linksObject = [[STCollegeDataSource sharedInstance] getObjectForLinksAndAddresses:linksAndAddress atIndex:itemIndex forCollegeID:self.college.collegeID];

                if([linksObject isEqualToString:@"EMAIL"]) {
                    
                    NSString *emailID = self.college.emailID;

                    callAndMailCell.title = @"email";
                    callAndMailCell.cellIcon.image = [UIImage imageNamed:@"email"];
                    callAndMailCell.cellTitle.text = emailID;
                    
                    callAndMailCell.mailActionBlock = ^(NSIndexPath *indexPath) {
                        [weakSelf mailAction:indexPath];
                    };
                }
                else if([linksObject isEqualToString:@"TELEPHONE"]) {
                    
                    callAndMailCell.title = @"phone";
                    callAndMailCell.cellIcon.image = [UIImage imageNamed:@"phone"];
                    callAndMailCell.cellTitle.text = self.college.telephoneNumber;
                    
                    callAndMailCell.callActionBlock = ^(NSIndexPath *indexPath) {
                        [weakSelf callAction:indexPath];
                    };
                }
                
                NSInteger totalItemsCount = [[STCollegeDataSource sharedInstance] getTotalCountOfItemsInLinksAndAddresses:linksAndAddress forCollegeID:self.college.collegeID];
                
                if(indexPath.row < (totalItemsCount - 1)) {
                    callAndMailCell.cellSeparatorLeadingConstraint.constant = 15.0;
                }
                else {
                    callAndMailCell.cellSeparatorLeadingConstraint.constant = 0.0;
                }
                
                cell = callAndMailCell;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            else {
                
                STCLinksAndAddressesItem *item = [linksAndAddress.linksAndAddressesItems objectAtIndex:indexPath.row];
                
                STDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
                defaultCell.ibCellTitleLabel.text = item.key;
                defaultCell.cellSeparatorLeadingSpaceConstraint.constant = 15.0f;
                defaultCell.backgroundColor = [UIColor whiteColor];
                cell = defaultCell;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
        }
        else if([sectionTitle isEqualToString:@"Freshmen Profile"] || [sectionTitle isEqualToString:@"Freshman Profile"]) {
            
            STCFreshman *freshman = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            if(indexPath.row == 0) {// Detail Items
                
                NSOrderedSet *detailItems = freshman.freshmanDetailItems;
                
                STFreshmenDetailsCell *freshmenDetailCell = [tableView dequeueReusableCellWithIdentifier:@"STFreshmenDetailsCell"];
                freshmenDetailCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                [freshmenDetailCell updateFreshmenWithDetails:detailItems];
                
                cell = freshmenDetailCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else if(indexPath.row == 1) { //Gender
                STFreshmanGenderCell *genderCell = [tableView dequeueReusableCellWithIdentifier:@"STFreshmanGenderCell"];
                genderCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                
                STCFreshmanGenderDetails *genderDetails = freshman.genderDetails;
                [genderCell updateGenderPercentageWithDetails:genderDetails];

                cell = genderCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else {
                
                id freshmanItem = [[STCollegeDataSource sharedInstance] getObjectForFreshman:freshman atIndexPath:indexPath];//[self getbjectForFreshman:freshman atIndexPath:indexPath];
                
                if([freshmanItem isKindOfClass:[STCPieChart class]]) {
                    
                    STCPieChart *pieChart = freshmanItem;
                    
                    if([[pieChart name] isEqualToString:@"Geography"]) {
                        STFreshmenGeographicsCell *geographyCell = [tableView dequeueReusableCellWithIdentifier:@"STFreshmenGeographicsCell"];
                        
                        [geographyCell updatePieChartViewWithDetails:[pieChart pieChartItem]];
                        geographyCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                        cell = geographyCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    else {
                        
                        STCPieChart *pieChart = freshmanItem;
                        STFreshmenEthnicityCell *ethicityCell = [tableView dequeueReusableCellWithIdentifier:@"STFreshmenEthnicityCell"];
                        
                        [ethicityCell updatePieChartViewWithDetails:[pieChart pieChartItem]];
                        ethicityCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                        
                        cell = ethicityCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }
                else if([freshmanItem isKindOfClass:[NSOrderedSet class]]) {
                    
                    NSOrderedSet *object = freshmanItem;
                    
                    if(object && ([object count] > 0)) {
                        if([object[0] isKindOfClass:[STCFreshmanRepresentedStates class]]) {
                            STMostRepresentedStatesCell *mostRepresentedStatesCell = [tableView dequeueReusableCellWithIdentifier:@"STMostRepresentedStatesCell"];
                            mostRepresentedStatesCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                            
                            [mostRepresentedStatesCell updateWithDetails:object];
                            
                            cell = mostRepresentedStatesCell;
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                        } else if([object[0] isKindOfClass:[STCFreshmanGreekLife class]]) {
                            STFreshmenGreekLifeCell *greekLifeCell = [tableView dequeueReusableCellWithIdentifier:@"STFreshmenGreekLifeCell"];
                            greekLifeCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                            
                            [greekLifeCell updateFreshmenWithGreekLifeDetails:object];
                            
                            cell = greekLifeCell;
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                    }
                    else {
                    }
                }
                else if([freshmanItem isKindOfClass:[NSString class]]) {
                    
                    NSString *freshmenType = freshmanItem;

                    if([freshmenType isEqualToString:freshmenItemString(FreshmenItemGraduationRate)]) {
                        
                        STFreshmanRateCell *ratesCell = [tableView dequeueReusableCellWithIdentifier:@"STFreshmanRateCell"];
                        ratesCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                        
                        STCFreshmanGraduationDetails *rateDetails = freshman.graduationDetails;
                        [ratesCell updateRatesPercentageWithDetails:rateDetails forType:FreshmenItemGraduationRate];
                        
                        cell = ratesCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    } else if([freshmenType isEqualToString:freshmenItemString(FreshmenItemRetentionRate)]) {
                        
                        STFreshmanRateCell *ratesCell = [tableView dequeueReusableCellWithIdentifier:@"STFreshmanRateCell"];
                        ratesCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                        
                        STCFreshmanGraduationDetails *rateDetails = freshman.graduationDetails;
                        [ratesCell updateRatesPercentageWithDetails:rateDetails forType:FreshmenItemRetentionRate];

                        __weak UITableView *weakTableview = self.mainTableView;
                        __weak STFreshmanRateCell *weakRateCell = ratesCell;
                        
                        ratesCell.imageClickActionBlock = ^(UIImageView *questionMarkview){
                            CGRect frame = [weakTableview convertRect:questionMarkview.frame fromView:weakRateCell];
                            
                            [weakSelf showRetentionRatePopupAtRect:frame];
                        };

                        cell = ratesCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    } else {
                        
                        STFreshmenReligiousCell *freshmenReligiousCell = [tableView dequeueReusableCellWithIdentifier:@"STFreshmenReligiousCell"];
                        freshmenReligiousCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                        freshmenReligiousCell.ibReligiousLabel.text = @"Religious Affiliation";
                        freshmenReligiousCell.ibReligiousValue.text = freshman.religiousAffiliation;
                        cell = freshmenReligiousCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }
                else {
                }
            }
        } else if ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) {
            
            STCIntendedStudy *intendedStudy = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            STCPieChart *pieChart = intendedStudy.intendedStudyPieChart;

            if(indexPath.row == 0) {
                
                STIntendedStudyPieChartCell *intendedStudyCell = [tableView dequeueReusableCellWithIdentifier:@"STIntendedStudyPieChartCell"];
                
                [intendedStudyCell updatePieChartViewWithDetails:[pieChart pieChartItem]];
                intendedStudyCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                
                cell = intendedStudyCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (indexPath.row == 1) {//Student Faculty Ratio
                
                STIntendedStudyDetailsCell *studyDetailsCell = [tableView dequeueReusableCellWithIdentifier:@"STIntendedStudyDetailsCell"];
                studyDetailsCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                
                [studyDetailsCell updateStudentFacultyRatioWithDetails:intendedStudy.studentFacultyRatio];
                
                cell = studyDetailsCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if ((indexPath.row == 2) || (indexPath.row == 3)) {
                STAdmissionSwitchViewCell *admissionSwitchViewCell = [tableView dequeueReusableCellWithIdentifier:@"STAdmissionSwitchViewCell"];
                admissionSwitchViewCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                
                if(indexPath.row == 2) {
                    
                    STCAdmissionItem *admissionItem = intendedStudy.admissionItems[0];
                    STCItem *item = admissionItem.items[0];
                    [admissionSwitchViewCell updateCellWithDetails:item];
                }
                else {
                    STCAdmissionItem *admissionItem = intendedStudy.admissionItems[1];
                    STCItem *item = admissionItem.items[0];
                    [admissionSwitchViewCell updateCellWithDetails:item];
                }
                
                cell = admissionSwitchViewCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            } else { // Broad Majors, Default Text & See More / See Less
                
                BOOL isSeeMore = [intendedStudy.hasSeeMore boolValue];
                
                if(isSeeMore) {
                    STSeeMoreCell *seeMoreCell = [tableView dequeueReusableCellWithIdentifier:@"STSeeMoreCell"];
                    [seeMoreCell.ibTapButton setBackgroundColor:[TILES_COLOR_ARRAY objectAtIndex:colorIndex]];
                    seeMoreCell.ibTapButton.tag = indexPath.section;
                    [seeMoreCell.ibTapButton setTitle:@"See More..." forState:UIControlStateNormal];
                    seeMoreCell.topCellSeparatorView.hidden = YES;
                    seeMoreCell.clickActionBlock = ^(NSInteger tag) {
                        [weakSelf seeMoreClicked:tag];
                    };
                    cell = seeMoreCell;
                } else {

                    NSInteger noOfRowsBeforeMajors = intendedStudy.admissionItems.count + 1 + 1;
                    NSOrderedSet *broadMajors = self.college.broadMajors;
                    
                    NSInteger currentIndex = indexPath.row - noOfRowsBeforeMajors;
                    
                    if(currentIndex == 0) {
                        
                        STQuickFactsViewCell *quickFactsCell = [tableView dequeueReusableCellWithIdentifier:@"STQuickFactsViewCell"];
                        quickFactsCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                        
                        quickFactsCell.ibTopLabelValue.text = BROAD_MAJORS_DEFAULT_TEXT;
                        quickFactsCell.ibTopLabelValue.textAlignment = NSTextAlignmentCenter;
                        quickFactsCell.ibTopLabelValue.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:14];
                        quickFactsCell.ibTopLabelValue.textColor = [UIColor darkGrayColor];
                        quickFactsCell.viewSeparator.hidden = YES;
                        cell = quickFactsCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    } else if(currentIndex <= broadMajors.count) {
                        
                        NSInteger majorsIndex = currentIndex - 1;
                        STBroadMajor *broadMajor = [broadMajors objectAtIndex:majorsIndex];
                        
                        STBroadMajorCell *broadMajorCell = [tableView dequeueReusableCellWithIdentifier:@"STBroadMajorCell"];
                        broadMajorCell.titleLabel.text = broadMajor.name;
                        if(majorsIndex == 0) {
                            broadMajorCell.topSeparatorView.hidden = NO;
                        } else {
                            broadMajorCell.topSeparatorView.hidden = YES;
                        }
                        broadMajorCell.bottomSeparatorViewLeadingConstraint.constant = 15.0f;
                        broadMajorCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                        cell = broadMajorCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                        
                    } else {
                        
                        STSeeMoreCell *seeMoreCell = [tableView dequeueReusableCellWithIdentifier:@"STSeeMoreCell"];
                        [seeMoreCell.ibTapButton setBackgroundColor:[TILES_COLOR_ARRAY objectAtIndex:colorIndex]];
                        seeMoreCell.ibTapButton.tag = indexPath.section;
                        [seeMoreCell.ibTapButton setTitle:@"See Less..." forState:UIControlStateNormal];
                        seeMoreCell.topCellSeparatorView.hidden = YES;
                        seeMoreCell.clickActionBlock = ^(NSInteger tag) {
                            [weakSelf seeMoreClicked:tag];
                        };
                        cell = seeMoreCell;
                    }
                }
            }
        }
        else if ([sectionTitle isEqualToString:@"Fees And Financial Aid"]) {
            
            if(indexPath.row == 0) {
                
                STCFeesAndFinancialAid *feesAndFinancialAid = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
                
                STFinancialDetailsCell *financeDetailCell = [tableView dequeueReusableCellWithIdentifier:@"STFinancialDetailsCell"];
                financeDetailCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                [financeDetailCell updateFeeAndFinancialWithDetails:feesAndFinancialAid];
                
                financeDetailCell.toggleAction = ^{
                    [tableView reloadData];
                };
                
                __weak STFinancialDetailsCell *weakFinancialAidCell = financeDetailCell;
                
                financeDetailCell.imageClickActionBlock = ^(UIImageView *questionMarkview, CGRect imageViewRect, int position, FinancialAidItem type) {
                    
                    CGRect frame = [weakTableview convertRect:questionMarkview.frame fromView:weakFinancialAidCell];
                    
                    [weakSelf showFinancialAidPopupAtRect:frame imageViewRect:imageViewRect position:position type:type];
                };
                
                cell = financeDetailCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            } else if(indexPath.row == 1) {
                
                STCFeesAndFinancialAid *feesAndFinancialAid = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];

                BOOL isSeeMore = [feesAndFinancialAid.hasSeeMore boolValue];

                if(isSeeMore) {
                    STSeeMoreCell *seeMoreCell = [tableView dequeueReusableCellWithIdentifier:@"STSeeMoreCell"];
                    [seeMoreCell.ibTapButton setBackgroundColor:[TILES_COLOR_ARRAY objectAtIndex:colorIndex]];
                    seeMoreCell.ibTapButton.tag = indexPath.section;
                    [seeMoreCell.ibTapButton setTitle:@"See More..." forState:UIControlStateNormal];
                    seeMoreCell.topCellSeparatorView.hidden = NO;
                    seeMoreCell.clickActionBlock = ^(NSInteger tag) {
                        [weakSelf seeMoreClicked:tag];
                    };
                    
                    cell = seeMoreCell;
                } else {
                    
                    STFinancialAidNetIncomeCell *netIncomeCell = [tableView dequeueReusableCellWithIdentifier:@"STFinancialAidNetIncomeCell"];
                    netIncomeCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                    [netIncomeCell updateWithNetIncomeDetails:feesAndFinancialAid.householdIncome];
                    cell = netIncomeCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    __weak STFinancialAidNetIncomeCell *weakFinancialAidCell = netIncomeCell;

                    netIncomeCell.imageClickActionBlock = ^(UIImageView *questionMarkview, CGRect imageViewRect, int position) {
                        
                        CGRect frame = [weakTableview convertRect:questionMarkview.frame fromView:weakFinancialAidCell];
                        
                        [weakSelf showFinancialAidPopupAtRect:frame imageViewRect:imageViewRect position:position type:FinancialAidItemHouseholdIncome];
                    };
                }
            } else {
                
                STDefaultCell *netPriceCalculatorCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
                netPriceCalculatorCell.ibCellTitleLabel.text = @"Net Price Calculator";
                netPriceCalculatorCell.cellSeparatorLeadingSpaceConstraint.constant = 15.0f;
                netPriceCalculatorCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                cell = netPriceCalculatorCell;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
        }
        else if ([sectionTitle isEqualToString:@"Calendar"]) {
            
            STCalenderDetailsCell *calenderDetailsCell = (STCalenderDetailsCell *)[tableView dequeueReusableCellWithIdentifier:@"STCalenderDetailsCell"];
            calenderDetailsCell.contentView.backgroundColor = [UIColor lightGrayColor];
            
            STCCalender *calender = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];

            [calenderDetailsCell updateCalenderSectionWithDetails:calender];
            
            calenderDetailsCell.contentView.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
            
            cell = calenderDetailsCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else if ([sectionTitle isEqualToString:@"Weather"]) {
            
            STCWeather *weather = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            STWeatherDetailCell *weatherCell = [tableView dequeueReusableCellWithIdentifier:@"STWeatherDetailCell"];
            weatherCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
            [weatherCell updateCellWithDetails:weather];
            
            weatherCell.logoClickActionBlock = ^{

                [self navigateToWebViewWithUrlString:WEATHER_SERVICE_SITE_URL AndTitle:@""];
            };
            
            cell = weatherCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if ([sectionTitle isEqualToString:@"Sports"]) {
            
            STCSports *sports = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];

            if(indexPath.row == 0) {
                
                STSportsDetailsCell *sportsCell = [tableView dequeueReusableCellWithIdentifier:@"STSportsDetailsCell"];
                sportsCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                
                [sportsCell updateSportsSectionWithDetails:sports];
                
                sportsCell.toggleAction = ^{
                    [tableView reloadData];
                };

                cell = sportsCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            else if(indexPath.row == 1) {
                
                STAdmissionSwitchViewCell *admissionSwitchViewCell = [tableView dequeueReusableCellWithIdentifier:@"STAdmissionSwitchViewCell"];
                admissionSwitchViewCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                
                STCAdmissionItem *admissionItem = sports.admissionItems[0];
                STCItem *item = admissionItem.items[0];
                
                [admissionSwitchViewCell updateCellWithDetails:item];
                
                cell = admissionSwitchViewCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            else if(indexPath.row == 2) {

                STSportsMascotCell *sportsMoscotCell = [tableView dequeueReusableCellWithIdentifier:@"STSportsMascotCell"];
                sportsMoscotCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                sportsMoscotCell.titleLabel.text = @"Team Name";
                
                if(sports.mascotName && (sports.mascotName.length > 0)) {
                    sportsMoscotCell.valueLabel.text = sports.mascotName;
                }
                else {
                    sportsMoscotCell.valueLabel.text = @"N/A";
                }
                
                cell = sportsMoscotCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            else {
                
                STDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
                cell = defaultCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        else if ([sectionTitle isEqualToString:@"Test Scores & Grades"]) {
            
            STCTestScoresAndGrades *testScoreAndGrades = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];

            id testScoreItem = [[STCollegeDataSource sharedInstance] getObjectForTestScores:testScoreAndGrades atIndex:indexPath.row];
            
            if([testScoreItem isEqualToString:@"AVERAGE SCORES"]) {
                STTestScoresDetailCell *testScoresDetailCell = [tableView dequeueReusableCellWithIdentifier:@"STTestScoresDetailCell"];
                testScoresDetailCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                [testScoresDetailCell updateTestScoresWithDetails:testScoreAndGrades.averageScores withTestScoresAndGrades:testScoreAndGrades forCollege:self.college];
                
                cell = testScoresDetailCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            else if([testScoreItem isEqualToString:@"BAR CHARTS"]) {
                STTestScoresBarChartCell *testScoresBarChartCell = [tableView dequeueReusableCellWithIdentifier:@"STTestScoresBarChartCell"];
                testScoresBarChartCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                [testScoresBarChartCell updateBarChartsWithDetails:testScoreAndGrades];
                
                testScoresBarChartCell.toggleAction = ^{
                    [tableView reloadData];
                };

                testScoresBarChartCell.presentPopoverController = ^(STTestScorePopoverViewController *popoverController){
                    [ self presentViewController:popoverController animated:true completion:nil ];
                };

                cell = testScoresBarChartCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            else if([testScoreItem isEqualToString:@"PIE CHARTS"]) {
                STTestScoresPieChartCell *testScoresPieChartCell = [tableView dequeueReusableCellWithIdentifier:@"STTestScoresPieChartCell"];
                testScoresPieChartCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                [testScoresPieChartCell updateTestScorePieChartWithDetails:testScoreAndGrades];
                
                testScoresPieChartCell.toggleAction = ^{
                    [tableView reloadData];
                };
                
                cell = testScoresPieChartCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            } else if([testScoreItem isEqualToString:@"HSCR VIEW"]) {
                STTestScoresHSCRCell *testScoresHSCRCell = [tableView dequeueReusableCellWithIdentifier:@"STTestScoresHSCRCell"];
                testScoresHSCRCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                [testScoresHSCRCell updateBarChartsWithDetails:testScoreAndGrades];
                
                cell = testScoresHSCRCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else {
                STQuickFactsViewCell *quickFactsCell = [tableView dequeueReusableCellWithIdentifier:@"STQuickFactsViewCell"];
                quickFactsCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                
                quickFactsCell.ibTopLabelValue.text = TEST_SCORE_DEFAULT_TEXT;
                quickFactsCell.ibTopLabelValue.textAlignment = NSTextAlignmentCenter;
                quickFactsCell.ibTopLabelValue.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:14];
                quickFactsCell.ibTopLabelValue.textColor = [UIColor darkGrayColor];
                quickFactsCell.viewSeparator.hidden = YES;
                cell = quickFactsCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
        }
        else {
            
            STDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
            cell = defaultCell;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    }
    else {
        
        STDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
        defaultCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return defaultCell;
    }
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    STSections *sectionDetails = [self.collegeSections objectAtIndex:indexPath.section];
    NSNumber *sectionID = sectionDetails.sectionItem.sectionID;
    NSString *sectionTitle = sectionDetails.sectionItem.sectionTitle;

    if([sectionTitle isEqualToString:@"Location"]) {
        
        if(indexPath.row == 1) {
            STCollegeSections *collegeSection = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            if(collegeSection.college.place && (collegeSection.college.place != 0)) {
                
                NSString *searchString = [NSString stringWithFormat:@"%@", collegeSection.college.place];
                
                NSString *urlString = [[NSString stringWithFormat:@"https://en.wikipedia.org/wiki/%@",searchString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                [self navigateToWebViewWithUrlString:urlString AndTitle:searchString];
            }
        }
    }
    else if([sectionTitle isEqualToString:@"Similar Schools"]) {

        STCSimilarSchools *similarSchool = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
        STCSimilarSchoolItem *item = [similarSchool.simlarSchoolItems objectAtIndex:indexPath.row];
        
        if(!self.isPresenting) {
            
            if(self.similarSchoolAction) {
                self.similarSchoolAction(item.schoolID);
            }
        }
        else {
            
            if(!self.presentedCollegesStack) {
                self.presentedCollegesStack = [[NSMutableArray alloc] init];
            }
            
            [self.presentedCollegesStack addObject:self.collegeID];
            
            if([self.presentedCollegesStack count] == 0) {
                self.navigationItem.leftBarButtonItem = nil;
            }
            else {
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"browser_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAction)];
            }
            
            [self updatePresentationViewWithCollegeID:item.schoolID];
        }
    } else if ([sectionTitle isEqualToString:@"Links And Addresses"]) {
        
        STCLinksAndAddresses *linksAndAddress = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
        
        NSInteger linksAndAddressCount = (linksAndAddress.linksAndAddressesItems.count);
        
        if(indexPath.row < linksAndAddressCount) {
            
            STCLinksAndAddressesItem *item = [linksAndAddress.linksAndAddressesItems objectAtIndex:indexPath.row];
            
            if(item.value && (item.value.length != 0)) {
                
                if([item.key isEqualToString:@"Virtual Campus Tour"]) {
                    
                    NSNumber *isVirtualTourSeen =  [[NSUserDefaults standardUserDefaults] objectForKey:VIRTUAL_CAMPUS_TOUR_SEEN];

                    if(![isVirtualTourSeen boolValue]) {
                        
                        NSDictionary *messageDetails = @{@"privacyText":@"Please connect to your Wi-Fi network to avoid consuming or exceeding your cellular data limits. ", @"privacyUrl":@"urlSting"};
                        
                        STPrivacyPolicyPopupView *popUpView = [STPrivacyPolicyPopupView shareView];
                        
                        [popUpView showInView:[[[UIApplication sharedApplication] delegate] window] withMessageDetails:messageDetails];
                        
                        [popUpView.closeButton setHidden:NO];
                        [popUpView.learnMoreButton setTitle:@"I understand" forState:UIControlStateNormal];
                        
                        __weak STPrivacyPolicyPopupView *weakPopUpView = popUpView;
                        
                        popUpView.closeActionBlock = ^{
                            [weakPopUpView removeFromSuperview];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:VIRTUAL_CAMPUS_TOUR_SEEN];
                        };
                        
                        popUpView.learnMoreActionBlock = ^(NSString *hyperlinkUrl){
                            
                            [self navigateToWebViewWithUrlString:item.value AndTitle:item.key];
                            
                            [weakPopUpView removeFromSuperview];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:VIRTUAL_CAMPUS_TOUR_SEEN];
                        };
                        
                    } else {
                        [self navigateToWebViewWithUrlString:item.value AndTitle:item.key];
                    }
                } else {
                    [self navigateToWebViewWithUrlString:item.value AndTitle:item.key];
                }
            }
        }
    } else if ([sectionTitle isEqualToString:@"Notable Alumini"]) {
        
        STCProminentAlumini *alumini = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
        STCAluminiItem *item = [alumini.aluminiItems objectAtIndex:indexPath.row];
        
        NSString *searchString = [NSString stringWithFormat:@"%@", item.key];
        NSString *urlString = [[NSString stringWithFormat:@"https://en.wikipedia.org/wiki/%@",searchString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [self navigateToWebViewWithUrlString:urlString AndTitle:searchString];
        
    } else if ([sectionTitle isEqualToString:@"Fees And Financial Aid"]) {
        
        if(indexPath.row == 2) {
            
            STCFeesAndFinancialAid *feesAndFinancialAid = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            if(feesAndFinancialAid.netPriceCalculatorURL && (feesAndFinancialAid.netPriceCalculatorURL.length != 0)) {
                [self navigateToWebViewWithUrlString:feesAndFinancialAid.netPriceCalculatorURL AndTitle:@"Net Price Calculator"];
            }
        }
    } else if ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) {
        
        STCIntendedStudy *intendedStudy = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
        
        NSInteger noOfRowsBeforeMajors = intendedStudy.admissionItems.count + 1 + 1;
        NSOrderedSet *broadMajors = self.college.broadMajors;

        NSInteger currentIndex = indexPath.row - noOfRowsBeforeMajors - 1;

        if(currentIndex >= 0) {
            STBroadMajor *broadMajor = [broadMajors objectAtIndex:currentIndex];
            
            STSpecificMajorsViewController *specificMajorsView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STSpecificMajorsViewController"];
            specificMajorsView.specificMajors = broadMajor.specificMajors;
            
            [self.navigationController pushViewController:specificMajorsView animated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[STFreshmanRateCell class]]) {
        [self hideRetentionRatePopupView];
    }
    
    [self hideFinancialAidPopupView];
}

// Navigate to In-App webview
- (void)navigateToWebViewWithUrlString:(NSString *)urlString AndTitle:(NSString *)title {
    
    STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
    webView.urlString = urlString;
    webView.titleText = title;
    
    [self.navigationController pushViewController:webView animated:YES];
}

// Section Click Action

- (void)onSectionTapAction:(NSInteger)section {
    
    STSections *sectionDetails = [self.collegeSections objectAtIndex:section];
    NSNumber *sectionID = sectionDetails.sectionItem.sectionID;
    NSString *sectionTitle = sectionDetails.sectionItem.sectionTitle;
    
    STCollegeSections *collegeSection = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
    
    STCollegeSectionHeaderView *sectionHeaderView = (STCollegeSectionHeaderView *)[self.mainTableView viewWithTag:(section + SECTION_BASE_TAG)];
    UIImageView *sectionArrowImage = [sectionHeaderView ibSectionHeaderArrow];
    UIView *overlayView = [sectionHeaderView overlayView];
    
    // Removing Financial Aid Popips if any.
    [self hideFinancialAidPopupView];
    
    if(collegeSection) {
        
        BOOL isExpanded = [collegeSection.isExpanded boolValue];
        collegeSection.isExpanded = [NSNumber numberWithBool:!isExpanded];
        
        if(!isExpanded) {
            
            //Show Tutorial View
            //CGRect rect = [self.mainTableView convertRect:[self.mainTableView rectForHeaderInSection:section] toView:self.view];

            overlayView.hidden = YES;
            sectionArrowImage.image = [UIImage imageNamed:TILE_CLOSE];
            
            sectionHeaderView.ibSectionHeaderIcon.alpha = 1.0;
            sectionHeaderView.ibSectionHeaderName.alpha = 1.0;
            
        }
        else {
            overlayView.hidden = YES;
            sectionArrowImage.image = [UIImage imageNamed:TILE_OPEN];
            
            sectionHeaderView.ibSectionHeaderIcon.alpha = 0.5;
            sectionHeaderView.ibSectionHeaderName.alpha = 0.5;
        }
        
        if ([sectionTitle isEqualToString:@"Location"]) {
           
            if(!isExpanded) {
                
                sectionHeaderView.viewSeparator.hidden = YES;
                
                NSInteger rowCount = 2;
                
                [self insertRows:rowCount inSection:section withAnimation:UITableViewRowAnimationFade];
                
            } else {
                
                sectionHeaderView.viewSeparator.hidden = NO;
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }

        } else if ([sectionTitle isEqualToString:@"Fast Facts"]) {
            
            if(!isExpanded) {
                
                sectionHeaderView.viewSeparator.hidden = YES;
                
                NSInteger rowCount = 1;
                
                [self insertRows:rowCount inSection:section withAnimation:UITableViewRowAnimationFade];
                
            } else {
                
                sectionHeaderView.viewSeparator.hidden = NO;
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
        } else if([sectionTitle isEqualToString:@"Notable Alumini"]) {
            
            STCProminentAlumini *alumini = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];

            BOOL isSeeMore = [alumini.hasSeeMore boolValue];
            
            if(!isExpanded) {
                
                NSInteger totalNumberOfRows = alumini.aluminiItems.count;
                NSInteger rowCount = 0;
                
                if(isSeeMore) {
                    
                    if(totalNumberOfRows > 5) {
                        alumini.hasSeeMore = [NSNumber numberWithBool:YES];
                        rowCount = 6;
                    }
                    else {
                        rowCount = totalNumberOfRows;
                    }
                } else {
                    rowCount = totalNumberOfRows;
                }
                
                [self insertRows:rowCount inSection:section withAnimation:UITableViewRowAnimationFade];
                
            } else {
                alumini.hasSeeMore = [NSNumber numberWithBool:YES];
                
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }

            
        } else if([sectionTitle isEqualToString:@"Similar Schools"]) {
            
            STCSimilarSchools *similarSchool = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            BOOL isSeeMore = [similarSchool.hasSeeMore boolValue];
            
            if(!isExpanded) {
                
                NSInteger totalNumberOfRows = similarSchool.simlarSchoolItems.count;
                NSInteger rowCount = 0;
                
                if(isSeeMore) {
                    
                    if(totalNumberOfRows > 5) {
                        similarSchool.hasSeeMore = [NSNumber numberWithBool:YES];
                        rowCount = 6;
                    }
                    else {
                        rowCount = totalNumberOfRows;
                    }
                } else {
                    rowCount = totalNumberOfRows;
                }
                
                 [self insertRows:rowCount inSection:section withAnimation:UITableViewRowAnimationFade];
            } else {
                similarSchool.hasSeeMore = [NSNumber numberWithBool:YES];
                
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
        } else if ([sectionTitle isEqualToString:@"Admissions"]) {
            
            STCAdmissions *admissions = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            if(!isExpanded) {
                sectionHeaderView.viewSeparator.hidden = YES;
                
                NSInteger totalNumberOfRows = (admissions.admissionItems.count + 1);
                [self insertRows:totalNumberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
            else {
                
                sectionHeaderView.viewSeparator.hidden = NO;
                
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }

        }
        else if ([sectionTitle isEqualToString:@"Links And Addresses"]) {
        
            STCLinksAndAddresses *linksAndAddresses = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            if(!isExpanded) {
                
                NSInteger totalNumberOfRows = [[STCollegeDataSource sharedInstance] getTotalCountOfItemsInLinksAndAddresses:linksAndAddresses forCollegeID:self.college.collegeID];
                
                [self insertRows:totalNumberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
            else {
               
                sectionHeaderView.viewSeparator.hidden = NO;
                
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
            
        }  else if ([sectionTitle isEqualToString:@"Fees And Financial Aid"]) {
            STCFeesAndFinancialAid *feesAndFinancialAid = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            BOOL isSeeMore = [feesAndFinancialAid.hasSeeMore boolValue];
            NSInteger householdIncomeCount = feesAndFinancialAid.householdIncome.count;

            if(!isExpanded) {
                
                sectionHeaderView.viewSeparator.hidden = YES;
                
                NSInteger rowCount = 1;
                
                if(isSeeMore && (householdIncomeCount > 0)) {
                    rowCount = 2;
                } else {
                    if(householdIncomeCount > 0) {
                        if(feesAndFinancialAid.netPriceCalculatorURL && (feesAndFinancialAid.netPriceCalculatorURL.length != 0)) {
                            rowCount = 3;
                        } else {
                            rowCount = 2;
                        }
                    } else {
                        rowCount = 1;
                    }
                }
                
                [self insertRows:rowCount inSection:section withAnimation:UITableViewRowAnimationFade];
                
            } else {
                
                feesAndFinancialAid.hasSeeMore = [NSNumber numberWithBool:YES];
                sectionHeaderView.viewSeparator.hidden = NO;
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
        }
        else if ([sectionTitle isEqualToString:@"Freshmen Profile"] || [sectionTitle isEqualToString:@"Freshman Profile"]) {
            
            if(!isExpanded) {
                
                sectionHeaderView.viewSeparator.hidden = YES;

                STCFreshman *freshman = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
                
                NSInteger totalNumberOfRows = 0;
                
                NSOrderedSet *freshmemDetailItems = freshman.freshmanDetailItems;
                
                if(freshmemDetailItems.count > 0) {
                    totalNumberOfRows += 1;
                }
                
                NSOrderedSet *mostRepresentedStates = freshman.freshmanMostRepresentedStates;
                
                if(mostRepresentedStates.count > 0) {
                    totalNumberOfRows += 1;
                }
                
                NSOrderedSet *pieCharts = freshman.pieCharts;
                
                for (STCPieChart *pieChart in pieCharts) {
                    
                    if(pieChart.pieChartItem.count > 0) {
                        totalNumberOfRows += 1;
                    }
                }
                
                if(freshman.religiousAffiliation) {
                    totalNumberOfRows += 1;
                }
                
                NSOrderedSet *greekLife = freshman.freshmanGreekLife;
                
                if(greekLife.count > 0) {
                    totalNumberOfRows += 1;
                }

                STCFreshmanGraduationDetails *graduationDetails = freshman.graduationDetails;
                
                if([graduationDetails.sixYearGraduationRate integerValue] > 0 || [graduationDetails.fourYearGraduationRate integerValue] > 0) {
                    totalNumberOfRows += 1;
                }
                
                if([graduationDetails.retentionRate integerValue] > 0) {
                    totalNumberOfRows += 1;
                }
                
                totalNumberOfRows++;
                
                [self insertRows:totalNumberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
            else {
                
                sectionHeaderView.viewSeparator.hidden = NO;
                
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
        }
        else if ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) {
            
            STCIntendedStudy *intendedStudy = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];

            if(!isExpanded) {

                sectionHeaderView.viewSeparator.hidden = YES;
                
                BOOL isSeeMore = [intendedStudy.hasSeeMore boolValue];
                NSInteger broadMajorsCount =  self.college.broadMajors.count;
                
                NSInteger totalNumberOfRows = 0;
                totalNumberOfRows = intendedStudy.admissionItems.count + 1 + 1; //1 for pie chart , 1 for student faculty ratio
                
                // Broad Majors
                if(broadMajorsCount > 0) {
                    if(isSeeMore) {
                        totalNumberOfRows += 1;
                    } else {
                         totalNumberOfRows += broadMajorsCount + 1 + 1;
                    }
                }
                
                [self insertRows:totalNumberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                
            } else {

                intendedStudy.hasSeeMore = [NSNumber numberWithBool:YES];
                sectionHeaderView.viewSeparator.hidden = NO;
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
        }
        else if ([sectionTitle isEqualToString:@"Calendar"]) {
            
            if(!isExpanded) {
                
                sectionHeaderView.viewSeparator.hidden = YES;
                
                NSInteger rowCount = 1;
                [self insertRows:rowCount inSection:section withAnimation:UITableViewRowAnimationFade];
                
            } else {
                
                sectionHeaderView.viewSeparator.hidden = NO;
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
        }
        else if ([sectionTitle isEqualToString:@"Weather"]) {
            
            if(!isExpanded) {
                
                sectionHeaderView.viewSeparator.hidden = YES;
                
                NSInteger rowCount = 1;
                [self insertRows:rowCount inSection:section withAnimation:UITableViewRowAnimationFade];
                
            } else {
                
                sectionHeaderView.viewSeparator.hidden = NO;
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
        }
        else if ([sectionTitle isEqualToString:@"Sports"]) {
            
            if(!isExpanded) {
                
                sectionHeaderView.viewSeparator.hidden = YES;
                
                NSInteger rowCount = 3;
                [self insertRows:rowCount inSection:section withAnimation:UITableViewRowAnimationFade];
                
            } else {
                
                sectionHeaderView.viewSeparator.hidden = NO;
                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
            
        } else if ([sectionTitle isEqualToString:@"PayScale ROI Rank"]) {
            
            overlayView.hidden = YES;
            
            STCRankings *rankings = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
            
            STCRankingItem *item = [rankings.rankingItems firstObject];
            
            if(item.rankingURL && item.rankingURL.length != 0) {
                [self navigateToWebViewWithUrlString:item.rankingURL AndTitle:@"PayScale ROI Rank"];
            }
        }
        else if ([sectionTitle isEqualToString:@"Test Scores & Grades"]) {
            
            if(!isExpanded) {
                
                STCTestScoresAndGrades *testScores = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];

                sectionHeaderView.viewSeparator.hidden = YES;

                NSInteger totalNumberOfRows = 0;
                
                if(testScores.averageScores) {
                    totalNumberOfRows++;
                }
                
                if(testScores.testScoresBarCharts && ([testScores.testScoresBarCharts count] > 0)) {
                    totalNumberOfRows++;
                }
                
                if((testScores.testScoresPieCharts && ([testScores.testScoresPieCharts count] > 0)) || (testScores.testScoreSATPieChart)) {
                    totalNumberOfRows++;
                }
            
                if(testScores.testScoreHSCRBarCharts) {
                    totalNumberOfRows++;
                }
                
                totalNumberOfRows++;

                [self insertRows:totalNumberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];

//                NSNumber *isTestScoreTutorialScreenSeen =  [[NSUserDefaults standardUserDefaults] objectForKey:TEST_SCORE_TUTORIAL_SEEN];
//
//                if(![isTestScoreTutorialScreenSeen boolValue]) {
//                    [self showTestScoresTutorialView];
//                }
            }
            else {
                
                sectionHeaderView.viewSeparator.hidden = NO;

                NSInteger numberOfRows = [self.mainTableView numberOfRowsInSection:section];
                [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

// Location map clicked action

- (void)mapClickAction:(STCLocation *)location {
    
    NSDictionary *locationDict = @{KEY_LABEL:location.college.collegeName, COLLEGE_LATITUDE:location.lattitude, COLLEGE_LONGITUDE:location.longitude};

    if(self.isPresenting) {
        STLocationViewController *locationViewController = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationViewController"];
        locationViewController.locationDetails = locationDict;
        locationViewController.collegeID = self.collegeID;
        
        [self.navigationController pushViewController:locationViewController animated:YES];
    }
    else {
        if(self.mapClickedAction) {
            self.mapClickedAction(locationDict, self.collegeID);
        }
    }
}

// See more action from similar schools and prominent alumni sctions

- (void)seeMoreClicked:(NSInteger)section {
    
    STSections *sectionDetails = [self.collegeSections objectAtIndex:section];
    NSNumber *sectionID = sectionDetails.sectionItem.sectionID;
    NSString *sectionTitle = sectionDetails.sectionItem.sectionTitle;
    
    if([sectionTitle isEqualToString:@"Similar Schools"]) {
        
        STCSimilarSchools *similarSchool = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
        similarSchool.hasSeeMore = [NSNumber numberWithBool:NO];
        
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        
        NSInteger rowCount = similarSchool.simlarSchoolItems.count;
        rowCount--;
        
        for (NSInteger i = 5; i < rowCount; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        
        [self.mainTableView beginUpdates];
        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
        [self.mainTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
        [self.mainTableView endUpdates];
        
    } else if([sectionTitle isEqualToString:@"Notable Alumini"]) {
        
        STCProminentAlumini *alumini = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
        alumini.hasSeeMore = [NSNumber numberWithBool:NO];
        
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        
        NSInteger rowCount = alumini.aluminiItems.count;
        rowCount--;
        
        for (NSInteger i = 5; i < rowCount; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        
        [self.mainTableView beginUpdates];
        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
        [self.mainTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
        [self.mainTableView endUpdates];
    } else if([sectionTitle isEqualToString:@"Fees And Financial Aid"]) {
        
        STCFeesAndFinancialAid *financialAid = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
        financialAid.hasSeeMore = [NSNumber numberWithBool:NO];
        
//        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
//
//        NSInteger rowCount = alumini.aluminiItems.count;
//        rowCount--;
//
//        for (NSInteger i = 5; i < rowCount; i++) {
//            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
//        }
//
//        [self.mainTableView beginUpdates];
//        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
//        [self.mainTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
//        [self.mainTableView endUpdates];
        
        [self.mainTableView beginUpdates];
        [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
//        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
        [self.mainTableView endUpdates];
    } else if ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) {
        
        STCIntendedStudy *intendedStudy = [[STCollegeDataSource sharedInstance] getCollegeSectionForSectionID:sectionID andCollegeID:self.college.collegeID];
        bool hasSeeMoreValue = [intendedStudy.hasSeeMore boolValue];

        @try {
            if(hasSeeMoreValue) {
                intendedStudy.hasSeeMore = [NSNumber numberWithBool:NO];
                
                NSInteger broadMajorsCount = self.college.broadMajors.count;
                
                NSInteger totalRowsBeforeMajors = 0;
                totalRowsBeforeMajors = intendedStudy.admissionItems.count + 1 + 1; //1 for pie chart , 1 for student faculty ratio
                
                NSInteger totalRows = totalRowsBeforeMajors + broadMajorsCount;// + 1;
                
                NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
                
                for (NSInteger i = totalRowsBeforeMajors; i < totalRows; i++) {
                    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
                }
                
                [self.mainTableView beginUpdates];
                [self.mainTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
                [self.mainTableView endUpdates];
                
                [self.mainTableView beginUpdates];
                [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:totalRows inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
                [self.mainTableView endUpdates];
                
            } else {
                intendedStudy.hasSeeMore = [NSNumber numberWithBool:YES];
                
                NSInteger broadMajorsCount = self.college.broadMajors.count;
                
                NSInteger totalRowsBeforeMajors = 0;
                totalRowsBeforeMajors = intendedStudy.admissionItems.count + 1 + 1; //1 for pie chart , 1 for student faculty ratio
                
                NSInteger totalRows = totalRowsBeforeMajors + broadMajorsCount + 1;
                
                NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
                
                for (NSInteger i = totalRowsBeforeMajors; i < totalRows; i++) {
                    [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
                }
                
                [self.mainTableView beginUpdates];
                [self.mainTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
                [self.mainTableView endUpdates];
                
                [self.mainTableView beginUpdates];
                [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:totalRowsBeforeMajors inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
                [self.mainTableView endUpdates];
            }
        }
        @catch(NSException *exception) {
            STLog(@"Exception: %@", exception);
        }
    }
}

- (void) insertRows:(NSInteger)totalRows inSection:(NSInteger) section withAnimation:(UITableViewRowAnimation) animation {

    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < totalRows; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    [self.mainTableView beginUpdates];
    [self.mainTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:animation];
    [self.mainTableView endUpdates];
}

- (void) deleteRows:(NSInteger)totalRows inSection:(NSInteger) section withAnimation:(UITableViewRowAnimation) animation {

    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < totalRows; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    [self.mainTableView beginUpdates];
    [self.mainTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:animation];
    [self.mainTableView endUpdates];
}

- (void) callAction:(NSIndexPath *) indexPath {
    
    NSString *telephoneNo = self.college.telephoneNumber;
    NSString *formattedTelephoenString = [telephoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *finalTelephoenString = [formattedTelephoenString stringByReplacingOccurrencesOfString:@" " withString:@""];

    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", finalTelephoenString]]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", finalTelephoenString]]];
    }
    else {
        STLog(@"can't call");
    }
}

- (void) mailAction:(NSIndexPath *) indexPath {
    
    NSString *emailTitle = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:self.college.emailID];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        [mailComposeVC setSubject:emailTitle];
        [mailComposeVC setToRecipients:toRecipents];
        mailComposeVC.navigationBar.tintColor = [UIColor whiteColor];
        
        [self presentViewController:mailComposeVC animated:YES completion:nil];
    } else {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"CollegeHunch"
                                              message:@"Please configure mail in device settings to use this service."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - mail compose delegate
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

#pragma mark Retention Rate View popup view

- (void) showRetentionRatePopupAtRect:(CGRect)rect {

    int viewTag = 100200;

    CGRect frame = rect;
    frame.origin.x -= (276.0 / 2);
    frame.origin.y += 20.0;
    frame.size.width = 276.0;
    frame.size.height = 112.0;

    if(![self.mainTableView viewWithTag:viewTag]) {
        self.ratePopupView = [[NSBundle mainBundle] loadNibNamed:@"RetentionRatePopupView" owner:self options:nil].firstObject;
        self.ratePopupView.frame = frame;
        self.ratePopupView.tag = viewTag;
        [self.mainTableView addSubview:self.ratePopupView];
    } else {
        [self hideRetentionRatePopupView];
    }
}

- (void) hideRetentionRatePopupView {

    [self.ratePopupView removeFromSuperview];
}

#pragma mark Financial Aid popup view

- (void) showFinancialAidPopupAtRect:(CGRect)rect imageViewRect:(CGRect)imageViewRect position:(int)position type:(FinancialAidItem)type {
    
    int viewTag = 100201;
    
    CGRect mainRect = rect;
    mainRect.origin.y += imageViewRect.origin.y;
    if((position == 2) || (position == 4)) {
        mainRect.origin.x += ((self.mainTableView.frame.size.width / 2) + 4);
    }
    
    NSString *financialText = @"";
    switch (type) {
        case FinancialAidItemNetPrice:
            financialText = FINANCIAL_AID_NET_PRICE;
            break;
        case FinancialAidItemHouseholdIncome:
            financialText = FINANCIAL_AID_HOUSEHOLD_INCOME;
            break;
        case FinancialAidItemAverageMeritAward:
            financialText = FINANCIAL_AID_AVG_MERIT_AWARDS;
            break;
        case FinancialAidItemReceivingMeritAwards:
            financialText = FINANCIAL_AID_REC_MERIT_AWARDS;
            break;
        default:
            financialText = @"";
            break;
    }
    
//    if(type == FinancialAidItemNetPrice) {
//        financialText = FINANCIAL_AID_NET_PRICE;
//    } else {
//        financialText = FINANCIAL_AID_HOUSEHOLD_INCOME;
//    }
    
    CGFloat frameWidth = 0.0;
    CGFloat frameHeight = 0.0;
    
    if(position == 4) {
        frameWidth = self.mainTableView.frame.size.width - 40.0;
        
        UIFont *textFont = [UIFont fontType:eFontTypeAvenirRoman FontForSize:15.0];
        CGRect labelRect = [financialText boundingRectWithSize:CGSizeMake(frameWidth, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName: textFont}
                                                       context:nil];
        int labelHeight = ceilf(labelRect.size.height) + 50.0;
        frameHeight = labelHeight;
    } else {
        frameWidth = 276.0;
        frameHeight = 112.0;
    }
    
    CGRect frame = mainRect;
    frame.origin.x -= (frameWidth / 2);
    if(frame.origin.x < 15) {
        frame.origin.x = 15.0;
    }
    frame.origin.y += 20.0;
    frame.size.width = frameWidth;
    frame.size.height = frameHeight;
    
    int imageviewXPosition = frame.size.width/2;
    
    if((position == 2) || (position == 4)) {
        int frameXPosition = frame.origin.x;
        
        if((frame.origin.x + frame.size.width) > self.mainTableView.frame.size.width) {
            frame.origin.x -= ((frame.origin.x + frame.size.width) - self.mainTableView.frame.size.width) + 10;
            if(position == 2) {
                imageviewXPosition += (frameXPosition - frame.origin.x - 5);
            } else {
                imageviewXPosition = frameXPosition - frame.origin.x - 20;
            }
        }
    } else if((position == 1) || (position == 3)) {
        imageviewXPosition = rect.origin.x - 16;
    }
    
    if(![self.mainTableView viewWithTag:viewTag]) {
        self.hintPopupView = [[NSBundle mainBundle] loadNibNamed:@"STHintPopUpView" owner:self options:nil].firstObject;
        self.hintPopupView.frame = frame;
        self.hintPopupView.tag = viewTag;
//        self.hintPopupView.backgroundColor = [UIColor greenColor];
        self.hintPopupView.imageviewXPosition = imageviewXPosition;
        self.hintPopupView.position = position;
        self.hintPopupView.textLabel.text = financialText;
        [self.mainTableView addSubview:self.hintPopupView];
        
    } else {
        [self hideFinancialAidPopupView];
    }
}

- (void) hideFinancialAidPopupView {
    
    [self.hintPopupView removeFromSuperview];
}


#pragma mark view unloading methods

- (void) resetValues {
    
    [self.mainTableView setContentOffset:CGPointZero animated:NO];
    self.collegeSections = nil;
    self.mainTableView.tableFooterView = nil;
    self.mainTableView.tableHeaderView = nil;
}

- (void) viewDidDisappear:(BOOL)animated {

    //[self resetValues];
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    STLog(@"controller dealloc");
    
    self.college = nil;
    self.mainTableView.tableHeaderView = nil;
    self.mainTableView.tableFooterView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
