//
//  STFilterViewController.m
//  Stipend
//
//  Created by Arun S on 14/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

NSString * const FilterStateDidChangeNameNotification = @"kFilterStateDidChangeNameNotification";
NSString * const FilterReligiousDidChangeNameNotification = @"kFilterReligiousDidChangeNameNotification";
NSString * const FilterMajorDidChangeNameNotification = @"kFilterMajorDidChangeNameNotification";

#import "STFilterViewController.h"
#import "STFilterStateViewController.h"
#import "STFilterReligiousViewController.h"
#import "STFilterMajorsViewController.h"

#import "STFilterRangeCell.h"
#import "STFilterOptionsCell.h"
#import "STFilterCheckboxCell.h"
#import "STFilterCollegeTypeCell.h"
#import "STFilterCell.h"
#import "STFilterResetCell.h"

#import "STFilter.h"
#import "STFilterCollegeType.h"
#import "STFilterRangeItem.h"
#import "STTutorialView.h"
#import "STFilterAdmissionType.h"
#import "STFilterAdmissionTypeCell.h"

#define SECTION_COUNT                       10

#define HEADER_VIEW_HEIGHT                  30.0
#define ROW_HEIGHT                          50.0
#define SECTION_HEIGHT                      40.0
#define TOP_BARHEIGHT                       44.0

@interface STFilterViewController ()

//@property (nonatomic, strong) STFilter *filter;
@property (nonatomic, strong) NSArray *majors;

@end

@implementation STFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFilterStateNameChange:) name:FilterStateDidChangeNameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFilterReligiousChange:) name:FilterReligiousDidChangeNameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFilterMajorsChange:) name:FilterMajorDidChangeNameNotification object:nil];
    
    self.title = @"Filter Colleges";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButtonAction:)];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onDoneButtonAction:)];
    
    self.rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBarButton setFrame:CGRectMake(0, 0, 45, 30)];
    [self.rightBarButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBarButton addTarget:self action:@selector(onDoneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton];
    
//    self.rightBarButton.enabled = NO;
//    self.rightBarButton.titleLabel.alpha = 0.5f;

    
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterOptionsCell" bundle:nil] forCellReuseIdentifier:@"STFilterOptionsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterCollegeTypeCell" bundle:nil] forCellReuseIdentifier:@"STFilterCollegeTypeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterCheckboxCell" bundle:nil] forCellReuseIdentifier:@"STFilterCheckboxCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterRangeCell" bundle:nil] forCellReuseIdentifier:@"STFilterRangeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterCell" bundle:nil] forCellReuseIdentifier:@"STFilterCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterSortHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"STFilterSortHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterResetCell" bundle:nil] forCellReuseIdentifier:@"FilterResetCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFilterAdmissionTypeCell" bundle:nil] forCellReuseIdentifier:@"STFilterAdmissionTypeCell"];
    
    if([[STUserManager sharedManager] isFilterApplied]) {
        self.hasResettedFilter = NO;
    }
    else {
        self.hasResettedFilter = YES;
    }
    
    self.filterDataSourceDictionary = [[NSMutableDictionary alloc] init];
    
    if(self.localContext == nil) {
        self.localContext = [NSManagedObjectContext MR_defaultContext];
    }

    STFilter *filter = [STFilter MR_findFirstInContext:self.localContext];
    
    if (!filter) {
        [self initializeDefaultModel];
    }
    else {
        [self updateFilterView];
    }

    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self updateHeaderAndFooterView];

    __weak STFilterViewController *weakSelf = self;
    [[STNetworkAPIManager sharedManager] getMajorsMasterData:^(id response) {
        weakSelf.majors = [response objectForKey:@"majors"];
    } failure:^(NSError *error) {
    }];
}

- (void) initializeDefaultModel {
    
    STFilter *filter = [STFilter MR_createEntityInContext:self.localContext];
    [self updateFilter:filter inContext:self.localContext];
    [self updateFilterView];
}

- (void) updateFilterView {
    
    STFilter *filter = [STFilter MR_findFirstInContext:self.localContext];
    self.filterDataSourceDictionary = [self getFilterDataSource:filter];
    [self.tableView reloadData];
}

- (void)updateFilter:(STFilter *)filter inContext:(NSManagedObjectContext *) localContext {
    //SORT ORDER
    filter.sortOrder = [NSNumber numberWithInteger:0];
    
    //Favorite Only Option
    filter.favoriteOnly = [NSNumber numberWithBool:NO];
    
    //GPA
    STFilterRangeItem *gpaRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    gpaRangeItem.rangeName = @"HIGH SCHOOL GPA";
    gpaRangeItem.lowerValue = @"2.00";
    gpaRangeItem.upperValue = @"4.50";
    gpaRangeItem.curLowerValue = @"2.00";
    gpaRangeItem.curUpperValue = @"4.50";
    gpaRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:gpaRangeItem];
    
    //SAT
    STFilterRangeItem *satRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    satRangeItem.rangeName = @"AVERAGE SAT SCORE";
    satRangeItem.lowerValue = @"800";
    satRangeItem.upperValue = @"1600";
    satRangeItem.curLowerValue = @"800";
    satRangeItem.curUpperValue = @"1600";
    satRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:satRangeItem];
    
    //ACT
    STFilterRangeItem *actRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    actRangeItem.rangeName = @"AVERAGE ACT COMPOSITE";
    actRangeItem.lowerValue = @"12";
    actRangeItem.upperValue = @"36";
    actRangeItem.curLowerValue = @"12";
    actRangeItem.curUpperValue = @"36";
    actRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:actRangeItem];
    
    //FRESHMEN CLASS
    STFilterRangeItem *freshMenRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    freshMenRangeItem.rangeName = @"SIZE OF FRESHMEN CLASS";
    freshMenRangeItem.lowerValue = @"0";
    freshMenRangeItem.upperValue = @"10000";
    freshMenRangeItem.curLowerValue = @"0";
    freshMenRangeItem.curUpperValue = @"10000";
    freshMenRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:freshMenRangeItem];
    
    //ACCEPTANCE RATE
    STFilterRangeItem *acceptanceRateRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    acceptanceRateRangeItem.rangeName = @"ACCEPTANCE RATE";
    acceptanceRateRangeItem.lowerValue = @"0.0";
    acceptanceRateRangeItem.upperValue = @"100.0";
    acceptanceRateRangeItem.curLowerValue = @"0.0";
    acceptanceRateRangeItem.curUpperValue = @"100.0";
    acceptanceRateRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:acceptanceRateRangeItem];

    //4 YEAR GRADUATION RATE
    STFilterRangeItem *fourYrGraduationRateRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    fourYrGraduationRateRangeItem.rangeName = @"4-YEAR GRADUATION RATE";
    fourYrGraduationRateRangeItem.lowerValue = @"0.0";
    fourYrGraduationRateRangeItem.upperValue = @"100.0";
    fourYrGraduationRateRangeItem.curLowerValue = @"0.0";
    fourYrGraduationRateRangeItem.curUpperValue = @"100.0";
    fourYrGraduationRateRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:fourYrGraduationRateRangeItem];

    //6 YEAR GRADUATION RATE
    STFilterRangeItem *sixYrGraduationRateRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    sixYrGraduationRateRangeItem.rangeName = @"6-YEAR GRADUATION RATE";
    sixYrGraduationRateRangeItem.lowerValue = @"0.0";
    sixYrGraduationRateRangeItem.upperValue = @"100.0";
    sixYrGraduationRateRangeItem.curLowerValue = @"0.0";
    sixYrGraduationRateRangeItem.curUpperValue = @"100.0";
    sixYrGraduationRateRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:sixYrGraduationRateRangeItem];
    
    //1 YEAR RETENTION RATE
    STFilterRangeItem *oneYrRetentionRateRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    oneYrRetentionRateRangeItem.rangeName = @"1-YEAR RETENTION RATE";
    oneYrRetentionRateRangeItem.lowerValue = @"0.0";
    oneYrRetentionRateRangeItem.upperValue = @"100.0";
    oneYrRetentionRateRangeItem.curLowerValue = @"0.0";
    oneYrRetentionRateRangeItem.curUpperValue = @"100.0";
    oneYrRetentionRateRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:oneYrRetentionRateRangeItem];
    
    //DISTANCE FROM CURRENT LOCATION
    STFilterRangeItem *distanceRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    distanceRangeItem.rangeName = @"DISTANCE FROM CURRENT LOCATION";
    distanceRangeItem.lowerValue = @"0.0";
    distanceRangeItem.upperValue = @"5000.0";
    distanceRangeItem.curLowerValue = @"0.0";
    distanceRangeItem.curUpperValue = @"5000.0";
    distanceRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:distanceRangeItem];
    
    //TOTAL FEES
    STFilterRangeItem *totalFeesRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    totalFeesRangeItem.rangeName = @"TOTAL FEES";
    totalFeesRangeItem.lowerValue = @"0.0";
    totalFeesRangeItem.upperValue = @"80000.0";
    totalFeesRangeItem.curLowerValue = @"0.0";
    totalFeesRangeItem.curUpperValue = @"80000.0";
    totalFeesRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:totalFeesRangeItem];
    
    //% RECEIVING FINANCIAL AID
    STFilterRangeItem *recivingRangeItem = [STFilterRangeItem MR_createEntityInContext:localContext];
    recivingRangeItem.rangeName = @"RECEIVING FINANCIAL AID";
    recivingRangeItem.lowerValue = @"0.0";
    recivingRangeItem.upperValue = @"100.0";
    recivingRangeItem.curLowerValue = @"0.0";
    recivingRangeItem.curUpperValue = @"100.0";
    recivingRangeItem.filter = filter;
    [filter addFilterRangeItemsObject:recivingRangeItem];
    
    //TYPE OF COLLEGES
    filter.collegeType = [STFilterCollegeType MR_createEntityInContext:localContext];
    filter.collegeType.isCity = [NSNumber numberWithBool:NO];
    filter.collegeType.isTown = [NSNumber numberWithBool:NO];
    filter.collegeType.isRural = [NSNumber numberWithBool:NO];
    filter.collegeType.isUniversity = [NSNumber numberWithBool:NO];
    filter.collegeType.isCollege = [NSNumber numberWithBool:NO];
    filter.collegeType.isPrivate = [NSNumber numberWithBool:NO];
    filter.collegeType.isPublic = [NSNumber numberWithBool:NO];
    
    //TYPE OF ADMISSIONS
    filter.admissionType = [STFilterAdmissionType MR_createEntityInContext:localContext];
    filter.admissionType.isEarlyDecision = [NSNumber numberWithBool:NO];
    filter.admissionType.isEarlyAction = [NSNumber numberWithBool:NO];
    filter.admissionType.isCommonApp = [NSNumber numberWithBool:NO];
    
    //STATE
    filter.stateName = @"All";
    filter.stateCode = @"All";
    
    //RELIGIOUS AFFILIATION
    filter.religiousAffiliation = @"All";

    //MAJORS
    filter.majors = [NSMutableOrderedSet orderedSet];
}

- (NSMutableDictionary *) getFilterDataSource:(STFilter *)filter {
    
    NSPredicate *predicate = nil;
    
    STFilterRangeItem *rangeItem = nil;
    
    NSString *valueString = nil;
    
    NSString *curValueString = nil;
    
    NSSet *rangeSet = nil;
    
    NSMutableDictionary *dataSourceDict = [NSMutableDictionary dictionary];
    
    //SORT ORDER
    //NSMutableArray *sortTypesArray = [NSMutableArray arrayWithObjects:@"Alphabetically",@"No. of Freshmen",@"Average GPA",@"Average SAT score",@"Average ACT Composite",@"Acceptance Rate",@"Distance", nil];
    //[dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Sort Colleges",KEY_LABEL,filter.sortOrder,KEY_VALUE,sortTypesArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND, nil] forKey:COLLEGE_SORT_DETAILS];
    
    //Favorite Only Option
    //[dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Favorite Colleges Only",KEY_LABEL,filter.favoriteOnly,KEY_VALUE, nil] forKey:FAVOURTIE_COLLEGE_DETAILS];
    
    //GPA
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"HIGH SCHOOL GPA"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"HIGH SCHOOL GPA";
        rangeItem.lowerValue = @"2.00";
        rangeItem.upperValue = @"4.50";
        rangeItem.curLowerValue = @"2.00";
        rangeItem.curUpperValue = @"4.50";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",[rangeItem.curLowerValue floatValue] > 0.0 ? rangeItem.curLowerValue : @"2.00", rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"HIGH SCHOOL GPA",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:HIGHSCHOOL_GPA_DETAILS];
    
    //SAT
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"AVERAGE SAT SCORE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"AVERAGE SAT SCORE";
        rangeItem.lowerValue = @"800";
        rangeItem.upperValue = @"1600";
        rangeItem.curLowerValue = @"800";
        rangeItem.curUpperValue = @"1600";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",[rangeItem.curLowerValue intValue] > 0.0 ? rangeItem.curLowerValue : @"800", rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"AVERAGE SAT SCORE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:AVERAGE_SAT_DETAILS];
    
    //ACT
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"AVERAGE ACT COMPOSITE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"AVERAGE ACT COMPOSITE";
        rangeItem.lowerValue = @"12";
        rangeItem.upperValue = @"36";
        rangeItem.curLowerValue = @"12";
        rangeItem.curUpperValue = @"36";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",[rangeItem.curLowerValue intValue] > 0.0 ? rangeItem.curLowerValue : @"12", rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"AVERAGE ACT COMPOSITE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:AVERAGE_ACT_DETAILS];
    
    //TEST OPTIONAL
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TEST OPTIONAL", KEY_LABEL, filter.testOptional, KEY_VALUE, nil] forKey:TEST_OPTIONAL_DETAILS];
    
    //FRESHMEN
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"SIZE OF FRESHMEN CLASS"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"SIZE OF FRESHMEN CLASS";
        rangeItem.lowerValue = @"0";
        rangeItem.upperValue = @"10000";
        rangeItem.curLowerValue = @"0";
        rangeItem.curUpperValue = @"10000";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"SIZE OF FRESHMEN CLASS",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:FRESHMEN_SIZE_DETAILS];

    //ACCEPTANCE RATE
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"ACCEPTANCE RATE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"ACCEPTANCE RATE";
        rangeItem.lowerValue = @"0.0";
        rangeItem.upperValue = @"100.0";
        rangeItem.curLowerValue = @"0.0";
        rangeItem.curUpperValue = @"100.0";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ACCEPTANCE RATE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:ACCEPTANCE_RATE_DETAILS];

    //4 YEAR GRADUATION RATE
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"4-YEAR GRADUATION RATE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"4-YEAR GRADUATION RATE";
        rangeItem.lowerValue = @"0.0";
        rangeItem.upperValue = @"100.0";
        rangeItem.curLowerValue = @"0.0";
        rangeItem.curUpperValue = @"100.0";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"4-YEAR GRADUATION RATE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:FOUR_YR_GRADUATION_RATE_DETAILS];

    //6 YEAR GRADUATION RATE
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"6-YEAR GRADUATION RATE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"6-YEAR GRADUATION RATE";
        rangeItem.lowerValue = @"0.0";
        rangeItem.upperValue = @"100.0";
        rangeItem.curLowerValue = @"0.0";
        rangeItem.curUpperValue = @"100.0";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"6-YEAR GRADUATION RATE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:SIX_YR_GRADUATION_RATE_DETAILS];
    
    //1 YEAR RETENTION RATE
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"1-YEAR RETENTION RATE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"1-YEAR RETENTION RATE";
        rangeItem.lowerValue = @"0.0";
        rangeItem.upperValue = @"100.0";
        rangeItem.curLowerValue = @"0.0";
        rangeItem.curUpperValue = @"100.0";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"1-YEAR RETENTION RATE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:ONE_YR_RETENTION_RATE_DETAILS];
    
    //DISTANCE FROM CURRENT LOCATION
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"DISTANCE FROM CURRENT LOCATION"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"DISTANCE FROM CURRENT LOCATION";
        rangeItem.lowerValue = @"0.0";
        rangeItem.upperValue = @"5000.0";
        rangeItem.curLowerValue = @"0.0";
        rangeItem.curUpperValue = @"5000.0";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"DISTANCE FROM CURRENT LOCATION",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:DISTANCE_CURRENTLOC_DETAILS];
    
    @try {
        NSMutableArray *admissionTypeArray = [NSMutableArray arrayWithObjects:
                                              (NSMutableDictionary *)@{KEY_VALUE:filter.admissionType.isEarlyDecision},
                                              (NSMutableDictionary *)@{KEY_VALUE:filter.admissionType.isEarlyAction},
                                              (NSMutableDictionary *)@{KEY_VALUE:filter.admissionType.isCommonApp},nil];
        
        //ADMISSION TYPES
        [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ADMISSIONS", KEY_LABEL, @"", KEY_VALUE, admissionTypeArray,KEY_VALUES_ARRAY, nil] forKey:ADMISSION_TYPE_DETAILS];
    } @catch (NSException *exception) {
        NSMutableArray *admissionTypeArray = [NSMutableArray arrayWithObjects:
                                              (NSMutableDictionary *)@{KEY_VALUE:[NSNumber numberWithInt:0]},
                                              (NSMutableDictionary *)@{KEY_VALUE:[NSNumber numberWithInt:0]},
                                              (NSMutableDictionary *)@{KEY_VALUE:[NSNumber numberWithInt:0]},nil];
        
        //ADMISSION TYPES
        [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ADMISSIONS", KEY_LABEL, @"", KEY_VALUE, admissionTypeArray,KEY_VALUES_ARRAY, nil] forKey:ADMISSION_TYPE_DETAILS];
    }

    @try {
        NSMutableArray *collegeTypeArray = [NSMutableArray arrayWithObjects:
                                            (NSMutableDictionary *)@{KEY_VALUE:filter.collegeType.isUniversity},
                                            (NSMutableDictionary *)@{KEY_VALUE:filter.collegeType.isCity},
                                            (NSMutableDictionary *)@{KEY_VALUE:filter.collegeType.isTown},
                                            (NSMutableDictionary *)@{KEY_VALUE:filter.collegeType.isRural},
                                            (NSMutableDictionary *)@{KEY_VALUE:filter.collegeType.isPrivate},
                                            (NSMutableDictionary *)@{KEY_VALUE:filter.collegeType.isPublic},
                                            (NSMutableDictionary *)@{KEY_VALUE:filter.collegeType.isCollege},nil];
        
        //COLLGE TYPES
        [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TYPE OF COLLEGE",KEY_LABEL,@"",KEY_VALUE,collegeTypeArray,KEY_VALUES_ARRAY, nil] forKey:COLLEGE_TYPE_DETAILS];
    } @catch (NSException *exception) {
        NSMutableArray *collegeTypeArray = [NSMutableArray arrayWithObjects:
                                            (NSMutableDictionary *)@{KEY_VALUE:[NSNumber numberWithInt:0]},
                                            (NSMutableDictionary *)@{KEY_VALUE:[NSNumber numberWithInt:0]},
                                            (NSMutableDictionary *)@{KEY_VALUE:[NSNumber numberWithInt:0]},
                                            (NSMutableDictionary *)@{KEY_VALUE:[NSNumber numberWithInt:0]},
                                            (NSMutableDictionary *)@{KEY_VALUE:[NSNumber numberWithInt:0]},
                                            (NSMutableDictionary *)@{KEY_VALUE:[NSNumber numberWithInt:0]},
                                            (NSMutableDictionary *)@{KEY_VALUE:[NSNumber numberWithInt:0]},nil];
        
        //COLLGE TYPES
        [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TYPE OF COLLEGE",KEY_LABEL,@"",KEY_VALUE,collegeTypeArray,KEY_VALUES_ARRAY, nil] forKey:COLLEGE_TYPE_DETAILS];
    }

    //RELIGIOUS AFFILIATION
    if(filter.religiousAffiliation) {
         [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"RELIGIOUS AFFILIATION",KEY_LABEL,filter.religiousAffiliation, KEY_FILTER_RELIGIOUS, nil] forKey:RELIGIOUS_AFFILIATION_DETAILS];
    } else {
         [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"RELIGIOUS AFFILIATION",KEY_LABEL,@"All", KEY_FILTER_RELIGIOUS, nil] forKey:RELIGIOUS_AFFILIATION_DETAILS];
    }

    //MAJORS
    @try {
        [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"MAJORS (B.A./B.S.)",KEY_LABEL,filter.majors, KEY_FILTER_MAJORS, nil] forKey:MAJORS_DETAILS];
    } @catch (NSException *exception) {
        [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"MAJORS (B.A./B.S.)",KEY_LABEL,[NSMutableOrderedSet orderedSet], KEY_FILTER_MAJORS, nil] forKey:MAJORS_DETAILS];
    }

    //STATE
    if(filter.stateName && filter.stateCode) {
        [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"State",KEY_LABEL,filter.stateName, KEY_FILTER_STATE_NAME, filter.stateCode, KEY_FILTER_STATE_CODE, nil] forKey:STATE_DETAILS];
    } else {
        [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"State",KEY_LABEL,@"All", KEY_FILTER_STATE_NAME,@"All", KEY_FILTER_STATE_CODE, nil] forKey:STATE_DETAILS];
    }

    //TOTAL FEES
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"TOTAL FEES"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"TOTAL FEES";
        rangeItem.lowerValue = @"0.0";
        rangeItem.upperValue = @"80000.0";
        rangeItem.curLowerValue = @"0.0";
        rangeItem.curUpperValue = @"80000.0";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TOTAL FEES",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE,nil] forKey:TOTAL_FEES_DETAILS];
    
    //% RECEIVING FINANCIAL AID
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"RECEIVING FINANCIAL AID"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    @try {
        rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    } @catch (NSException *exception) {
        rangeItem.rangeName = @"RECEIVING FINANCIAL AID";
        rangeItem.lowerValue = @"0.0";
        rangeItem.upperValue = @"100.0";
        rangeItem.curLowerValue = @"0.0";
        rangeItem.curUpperValue = @"100.0";
        rangeItem.filter = filter;
    }
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"RECEIVING FINANCIAL AID",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE,nil] forKey:FINANCIAL_AID_DETAILS];
    
    return dataSourceDict;
}

- (void)resetAllFilters {

    if(!self.hasResettedFilter) {
        self.hasResettedFilter = YES;
        
        STFilter *filterModel = [STFilter MR_findFirstInContext:self.localContext];
        [filterModel MR_deleteEntityInContext:self.localContext];
        [self initializeDefaultModel];
        
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Filter Colleges";

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showTutorialView];

}

- (void)showTutorialView {
    
    NSNumber *isResetFilterTutorialSeen =  [[NSUserDefaults standardUserDefaults] objectForKey:RESET_FILTER_TUTORIAL_SCREEN_SEEN];
    
    if(![isResetFilterTutorialSeen boolValue]){
        
        STTutorialView *tutorialView = [STTutorialView shareView];
        [tutorialView showInView:self.navigationController.view withTutorialType:kTutorialViewTypeResetFilter];
        
        __weak STTutorialView *weakTutorialView = tutorialView;
        
        tutorialView.tutorialActionBlock = ^(NSNumber *nextIndex){
            
            [weakTutorialView showInView:self.navigationController.view withTutorialType:kTutorialViewTypeNone];
            [weakTutorialView removeFromSuperview];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:RESET_FILTER_TUTORIAL_SCREEN_SEEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        };
    }
}

- (void)showLocationTutorialView {
    
    NSNumber *isLocationFilterTutorialSeen =  [[NSUserDefaults standardUserDefaults] objectForKey:FILTER_LOCATION_SCREEN_SEEN];
    
    if(![isLocationFilterTutorialSeen boolValue]){
        
        STTutorialView *tutorialView = [STTutorialView shareView];
        [tutorialView showInView:self.navigationController.view withTutorialType:kTutorialViewTypeLocation];
        
        __weak STTutorialView *weakTutorialView = tutorialView;
        
        tutorialView.tutorialActionBlock = ^(NSNumber *nextIndex){
            
            [weakTutorialView showInView:self.navigationController.view withTutorialType:kTutorialViewTypeNone];
            [weakTutorialView removeFromSuperview];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:FILTER_LOCATION_SCREEN_SEEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        };
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.title = @"";

}

- (IBAction)onCancelButtonAction:(id)sender {
    [[STUserManager sharedManager] setShouldReloadData:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDoneButtonAction:(id)sender {

    [STProgressHUD show];

    @try {
        
        STFilter *filterModel = [STFilter MR_findFirstInContext:self.localContext];
        
        /* //COLLEGE_SORT_DETAILS
         NSMutableDictionary *sortDetailDict = [self.filterDataSourceDictionary objectForKey:COLLEGE_SORT_DETAILS];
         
         filterModel.sortOrder = [NSNumber numberWithInt:[[sortDetailDict objectForKey:KEY_VALUE] intValue]];
         
         
         //FAVOURTIE_COLLEGE_DETAILS
         NSMutableDictionary *favouriteDetailDict = [self.filterDataSourceDictionary objectForKey:FAVOURTIE_COLLEGE_DETAILS];
         
         filterModel.favoriteOnly = [NSNumber numberWithInt:[[favouriteDetailDict objectForKey:KEY_VALUE] intValue]];
         */
        
        //SORT ORDER
        filterModel.sortOrder = [NSNumber numberWithInteger:0];
        
        //Favorite Only Option
        filterModel.favoriteOnly = [NSNumber numberWithBool:NO];
        
        
        //STATE_DETAILS
        NSMutableDictionary *stateDetailDict = [self.filterDataSourceDictionary objectForKey:STATE_DETAILS];
        
        filterModel.stateName = [stateDetailDict objectForKey:KEY_FILTER_STATE_NAME];
        filterModel.stateCode = [stateDetailDict objectForKey:KEY_FILTER_STATE_CODE];
        
        //RELIGIOUS AFFILIATION
        NSMutableDictionary *religiousDetailDict = [self.filterDataSourceDictionary objectForKey:RELIGIOUS_AFFILIATION_DETAILS];
        
        filterModel.religiousAffiliation = [religiousDetailDict objectForKey:KEY_FILTER_RELIGIOUS];
        
        //TEST OPTIONALS
        NSMutableDictionary *testOptionalDict = [self.filterDataSourceDictionary objectForKey:TEST_OPTIONAL_DETAILS];
        BOOL status = [[testOptionalDict objectForKey:KEY_VALUE] boolValue];
        
        filterModel.testOptional = [NSNumber numberWithBool:status];
        
        //Range Item values
        NSPredicate *predicate = nil;
        NSArray *rangeItmes = [NSArray arrayWithObjects:
                               [NSDictionary dictionaryWithObjectsAndKeys:HIGHSCHOOL_GPA_DETAILS, KEY_LABEL, @"HIGH SCHOOL GPA", KEY_VALUE,  nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:AVERAGE_SAT_DETAILS, KEY_LABEL, @"AVERAGE SAT SCORE", KEY_VALUE,  nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:AVERAGE_ACT_DETAILS, KEY_LABEL, @"AVERAGE ACT COMPOSITE", KEY_VALUE,  nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:FRESHMEN_SIZE_DETAILS, KEY_LABEL, @"SIZE OF FRESHMEN CLASS", KEY_VALUE,  nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:ACCEPTANCE_RATE_DETAILS, KEY_LABEL, @"ACCEPTANCE RATE", KEY_VALUE,  nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:FOUR_YR_GRADUATION_RATE_DETAILS, KEY_LABEL, @"4-YEAR GRADUATION RATE", KEY_VALUE,  nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:SIX_YR_GRADUATION_RATE_DETAILS, KEY_LABEL, @"6-YEAR GRADUATION RATE", KEY_VALUE,  nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:ONE_YR_RETENTION_RATE_DETAILS, KEY_LABEL, @"1-YEAR RETENTION RATE", KEY_VALUE,  nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:DISTANCE_CURRENTLOC_DETAILS, KEY_LABEL, @"DISTANCE FROM CURRENT LOCATION", KEY_VALUE,  nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:TOTAL_FEES_DETAILS, KEY_LABEL, @"TOTAL FEES", KEY_VALUE,  nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:FINANCIAL_AID_DETAILS, KEY_LABEL, @"RECEIVING FINANCIAL AID", KEY_VALUE,  nil],nil];
        
        
        for(int index = 0; index < [rangeItmes count]; index++) {
            
            NSDictionary *rangeItemDetails = [rangeItmes objectAtIndex:index];
            
            NSString *rangeItemKey  = [rangeItemDetails objectForKey:KEY_LABEL];
            NSString *rangeItemName = [rangeItemDetails objectForKey:KEY_VALUE];
            
            NSDictionary *rangeDetails = [self.filterDataSourceDictionary objectForKey:rangeItemKey];
            NSArray *rangeItmesList = [[rangeDetails objectForKey:KEY_VALUE] componentsSeparatedByString:@","];
            
            predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",rangeItemName];
            
            NSSet *rangeSet = [filterModel.filterRangeItems filteredSetUsingPredicate:predicate];
            
            STFilterRangeItem *filterItemModel = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
            
            filterItemModel.curUpperValue = [NSString stringWithFormat:@"%.2f", [[rangeItmesList lastObject] floatValue]];
            
            float lowerValue = [[rangeItmesList firstObject] floatValue];
            
            if(([rangeItemKey isEqualToString:AVERAGE_SAT_DETAILS] && lowerValue == 800.0) || ([rangeItemKey isEqualToString:AVERAGE_ACT_DETAILS] && lowerValue == 12.0) || ([rangeItemKey isEqualToString:HIGHSCHOOL_GPA_DETAILS] && lowerValue == 2.0)) {
                lowerValue = 0.0;
            }
            
            filterItemModel.curLowerValue = [NSString stringWithFormat:@"%.2f", lowerValue];
        }
        
        //ADMISSION_TYPE_DETAILS
        NSMutableDictionary *admissionTypeDetailDict = [self.filterDataSourceDictionary objectForKey:ADMISSION_TYPE_DETAILS];
        
        NSMutableArray *admissionTypeArray = [admissionTypeDetailDict objectForKey:KEY_VALUES_ARRAY];
        
        filterModel.admissionType.isEarlyDecision = [NSNumber numberWithBool:[[[admissionTypeArray objectAtIndex:0] objectForKey:KEY_VALUE] boolValue]];
        filterModel.admissionType.isEarlyAction = [NSNumber numberWithBool:[[[admissionTypeArray objectAtIndex:1] objectForKey:KEY_VALUE] boolValue]];
        filterModel.admissionType.isCommonApp = [NSNumber numberWithBool:[[[admissionTypeArray objectAtIndex:2] objectForKey:KEY_VALUE] boolValue]];
        
        //COLLEGE_TYPE_DETAILS
        NSMutableDictionary *colleTypeDetailDict = [self.filterDataSourceDictionary objectForKey:COLLEGE_TYPE_DETAILS];
        
        NSMutableArray *collegeTypeArray = [colleTypeDetailDict objectForKey:KEY_VALUES_ARRAY];
        
        
        filterModel.collegeType.isUniversity = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:0] objectForKey:KEY_VALUE] boolValue]];
        filterModel.collegeType.isCity = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:1] objectForKey:KEY_VALUE] boolValue]];
        filterModel.collegeType.isTown = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:2] objectForKey:KEY_VALUE] boolValue]];
        filterModel.collegeType.isRural = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:3] objectForKey:KEY_VALUE] boolValue]];
        filterModel.collegeType.isPrivate = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:4] objectForKey:KEY_VALUE] boolValue]];
        filterModel.collegeType.isPublic = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:5] objectForKey:KEY_VALUE] boolValue]];
        filterModel.collegeType.isCollege = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:6] objectForKey:KEY_VALUE] boolValue]];
        
        
        __weak STFilterViewController *weakSelf = self;//to break retain cycles..
        
        [self.localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
            
            if(self.hasResettedFilter) {
                [[STUserManager sharedManager] setShouldReloadData:YES];
                [[STUserManager sharedManager] setIsFilterApplied:NO];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FILTER_STATUS];
            } else {
                [[STUserManager sharedManager] setShouldReloadData:YES];
                [[STUserManager sharedManager] setIsFilterApplied:YES];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FILTER_STATUS];
            }
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        
    } @catch (NSException *exception) {
         STLog(@"******* Exception: %@ *******", exception);
        [STProgressHUD dismissWithStatus:@"Something went wrong!, Please try later" isSucces:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateHeaderAndFooterView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, HEADER_VIEW_HEIGHT)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableFooterView = footerView;
}

- (IBAction)onSortTypeAction:(id)sender {
    
    NSMutableDictionary *sortDetailDict = [self.filterDataSourceDictionary objectForKey:COLLEGE_SORT_DETAILS];
    BOOL isExpanded = [[sortDetailDict objectForKey:KEY_EXPAND] boolValue];
    
    [sortDetailDict setObject:[NSNumber numberWithBool:!isExpanded] forKey:KEY_EXPAND];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if ([self.filterDataSourceDictionary allKeys].count) {
        return SECTION_COUNT;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == RESET_ALL_SECTION) {
        return 1;
    } else if (section == TEST_SCORE_SECTION) {
        return 3;
    } else if (section == TEST_OPTIONAL_SECTION) {
        return 1;
    } else if (section == FRESHMEN_SECTION) {
        return 2;
    } else if (section == GRADUATION_RATE_SECTION) {
        return 3;
    } else if (section == ADDMISSION_SECTION) {
        return 2;
    } else if (section == RELIGIOUS_AFFILIATION_SECTION) {
        return 1;
    } else if (section == MAJORS_SECTION) {
        return 1;
    } else if (section == LOCATION_SECTION) {
        return 2;
    } else if (section == FINANCIAL_AID_SECTION) {
        return 2;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if((indexPath.section == RESET_ALL_SECTION)) { // Reset Filter Section
        return ROW_HEIGHT;
    } else if((indexPath.section == TEST_SCORE_SECTION) || (indexPath.section == FRESHMEN_SECTION) || (indexPath.section == GRADUATION_RATE_SECTION)) {
            // Test Scores Section                          // Freshmen Profile                         // Graduation Rate
        return 80.0;
    } else if((indexPath.section == ADDMISSION_SECTION)) { // Admissions and College Type Section
        if(indexPath.row == 0) {
            return 260.0;
        } else if(indexPath.row == 1) {
            return 370.0;
        }
    } else if((indexPath.section == RELIGIOUS_AFFILIATION_SECTION) || (indexPath.section == MAJORS_SECTION)) {
                // Religious Affiliation                                // Majors
        return ROW_HEIGHT;
    } else if((indexPath.section == LOCATION_SECTION)) { // Distance and State Section
        if (indexPath.row == 0) {
            return 80.0;
        } else{
            return ROW_HEIGHT;
        }
    } else if((indexPath.section == FINANCIAL_AID_SECTION)) { // Total Fee and Receiving Financial Aid Section
        return 80.0;
    }

    return ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == RESET_ALL_SECTION) {
        return 0.0;
    } else {
        return 25.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
   /* if(section == 0) {
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, SECTION_HEIGHT)];
        [baseView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 14.0, (self.tableView.bounds.size.width/2.0) - 50.0, 21.0)];
        titleLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0];
        titleLabel.textColor = [UIColor cellTextFieldTextColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;

        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(((self.tableView.bounds.size.width/2.0) - 40.0), 14.0, (self.tableView.bounds.size.width/2.0) + 25.0, 21.0)];
        valueLabel.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0];
        valueLabel.textColor = [UIColor cellLabelTextColor];
        valueLabel.textAlignment = NSTextAlignmentRight;
        
        UIButton *overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [overlayButton addTarget:self action:@selector(onSortTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [overlayButton setTitle:@"" forState:UIControlStateNormal];
        overlayButton.frame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, SECTION_HEIGHT);
        
        NSMutableDictionary *sortDetailDict = [self.filterDataSourceDictionary objectForKey:COLLEGE_SORT_DETAILS];
        NSArray *sortArray = [sortDetailDict objectForKey:KEY_VALUES_ARRAY];
        
        NSString *label = [sortDetailDict objectForKey:KEY_LABEL];
        NSString *value = [sortArray objectAtIndex:[[sortDetailDict objectForKey:KEY_VALUE] integerValue]];

        if(label && (![label isEqualToString:@""])) {
            titleLabel.text = label;
        }
        
        if(value && (![value isEqualToString:@""])) {
            valueLabel.text = value;
        }

        [baseView addSubview:titleLabel];
        [baseView addSubview:valueLabel];
        [baseView addSubview:overlayButton];

        return baseView;
    }
    else if(section == 1) {
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectZero];
        return baseView;
    }
    else {
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectZero];
        return baseView;
    } */
    
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id contentCell = nil;
    
    __weak STFilterViewController *weakSelf = self;//to break retain cycles..

    if (indexPath.section == RESET_ALL_SECTION) {
        STFilterResetCell *cell = (STFilterResetCell *)[tableView dequeueReusableCellWithIdentifier:@"FilterResetCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        contentCell = cell;
    } else if(indexPath.section == TEST_SCORE_SECTION) {
        
        if(indexPath.row == 0) {
            STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
            
            NSMutableDictionary *highSchollGPADetailDict = [self.filterDataSourceDictionary objectForKey:HIGHSCHOOL_GPA_DETAILS];
            NSString *titleLabelString = [highSchollGPADetailDict objectForKey:KEY_LABEL];

            if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                cell.titleLabel.text = titleLabelString;
            } else {
                cell.titleLabel.text = @"";
            }
            
            [cell setRange:[highSchollGPADetailDict objectForKey:KEY_RANGE]];
            [cell setCurRange:[highSchollGPADetailDict objectForKey:KEY_VALUE]];
            cell.cellIndexPath = indexPath;
            [cell setMinMaxValueAndCurrentMinMaxSliderValue];
            [cell updateSliderTextForCell];
            
            cell.didUpdateCellActionBlock = ^(id cell) {
                [weakSelf didUpdateValueInCell:cell];
            };

            contentCell = cell;
        } else if(indexPath.row == 1) {
            STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
            
            NSMutableDictionary *averageSATDetailDict = [self.filterDataSourceDictionary objectForKey:AVERAGE_SAT_DETAILS];
            NSString *titleLabelString = [averageSATDetailDict objectForKey:KEY_LABEL];
            
            if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                cell.titleLabel.text = titleLabelString;
            }
            else {
                cell.titleLabel.text = @"";
            }

            [cell setRange:[averageSATDetailDict objectForKey:KEY_RANGE]];
            [cell setCurRange:[averageSATDetailDict objectForKey:KEY_VALUE]];

            cell.cellIndexPath = indexPath;
            [cell setMinMaxValueAndCurrentMinMaxSliderValue];
            [cell updateSliderTextForCell];

            cell.didUpdateCellActionBlock = ^(id cell) {
                [weakSelf didUpdateValueInCell:cell];
            };

            contentCell = cell;
        } else if(indexPath.row == 2) {
            STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
            
            NSMutableDictionary *averageACTDetailDict = [self.filterDataSourceDictionary objectForKey:AVERAGE_ACT_DETAILS];
            NSString *titleLabelString = [averageACTDetailDict objectForKey:KEY_LABEL];
            
            if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                cell.titleLabel.text = titleLabelString;
            }
            else {
                cell.titleLabel.text = @"";
            }
            
            [cell setRange:[averageACTDetailDict objectForKey:KEY_RANGE]];
            [cell setCurRange:[averageACTDetailDict objectForKey:KEY_VALUE]];

            cell.cellIndexPath = indexPath;
            [cell setMinMaxValueAndCurrentMinMaxSliderValue];
            [cell updateSliderTextForCell];

            cell.didUpdateCellActionBlock = ^(id cell) {
                [weakSelf didUpdateValueInCell:cell];
            };

            contentCell = cell;
        }
    } else if(indexPath.section == TEST_OPTIONAL_SECTION) {
        
        STFilterOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterOptionsCell" forIndexPath:indexPath];
        cell.labelField.text = @"TEST OPTIONAL";
        cell.cellIndexPath = indexPath;
        
        NSMutableDictionary *testOptionalDict = [self.filterDataSourceDictionary objectForKey:TEST_OPTIONAL_DETAILS];
        BOOL status = [[testOptionalDict objectForKey:KEY_VALUE] boolValue];
        
        [cell.mySwitch setOn:status];
        [cell updateSwitchWithStatus:status];
        
        cell.didUpdateCellActionBlock = ^(id cell) {
            [weakSelf didUpdateValueInCell:cell];
        };
        
        contentCell = cell;

    } else if(indexPath.section == FRESHMEN_SECTION) {

         if(indexPath.row == 0) {
            STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
            
            NSMutableDictionary *freshmenSizeGPADetailDict = [self.filterDataSourceDictionary objectForKey:FRESHMEN_SIZE_DETAILS];
            NSString *titleLabelString = [freshmenSizeGPADetailDict objectForKey:KEY_LABEL];
            
            if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                cell.titleLabel.text = titleLabelString;
            }
            else {
                cell.titleLabel.text = @"";
            }
            
            [cell setRange:[freshmenSizeGPADetailDict objectForKey:KEY_RANGE]];
            [cell setCurRange:[freshmenSizeGPADetailDict objectForKey:KEY_VALUE]];
            cell.cellIndexPath = indexPath;
            [cell setMinMaxValueAndCurrentMinMaxSliderValue];
            [cell updateSliderTextForCell];

            cell.didUpdateCellActionBlock = ^(id cell) {
                [weakSelf didUpdateValueInCell:cell];
            };

            contentCell = cell;

        } else if(indexPath.row == 1) {
            
            STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
            
            NSMutableDictionary *acceptanceRateDetailDict = [self.filterDataSourceDictionary objectForKey:ACCEPTANCE_RATE_DETAILS];
            NSString *titleLabelString = [acceptanceRateDetailDict objectForKey:KEY_LABEL];
            
            if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                cell.titleLabel.text = titleLabelString;
            }
            else {
                cell.titleLabel.text = @"";
            }
            
            [cell setRange:[acceptanceRateDetailDict objectForKey:KEY_RANGE]];
            [cell setCurRange:[acceptanceRateDetailDict objectForKey:KEY_VALUE]];
            cell.cellIndexPath = indexPath;
            [cell setMinMaxValueAndCurrentMinMaxSliderValue];
            [cell updateSliderTextForCell];

            cell.didUpdateCellActionBlock = ^(id cell) {
                [weakSelf didUpdateValueInCell:cell];
            };

            contentCell = cell;
        }
    } else if (indexPath.section == GRADUATION_RATE_SECTION) {
         if (indexPath.row == 0) {
            
            STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
            
            NSMutableDictionary *acceptanceRateDetailDict = [self.filterDataSourceDictionary objectForKey:FOUR_YR_GRADUATION_RATE_DETAILS];
            NSString *titleLabelString = [acceptanceRateDetailDict objectForKey:KEY_LABEL];
            
            if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                cell.titleLabel.text = titleLabelString;
            }
            else {
                cell.titleLabel.text = @"";
            }
            
            [cell setRange:[acceptanceRateDetailDict objectForKey:KEY_RANGE]];
            [cell setCurRange:[acceptanceRateDetailDict objectForKey:KEY_VALUE]];
            cell.cellIndexPath = indexPath;
            [cell setMinMaxValueAndCurrentMinMaxSliderValue];
            [cell updateSliderTextForCell];
            
            cell.didUpdateCellActionBlock = ^(id cell) {
                [weakSelf didUpdateValueInCell:cell];
            };
            
            contentCell = cell;
        } else if(indexPath.row == 1) {
            
            STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
            
            NSMutableDictionary *acceptanceRateDetailDict = [self.filterDataSourceDictionary objectForKey:SIX_YR_GRADUATION_RATE_DETAILS];
            NSString *titleLabelString = [acceptanceRateDetailDict objectForKey:KEY_LABEL];
            
            if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                cell.titleLabel.text = titleLabelString;
            }
            else {
                cell.titleLabel.text = @"";
            }
            
            [cell setRange:[acceptanceRateDetailDict objectForKey:KEY_RANGE]];
            [cell setCurRange:[acceptanceRateDetailDict objectForKey:KEY_VALUE]];
            cell.cellIndexPath = indexPath;
            [cell setMinMaxValueAndCurrentMinMaxSliderValue];
            [cell updateSliderTextForCell];
            
            cell.didUpdateCellActionBlock = ^(id cell) {
                [weakSelf didUpdateValueInCell:cell];
            };
            
            contentCell = cell;
        } else if(indexPath.row == 2) {
            
            STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
            
            NSMutableDictionary *acceptanceRateDetailDict = [self.filterDataSourceDictionary objectForKey:ONE_YR_RETENTION_RATE_DETAILS];
            NSString *titleLabelString = [acceptanceRateDetailDict objectForKey:KEY_LABEL];
            
            if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                cell.titleLabel.text = titleLabelString;
            }
            else {
                cell.titleLabel.text = @"";
            }
            
            [cell setRange:[acceptanceRateDetailDict objectForKey:KEY_RANGE]];
            [cell setCurRange:[acceptanceRateDetailDict objectForKey:KEY_VALUE]];
            cell.cellIndexPath = indexPath;
            [cell setMinMaxValueAndCurrentMinMaxSliderValue];
            [cell updateSliderTextForCell];
            
            cell.didUpdateCellActionBlock = ^(id cell) {
                [weakSelf didUpdateValueInCell:cell];
            };
            
            contentCell = cell;
        }
    } else if(indexPath.section == ADDMISSION_SECTION) {
         if(indexPath.row == 0) {
            STFilterAdmissionTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterAdmissionTypeCell" forIndexPath:indexPath];
            cell.cellIndexPath = indexPath;
            
            NSMutableDictionary *colleTypeDetailDict = [self.filterDataSourceDictionary objectForKey:ADMISSION_TYPE_DETAILS];
            NSArray *collegeTypeArray = [colleTypeDetailDict objectForKey:KEY_VALUES_ARRAY];
            for (int i = 0 ; i < 3; i++) {
                NSMutableDictionary *collegeTypeDict = [[collegeTypeArray objectAtIndex:i] mutableCopy];
                UIButton *button = (UIButton *)[cell.contentView viewWithTag:100 + i];
                button.selected = [[collegeTypeDict objectForKey:KEY_VALUE] boolValue];
                cell.isSelected = [[collegeTypeDict objectForKey:KEY_VALUE] boolValue];
            }
            cell.didUpdateCellActionBlock = ^(id cell) {
                [weakSelf didUpdateValueInCell:cell];
            };

            contentCell = cell;
        } else if(indexPath.row == 1) {
            STFilterCollegeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterCollegeTypeCell" forIndexPath:indexPath];
            cell.cellIndexPath = indexPath;
            
            NSMutableDictionary *colleTypeDetailDict = [self.filterDataSourceDictionary objectForKey:COLLEGE_TYPE_DETAILS];
            NSArray *collegeTypeArray = [colleTypeDetailDict objectForKey:KEY_VALUES_ARRAY];
            for (int i = 0 ; i < 7; i++) {
                NSMutableDictionary *collegeTypeDict = [[collegeTypeArray objectAtIndex:i] mutableCopy];
                UIButton *button = (UIButton *)[cell.contentView viewWithTag:100 + i];
                button.selected = [[collegeTypeDict objectForKey:KEY_VALUE] boolValue];
                cell.isSelected = [[collegeTypeDict objectForKey:KEY_VALUE] boolValue];
            }
            cell.didUpdateCellActionBlock = ^(id cell) {
                [weakSelf didUpdateValueInCell:cell];
            };
            
            contentCell = cell;
        }
    } else if (indexPath.section == RELIGIOUS_AFFILIATION_SECTION) {
        
        STFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterCell" forIndexPath:indexPath];
        NSMutableDictionary *religiousDetailDict = [self.filterDataSourceDictionary objectForKey:RELIGIOUS_AFFILIATION_DETAILS];
        NSString *label = [religiousDetailDict objectForKey:KEY_LABEL];
        
        if(label && (![label isEqualToString:@""])) {
            cell.titleLabel.text = label;
        } else {
            cell.titleLabel.text = @"";
        }
        
        cell.titleWidthConstraint.constant = 160.0;
        
        NSString *value = [religiousDetailDict objectForKey:KEY_FILTER_RELIGIOUS];
        
        if(value && (![value isEqualToString:@""])) {
            
            NSArray *religiousNames = [value componentsSeparatedByString:@","];
            
            if(religiousNames.count > 1) {
                cell.valueLabel.text = @"Various";
            } else {
                cell.valueLabel.text = value;
            }
        } else {
            cell.valueLabel.text = @"All";
        }
        cell.cellIndexPath = indexPath;
        [cell updateTitleFontIfNeeded];
        
        contentCell = cell;
        
    } else if (indexPath.section == MAJORS_SECTION) {
        
        STFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterCell" forIndexPath:indexPath];
        NSMutableDictionary *religiousDetailDict = [self.filterDataSourceDictionary objectForKey:MAJORS_DETAILS];
        NSString *label = [religiousDetailDict objectForKey:KEY_LABEL];

        if(label && (![label isEqualToString:@""])) {
            cell.titleLabel.text = label;
        } else {
            cell.titleLabel.text = @"";
        }

        cell.titleWidthConstraint.constant = 160.0;
        
        STFilter *filter = [STFilter MR_findFirstInContext:self.localContext];

        if(filter.majors.count > 0) {
            cell.valueLabel.text = @"Various";
        } else {
            cell.valueLabel.text = @"All";
        }
        
//        NSString *value = [religiousDetailDict objectForKey:KEY_FILTER_MAJORS];
//
//        if(value && (![value isEqualToString:@""])) {
//
//            NSArray *religiousNames = [value componentsSeparatedByString:@","];
//
//            if(religiousNames.count > 1) {
//                cell.valueLabel.text = @"Various";
//            } else {
//                cell.valueLabel.text = value;
//            }
//        } else {
//            cell.valueLabel.text = @"All";
//        }
        cell.cellIndexPath = indexPath;
        [cell updateTitleFontIfNeeded];
        
        contentCell = cell;
        
    } else if (indexPath.section == LOCATION_SECTION) {
            if(indexPath.row == 0) {
                STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
                
                NSMutableDictionary *distanceFromCurLocationDetailDict = [self.filterDataSourceDictionary objectForKey:DISTANCE_CURRENTLOC_DETAILS];
                NSString *titleLabelString = [distanceFromCurLocationDetailDict objectForKey:KEY_LABEL];
                
                if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                    cell.titleLabel.text = titleLabelString;
                } else {
                    cell.titleLabel.text = @"";
                }
                
                [cell setRange:[distanceFromCurLocationDetailDict objectForKey:KEY_RANGE]];
                [cell setCurRange:[distanceFromCurLocationDetailDict objectForKey:KEY_VALUE]];
                
                cell.cellIndexPath = indexPath;
                [cell setMinMaxValueAndCurrentMinMaxSliderValue];
                [cell updateSliderTextForCell];

                cell.didUpdatedCellActionBlock = ^(id cell) {
//                    [weakSelf showLocationTutorialView];
                };
                
                cell.didUpdateCellActionBlock = ^(id cell) {
                    [weakSelf didUpdateValueInCell:cell];
                };
                
                contentCell = cell;
            } else if(indexPath.row == 1) {
                STFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterCell" forIndexPath:indexPath];
                NSMutableDictionary *stateDetailDict = [self.filterDataSourceDictionary objectForKey:STATE_DETAILS];
                NSString *label = [stateDetailDict objectForKey:KEY_LABEL];
                
                if(label && (![label isEqualToString:@""])) {
                    cell.titleLabel.text = label;
                }
                else {
                    cell.titleLabel.text = @"";
                }
                
                cell.titleWidthConstraint.constant = 60.0;
                
                NSString *value = [stateDetailDict objectForKey:KEY_FILTER_STATE_NAME];
                
                if(value && (![value isEqualToString:@""])) {
                    
                    NSArray *stateNames = [value componentsSeparatedByString:@","];
                    
                    if(stateNames.count > 1) {
                        cell.valueLabel.text = @"Various";
                    } else {
                        cell.valueLabel.text = value;
                    }
                } else {
                    cell.valueLabel.text = @"All";
                }
                cell.cellIndexPath = indexPath;
                [cell updateTitleFontIfNeeded];
                
                contentCell = cell;
            }
        } else if (indexPath.section == FINANCIAL_AID_SECTION) {
            
            if(indexPath.row == 0) {
                STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
                
                NSMutableDictionary *totalFeesDetailDict = [self.filterDataSourceDictionary objectForKey:TOTAL_FEES_DETAILS];
                NSString *titleLabelString = [totalFeesDetailDict objectForKey:KEY_LABEL];
                
                if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                    cell.titleLabel.text = titleLabelString;
                } else {
                    cell.titleLabel.text = @"";
                }
                
                [cell setRange:[totalFeesDetailDict objectForKey:KEY_RANGE]];
                [cell setCurRange:[totalFeesDetailDict objectForKey:KEY_VALUE]];
                
                cell.cellIndexPath = indexPath;
                [cell setMinMaxValueAndCurrentMinMaxSliderValue];
                [cell updateSliderTextForCell];

                cell.didUpdateCellActionBlock = ^(id cell) {
                    [weakSelf didUpdateValueInCell:cell];
                };
                
                contentCell = cell;
            } else if(indexPath.row == 1) {
                STFilterRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STFilterRangeCell" forIndexPath:indexPath];
                
                NSMutableDictionary *financialAidDetailDict = [self.filterDataSourceDictionary objectForKey:FINANCIAL_AID_DETAILS];
                NSString *titleLabelString = [financialAidDetailDict objectForKey:KEY_LABEL];
                
                if(titleLabelString && (![titleLabelString isEqualToString:@""])) {
                    cell.titleLabel.text = titleLabelString;
                } else {
                    cell.titleLabel.text = @"";
                }
                
                [cell setRange:[financialAidDetailDict objectForKey:KEY_RANGE]];
                [cell setCurRange:[financialAidDetailDict objectForKey:KEY_VALUE]];
                
                cell.cellIndexPath = indexPath;
                [cell setMinMaxValueAndCurrentMinMaxSliderValue];
                [cell updateSliderTextForCell];

                cell.didUpdateCellActionBlock = ^(id cell) {
                    [weakSelf didUpdateValueInCell:cell];
                };
                
                contentCell = cell;
            }
        }
    
    return contentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == RESET_ALL_SECTION) {
        [self resetAllFilters];
    } else if (indexPath.section == LOCATION_SECTION){
        if(indexPath.row == 1) {
            //Push to State Selection VC
            self.title = @"";
            [self performSegueWithIdentifier:FILTER_STATE_SEGUE_ID sender:self];
        }
    } else if(indexPath.section == RELIGIOUS_AFFILIATION_SECTION) {
        //Push to Religious Selection VC
        self.title = @"";
        [self performSegueWithIdentifier:FILTER_RELIGIOUS_SEGUE_ID sender:self];
    } else if(indexPath.section == MAJORS_SECTION) {
        // Push to Majors Selection VC
        NSNumber *isMajorsPopupSeen =  [[NSUserDefaults standardUserDefaults] objectForKey:MAJORS_POPUP_SEEN];
        
        __weak STFilterViewController *weakSelf = self;
        
        if(![isMajorsPopupSeen boolValue]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CollegeHunch" message:MAJORS_POPUP_TEXT preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf navigateToMajorsVC];
            }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        } else {
            [self navigateToMajorsVC];
        }
    }
}

// Navigate to Majors selection screen
- (void)navigateToMajorsVC {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:MAJORS_POPUP_SEEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.title = @"";
    [self performSegueWithIdentifier:FILTER_MAJORS_SEGUE_ID sender:self];
}

#pragma mark Segue Method
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:FILTER_STATE_SEGUE_ID]) {
        STFilterStateViewController *stateViewCntrl = [segue destinationViewController];
        NSMutableDictionary *stateDetailDict = [self.filterDataSourceDictionary objectForKey:STATE_DETAILS];
        stateViewCntrl.selectedStateNameList = [NSMutableArray arrayWithArray:[[stateDetailDict objectForKey:KEY_FILTER_STATE_NAME] componentsSeparatedByString:@","]];
        stateViewCntrl.selectedStateCodeList = [NSMutableArray arrayWithArray:[[stateDetailDict objectForKey:KEY_FILTER_STATE_CODE] componentsSeparatedByString:@","]];
    } else if([[segue identifier] isEqualToString:FILTER_RELIGIOUS_SEGUE_ID]) {
        STFilterReligiousViewController *religiousViewController = [segue destinationViewController];
        NSMutableDictionary *religiousDetailDict = [self.filterDataSourceDictionary objectForKey:RELIGIOUS_AFFILIATION_DETAILS];
        religiousViewController.selectedReligiousList = [NSMutableArray arrayWithArray:[[religiousDetailDict objectForKey:KEY_FILTER_RELIGIOUS] componentsSeparatedByString:@","]];
    } else if([[segue identifier] isEqualToString:FILTER_MAJORS_SEGUE_ID]) {
        STFilterMajorsViewController *majorsViewController = [segue destinationViewController];
        majorsViewController.broadMajors = self.majors;
    }
}

#pragma mark Misc method
- (void) didUpdateValueInCell:(id) cell {
    
    @synchronized(self) {
        
        self.hasResettedFilter = NO;
        
        NSPredicate *predicate = nil;
       // STFilter *filterModel = [STFilter MR_findFirstInContext:self.localContext];
        
       /* if(!self.localContext || !filterModel) {
            STLog(@"no data");
            return;
        }*/
        
        if([cell isKindOfClass:[STFilterCheckboxCell class]]) {
            STFilterCheckboxCell *updatingCell = cell;
            
            if(updatingCell.cellIndexPath.section == TEST_SCORE_SECTION) {
                
                NSMutableDictionary *favouriteDetailDict = [self.filterDataSourceDictionary objectForKey:FAVOURTIE_COLLEGE_DETAILS];
                [favouriteDetailDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                //filterModel.favoriteOnly = [NSNumber numberWithBool:updatingCell.isSelected];
            }
        }
        else if([cell isKindOfClass:[STFilterOptionsCell class]]) {
            
            STFilterOptionsCell *updatingCell = cell;
            
            if(updatingCell.cellIndexPath.section == TEST_OPTIONAL_SECTION) {
                NSMutableDictionary *testOptionalDict = [self.filterDataSourceDictionary objectForKey:TEST_OPTIONAL_DETAILS];
                [testOptionalDict setObject:[NSNumber numberWithBool:updatingCell.mySwitch.isOn] forKey:KEY_VALUE];
            }
        }
        else if([cell isKindOfClass:[STFilterAdmissionTypeCell class]]) {
            STFilterAdmissionTypeCell *updatingCell = cell;
            
            if(updatingCell.cellIndexPath.section == ADDMISSION_SECTION) {
                if(updatingCell.cellIndexPath.row == 0) {
                    NSInteger tag = updatingCell.buttonTag - 100;
                    NSMutableDictionary *admissionTypeDetailDict = [self.filterDataSourceDictionary objectForKey:ADMISSION_TYPE_DETAILS];
                    NSMutableArray *admissionTypeArray = [admissionTypeDetailDict objectForKey:KEY_VALUES_ARRAY];
                    NSMutableDictionary *admissionTypeDict = [[admissionTypeArray objectAtIndex:tag] mutableCopy];
                    
                    if (tag == 0) {
                        [admissionTypeDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                    }else if (tag == 1){
                        [admissionTypeDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                    }else if (tag == 2){
                        [admissionTypeDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                    }
                    
                    [admissionTypeArray replaceObjectAtIndex:tag withObject:admissionTypeDict];
                    
                }
            }
        }
        else if([cell isKindOfClass:[STFilterCollegeTypeCell class]]) {
            STFilterCollegeTypeCell *updatingCell = cell;
            
            if(updatingCell.cellIndexPath.section == ADDMISSION_SECTION) {
                if(updatingCell.cellIndexPath.row == 1) {
                    NSInteger tag = updatingCell.buttonTag - 100;
                    NSMutableDictionary *colleTypeDetailDict = [self.filterDataSourceDictionary objectForKey:COLLEGE_TYPE_DETAILS];
                    NSMutableArray *collegeTypeArray = [colleTypeDetailDict objectForKey:KEY_VALUES_ARRAY];
                    NSMutableDictionary *collegeTypeDict = [[collegeTypeArray objectAtIndex:tag] mutableCopy];
                    
                    if (tag == 0) {
                        [collegeTypeDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                        //filterModel.collegeType.isUniversity = [NSNumber numberWithBool:updatingCell.isSelected];
                    }else if (tag == 1){
                        [collegeTypeDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                        //filterModel.collegeType.isCity = [NSNumber numberWithBool:updatingCell.isSelected];
                    }else if (tag == 2){
                        [collegeTypeDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                        //filterModel.collegeType.isTown = [NSNumber numberWithBool:updatingCell.isSelected];
                    }else if (tag == 3){
                        [collegeTypeDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                        //filterModel.collegeType.isRural = [NSNumber numberWithBool:updatingCell.isSelected];
                    }else if (tag == 4){
                        [collegeTypeDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                        //filterModel.collegeType.isPrivate = [NSNumber numberWithBool:updatingCell.isSelected];
                    }else if (tag == 5){
                        [collegeTypeDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                        //filterModel.collegeType.isPublic = [NSNumber numberWithBool:updatingCell.isSelected];
                    }else if (tag == 6){
                        [collegeTypeDict setObject:[NSNumber numberWithBool:updatingCell.isSelected] forKey:KEY_VALUE];
                        //filterModel.collegeType.isCollege = [NSNumber numberWithBool:updatingCell.isSelected];
                    }
                    
                    [collegeTypeArray replaceObjectAtIndex:tag withObject:collegeTypeDict];
                }
            }
        }
        else if([cell isKindOfClass:[STFilterRangeCell class]]) {
            STFilterRangeCell *updatingCell = cell;
            
            if(updatingCell.cellIndexPath.section == TEST_SCORE_SECTION) {
                
                if(updatingCell.cellIndexPath.row == 0) {
                    NSMutableDictionary *highSchollGPADetailDict = [self.filterDataSourceDictionary objectForKey:HIGHSCHOOL_GPA_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",updatingCell.rangeSlider.selectedMinimumValue,updatingCell.rangeSlider.selectedMaximumValue];
                    [highSchollGPADetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[highSchollGPADetailDict objectForKey:KEY_LABEL]];
                    
                }
                else if(updatingCell.cellIndexPath.row == 1) {
                    NSMutableDictionary *averageSATDetailDict = [self.filterDataSourceDictionary objectForKey:AVERAGE_SAT_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",roundf(updatingCell.rangeSlider.selectedMinimumValue),roundf(updatingCell.rangeSlider.selectedMaximumValue)];
                    [averageSATDetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[averageSATDetailDict objectForKey:KEY_LABEL]];
                    
                }
                else if(updatingCell.cellIndexPath.row == 2) {
                    NSMutableDictionary *averageACTDetailDict = [self.filterDataSourceDictionary objectForKey:AVERAGE_ACT_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",roundf(updatingCell.rangeSlider.selectedMinimumValue),roundf(updatingCell.rangeSlider.selectedMaximumValue)];
                    [averageACTDetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[averageACTDetailDict objectForKey:KEY_LABEL]];
                }
            } else if(updatingCell.cellIndexPath.section == FRESHMEN_SECTION) {

                 if(updatingCell.cellIndexPath.row == 0) {
                    NSMutableDictionary *freshmenSizeGPADetailDict = [self.filterDataSourceDictionary objectForKey:FRESHMEN_SIZE_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",roundf(updatingCell.rangeSlider.selectedMinimumValue),roundf(updatingCell.rangeSlider.selectedMaximumValue)];
                    [freshmenSizeGPADetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[freshmenSizeGPADetailDict objectForKey:KEY_LABEL]];
                }
                else if(updatingCell.cellIndexPath.row == 1) {
                    NSMutableDictionary *acceptanceRateDetailDict = [self.filterDataSourceDictionary objectForKey:ACCEPTANCE_RATE_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",roundf(updatingCell.rangeSlider.selectedMinimumValue),roundf(updatingCell.rangeSlider.selectedMaximumValue)];
                    [acceptanceRateDetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[acceptanceRateDetailDict objectForKey:KEY_LABEL]];
                }
                
            } else if(updatingCell.cellIndexPath.section == GRADUATION_RATE_SECTION) {
                if(updatingCell.cellIndexPath.row == 0) {
                    NSMutableDictionary *acceptanceRateDetailDict = [self.filterDataSourceDictionary objectForKey:FOUR_YR_GRADUATION_RATE_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",roundf(updatingCell.rangeSlider.selectedMinimumValue),roundf(updatingCell.rangeSlider.selectedMaximumValue)];
                    [acceptanceRateDetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[acceptanceRateDetailDict objectForKey:KEY_LABEL]];
                    
                } else if(updatingCell.cellIndexPath.row == 1) {
                    NSMutableDictionary *acceptanceRateDetailDict = [self.filterDataSourceDictionary objectForKey:SIX_YR_GRADUATION_RATE_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",roundf(updatingCell.rangeSlider.selectedMinimumValue),roundf(updatingCell.rangeSlider.selectedMaximumValue)];
                    [acceptanceRateDetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[acceptanceRateDetailDict objectForKey:KEY_LABEL]];
                    
                } else if(updatingCell.cellIndexPath.row == 2) {
                    NSMutableDictionary *acceptanceRateDetailDict = [self.filterDataSourceDictionary objectForKey:ONE_YR_RETENTION_RATE_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",roundf(updatingCell.rangeSlider.selectedMinimumValue),roundf(updatingCell.rangeSlider.selectedMaximumValue)];
                    [acceptanceRateDetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[acceptanceRateDetailDict objectForKey:KEY_LABEL]];
                }
            }
            else if (updatingCell.cellIndexPath.section == LOCATION_SECTION) {
                if(updatingCell.cellIndexPath.row == 0) {
                    NSMutableDictionary *distanceFromCurLocationDetailDict = [self.filterDataSourceDictionary objectForKey:DISTANCE_CURRENTLOC_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",roundf(updatingCell.rangeSlider.selectedMinimumValue),roundf(updatingCell.rangeSlider.selectedMaximumValue)];
                    [distanceFromCurLocationDetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[distanceFromCurLocationDetailDict objectForKey:KEY_LABEL]];
                }
            }
            else if (updatingCell.cellIndexPath.section == FINANCIAL_AID_SECTION){
                if(updatingCell.cellIndexPath.row == 0) {
                    NSMutableDictionary *totalFeesDetailDict = [self.filterDataSourceDictionary objectForKey:TOTAL_FEES_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",roundf(updatingCell.rangeSlider.selectedMinimumValue),roundf(updatingCell.rangeSlider.selectedMaximumValue)];
                    [totalFeesDetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[totalFeesDetailDict objectForKey:KEY_LABEL]];
                }
                else if(updatingCell.cellIndexPath.row == 1) {
                    NSMutableDictionary *financialAidDetailDict = [self.filterDataSourceDictionary objectForKey:FINANCIAL_AID_DETAILS];
                    NSString *range = [NSString stringWithFormat:@"%.2f,%.2f",roundf(updatingCell.rangeSlider.selectedMinimumValue),roundf(updatingCell.rangeSlider.selectedMaximumValue)];
                    [financialAidDetailDict setObject:range forKey:KEY_VALUE];
                    
                    //Predicate
                    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",[financialAidDetailDict objectForKey:KEY_LABEL]];
                }
            }
        }
    }
}

- (void)didFilterStateNameChange:(NSNotification *)notification {

    self.hasResettedFilter = NO;

    NSDictionary *notificatioDictDetails = notification.userInfo;
    
   /* STFilter *filter = [STFilter MR_findFirstInContext:self.localContext];
    
    if(filter) {
        filter.stateName = [notificatioDictDetails objectForKey:KEY_FILTER_STATE_NAME];
        filter.stateCode = [notificatioDictDetails objectForKey:KEY_FILTER_STATE_CODE];
    }*/
    
    NSMutableDictionary *stateDetailDict = [self.filterDataSourceDictionary objectForKey:STATE_DETAILS];
    [stateDetailDict setObject:[notificatioDictDetails objectForKey:KEY_FILTER_STATE_NAME] forKey:KEY_FILTER_STATE_NAME];
    [stateDetailDict setObject:[notificatioDictDetails objectForKey:KEY_FILTER_STATE_CODE] forKey:KEY_FILTER_STATE_CODE];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:LOCATION_SECTION] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didFilterReligiousChange:(NSNotification *)notification {
    
    self.hasResettedFilter = NO;
    
    NSDictionary *notificatioDictDetails = notification.userInfo;
    
    NSMutableDictionary *religiousDetailDict = [self.filterDataSourceDictionary objectForKey:RELIGIOUS_AFFILIATION_DETAILS];
    [religiousDetailDict setObject:[notificatioDictDetails objectForKey:KEY_FILTER_RELIGIOUS] forKey:KEY_FILTER_RELIGIOUS];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:RELIGIOUS_AFFILIATION_SECTION] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didFilterMajorsChange:(NSNotification *)notification {
    
    self.hasResettedFilter = NO;
    
//    NSMutableDictionary *religiousDetailDict = [self.filterDataSourceDictionary objectForKey:RELIGIOUS_AFFILIATION_DETAILS];
//    [religiousDetailDict setObject:[notificatioDictDetails objectForKey:KEY_FILTER_RELIGIOUS] forKey:KEY_FILTER_RELIGIOUS];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:MAJORS_SECTION] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark View Unload Methods
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FilterStateDidChangeNameNotification object:nil];
    //self.filterDataSourceDictionary = nil;
    STLog(@"Dealloc");
}

@end
