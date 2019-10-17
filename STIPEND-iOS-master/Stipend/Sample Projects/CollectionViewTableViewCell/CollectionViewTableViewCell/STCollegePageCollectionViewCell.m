//
//  STCollegePageCollectionViewCell.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 26/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_EXPAND                      @"kExpandKey"

#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_VALUES_DICT                 @"kValuesDictKey"
#define KEY_VALID                       @"kValidKey"
#define KEY_ICON                        @"kIconKey"
#define KEY_ICON_TYPE                   @"kIconTypeKey"

#define KEY_MALE_PERCENTAGE             @"kMalePercentageKey"
#define KEY_FEM_PERCENTAGE              @"kFemalePercentageKey"
#define KEY_PERCENTAGE                  @"kPercentageKey"

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


#import "STCollegePageCollectionViewCell.h"
#import "STAdmissionCodeViewCell.h"
#import "STAdmissionSwitchViewCell.h"
#import "STMainDateViewCell.h"
#import "STCalenderViewCell.h"
#import "STEventKitManager.h"

#import "STSportsViewCell.h"
#import "STSportsDivisionCell.h"
#import "STSportsListViewCell.h"

#import "STFinancialListViewCell.h"
#import "STFinancialStateViewCell.h"
#import "STFinancialAidCell.h"

#import "STCollegeRankingsViewCell.h"

#import "STWeatherTemperatureCell.h"
#import "STWeatherAveragesCell.h"
#import "STWeatherViewCell.h"
#import "STWeatherCastListCell.h"

#import "STQuickFactsViewCell.h"

#import "STImportantDateView.h"
#import "STOtherDateView.h"

#import "STCollegeCalenderViewCell.h"

#define COLLEGE_RANKINGS_DETAILS  @"kCollegeRankingDetailsKey"
#define FINANCIAL_AID_DETAILS     @"kFinancialAidDetailsKey"

#define KEY_EXPAND                      @"kExpandKey"
#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_VALID                       @"kValidKey"
#define KEY_ISACTIVE                    @"kIsActiveKey"
#define KEY_COLORS_VALUES_ARRAY         @"kColorValuesArrayKey"
#define KEY_VALUES_LIST_ARRAY           @"kListValuesArrayKey"




@interface STCollegePageCollectionViewCell()

@property (nonatomic, strong) NSDateComponents *dateComponents;
@property (nonatomic, strong) STEventKitManager *eventManager;

@property (nonatomic, strong) NSDictionary *collegePageDictionary;

@property (nonatomic, strong) NSMutableDictionary *dataSourceDict;


@property (nonatomic, assign) BOOL isToggle;
@end
@implementation STCollegePageCollectionViewCell
@synthesize collegePageSection;
@synthesize dateComponents,eventManager;
@synthesize collegePageDictionary, isToggle , dataSourceDict;

- (void)updateAuthorizationStatusToAccessEventStore {
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authorizationStatus) {
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Reminders." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
            break;
        }
            
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            break;
            
        case EKAuthorizationStatusNotDetermined: {
            __weak STCollegePageCollectionViewCell *weakSelf = self;
            [eventManager.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                });
                                            }];
            break;
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
    
    self.collegePageDictionary = [self getCollegeDataSource];
    
    dataSourceDict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *calenderArray = [NSMutableArray array];
    NSMutableDictionary *mostImportantDatesDict = [NSMutableDictionary dictionary];
    
    NSMutableArray *mostImpDatesArray = [NSMutableArray array];
    [mostImpDatesArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Early Decision Deadline",KEY_LABEL,nil,KEY_ICON,@"1 Nov",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil]];
    [mostImpDatesArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Early Action Deadline",KEY_LABEL,nil,KEY_ICON,@"4 Nov",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil]];
    [mostImpDatesArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Regular Action Deadline",KEY_LABEL,nil,KEY_ICON,@"8 Nov",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil]];
    
    [mostImportantDatesDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Most Imp Dates",KEY_LABEL,@"",KEY_ICON,@"",KEY_VALUE,mostImpDatesArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:@"kMostImpDateKey"];
    
    NSMutableDictionary *otherDatesDict = [NSMutableDictionary dictionary];
    
    NSMutableArray *otherDatesArray = [NSMutableArray array];
    [otherDatesArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"SAT Scores Due",KEY_LABEL,nil,KEY_ICON,@"1 Jan",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil]];
    [otherDatesArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ACT Scores Due",KEY_LABEL,nil,KEY_ICON,@"1 Jan",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil]];
    [otherDatesArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"SAT Subject Scores Due",KEY_LABEL,nil,KEY_ICON,@"1 Jan",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil]];
    [otherDatesArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Recommendations Due",KEY_LABEL,nil,KEY_ICON,@"1 Jan",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil]];
    [otherDatesArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Ealry Decision Notification",KEY_LABEL,nil,KEY_ICON,@"1 Feb",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil]];
    [otherDatesArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Early Action Notification",KEY_LABEL,nil,KEY_ICON,@"1 Mar",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil]];
    
    [otherDatesDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Other Dates",KEY_LABEL,@"",KEY_ICON,@"",KEY_VALUE,otherDatesArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:@"kOtherImpDateKey"];
    
    [calenderArray addObject:mostImportantDatesDict];
    [calenderArray addObject:otherDatesDict];
    
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Calendar",KEY_LABEL,@"tile_calender",KEY_ICON,@"",KEY_VALUE,calenderArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:CALENDAR_DETAILS];

    
    eventManager = [STEventKitManager sharedManager];
    dateComponents = [[NSDateComponents alloc] init];
    [self updateAuthorizationStatusToAccessEventStore];
    
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STAdmissionCodeViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AdmissionCodeCellIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STAdmissionSwitchViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AdmissionSwitchViewIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STMainDateViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MainDateViewCellIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STCalenderViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CalenderCellIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STSportsViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SportsViewCellIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STSportsDivisionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SportsDivisionCellIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STSportsListViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SportsListViewCellIdentifier"];
    
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STFinancialListViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FinancialListViewIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STFinancialStateViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FinancialStateViewCellIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STFinancialAidCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FinancialAidCellIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STCollegeRankingsViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CollegeRankingsViewCellIdentifier"];
    
    
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STWeatherViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WeatherViewCellIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STWeatherAveragesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WeatherAveragesCellIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STWeatherTemperatureCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WeatherTemperatureCellIdentifier"];
    [self.ibTableView registerNib:[UINib nibWithNibName:@"STWeatherCastListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"WeatherCastListCellIdentifier"];//
    
     [self.ibTableView registerNib:[UINib nibWithNibName:@"STQuickFactsViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QuickFactsViewCellIdentifier"];
 }

- (NSDictionary *)getCollegeDataSource{
    NSMutableDictionary *dataSourceDict1 = [NSMutableDictionary dictionary];
    
    NSMutableArray *collegeRankingsArray = [NSMutableArray arrayWithObjects:@{@"Forbes": @"1"},@{@"Financial Times": @"2"},@{@"U.S. News & World Reports": @"3"},@{@"Business Insider": @"4"}, nil];
    NSArray *colorsArray = @[[UIColor yellowColor],[UIColor redColor],[UIColor blueColor],[UIColor greenColor]];
    [dataSourceDict1 setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:collegeRankingsArray,KEY_VALUES_ARRAY,colorsArray,KEY_COLORS_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:COLLEGE_RANKINGS_DETAILS];
    
    NSMutableArray *financialListOutStateArray = [NSMutableArray arrayWithObjects:@{@"Application Fee": @"$75"},@{@"Tuition": @"$50"},@{@"Room & Board": @"$3011"},@{@"Books & Supplies": @"$14,500"}, nil];
    NSMutableArray *financialListInStateArray = [NSMutableArray arrayWithObjects:@{@"Application Fee": @"$55"},@{@"Tuition": @"$37,500"},@{@"Room & Board": @"$3011"},@{@"Books & Supplies": @"$14,500"}, nil];
    [dataSourceDict1 setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:financialListInStateArray,KEY_VALUES_ARRAY,financialListOutStateArray,KEY_VALUES_LIST_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:FINANCIAL_AID_DETAILS];

    
    return dataSourceDict;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case eCollegePageAdmissions:
            return 10;
            break;
        case eCollegePageCalender:{
            return 1;//7;
        }
            break;
        case eCollegePageSports:
            return 5;
            break;
        case eCollegePageFinancialAid:
            return 6;
            break;
        case eCollegePageCollegeRankings:
            return 4;
            break;
        case eCollegePageWeather:
            return 4;
            break;
        case eCollegePageQuickFacts:
            return 1;
        default:
            break;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak STCollegePageCollectionViewCell *weakSelf = self;
    id cell = nil;
    switch (indexPath.section) {//AdmissionCodeCellIdentifier
        case eCollegePageAdmissions:{
            if (indexPath.row == 0) {
                STAdmissionCodeViewCell *contentCell = (STAdmissionCodeViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AdmissionCodeCellIdentifier"];
                if (contentCell == nil) {
                    contentCell = (STAdmissionCodeViewCell *)[STAdmissionCodeViewCell loadFromNib];
                }
                cell = contentCell;
            } else if (indexPath.row == 7 || indexPath.row == 8) {
                STAdmissionSwitchViewCell *contentCell = (STAdmissionSwitchViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AdmissionSwitchViewIdentifier"];
                if (contentCell == nil) {
                    contentCell = (STAdmissionSwitchViewCell *)[STAdmissionSwitchViewCell loadFromNib];
                }
                contentCell.ibLabelValue.text = @"Jipmer";
                contentCell.ibLabelLeadingSpaceConstraint.constant = 27.0f;
                contentCell.ibSeparatorLineView.hidden = YES;
                cell = contentCell;

            } else if (indexPath.row == 6) {
                UITableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"BasicCellIdentifier"];
                if (contentCell == nil) {
                    contentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BasicCellIdentifier"];
                }
                contentCell.textLabel.text = @"Hot Cripsy";
                contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell = contentCell;
            } else {
                STAdmissionSwitchViewCell *contentCell = (STAdmissionSwitchViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AdmissionSwitchViewIdentifier"];
                if (contentCell == nil) {
                    contentCell = (STAdmissionSwitchViewCell *)[STAdmissionSwitchViewCell loadFromNib];
                }
                contentCell.ibLabelValue.text = @"KFC Chicken";
                contentCell.ibLabelLeadingSpaceConstraint.constant = 10.0f;
                contentCell.ibSeparatorLineView.hidden = NO;
                cell = contentCell;
            }
        }
            break;
        case eCollegePageCalender:{
            NSMutableDictionary *calenderDict = [dataSourceDict objectForKey:CALENDAR_DETAILS];
            NSMutableArray *calenderArray = [calenderDict objectForKey:KEY_VALUES_ARRAY];
            NSMutableDictionary *importantDatesDictionary = nil;
            NSMutableDictionary *OtherDatesDictionary = nil;
            for (NSMutableDictionary *dictionary in calenderArray) {
                if ([dictionary objectForKey:@"kMostImpDateKey"] != nil) {
                    importantDatesDictionary = [dictionary objectForKey:@"kMostImpDateKey"];
                    NSLog(@"importantDatesDictionary = %@",importantDatesDictionary);
                }else if ([dictionary objectForKey:@"kOtherImpDateKey"] != nil){
                    OtherDatesDictionary = [dictionary objectForKey:@"kOtherImpDateKey"];
                    NSLog(@"OtherDatesDictionary = %@",OtherDatesDictionary);}
            }

            
            STCollegeCalenderViewCell *contentView = (STCollegeCalenderViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CollegeCalenderViewCellIdentifier"];
            if (contentView == nil) {
                [tableView registerClass:[STCollegeCalenderViewCell class] forCellReuseIdentifier:@"CollegeCalenderViewCellIdentifier"];
                contentView = [tableView dequeueReusableCellWithIdentifier:@"CollegeCalenderViewCellIdentifier"];
                contentView.frame = CGRectMake(0, 0, self.frame.size.width, 204.0 + (4 * 65.0) + 139.0);
                contentView.contentView.backgroundColor = [UIColor lightGrayColor];
                [contentView loadViews:kCalenderViewTypeImportantDates withDataSource:importantDatesDictionary];
                [contentView loadViews:kCalenderViewTypeOtherDates withDataSource:OtherDatesDictionary];
                [contentView loadViews:kCalenderViewTypeFooter withDataSource:nil];
            }
            cell = contentView;
           /* if (indexPath.row == 0) {
                STMainDateViewCell *contentCell = (STMainDateViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MainDateViewCellIdentifier"];
                if (contentCell == nil) {
                    contentCell = (STMainDateViewCell *)[STMainDateViewCell loadFromNib];
                }
                cell = contentCell;
            } else if (indexPath.row == 6){
                UITableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"BasicCellIdentifier"];
                if (contentCell == nil) {
                    contentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BasicCellIdentifier"];
                }
                contentCell.textLabel.text = @"Tap a date to add it to your calender.";
                contentCell.textLabel.textAlignment = NSTextAlignmentCenter;
                contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell = contentCell;
            } else {
                STCalenderViewCell *contentCell = (STCalenderViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CalenderCellIdentifier"];
                if (contentCell == nil) {
                    contentCell = (STCalenderViewCell *)[STCalenderViewCell loadFromNib];
                }
                contentCell.didDateAddedActionBlock = ^{
                    [weakSelf addDateToCalender];
                };
                cell = contentCell;
            } */
        }
            break;
        case eCollegePageSports:{
            if (indexPath.row == 0) {
                STSportsViewCell *contentCell = (STSportsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SportsViewCellIdentifier"];
                cell = contentCell;
            }else if(indexPath.row == 1){
                STSportsDivisionCell *contentCell = (STSportsDivisionCell *)[tableView dequeueReusableCellWithIdentifier:@"SportsDivisionCellIdentifier"];
                cell = contentCell;
            }else{
                STSportsListViewCell *contentCell = (STSportsListViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SportsListViewCellIdentifier"];
                cell = contentCell;
            }
        }
            break;
        case eCollegePageFinancialAid:{
            if (indexPath.row == 0) {
                STFinancialStateViewCell *contentCell = (STFinancialStateViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FinancialStateViewCellIdentifier"];
                isToggle = [[[collegePageDictionary objectForKey:FINANCIAL_AID_DETAILS] objectForKey:KEY_VALID] boolValue];
                if (isToggle) {
                    contentCell.ibRightSeparatorLine.hidden = TRUE;
                    contentCell.ibLeftSeparatorLine.hidden = FALSE;
                    contentCell.ibLeftLabel.alpha = 1.0;
                    contentCell.ibRightLabel.alpha = 0.35;
                }else{
                    contentCell.ibLeftSeparatorLine.hidden = TRUE;
                    contentCell.ibRightSeparatorLine.hidden = FALSE;
                    contentCell.ibRightLabel.alpha = 1.0;
                    contentCell.ibLeftLabel.alpha = 0.35;
                }
                contentCell.onButtonActionBlock = ^(id sender){
                    UIButton *button = (UIButton *)sender;
                    [weakSelf financeStateToggle:button.tag];
                };
                cell = contentCell;
            }else if(indexPath.row >= 1 && indexPath.row <=4){
                STFinancialListViewCell *contentCell = (STFinancialListViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FinancialListViewIdentifier"];
                NSMutableDictionary *dictionary = [collegePageDictionary objectForKey:FINANCIAL_AID_DETAILS];
                NSMutableArray *inOutStateArray = nil;
                isToggle = [[[collegePageDictionary objectForKey:FINANCIAL_AID_DETAILS] objectForKey:KEY_VALID] boolValue];
                if (isToggle) {
                    inOutStateArray = [dictionary objectForKey:KEY_VALUES_ARRAY];
                }else{
                    inOutStateArray = [dictionary objectForKey:KEY_VALUES_LIST_ARRAY];
                }
                NSDictionary *dict = [inOutStateArray objectAtIndex:indexPath.row - 1];
                contentCell.ibLabelField.text = [[dict allKeys] objectAtIndex:0];
                contentCell.ibLabelValue.text = [[dict allValues] objectAtIndex:0];
                cell = contentCell;
            }else{
                STFinancialAidCell *contentCell = (STFinancialAidCell *)[tableView dequeueReusableCellWithIdentifier:@"FinancialAidCellIdentifier"];
                cell = contentCell;//CollegeRankingsViewCellIdentifier
            }
        }
            break;
        case eCollegePageCollegeRankings:{
            STCollegeRankingsViewCell *contentCell = (STCollegeRankingsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CollegeRankingsViewCellIdentifier"];
            NSMutableDictionary *dictionary = [self.collegePageDictionary objectForKey:COLLEGE_RANKINGS_DETAILS];
            NSMutableArray *collegeRankingArray = (NSMutableArray *)[dictionary objectForKey:KEY_VALUES_ARRAY];
            NSDictionary *collegeRankingDict = (NSDictionary *)[collegeRankingArray objectAtIndex:indexPath.row];
            contentCell.ibLabelValue.text = [[collegeRankingDict allKeys] objectAtIndex:0];
            contentCell.ibRankLabel.text = [[collegeRankingDict allValues] objectAtIndex:0];
            cell = contentCell;
        }
             break;
        case eCollegePageWeather:{
            if (indexPath.row == 0) {
                STWeatherViewCell *contentCell = (STWeatherViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WeatherViewCellIdentifier"];
                cell = contentCell;

            }else if (indexPath.row == 1){
                STWeatherCastListCell *contentCell = (STWeatherCastListCell *)[tableView dequeueReusableCellWithIdentifier:@"WeatherCastListCellIdentifier"];
                cell = contentCell;
            }else if (indexPath.row == 2){
                STWeatherAveragesCell *contentCell = (STWeatherAveragesCell *)[tableView dequeueReusableCellWithIdentifier:@"WeatherAveragesCellIdentifier"];
                cell = contentCell;
            }else{
                STWeatherTemperatureCell *contentCell = (STWeatherTemperatureCell *)[tableView dequeueReusableCellWithIdentifier:@"WeatherTemperatureCellIdentifier"];
                cell = contentCell;
            }
         }
            break;//QuickFactsViewCellIdentifier
        case eCollegePageQuickFacts:{
            STQuickFactsViewCell *contentCell = (STQuickFactsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"QuickFactsViewCellIdentifier"];
            contentCell = [self configureCellAtIndexPath:indexPath];
            cell = contentCell;
        }
        default:
            break;
    }
    return cell;
}

- (STQuickFactsViewCell *)configureCellAtIndexPath:(NSIndexPath *)indexPath {
    STQuickFactsViewCell *cell = [self.ibTableView dequeueReusableCellWithIdentifier:@"QuickFactsViewCellIdentifier" forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(STQuickFactsViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
   cell.ibTopLabelValue.text = @"A simple approach you might take is to add an image view to RWBasicCell. While this might work for some apps, Deviant Art has both deviations (posts with images) and blog posts (without images), so in this instance, it’s actually better to create a new custom cell.";
    
    cell.ibBottomLabelValue.text = @"A simple approach you might take is to add an image view to RWBasicCell. While this might work for some apps, Deviant Art has both deviations (posts with images) and blog posts (without images), so in this instance, it’s actually better to create a new custom cell.";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case eCollegePageAdmissions:
            if (indexPath.row == 0) {
                return 110.0f;
            }else{
                return 44.0f;
            }
            break;
        case eCollegePageCalender:
            return 204.0 + (4 * 65.0) + 139.0;
            break;
        case eCollegePageSports:
            return 60.0f;
            break;
        case eCollegePageFinancialAid:
            if (indexPath.row == 0)
               return 60.0;
            else if(indexPath.row >= 1 && indexPath.row <=4)
                return 50.0;
            else
                return 100.0;
            break;
        case eCollegePageCollegeRankings:
            return 55.0;
            break;
        case eCollegePageWeather:
            if (indexPath.row == 0) {
                return 142.0f;
            } else if(indexPath.row == 1){
                return 135.0f;
            } else if(indexPath.row == 2){
                return 148.0f;
            } else{
                return 75.0f;
            }
            break;
        case eCollegePageQuickFacts:
             return [self heightForBasicCellAtIndexPath:indexPath];
            break;
        default:
            break;
    }

    return 0.0f;
}



- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static STQuickFactsViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.ibTableView dequeueReusableCellWithIdentifier:@"QuickFactsViewCellIdentifier"];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark Finance State View Cell Methods
- (void)financeStateToggle:(NSInteger)tag {
    //STFinancialStateViewCell *contentCell
    [self.ibTableView reloadSections:[NSIndexSet indexSetWithIndex:eCollegePageFinancialAid] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)addDateToCalender {
    
    [dateComponents setDay:12];
    [dateComponents setMonth:06];
    [dateComponents setYear:2015];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    //[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate * timestamp = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    EKEvent *event = [EKEvent eventWithEventStore:eventManager.eventStore];
    event.title = @"EVENT Manager WHERE";
    event.startDate = timestamp;
    event.endDate = [event.startDate dateByAddingTimeInterval:24*60*60];
    [event setCalendar:[eventManager.eventStore defaultCalendarForNewEvents]];
    NSError *err = nil;
    [eventManager.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
}

-(void)dealloc{
    NSLog(@"STCollegePageCollectionViewCell");
}

@end
