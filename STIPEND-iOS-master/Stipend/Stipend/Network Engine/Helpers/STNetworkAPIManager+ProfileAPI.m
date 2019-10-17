//
//  STNetworkAPIManager+ProfileAPI.m
//  Stipend
//
//  Created by Arun S on 08/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager+ProfileAPI.h"

#import "STFilter.h"
#import "STFilterCollegeType.h"
#import "STFilterRangeItem.h"
#import "STFilterAdmissionType.h"

@implementation STNetworkAPIManager(ProfileAPI)

- (void) updateProfileWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {

    NSMutableDictionary *detailDict = [NSMutableDictionary dictionaryWithDictionary:details];
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];

    __weak STNetworkAPIManager *weakSelf = self;

    if([[STUserManager sharedManager] isGuestUser]) {
        [detailDict setObject:userID forKey:kUserID];
        [weakSelf updateUserProfileToCoreDataWithDetails:detailDict forResponseType:eResponseTypeUpdateProfile success:successBlock failure:failureBlock];
    }
    else {
        [detailDict setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
        [self POST:@"updateProfileDetails" parameters:detailDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSMutableDictionary *responseDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            [responseDict addEntriesFromDictionary:detailDict];
            
            [weakSelf updateUserProfileToCoreDataWithDetails:responseDict forResponseType:eResponseTypeUpdateProfile success:successBlock failure:failureBlock];
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
            failureBlock(error);
        }];
    }
}

- (void) getFilterPreferencesSuccess:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    if(![[STUserManager sharedManager] isGuestUser]) {
        
        __weak STNetworkAPIManager *weakSelf = self;
        
        [self GET:[NSString stringWithFormat:@"getUserFilters/%@", userID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if(![self isNullValueForObject:([responseObject objectForKey:kFilterData])] && ![self isNullValueForObject:[responseObject objectForKey:kResetState]] && ![[responseObject objectForKey:kResetState] boolValue]) {
                NSError *jsonError;
                NSData *objectData = [[responseObject objectForKey:kFilterData] dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableDictionary *filterDict = [NSJSONSerialization JSONObjectWithData:objectData
                                                                                  options:NSJSONReadingMutableContainers
                                                                                    error:&jsonError];
                
                [weakSelf updateUserProfileToCoreDataWithDetails:filterDict forResponseType:eResponseTypeGetFilterData success:successBlock failure:failureBlock];
            } else {
                [[STUserManager sharedManager] resetFilterWithCompletion:nil];
                successBlock([NSNull null]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
            failureBlock(error);
        }];
    } else {
        [[STUserManager sharedManager] resetFilterWithCompletion:nil];
        successBlock([NSNull null]);
    }
}

- (void) updateFilterPreferences:(NSMutableDictionary *)details resetState:(BOOL)resetState success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {

    STUser *currentUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSString *userID = [NSString stringWithFormat:@"%@",currentUser.userID];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:details
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:[userID integerValue]] forKey:kUserID];
    [parameters setObject:jsonString forKey:kFilterData];
    [parameters setObject:[NSNumber numberWithBool:resetState] forKey:kResetState];

    __weak STNetworkAPIManager *weakSelf = self;
    
    [self POST:@"addUserFilters" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf updateUserProfileToCoreDataWithDetails:details forResponseType:eResponseTypeUpdateFilterData success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) updateUserProfileToCoreDataWithDetails:(NSMutableDictionary *) details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    NSInteger errorCode = [[details objectForKey:kErrorCode] integerValue];
    
    if(errorCode == -1) {
        STLog(@"%@", [details objectForKey:kStatus]);
        
        NSError *error = [NSError errorWithDomain:[details objectForKey:kStatus] code:2000 userInfo:nil];
        failureBlock(error);
    } else if (errorCode == 0) {

        if(type == eResponseTypeUpdateProfile) {
            NSNumber *genderType = [details objectForKey:kGenderType];
            NSNumber *userType = [details objectForKey:kUserType];
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                STUser *localUser = [[STUserManager sharedManager] getCurrentUserInContext:localContext];
                
                if(!localUser) {
                    localUser = [STUser MR_createEntityInContext:localContext];
                }
                
                localUser.genderType = genderType;
                localUser.userType = userType;
                
            } completion:^(BOOL success, NSError *error) {
                successBlock([NSNull null]);
            }];
        } else if(type == eResponseTypeUpdateFilterData) {
            successBlock([NSNull null]);
        } else if(type == eResponseTypeGetFilterData) {
            [self updateFilterPreferenceInCoreData:details success:successBlock failure:failureBlock];
        } else {
            
        }
    }
}

- (NSMutableDictionary *) getFilterDataSource {
    
    STFilter *filter = [STFilter MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];

    NSPredicate *predicate = nil;
    
    STFilterRangeItem *rangeItem = nil;
    
    NSString *valueString = nil;
    
    NSString *curValueString = nil;
    
    NSSet *rangeSet = nil;
    
    NSMutableDictionary *dataSourceDict = [NSMutableDictionary dictionary];
    
    //GPA
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"HIGH SCHOOL GPA"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",[rangeItem.curLowerValue floatValue] > 0.0 ? rangeItem.curLowerValue : @"2.00", rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"HIGH SCHOOL GPA",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:HIGHSCHOOL_GPA_DETAILS];
    
    //SAT
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"AVERAGE SAT SCORE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",[rangeItem.curLowerValue intValue] > 0.0 ? rangeItem.curLowerValue : @"800", rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"AVERAGE SAT SCORE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:AVERAGE_SAT_DETAILS];
    
    //ACT
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"AVERAGE ACT COMPOSITE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",[rangeItem.curLowerValue intValue] > 0.0 ? rangeItem.curLowerValue : @"12", rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"AVERAGE ACT COMPOSITE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:AVERAGE_ACT_DETAILS];
    
    //TEST OPTIONAL
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TEST OPTIONAL", KEY_LABEL, filter.testOptional, KEY_VALUE, nil] forKey:TEST_OPTIONAL_DETAILS];
    
    //FRESHMEN
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"SIZE OF FRESHMEN CLASS"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"SIZE OF FRESHMEN CLASS",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:FRESHMEN_SIZE_DETAILS];
    
    //ACCEPTANCE RATE
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"ACCEPTANCE RATE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ACCEPTANCE RATE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:ACCEPTANCE_RATE_DETAILS];
    
    //4 YEAR GRADUATION RATE
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"4-YEAR GRADUATION RATE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"4-YEAR GRADUATION RATE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:FOUR_YR_GRADUATION_RATE_DETAILS];
    
    //6 YEAR GRADUATION RATE
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"6-YEAR GRADUATION RATE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"6-YEAR GRADUATION RATE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:SIX_YR_GRADUATION_RATE_DETAILS];
    
    //1 YEAR RETENTION RATE
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"1-YEAR RETENTION RATE"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"1-YEAR RETENTION RATE",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:ONE_YR_RETENTION_RATE_DETAILS];
    
    //DISTANCE FROM CURRENT LOCATION
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"DISTANCE FROM CURRENT LOCATION"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"DISTANCE FROM CURRENT LOCATION",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE, nil] forKey:DISTANCE_CURRENTLOC_DETAILS];
    
    NSMutableArray *admissionTypeArray = [NSMutableArray arrayWithObjects:
                                          (NSMutableDictionary *)@{KEY_VALUE:filter.admissionType.isEarlyDecision},
                                          (NSMutableDictionary *)@{KEY_VALUE:filter.admissionType.isEarlyAction},
                                          (NSMutableDictionary *)@{KEY_VALUE:filter.admissionType.isCommonApp},nil];
    
    //ADMISSION TYPES
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ADMISSIONS", KEY_LABEL, @"", KEY_VALUE, admissionTypeArray,KEY_VALUES_ARRAY, nil] forKey:ADMISSION_TYPE_DETAILS];
    
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
    
    //RELIGIOUS AFFILIATION
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"RELIGIOUS AFFILIATION",KEY_LABEL,filter.religiousAffiliation, KEY_FILTER_RELIGIOUS, nil] forKey:RELIGIOUS_AFFILIATION_DETAILS];
    
    //STATE
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"State",KEY_LABEL,filter.stateName, KEY_FILTER_STATE_NAME, filter.stateCode, KEY_FILTER_STATE_CODE, nil] forKey:STATE_DETAILS];
    
    //TOTAL FEES
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"TOTAL FEES"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TOTAL FEES",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE,nil] forKey:TOTAL_FEES_DETAILS];
    
    //% RECEIVING FINANCIAL AID
    predicate = [NSPredicate predicateWithFormat:@"rangeName == %@",@"RECEIVING FINANCIAL AID"];
    rangeSet = [filter.filterRangeItems filteredSetUsingPredicate:predicate];
    rangeItem = (STFilterRangeItem *)[[rangeSet allObjects] objectAtIndex:0];
    valueString = [NSString stringWithFormat:@"%@,%@",rangeItem.lowerValue,rangeItem.upperValue];
    curValueString = [NSString stringWithFormat:@"%@,%@",rangeItem.curLowerValue,rangeItem.curUpperValue];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"RECEIVING FINANCIAL AID",KEY_LABEL,curValueString,KEY_VALUE,valueString,KEY_RANGE,nil] forKey:FINANCIAL_AID_DETAILS];
    
    return dataSourceDict;
}

- (void)updateFilterPreferenceInCoreData: (NSMutableDictionary *)details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {

    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_defaultContext];

    STFilter *filter = [STFilter MR_findFirstInContext:localContext];

    if(!filter) {
        filter = [STFilter MR_createEntityInContext:localContext];
    }
    
    //SORT ORDER
    filter.sortOrder = [NSNumber numberWithInteger:0];
    
    //Favorite Only Option
    filter.favoriteOnly = [NSNumber numberWithBool:NO];

    //STATE_DETAILS
    NSMutableDictionary *stateDetailDict = [details objectForKey:STATE_DETAILS];

    filter.stateName = [stateDetailDict objectForKey:KEY_FILTER_STATE_NAME];
    filter.stateCode = [stateDetailDict objectForKey:KEY_FILTER_STATE_CODE];

    //RELIGIOUS AFFILIATION
    NSMutableDictionary *religiousDetailDict = [details objectForKey:RELIGIOUS_AFFILIATION_DETAILS];

    filter.religiousAffiliation = [religiousDetailDict objectForKey:KEY_FILTER_RELIGIOUS];

    //TEST OPTIONALS
    NSMutableDictionary *testOptionalDict = [details objectForKey:TEST_OPTIONAL_DETAILS];
    BOOL status = [[testOptionalDict objectForKey:KEY_VALUE] boolValue];
    
    filter.testOptional = [NSNumber numberWithBool:status];
    
    //Range Item values
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
        
        NSDictionary *rangeDetails = [details objectForKey:rangeItemKey];
        NSArray *rangeKeys = [[rangeDetails objectForKey:KEY_RANGE] componentsSeparatedByString:@","];
        NSArray *valueItmes = [[rangeDetails objectForKey:KEY_VALUE] componentsSeparatedByString:@","];
        
        STFilterRangeItem *filterItemModel = [STFilterRangeItem MR_createEntityInContext:localContext];
        filterItemModel.rangeName = rangeItemName;
        filterItemModel.lowerValue = [NSString stringWithFormat:@"%.2f", [[rangeKeys firstObject] floatValue]];;
        filterItemModel.upperValue = [NSString stringWithFormat:@"%.2f", [[rangeKeys lastObject] floatValue]];;
        filterItemModel.filter = filter;
        
        filterItemModel.curUpperValue = [NSString stringWithFormat:@"%.2f", [[valueItmes lastObject] floatValue]];
        
        float lowerValue = [[valueItmes firstObject] floatValue];
        
        if(([rangeItemKey isEqualToString:AVERAGE_SAT_DETAILS] && lowerValue == 800.0) || ([rangeItemKey isEqualToString:AVERAGE_ACT_DETAILS] && lowerValue == 12.0) || ([rangeItemKey isEqualToString:HIGHSCHOOL_GPA_DETAILS] && lowerValue == 2.0)) {
            lowerValue = 0.0;
        }
        
        filterItemModel.curLowerValue = [NSString stringWithFormat:@"%.2f", lowerValue];
        [filter addFilterRangeItemsObject:filterItemModel];
    }

    //ADMISSION_TYPE_DETAILS
    NSMutableDictionary *admissionTypeDetailDict = [details objectForKey:ADMISSION_TYPE_DETAILS];
    
    NSMutableArray *admissionTypeArray = [admissionTypeDetailDict objectForKey:KEY_VALUES_ARRAY];
    
    filter.admissionType = [STFilterAdmissionType MR_createEntityInContext:localContext];
    filter.admissionType.isEarlyDecision = [NSNumber numberWithBool:[[[admissionTypeArray objectAtIndex:0] objectForKey:KEY_VALUE] boolValue]];
    filter.admissionType.isEarlyAction = [NSNumber numberWithBool:[[[admissionTypeArray objectAtIndex:1] objectForKey:KEY_VALUE] boolValue]];
    filter.admissionType.isCommonApp = [NSNumber numberWithBool:[[[admissionTypeArray objectAtIndex:2] objectForKey:KEY_VALUE] boolValue]];
    
    //COLLEGE_TYPE_DETAILS
    NSMutableDictionary *colleTypeDetailDict = [details objectForKey:COLLEGE_TYPE_DETAILS];
    
    NSMutableArray *collegeTypeArray = [colleTypeDetailDict objectForKey:KEY_VALUES_ARRAY];
    
    filter.collegeType = [STFilterCollegeType MR_createEntityInContext:localContext];
    filter.collegeType.isUniversity = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:0] objectForKey:KEY_VALUE] boolValue]];
    filter.collegeType.isCity = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:1] objectForKey:KEY_VALUE] boolValue]];
    filter.collegeType.isTown = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:2] objectForKey:KEY_VALUE] boolValue]];
    filter.collegeType.isRural = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:3] objectForKey:KEY_VALUE] boolValue]];
    filter.collegeType.isPrivate = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:4] objectForKey:KEY_VALUE] boolValue]];
    filter.collegeType.isPublic = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:5] objectForKey:KEY_VALUE] boolValue]];
    filter.collegeType.isCollege = [NSNumber numberWithBool:[[[collegeTypeArray objectAtIndex:6] objectForKey:KEY_VALUE] boolValue]];

    [localContext MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        [[STUserManager sharedManager] setShouldReloadData:YES];
        [[STUserManager sharedManager] setIsFilterApplied:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FILTER_STATUS];
        successBlock([NSNull null]);
    }];
}

@end
