//
//  STNetworkAPIManager+CollegeDetailsAPI.m
//  Stipend
//
//  Created by Ganesh Kumar on 17/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager+CollegeDetailsAPI.h"
#import "STCollegeSections.h"


@implementation STNetworkAPIManager (CollegeDetailsAPI)

- (void) fetchCollegeWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    NSNumber *collegeID = [details objectForKey:kCollegeID];
    
    NSString *urlString = [NSString stringWithFormat:@"getCollegeDetailsForApp/%@", collegeID];
    
    __weak STNetworkAPIManager *weakSelf = self;

    [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [weakSelf updateCollegeToCoreDataWithDetails:responseObject forResponseType:eResponseTypeCollegeDetails success:successBlock failure:failureBlock];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        error = [NSError errorWithDomain:[error localizedDescription] code:error.code userInfo:nil];
        failureBlock(error);
    }];
}

- (void) updateCollegeToCoreDataWithDetails:(id) details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock {
    
    
    NSInteger errorCode = [[details objectForKey:kErrorCode] integerValue];
    
    if(errorCode == -1) {
        NSError *error = [NSError errorWithDomain:[details objectForKey:kStatus] code:2000 userInfo:nil];
        failureBlock(error);
    }
    else if (errorCode == 0) {
        
        __weak STNetworkAPIManager *weakSelf = self;

        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            @autoreleasepool {
                
                NSDictionary *collegeDetails = [details objectForKey:kCollege];
                NSDictionary *collegeSummary = [collegeDetails objectForKey:kCollegeSummary];
                NSNumber *collegeID = [collegeSummary objectForKey:kCollegeID];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@",collegeID];
                STCollege *localCollege = [STCollege MR_findFirstWithPredicate:predicate inContext:localContext];
                
                if(!localCollege) {
                    localCollege = [STCollege MR_createEntityInContext:localContext];
                }
                
                NSMutableOrderedSet *sectionItems = [NSMutableOrderedSet orderedSet];
                
                [weakSelf updateCollegeWithSummaryDetails:collegeSummary forCollege:localCollege inContext:localContext];
                
                NSArray *majors = [collegeDetails objectForKey:kMajors];
                if(majors) {
                    [weakSelf updateCollegeWithSummaryDetails:@{kMajors: majors} forCollege:localCollege inContext:localContext];
                }
                
                NSDictionary *collegeLocation = [collegeDetails objectForKey:kLocation];
                
                STCLocation *location = [weakSelf updateCollegeWithLocationDetails:collegeLocation forCollege:localCollege inContext:localContext];
                if(location) {
                    [sectionItems addObject:location];
                }
                
                NSDictionary *collegeSimilarSchools = [collegeDetails objectForKey:kSimilarSchools];
                
                STCSimilarSchools *similarSchools = [weakSelf updateCollegeWithSimilarSchoolsDetails:collegeSimilarSchools forCollege:localCollege inContext:localContext];
                if(similarSchools) {
                    [sectionItems addObject:similarSchools];
                }
                
                NSDictionary *collegeTestScoresAndGrades = [collegeDetails objectForKey:kTestScoresAndGrades];
                
                STCTestScoresAndGrades *testScoreAndGrades = [weakSelf updateCollegeWithTestScoresAndGradesDetails:collegeTestScoresAndGrades forCollege:localCollege inContext:localContext];
                
                if(testScoreAndGrades) {
                    [sectionItems addObject:testScoreAndGrades];
                }
                
                NSDictionary *collegeFreshManProfile = [collegeDetails objectForKey:kFreshManProfile];
                
                STCFreshman *freshman = [weakSelf updateCollegeWithFreshManProfileDetails:collegeFreshManProfile forCollege:localCollege inContext:localContext];
                if(freshman) {
                    [sectionItems addObject:freshman];
                }
                
                NSDictionary *collegeAdmissions = [collegeDetails objectForKey:kAdmissions];
                
                STCAdmissions *admission = [weakSelf updateCollegeWithAdmissionsDetails:collegeAdmissions forCollege:localCollege inContext:localContext];
                if(admission) {
                    [sectionItems addObject:admission];
                }
                
                NSDictionary *collegeCalendar = [collegeDetails objectForKey:kCalendar];
                
                STCCalender *calender = [weakSelf updateCollegeWithCalendarDetails:collegeCalendar forCollege:localCollege inContext:localContext];
                if(calender) {
                    [sectionItems addObject:calender];
                }
                
                NSDictionary *collegeIntendedStudy = [collegeDetails objectForKey:kIntendedStudy];
                
                STCIntendedStudy *intendedStudy = [weakSelf updateCollegeWithIntendedStudyDetails:collegeIntendedStudy forCollege:localCollege inContext:localContext];
                if(intendedStudy) {
                    [sectionItems addObject:intendedStudy];
                }
                
                NSDictionary *collegeFeesAndFinancialAids = [collegeDetails objectForKey:kFeesAndFinancialAids];
                
                STCFeesAndFinancialAid *feesAndFinancialAid = [weakSelf updateCollegeWithFeesAndFinancialAidsDetails:collegeFeesAndFinancialAids forCollege:localCollege inContext:localContext];
                if(feesAndFinancialAid) {
                    [sectionItems addObject:feesAndFinancialAid];
                }
                
                NSDictionary *collegeSports = [collegeDetails objectForKey:kSports];
                
                STCSports *sports = [weakSelf updateCollegeWithSportsDetails:collegeSports forCollege:localCollege inContext:localContext];
                if(sports) {
                    [sectionItems addObject:sports];
                }
                
                NSDictionary *collegeWeather = [collegeDetails objectForKey:kWeather];
                
                STCWeather *weather = [weakSelf updateCollegeWithWeatherDetails:collegeWeather forCollege:localCollege inContext:localContext];
                if(weather) {
                    [sectionItems addObject:weather];
                }
                
                NSDictionary *collegePayScaleRankings = [collegeDetails objectForKey:kPayScaleRankings];
                
                STCRankings *ranking = [weakSelf updateCollegeWithPayScaleRankingsDetails:collegePayScaleRankings forCollege:localCollege inContext:localContext];
                if(ranking) {
                    [sectionItems addObject:ranking];
                }
                
                NSDictionary *collegeProminentAlumini = [collegeDetails objectForKey:kProminentAlumini];
                
                STCProminentAlumini *alumini = [weakSelf updateCollegeWithProminentAluminiDetails:collegeProminentAlumini forCollege:localCollege inContext:localContext];
                if(alumini) {
                    [sectionItems addObject:alumini];
                }
                
                NSDictionary *collegeLinksAndAddresses = [collegeDetails objectForKey:kLinksAndAddresses];
                
                STCLinksAndAddresses *linksAndAddresses = [weakSelf updateCollegeWithLinksAndAddressesDetails:collegeLinksAndAddresses forCollege:localCollege inContext:localContext];
                if(linksAndAddresses) {
                    [sectionItems addObject:linksAndAddresses];
                }
                
                NSDictionary *collegeQuickFacts = [collegeDetails objectForKey:kQuickFacts];
                
                STCQuickFacts *quickFacts = [weakSelf updateCollegeWithQuickFactsDetails:collegeQuickFacts forCollege:localCollege inContext:localContext];
                if(quickFacts) {
                    [sectionItems addObject:quickFacts];
                }
                
                localCollege.collegeSections = sectionItems;
            }
            
        } completion:^(BOOL success, NSError *error) {
            successBlock([NSNull null]);
        }];
    }
}

- (void)updateCollegeWithSummaryDetails:(id)summaryDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeName]]) {
        college.collegeName = [summaryDetails objectForKey:kCollegeName];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeLogoPath]]) {
        college.logoPath = [summaryDetails objectForKey:kCollegeLogoPath];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeWebSiteURL]]) {
        college.websiteUrl = [summaryDetails objectForKey:kCollegeWebSiteURL];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeSteetName]]) {
        college.streetName = [summaryDetails objectForKey:kCollegeSteetName];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeCity]]) {
        college.city = [summaryDetails objectForKey:kCollegeCity];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeState]]) {
        college.state = [summaryDetails objectForKey:kCollegeState];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeCountry]]) {
        college.country = [summaryDetails objectForKey:kCollegeCountry];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeZip]]) {
        college.zipCode = [summaryDetails objectForKey:kCollegeZip];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeTelephone]]) {
        college.telephoneNumber = [summaryDetails objectForKey:kCollegeTelephone];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeEmailID]]) {
        college.emailID = [summaryDetails objectForKey:kCollegeEmailID];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeAppleLattitude]]) {
        college.appleLattitude = [summaryDetails objectForKey:kCollegeAppleLattitude];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeAppleLongitude]]) {
        college.appleLongitude = [summaryDetails objectForKey:kCollegeAppleLongitude];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeGoogleLattitude]]) {
        college.googleLattitude = [summaryDetails objectForKey:kCollegeGoogleLattitude];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeGoogleLongitude]]) {
        college.googleLongitude = [summaryDetails objectForKey:kCollegeGoogleLongitude];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeTotalFreshman]]) {
        college.totalFreshmens = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeTotalFreshman] integerValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeTotalUndergrads]]) {
        college.totalUndergrads = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeTotalUndergrads] integerValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeAceeptanceRate]]) {
        college.acceptanceRate = [NSNumber numberWithFloat:[[summaryDetails objectForKey:kCollegeAceeptanceRate] floatValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeAverageGPA]]) {
        college.averageGPA = [NSNumber numberWithFloat:[[summaryDetails objectForKey:kCollegeAverageGPA] floatValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeAverageSAT]]) {
        college.averageSAT = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeAverageSAT] integerValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeNewAverageSAT]]) {
        college.averageSATNew = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeNewAverageSAT] integerValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeAverageACT]]) {
        college.averageACT = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeAverageACT] integerValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeClassSize]]) {
        college.classSize = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeClassSize] integerValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeActive]]) {
        college.isActive = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeActive] boolValue]];
    }

    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeFourYrGraduationRate]]) {
        college.fourYrGraduationRate = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeFourYrGraduationRate] floatValue]];
    }

    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeSixYrGraduationRate]]) {
        college.sixYrGraduationRate = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeSixYrGraduationRate] floatValue]];
    }

    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeOneYrRetentionRate]]) {
        college.oneYrRetentionRate = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeOneYrRetentionRate] floatValue]];
    }
    
    NSString *collegeName = college.collegeName;
    NSString *streetName = college.streetName;
    NSString *state = college.state;
    NSString *city = college.city;
    NSString *country = college.country;
    NSString *pinCode = [NSString stringWithFormat:@"%@",college.zipCode];
    
    NSString *addressText = @"";
    
    if(collegeName) {
        addressText = [addressText stringByAppendingString:collegeName];
    }
    
    if(streetName) {
        addressText = [addressText stringByAppendingString:[NSString stringWithFormat:@", %@",streetName]];
    }
    
    if(state) {
        addressText = [addressText stringByAppendingString:[NSString stringWithFormat:@", %@",state]];
    }
    
    if(city) {
        addressText = [addressText stringByAppendingString:[NSString stringWithFormat:@", %@",city]];
    }
    
    if(country) {
        addressText = [addressText stringByAppendingString:[NSString stringWithFormat:@", %@",country]];
    }
    
    if(pinCode) {
        addressText = [addressText stringByAppendingString:[NSString stringWithFormat:@", %@",pinCode]];
    }
    
    college.address = addressText;
    
    NSString *collegePlace = @"";
    
    if(city) {
        collegePlace = [NSString stringWithFormat:@"%@",city];
    }
    if(state) {
        NSString *place = collegePlace;
        collegePlace = [NSString stringWithFormat:@"%@, %@",place,state];
    }

    college.place = collegePlace;
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeLastUpdatedDate]]) {
        
       /* NSString *dateString = [summaryDetails objectForKey:kCollegeLastUpdatedDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDate *formatedDate = [dateFormatter dateFromString:dateString];
        
        college.lastUpdatedDate = formatedDate; */
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeTypeID]]) {
        college.collegeType = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeTypeID] integerValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeAreaTypeID]]) {
        college.collegeAreaType = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeAreaTypeID] integerValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:kCollegeAccessTypeID]]) {
        college.collegeAccessType = [NSNumber numberWithInteger:[[summaryDetails objectForKey:kCollegeAccessTypeID] integerValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:@"earlyDecision"]]) {
        college.earlyDecision = [NSNumber numberWithBool:[[summaryDetails objectForKey:@"earlyDecision"] boolValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:@"earlyAction"]]) {
        college.earlyAction = [NSNumber numberWithBool:[[summaryDetails objectForKey:@"earlyAction"] boolValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:@"rollingAdmissions"]]) {
        college.rollingAdmissions = [NSNumber numberWithBool:[[summaryDetails objectForKey:@"rollingAdmissions"] boolValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:@"commonApplicationAccepted"]]) {
        college.commonApplicationAccepted = [NSNumber numberWithBool:[[summaryDetails objectForKey:@"commonApplicationAccepted"] boolValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:@"inStateFees"]]) {
        college.totalFees = [NSNumber numberWithInteger:[[summaryDetails objectForKey:@"inStateFees"] integerValue]];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:@"receivingFinancialAid"]]) {
        college.receivingFinancialAid = [NSNumber numberWithInteger:[[summaryDetails objectForKey:@"receivingFinancialAid"] integerValue]];
    }

    if(![self isNullValueForObject:[summaryDetails objectForKey:@"religiousAffiliation"]]) {
        college.religiousAffiliation = [summaryDetails objectForKey:@"religiousAffiliation"];
    }
    
    if(![self isNullValueForObject:[summaryDetails objectForKey:@"satACTOptionalValue"]]) {
        if([[summaryDetails objectForKey:@"satACTOptionalValue"] isEqualToString:@"YES"]) {
            college.testOptional = [NSNumber numberWithBool:YES];
        } else {
             college.testOptional = [NSNumber numberWithBool:NO];
        }
    }

    if(![self isNullValueForObject:[summaryDetails objectForKey:@"majors"]]) {
        
        NSMutableOrderedSet *broadMajors = [NSMutableOrderedSet orderedSet];
        
        NSMutableOrderedSet *broadMajorsDetails = [summaryDetails objectForKey:@"majors"];

        for(NSDictionary *broadMajorDict in broadMajorsDetails) {
            
            STBroadMajor *broadMajor = [STBroadMajor MR_createEntityInContext:localContext];
            broadMajor.name = [broadMajorDict objectForKey:@"name"];
            broadMajor.nickName = [broadMajorDict objectForKey:@"nickName"];
            broadMajor.code = [broadMajorDict objectForKey:@"code"];
            
            NSMutableOrderedSet *specificMajors = [NSMutableOrderedSet orderedSet];
            
            NSMutableOrderedSet *specificMajorsDetails = [broadMajorDict objectForKey:@"specificMajors"];

            for(NSDictionary *specificMajorDict in specificMajorsDetails) {
                
                STSpecificMajor *specificMajor = [STSpecificMajor MR_createEntityInContext:localContext];
                specificMajor.name = [specificMajorDict objectForKey:@"name"];
                specificMajor.code = [specificMajorDict objectForKey:@"code"];
                specificMajor.studentCount = [NSNumber numberWithInt:[[specificMajorDict objectForKey:@"graduate"] intValue]];
                specificMajor.broadMajor = broadMajor;
                [specificMajors addObject:specificMajor];
            }
            
            broadMajor.specificMajors = specificMajors;
            [broadMajors addObject:broadMajor];
        }

        college.broadMajors = broadMajors;
    }
}

- (STCLocation *)updateCollegeWithLocationDetails:(id)locationDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kLocation];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCLocation *location = [STCLocation MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!location) {
        location = [STCLocation MR_createEntityInContext:localContext];
        location.college = college;
        location.isExpanded = [NSNumber numberWithBool:NO];
    }
    
    location.collegeID = college.collegeID;
    location.sectionID = sectionID;
    location.sectionTitle = sectionName;
    
    if(![self isNullValueForObject:[locationDetails objectForKey:@"Latitude"]]) {
        location.lattitude = [NSNumber numberWithFloat:[[locationDetails objectForKey:@"Latitude"] floatValue]];
    }
    else {
    }
    
    if(![self isNullValueForObject:[locationDetails objectForKey:@"Longitude"]]) {
        location.longitude = [NSNumber numberWithFloat:[[locationDetails objectForKey:@"Longitude"] floatValue]];
    }
    else {
    }

    if(![self isNullValueForObject:[locationDetails objectForKey:@"moreAboutCollegeURL"]]) {
        location.moreAboutCollegeURL = [locationDetails objectForKey:@"moreAboutCollegeURL"];
    }
    else {
    }
    
    return location;
}

- (STCSimilarSchools *)updateCollegeWithSimilarSchoolsDetails:(id)similarSchoolsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
 
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kSimilarSchools];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCSimilarSchools *similarSchools = [STCSimilarSchools MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!similarSchools) {
        similarSchools = [STCSimilarSchools MR_createEntityInContext:localContext];
        similarSchools.college = college;
        similarSchools.isExpanded = [NSNumber numberWithBool:NO];
        similarSchools.hasSeeMore = [NSNumber numberWithBool:YES];
    }
    
    similarSchools.collegeID = college.collegeID;
    similarSchools.sectionID = sectionID;
    similarSchools.sectionTitle = sectionName;
    
    NSMutableOrderedSet *similarSchoolSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *details in similarSchoolsDetails) {
        
        STCSimilarSchoolItem *item = [STCSimilarSchoolItem MR_createEntityInContext:localContext];
        
        if(![self isNullValueForObject:[details objectForKey:@"collegeName"]]) {
            item.name = [details objectForKey:@"collegeName"];
        }
        else {
            item.name = @"";
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"collegeID"]]) {
            item.schoolID = [details objectForKey:@"collegeID"];
        }
        else {
        }

        if(![self isNullValueForObject:[details objectForKey:@"collegeURL"]]) {
            item.schoolID = [details objectForKey:@"collegeURL"];
        }
        else {
        }

        item.similarSchools = similarSchools;
        [similarSchoolSet addObject:item];
    }
    
    if(similarSchoolSet && [similarSchoolSet count] > 0) {
        similarSchools.simlarSchoolItems = similarSchoolSet;
    }
    else {
        
        similarSchools.simlarSchoolItems = nil;
    }
    
    return similarSchools;
}

- (STCTestScoresAndGrades *)updateCollegeWithTestScoresAndGradesDetails:(id)testScoresAndGradesDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kTestScoresAndGrades];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCTestScoresAndGrades *testScoresAndGrades = [STCTestScoresAndGrades MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!testScoresAndGrades) {
        testScoresAndGrades = [STCTestScoresAndGrades MR_createEntityInContext:localContext];
        testScoresAndGrades.college = college;
        testScoresAndGrades.barChartSelectedIndex = [NSNumber numberWithInteger:0];
        testScoresAndGrades.pieChartSelectedIndex = [NSNumber numberWithInteger:0];
        testScoresAndGrades.isExpanded = [NSNumber numberWithBool:NO];
    }
    
    testScoresAndGrades.collegeID = college.collegeID;
    testScoresAndGrades.sectionID = sectionID;
    testScoresAndGrades.sectionTitle = sectionName;
    
    NSDictionary *averageScoresDetails = [testScoresAndGradesDetails objectForKey:@"Averages"];
    
    NSMutableOrderedSet *averageScoresItemsSet = [NSMutableOrderedSet orderedSet];
    
    if(![self isNullValueForObject:[averageScoresDetails objectForKey:@"AverageGPA"]]) {
        STCAverageScoreItem *item = [STCAverageScoreItem MR_createEntityInContext:localContext];
        item.testScoresAndGrades = testScoresAndGrades;
        item.key = @"Average GPA";
        item.value = [NSNumber numberWithFloat:[[averageScoresDetails objectForKey:@"AverageGPA"] floatValue]];
        [averageScoresItemsSet addObject:item];
    }
    
    if(![self isNullValueForObject:[averageScoresDetails objectForKey:@"NewAverageSAT"]]) {
        STCAverageScoreItem *item = [STCAverageScoreItem MR_createEntityInContext:localContext];
        item.testScoresAndGrades = testScoresAndGrades;
        item.key = @"Average SAT";
        item.value = [NSNumber numberWithFloat:[[averageScoresDetails objectForKey:@"NewAverageSAT"] floatValue]];
        [averageScoresItemsSet addObject:item];
    }
    
    if(![self isNullValueForObject:[averageScoresDetails objectForKey:@"AverageACT"]]) {
        STCAverageScoreItem *item = [STCAverageScoreItem MR_createEntityInContext:localContext];
        item.testScoresAndGrades = testScoresAndGrades;
        item.key = @"Average ACT";
        item.value = [NSNumber numberWithFloat:[[averageScoresDetails objectForKey:@"AverageACT"] floatValue]];
        [averageScoresItemsSet addObject:item];
    }
    
    if(averageScoresItemsSet && [averageScoresItemsSet count] > 0) {
        testScoresAndGrades.averageScores = averageScoresItemsSet;
    }
    else {
        testScoresAndGrades.averageScores = nil;
    }
    
    NSDictionary *barChartDetails = [testScoresAndGradesDetails objectForKey:@"SATAndACT"];
    NSArray *barChartCodes = [barChartDetails objectForKey:@"Codes"];
    
    NSMutableOrderedSet *barChartsSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *barChartDict in barChartCodes) {
        
        STCTestScoresBarChart *barChart = [STCTestScoresBarChart MR_createEntityInContext:localContext];
        barChart.testScoresAndGrades = testScoresAndGrades;
        
        NSMutableOrderedSet *barChartsItemSet = [NSMutableOrderedSet orderedSet];

        NSString *key = @"";
        
        id value = [barChartDict objectForKey:@"SAT"];
        key = @"SAT";
        
        if(!value) {
            key = @"ACT";
            value = [barChartDict objectForKey:@"ACT"];
        }
        
        if([key isEqualToString:@"ACT"]) {
            
            barChart.title = @"ACT SCORE";
            
            for (NSDictionary *barChartValues in value) {
                
                if(![self isNullValueForObject:[barChartValues objectForKey:@"CompositeLow"]]) {
                    barChart.percentageLowValue = [barChartValues objectForKey:@"CompositeLow"];
                }
                
                if(![self isNullValueForObject:[barChartValues objectForKey:@"CompositeHigh"]]) {
                    barChart.percentageHighValue = [barChartValues objectForKey:@"CompositeHigh"];
                }
                
                if(![self isNullValueForObject:[barChartValues objectForKey:@"English"]]) {
                    
                    NSDictionary *detailDict = [barChartValues objectForKey:@"English"];
                    
                    STCBarChartItem *item = [STCBarChartItem MR_createEntityInContext:localContext];
                    item.testScoreBarChart = barChart;
                    item.lowerValue = [detailDict objectForKey:@"scoreLowerLimit"];
                    item.upperValue = [detailDict objectForKey:@"scoreHigherLimit"];
                    item.title = @"English";
                    
                    [barChartsItemSet addObject:item];
                }
                
                if(![self isNullValueForObject:[barChartValues objectForKey:@"math"]]) {
                    
                    NSDictionary *detailDict = [barChartValues objectForKey:@"math"];
                    
                    STCBarChartItem *item = [STCBarChartItem MR_createEntityInContext:localContext];
                    item.testScoreBarChart = barChart;
                    item.lowerValue = [detailDict objectForKey:@"scoreLowerLimit"];
                    item.upperValue = [detailDict objectForKey:@"scoreHigherLimit"];
                    item.title = @"Math";
                    
                    [barChartsItemSet addObject:item];
                }
            }
            
            if(barChartsItemSet && ([barChartsItemSet count] > 0)) {
                barChart.barChartItems = barChartsItemSet;
                [barChartsSet addObject:barChart];
            }
            else {
                
                if((barChart.percentageLowValue) && (barChart.percentageHighValue)) {
                    [barChartsSet addObject:barChart];
                }
            }
        }
        else if([key isEqualToString:@"SAT"]) {
            
            barChart.title = @"SAT SCORE";
            
            for (NSDictionary *barChartValues in value) {
                
                if(![self isNullValueForObject:[barChartValues objectForKey:@"TotalLow"]]) {
                    barChart.percentageLowValue = [barChartValues objectForKey:@"TotalLow"];
                }
                
                if(![self isNullValueForObject:[barChartValues objectForKey:@"TotalHigh"]]) {
                    barChart.percentageHighValue = [barChartValues objectForKey:@"TotalHigh"];
                }
                
                if(![self isNullValueForObject:[barChartValues objectForKey:@"NewTotalHigh"]]) {
                    barChart.percentageNewHighValue = [barChartValues objectForKey:@"NewTotalHigh"];
                }
                
                if(![self isNullValueForObject:[barChartValues objectForKey:@"NewTotalLow"]]) {
                    barChart.percentageNewLowValue = [barChartValues objectForKey:@"NewTotalLow"];
                }
                
                if(![self isNullValueForObject:[barChartValues objectForKey:@"NewSat"]]) {
                    barChart.newScoresAvailable = [barChartValues objectForKey:@"NewSat"];
                }
                
                if(barChart.newScoresAvailable.boolValue) {
    
                    barChart.title = @"SAT SCORE";

                    if(![self isNullValueForObject:[barChartValues objectForKey:@"ReadingWriting"]]) {
                        
                        NSDictionary *detailDict = [barChartValues objectForKey:@"ReadingWriting"];
                        
                        STCBarChartItem *item = [STCBarChartItem MR_createEntityInContext:localContext];
                        item.testScoreBarChart = barChart;
                        item.lowerValue = [detailDict objectForKey:@"scoreLowerLimit"];
                        item.upperValue = [detailDict objectForKey:@"scoreHigherLimit"];
                        item.title = @"Reading and Writing";
                        
                        [barChartsItemSet addObject:item];
                    }

                    if(![self isNullValueForObject:[barChartValues objectForKey:@"NewMath"]]) {
                        
                        NSDictionary *detailDict = [barChartValues objectForKey:@"NewMath"];
                        
                        STCBarChartItem *item = [STCBarChartItem MR_createEntityInContext:localContext];
                        item.testScoreBarChart = barChart;
                        item.lowerValue = [detailDict objectForKey:@"scoreLowerLimit"];
                        item.upperValue = [detailDict objectForKey:@"scoreHigherLimit"];
                        item.title = @"Math";
                        
                        [barChartsItemSet addObject:item];
                    }

                    if(barChartsItemSet && ([barChartsItemSet count] > 0)) {
                        barChart.barChartItems = barChartsItemSet;
                        [barChartsSet addObject:barChart];
                    } else {
                        if((barChart.percentageNewLowValue.integerValue > 0) && (barChart.percentageNewHighValue.integerValue > 0)) {
                            [barChartsSet addObject:barChart];
                        }
                    }
                } /*
                else {
                    
                    barChart.title = @"SAT SCORE";

                    if(![self isNullValueForObject:[barChartValues objectForKey:@"CriticalReading"]]) {
                        
                        NSDictionary *detailDict = [barChartValues objectForKey:@"CriticalReading"];
                        
                        STCBarChartItem *item = [STCBarChartItem MR_createEntityInContext:localContext];
                        item.testScoreBarChart = barChart;
                        item.lowerValue = [detailDict objectForKey:@"scoreLowerLimit"];
                        item.upperValue = [detailDict objectForKey:@"scoreHigherLimit"];
                        item.title = @"Critical Reading";
                        
                        [barChartsItemSet addObject:item];
                    }
                    
                    if(![self isNullValueForObject:[barChartValues objectForKey:@"math"]]) {
                        
                        NSDictionary *detailDict = [barChartValues objectForKey:@"math"];
                        
                        STCBarChartItem *item = [STCBarChartItem MR_createEntityInContext:localContext];
                        item.testScoreBarChart = barChart;
                        item.lowerValue = [detailDict objectForKey:@"scoreLowerLimit"];
                        item.upperValue = [detailDict objectForKey:@"scoreHigherLimit"];
                        item.title = @"Math";
                        
                        [barChartsItemSet addObject:item];
                    }
                    
                    if(![self isNullValueForObject:[barChartValues objectForKey:@"Writing"]]) {
                        
                        NSDictionary *detailDict = [barChartValues objectForKey:@"Writing"];
                        
                        STCBarChartItem *item = [STCBarChartItem MR_createEntityInContext:localContext];
                        item.testScoreBarChart = barChart;
                        item.lowerValue = [detailDict objectForKey:@"scoreLowerLimit"];
                        item.upperValue = [detailDict objectForKey:@"scoreHigherLimit"];
                        item.title = @"Writing";
                        
                        [barChartsItemSet addObject:item];
                    }
                } */
            }
        }
    }
    
    if(barChartsSet && [barChartsSet count] > 0) {
        testScoresAndGrades.testScoresBarCharts = barChartsSet;
    }
    else {
        testScoresAndGrades.testScoresBarCharts = nil;
    }
            
    NSDictionary *pieChartScoresDetails = [testScoresAndGradesDetails objectForKey:@"SCORES"];
    
    NSArray *pieChartCodes = [pieChartScoresDetails objectForKey:@"AllScores"];

    NSMutableOrderedSet *pieChartSet = [NSMutableOrderedSet orderedSet];
    NSMutableOrderedSet *satPieChartSet = [NSMutableOrderedSet orderedSet];

    for (NSDictionary *pieChartDict in pieChartCodes) {
        
        NSString *key = @"";
        
        id value = [pieChartDict objectForKey:@"GPASCORES"];
        key = @"GPASCORES";
        
        if(!value) {
            key = @"SATSCORES";
            value = [pieChartDict objectForKey:@"NEWSATSCORES"];
        }
        
        if(!value) {
            key = @"ACTSCORES";
            value = [pieChartDict objectForKey:@"ACTSCORES"];
        }
        
        if([key isEqualToString:@"GPASCORES"]) {
            
            STCPieChart *pieChart = [STCPieChart MR_createEntityInContext:localContext];
            pieChart.testScoresAndGrades = testScoresAndGrades;
            pieChart.name = @"GPA SCORES";
            
            NSMutableOrderedSet *pieChartItemSet = [NSMutableOrderedSet orderedSet];
            
            for (NSDictionary *detail in value) {
                
                STCPieChartItem *item = [STCPieChartItem MR_createEntityInContext:localContext];
                item.pieChart = pieChart;
                item.key = [NSString stringWithFormat:@"%.2f - %.2f",[[detail objectForKey:@"scoreLowerLimit"] floatValue],[[detail objectForKey:@"scoreHigherLimit"] floatValue]];
                item.value = [detail objectForKey:@"percentage"];
                
                [pieChartItemSet addObject:item];
            }
            
            if(pieChartItemSet && [pieChartItemSet count] > 0) {
                pieChart.pieChartItem = pieChartItemSet;
                [pieChartSet addObject:pieChart];
            }
            else {
                pieChart.pieChartItem = nil;
            }
        }
        else if([key isEqualToString:@"ACTSCORES"]) {
            
            STCPieChart *pieChart = [STCPieChart MR_createEntityInContext:localContext];
            pieChart.testScoresAndGrades = testScoresAndGrades;
            pieChart.name = @"ACT SCORES";
            
            NSMutableOrderedSet *pieChartItemSet = [NSMutableOrderedSet orderedSet];
            
            for (NSDictionary *detail in value) {
                
                STCPieChartItem *item = [STCPieChartItem MR_createEntityInContext:localContext];
                item.pieChart = pieChart;
                item.key = [NSString stringWithFormat:@"%.2f - %.2f",[[detail objectForKey:@"scoreLowerLimit"] floatValue],[[detail objectForKey:@"scoreHigherLimit"] floatValue]];
                item.value = [detail objectForKey:@"percentage"];
                
                [pieChartItemSet addObject:item];
            }
            
            if(pieChartItemSet && [pieChartItemSet count] > 0) {
                pieChart.pieChartItem = pieChartItemSet;
                [pieChartSet addObject:pieChart];
            }
            else {
                pieChart.pieChartItem = nil;
            }
        }
        else if([key isEqualToString:@"SATSCORES"]) {
            
            STCSATPieChartLayout *satPieChartLayout = [STCSATPieChartLayout MR_createEntityInContext:localContext];
            satPieChartLayout.name = @"SAT SCORES";
            satPieChartLayout.testScoresAndGrades = testScoresAndGrades;

            satPieChartLayout.name = @"SAT SCORES";
            
            for (NSDictionary *pieChartDict in value) {
                
                STCSATPieChart *pieChart = [STCSATPieChart MR_createEntityInContext:localContext];
                pieChart.satPieChartLayout = satPieChartLayout;
                
                NSString *key = @"";
                
                id pieChartDetails = [pieChartDict objectForKey:@"NewSatScoresReadingAndWriting"];
                key = @"ReadingWritingPercentage";
                pieChart.name = @"Reading and Writing";
                
                if(!pieChartDetails) {
                    pieChart.name = @"Math";
                    key = @"Math";
                    pieChartDetails = [pieChartDict objectForKey:@"NewSatScoresMath"];
                }
                
                NSMutableOrderedSet *pieChartItemSet = [NSMutableOrderedSet orderedSet];
                
                for (NSDictionary *detail in pieChartDetails) {
                    STCSATPieChartItem *item = [STCSATPieChartItem MR_createEntityInContext:localContext];
                    item.value = [detail objectForKey:@"percentage"];
                    item.key = [NSString stringWithFormat:@"%.2f - %.2f",[[detail objectForKey:@"scoreLowerLimit"] floatValue],[[detail objectForKey:@"scoreHigherLimit"] floatValue]];
                    
                    [pieChartItemSet addObject:item];
                }
                
                if(pieChartItemSet && [pieChartItemSet count] > 0) {
                    pieChart.pieChartItems = pieChartItemSet;
                    [satPieChartSet addObject:pieChart];
                } else {
                    pieChart.pieChartItems = nil;
                }
            }

            if(satPieChartSet && [satPieChartSet count] > 0) {
                satPieChartLayout.items = satPieChartSet;
                testScoresAndGrades.testScoreSATPieChart = satPieChartLayout;
            } else {
                satPieChartLayout.items = nil;
                testScoresAndGrades.testScoreSATPieChart = nil;
            }
        }
    }
            /*
            id newSATValue = [pieChartDict objectForKey:@"NEWSATSCORES"];

            if(((NSArray *)newSATValue).count > 0) {
                
                satPieChartLayout.name = @"SAT SCORES";

                for (NSDictionary *pieChartDict in newSATValue) {
                    
                    STCSATPieChart *pieChart = [STCSATPieChart MR_createEntityInContext:localContext];
                    pieChart.satPieChartLayout = satPieChartLayout;
                    
                    NSString *key = @"";
                    
                    id pieChartDetails = [pieChartDict objectForKey:@"NewSatScoresReadingAndWriting"];
                    key = @"ReadingWritingPercentage";
                    pieChart.name = @"Reading and Writing";
                    
                    if(!pieChartDetails) {
                        pieChart.name = @"Math";
                        key = @"Math";
                        pieChartDetails = [pieChartDict objectForKey:@"NewSatScoresMath"];
                    }
                    
                    NSMutableOrderedSet *pieChartItemSet = [NSMutableOrderedSet orderedSet];
                    
                    for (NSDictionary *detail in pieChartDetails) {
                        STCSATPieChartItem *item = [STCSATPieChartItem MR_createEntityInContext:localContext];
                        item.value = [detail objectForKey:@"percentage"];
                        item.key = [NSString stringWithFormat:@"%.2f - %.2f",[[detail objectForKey:@"scoreLowerLimit"] floatValue],[[detail objectForKey:@"scoreHigherLimit"] floatValue]];
                        
                        [pieChartItemSet addObject:item];
                    }
                    
                    if(pieChartItemSet && [pieChartItemSet count] > 0) {
                        pieChart.pieChartItems = pieChartItemSet;
                        [satPieChartSet addObject:pieChart];
                    }
                    else {
                        pieChart.pieChartItems = nil;
                    }
                }
            } else {

                satPieChartLayout.name = @"SAT SCORES";
                
                for (NSDictionary *pieChartDict in value) {
                    
                    STCSATPieChart *pieChart = [STCSATPieChart MR_createEntityInContext:localContext];
                    pieChart.satPieChartLayout = satPieChartLayout;
                    
                    NSString *key = @"";
                    
                    id pieChartDetails = [pieChartDict objectForKey:@"ReadingPercentage"];
                    key = @"ReadingPercentage";
                    pieChart.name = @"Critical Reading";
                    
                    if(!pieChartDetails) {
                        pieChart.name = @"Math";
                        key = @"Math";
                        pieChartDetails = [pieChartDict objectForKey:@"MathPecentage"];
                        
                    }
                    
                    if(!pieChartDetails) {
                        pieChart.name = @"Writing";
                        key = @"WritingPercentage";
                        pieChartDetails = [pieChartDict objectForKey:@"WritingPercentage"];
                        
                    }
                    
                    NSMutableOrderedSet *pieChartItemSet = [NSMutableOrderedSet orderedSet];
                    
                    for (NSDictionary *detail in pieChartDetails) {
                        STCSATPieChartItem *item = [STCSATPieChartItem MR_createEntityInContext:localContext];
                        item.value = [detail objectForKey:@"percentage"];
                        item.key = [NSString stringWithFormat:@"%.2f - %.2f",[[detail objectForKey:@"scoreLowerLimit"] floatValue],[[detail objectForKey:@"scoreHigherLimit"] floatValue]];
                        
                        [pieChartItemSet addObject:item];
                    }
                    
                    if(pieChartItemSet && [pieChartItemSet count] > 0) {
                        pieChart.pieChartItems = pieChartItemSet;
                        [satPieChartSet addObject:pieChart];
                    }
                    else {
                        pieChart.pieChartItems = nil;
                    }
                }
            }
            
            if(satPieChartSet && [satPieChartSet count] > 0) {
                satPieChartLayout.items = satPieChartSet;
                testScoresAndGrades.testScoreSATPieChart = satPieChartLayout;
            }
            else {
                satPieChartLayout.items = nil;
            }
        }
    }
    */
            
    if(pieChartSet && [pieChartSet count] > 0) {
        testScoresAndGrades.testScoresPieCharts = pieChartSet;
    }
    else {
        testScoresAndGrades.testScoresPieCharts = nil;
    }

    if([satPieChartSet count] <= 0) {
        testScoresAndGrades.testScoreSATPieChart = nil;
    }

    NSDictionary *highSchoolClassRankDetails = [testScoresAndGradesDetails objectForKey:@"HSC"];

    if(highSchoolClassRankDetails.allKeys.count > 0) {
        
        STCTestScoresHSCRBarChart *highSchoolBarChart = [STCTestScoresHSCRBarChart MR_createEntityInContext:localContext];
        highSchoolBarChart.testScoresAndGrades = testScoresAndGrades;
        
        if([highSchoolClassRankDetails.allKeys containsObject:@"HSC_TOP_TENTH"]) {
            highSchoolBarChart.topTenthPercentageValue = [[highSchoolClassRankDetails objectForKey:@"HSC_TOP_TENTH"] objectForKey:@"percentage"];
        } else {
            highSchoolBarChart.topTenthPercentageValue = [NSNumber numberWithInt:0];
        }

        if([highSchoolClassRankDetails.allKeys containsObject:@"HSC_TOP_QUARTER"]) {
            highSchoolBarChart.topQuarterPercentageValue = [[highSchoolClassRankDetails objectForKey:@"HSC_TOP_QUARTER"] objectForKey:@"percentage"];
        } else {
            highSchoolBarChart.topQuarterPercentageValue = [NSNumber numberWithInt:0];
        }
        
        if([highSchoolClassRankDetails.allKeys containsObject:@"HSC_TOP_HALF"]) {
            highSchoolBarChart.topHalfPercentageValue = [[highSchoolClassRankDetails objectForKey:@"HSC_TOP_HALF"] objectForKey:@"percentage"];
        } else {
            highSchoolBarChart.topHalfPercentageValue = [NSNumber numberWithInt:0];
        }
        
        if([highSchoolClassRankDetails.allKeys containsObject:@"HSC_BOTTOM_HALF"]) {
            highSchoolBarChart.bottomHalfPercentageValue = [[highSchoolClassRankDetails objectForKey:@"HSC_BOTTOM_HALF"] objectForKey:@"percentage"];
        } else {
            highSchoolBarChart.bottomHalfPercentageValue = [NSNumber numberWithInt:0];
        }
        
        if([highSchoolClassRankDetails.allKeys containsObject:@"HSC_BOTTOM_QUARTER"]) {
            highSchoolBarChart.bottomQuarterPercentageValue = [[highSchoolClassRankDetails objectForKey:@"HSC_BOTTOM_QUARTER"] objectForKey:@"percentage"];
        } else {
            highSchoolBarChart.bottomQuarterPercentageValue = [NSNumber numberWithInt:0];
        }
        
        if([highSchoolClassRankDetails.allKeys containsObject:@"HSC_TOTAL"]) {
            highSchoolBarChart.totalPercentageValue = [[highSchoolClassRankDetails objectForKey:@"HSC_TOTAL"] objectForKey:@"percentage"];
        } else {
            highSchoolBarChart.totalPercentageValue = [NSNumber numberWithInt:0];
        }
        
        testScoresAndGrades.testScoreHSCRBarCharts = highSchoolBarChart;
    } else {
        testScoresAndGrades.testScoreHSCRBarCharts = nil;
    }
    
    return testScoresAndGrades;
}

- (STCFreshman *)updateCollegeWithFreshManProfileDetails:(id)freshManProfileDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kFreshManProfile];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCFreshman *freshman = [STCFreshman MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!freshman) {
        freshman = [STCFreshman MR_createEntityInContext:localContext];
        freshman.college = college;
        freshman.isExpanded = [NSNumber numberWithBool:NO];
    }
    
    freshman.collegeID = college.collegeID;
    freshman.sectionID = sectionID;
    freshman.sectionTitle = sectionName;
    
    NSArray *freshmanDetailArray = [freshManProfileDetails objectForKey:@"Profile"];
    
    NSMutableOrderedSet *freshmanItemsSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *details in freshmanDetailArray) {
        
        STCFreshmanDetailItem *item = [STCFreshmanDetailItem MR_createEntityInContext:localContext];
        
        if(![self isNullValueForObject:[details objectForKey:@"Name"]]) {
            item.key = [details objectForKey:@"Name"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"Value"]]) {
            item.value = [NSNumber numberWithFloat:[[details objectForKey:@"Value"] floatValue]];
        }
        
        if([item.key isEqualToString:@"ACCEPTANCE RATE"]) {
            college.acceptanceRate = item.value;
        }
        
        [freshmanItemsSet addObject:item];
    }
    
    if(freshmanItemsSet && [freshmanItemsSet count] > 0) {
        freshman.freshmanDetailItems = freshmanItemsSet;
    }
    else {
        freshman.freshmanDetailItems = nil;
    }

    NSMutableOrderedSet *pieChartItemsSet = [NSMutableOrderedSet orderedSet];
    
    NSArray *ethnicityPieChartArray = [freshManProfileDetails objectForKey:@"Ethncity"];
    
    STCPieChart *pieChart = [STCPieChart MR_createEntityInContext:localContext];
    pieChart.name = @"Ethnicity";
    pieChart.freshman = freshman;
    
    NSMutableOrderedSet *pieChartItemSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *details in ethnicityPieChartArray) {
        STCPieChartItem *pieChartItem = [STCPieChartItem MR_createEntityInContext:localContext];
        pieChartItem.pieChart = pieChart;
        
        if(![self isNullValueForObject:[details objectForKey:@"demographicName"]]) {
            pieChartItem.key = [details objectForKey:@"demographicName"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"ethnicityPercentage"]]) {
            pieChartItem.value = [details objectForKey:@"ethnicityPercentage"];
        }
        
        [pieChartItemSet addObject:pieChartItem];
    }
    
    if(pieChartItemSet && [pieChartItemSet count] > 0) {
        pieChart.pieChartItem = pieChartItemSet;
        [pieChartItemsSet addObject:pieChart];
    }
    else {
        pieChart.pieChartItem = nil;
    }
    
    NSArray *geographicsPieChartArray = [freshManProfileDetails objectForKey:@"Geographics"];
    
    pieChart = [STCPieChart MR_createEntityInContext:localContext];
    pieChart.name = @"Geography";
    pieChart.freshman = freshman;
    
    pieChartItemSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *details in geographicsPieChartArray) {
        STCPieChartItem *pieChartItem = [STCPieChartItem MR_createEntityInContext:localContext];
        pieChartItem.pieChart = pieChart;
        
        if(![self isNullValueForObject:[details objectForKey:@"geographicName"]]) {
            pieChartItem.key = [details objectForKey:@"geographicName"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"geographicsPercentage"]]) {
            pieChartItem.value = [details objectForKey:@"geographicsPercentage"];
        }
        
        [pieChartItemSet addObject:pieChartItem];
    }
    
    if(pieChartItemSet && [pieChartItemSet count] > 0) {
        pieChart.pieChartItem = pieChartItemSet;
        [pieChartItemsSet addObject:pieChart];
    }
    else {
        pieChart.pieChartItem = nil;
    }
    
    freshman.pieCharts = pieChartItemsSet;
    
    NSDictionary *genderDetails = [freshManProfileDetails objectForKey:@"GenderPercentage"];
    
    if(genderDetails) {
        STCFreshmanGenderDetails *gender = [STCFreshmanGenderDetails MR_createEntityInContext:localContext];
        gender.freshman = freshman;
        
        if(![self isNullValueForObject:[genderDetails objectForKey:@"MALE"]]) {
            gender.malePercentage = [genderDetails objectForKey:@"MALE"];
        }
        
        if(![self isNullValueForObject:[genderDetails objectForKey:@"FEMALE"]]) {
            gender.femalePercentage = [genderDetails objectForKey:@"FEMALE"];
        }
        
        freshman.genderDetails = gender;
    }
    else {
        freshman.genderDetails = nil;
    }
    
    NSDictionary *graduationDetails = [freshManProfileDetails objectForKey:@"GraduationRate"];
    
    if(graduationDetails) {
        
        STCFreshmanGraduationDetails *graduation = [STCFreshmanGraduationDetails MR_createEntityInContext:localContext];
        graduation.freshman = freshman;
        
        if(![self isNullValueForObject:[graduationDetails objectForKey:@"SixYearGraduationRate"]]) {
            graduation.sixYearGraduationRate = [graduationDetails objectForKey:@"SixYearGraduationRate"];
        }
        
        if(![self isNullValueForObject:[graduationDetails objectForKey:@"FourYearGraduationRate"]]) {
            graduation.fourYearGraduationRate = [graduationDetails objectForKey:@"FourYearGraduationRate"];
        }
        
        if(![self isNullValueForObject:[graduationDetails objectForKey:@"RetentionRate"]]) {
            graduation.retentionRate = [graduationDetails objectForKey:@"RetentionRate"];
        }
        
        freshman.graduationDetails = graduation;
        
    } else {
        freshman.graduationDetails = nil;
    }
    
    NSString *religiousAffiliation = [freshManProfileDetails objectForKey:@"ReligiousAffiliation"];
    
    if(![self isNullValueForObject:religiousAffiliation]) {
        freshman.religiousAffiliation = religiousAffiliation;
    }
    else {
        freshman.religiousAffiliation = nil;
    }
    
    NSDictionary *mostRepresentedStateDetails = [freshManProfileDetails objectForKey:@"MostRepresentedStates"];
    
    NSArray *mostRepresentedStateArray = [mostRepresentedStateDetails objectForKey:@"States"];

    NSMutableOrderedSet *mostRepresentedStateItemSet = [NSMutableOrderedSet orderedSet];
    
    if(mostRepresentedStateArray) {

        for (NSString *mostRepState in mostRepresentedStateArray) {
            STCFreshmanRepresentedStates *mostRepStates = [STCFreshmanRepresentedStates MR_createEntityInContext:localContext];
            
            mostRepStates.name = mostRepState;
            [mostRepresentedStateItemSet addObject:mostRepStates];
        }
    }

    if(mostRepresentedStateItemSet && [mostRepresentedStateItemSet count] > 0) {
        freshman.freshmanMostRepresentedStates = mostRepresentedStateItemSet;
    }
    else {
        freshman.freshmanMostRepresentedStates = nil;
    }
    
    NSArray *greekLifeDetails = [freshManProfileDetails objectForKey:@"GreekLife"];
    
    NSMutableOrderedSet *greekLifeItemSet = [NSMutableOrderedSet orderedSet];
    
    if(greekLifeDetails) {
        
        for (NSDictionary *greekLifeDict in greekLifeDetails) {
            
            STCFreshmanGreekLife *greekLife = [STCFreshmanGreekLife MR_createEntityInContext:localContext];
            
            if(![self isNullValueForObject:[greekLifeDict objectForKey:@"Name"]]) {
                greekLife.name = [greekLifeDict objectForKey:@"Name"];
            }
            
            if(![self isNullValueForObject:[greekLifeDict objectForKey:@"Value"]]) {
                greekLife.value = [NSNumber numberWithInteger:[[greekLifeDict objectForKey:@"Value"] integerValue]];
            }
            
            [greekLifeItemSet addObject:greekLife];
        }
    }
    
    if(greekLifeItemSet && [greekLifeItemSet count] > 0) {
        freshman.freshmanGreekLife = greekLifeItemSet;
    }
    else {
        freshman.freshmanGreekLife = nil;
    }
    
    return freshman;
}

- (STCAdmissions *)updateCollegeWithAdmissionsDetails:(id)admissionsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSArray *admissionsArray = [admissionsDetails objectForKey:@"Admission"];
    NSArray *interviewsArray = [admissionsDetails objectForKey:@"Interviews"];
    NSArray *recommendationsArray = [admissionsDetails objectForKey:@"Recommendations"];
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kAdmissions];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCAdmissions *admission = [STCAdmissions MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!admission) {
        admission = [STCAdmissions MR_createEntityInContext:localContext];
        admission.college = college;
        admission.isExpanded = [NSNumber numberWithBool:NO];
    }
    
    admission.collegeID = college.collegeID;
    admission.sectionID = sectionID;
    admission.sectionTitle = sectionName;
    
    NSDictionary *admissionsCodes = [admissionsDetails objectForKey:@"AdmissionCodes"];
    NSMutableOrderedSet *admissionCodesSet = [NSMutableOrderedSet orderedSet];
    
    if(![self isNullValueForObject:[admissionsCodes objectForKey:@"satCode"]]) {
        STCAdmissionCodes *admissionItem = [STCAdmissionCodes MR_createEntityInContext:localContext];
        admissionItem.admissions = admission;
        admissionItem.key = @"SAT Code";
        admissionItem.value = [NSNumber numberWithInteger:[[admissionsCodes objectForKey:@"satCode"] integerValue]];
        [admissionCodesSet addObject:admissionItem];
    }
    
    if(![self isNullValueForObject:[admissionsCodes objectForKey:@"actCode"]]) {
        STCAdmissionCodes *admissionItem = [STCAdmissionCodes MR_createEntityInContext:localContext];
        admissionItem.admissions = admission;
        admissionItem.key = @"ACT Code";
        admissionItem.value = [NSNumber numberWithInteger:[[admissionsCodes objectForKey:@"actCode"] integerValue]];
        [admissionCodesSet addObject:admissionItem];
    }
    
    if(admissionCodesSet && [admissionCodesSet count] > 0) {
        admission.admissionCodes = admissionCodesSet;
    }
    else {
        admission.admissionCodes = nil;
    }
    
    NSMutableOrderedSet *admissionItemsSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *details in admissionsArray) {
        
        STCAdmissionItem *admissionItem = [STCAdmissionItem MR_createEntityInContext:localContext];
        admissionItem.admission = admission;

        if(![self isNullValueForObject:[details objectForKey:@"optionName"]]) {
            admissionItem.title = [details objectForKey:@"optionName"];
        }

        STCItem *item = [STCItem MR_createEntityInContext:localContext];
        item.admissionItem = admissionItem;
        
        if(![self isNullValueForObject:[details objectForKey:@"optionValue"]]) {
            item.badgeText = [details objectForKey:@"optionValue"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"optionValueID"]]) {
            item.badgeType = [details objectForKey:@"optionValueID"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"optionName"]]) {
            item.itemName = [details objectForKey:@"optionName"];
        }
        
        NSMutableOrderedSet *itemSet = [NSMutableOrderedSet orderedSet];
        [itemSet addObject:item];
        admissionItem.items = itemSet;
        
        [admissionItemsSet addObject:admissionItem];
    }
    
    STCAdmissionItem *admissionItem = [STCAdmissionItem MR_createEntityInContext:localContext];
    admissionItem.title = @"Recommendations";
    admissionItem.admission = admission;
    
    NSMutableOrderedSet *itemSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *details in recommendationsArray) {
        
        STCItem *item = [STCItem MR_createEntityInContext:localContext];
        item.admissionItem = admissionItem;
        
        if(![self isNullValueForObject:[details objectForKey:@"optionValue"]]) {
            item.badgeText = [details objectForKey:@"optionValue"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"optionValueID"]]) {
            item.badgeType = [details objectForKey:@"optionValueID"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"optionName"]]) {
            item.itemName = [details objectForKey:@"optionName"];
        }
        
        [itemSet addObject:item];
    }
    
    if(itemSet && [itemSet count] > 0) {
        admissionItem.items = itemSet;
    }
    else {
        admissionItem.items = nil;
    }
    
    [admissionItemsSet addObject:admissionItem];

    admissionItem = [STCAdmissionItem MR_createEntityInContext:localContext];
    admissionItem.title = @"Interviews";
    admissionItem.admission = admission;
    
    itemSet = [NSMutableOrderedSet orderedSet];

    for (NSDictionary *details in interviewsArray) {
        
        STCItem *item = [STCItem MR_createEntityInContext:localContext];
        item.admissionItem = admissionItem;
        
        if(![self isNullValueForObject:[details objectForKey:@"optionValue"]]) {
            item.badgeText = [details objectForKey:@"optionValue"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"optionValueID"]]) {
            item.badgeType = [details objectForKey:@"optionValueID"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"optionName"]]) {
            item.itemName = [details objectForKey:@"optionName"];
        }
        
        [itemSet addObject:item];
    }
    
    if(itemSet && [itemSet count] > 0) {
        admissionItem.items = itemSet;
    }
    else {
        admissionItem.items = nil;
    }

    [admissionItemsSet addObject:admissionItem];
    
    
    admission.admissionItems = admissionItemsSet;
    
    return admission;
}

- (STCCalender *)updateCollegeWithCalendarDetails:(id)calendarDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSArray *mostImportantDatesArray = [calendarDetails objectForKey:@"MostImportantDates"];
    NSArray *otherImportantDatesArray = [calendarDetails objectForKey:@"Events"];
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kCalendar];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCCalender *calender = [STCCalender MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!calender) {
        calender = [STCCalender MR_createEntityInContext:localContext];
        calender.college = college;
        calender.isExpanded = [NSNumber numberWithBool:NO];
    }
    
    calender.collegeID = college.collegeID;
    calender.sectionID = sectionID;
    calender.sectionTitle = sectionName;
    
    
    NSMutableOrderedSet *mostImpDateItemsSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *dateDetails in mostImportantDatesArray) {
        
        STCMostImportantCalenderDates *mostImpDate = [STCMostImportantCalenderDates MR_createEntityInContext:localContext];
        mostImpDate.calender = calender;
        
        if(![self isNullValueForObject:[dateDetails objectForKey:@"eventDate"]]) {
            
            NSString *dateString = [dateDetails objectForKey:@"eventDate"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
            NSString *formattedDateString = [NSString stringWithFormat:@"%@ 00:00:00 +0000",dateString];
            NSDate *formatedDate = [dateFormatter dateFromString:formattedDateString];
            mostImpDate.eventDate = formatedDate;
            
            mostImpDate.eventDateString = dateString;
        }
        
        if(![self isNullValueForObject:[dateDetails objectForKey:@"eventDescription"]]) {
            mostImpDate.eventdateDescription = [dateDetails objectForKey:@"eventDescription"];
        }
        else {
        }

        if(![self isNullValueForObject:[dateDetails objectForKey:@"eventName"]]) {
            mostImpDate.eventName = [dateDetails objectForKey:@"eventName"];
        }
        else {
        }
        
        NSString *eventDescription = [NSString stringWithFormat:@"%@ - %@",college.collegeName,mostImpDate.eventName];
        mostImpDate.eventdateDescription = eventDescription;
        
        [mostImpDateItemsSet addObject:mostImpDate];
    }
    
    if(mostImpDateItemsSet && [mostImpDateItemsSet count] > 0) {
        calender.mostImportantDates = mostImpDateItemsSet;
    }
    else {
        calender.mostImportantDates = nil;
    }
    
    NSMutableOrderedSet *otherImpDateItemsSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *dateDetails in otherImportantDatesArray) {
        
        STCOtherCalenderDates *otherImpDate = [STCOtherCalenderDates MR_createEntityInContext:localContext];
        otherImpDate.calender = calender;
        
        if(![self isNullValueForObject:[dateDetails objectForKey:@"eventDate"]]) {
            
            NSString *dateString = [dateDetails objectForKey:@"eventDate"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
            NSString *formattedDateString = [NSString stringWithFormat:@"%@ 00:00:00 +0000",dateString];
            NSDate *formatedDate = [dateFormatter dateFromString:formattedDateString];
            otherImpDate.eventDate = formatedDate;
            
            otherImpDate.eventDateString = dateString;
        }
        
        if(![self isNullValueForObject:[dateDetails objectForKey:@"eventDescription"]]) {
            otherImpDate.eventdateDescription = [dateDetails objectForKey:@"eventDescription"];
        }
        else {
        }
        
        if(![self isNullValueForObject:[dateDetails objectForKey:@"eventName"]]) {
            otherImpDate.eventName = [dateDetails objectForKey:@"eventName"];
        }
        else {
        }
        
        NSString *eventDescription = [NSString stringWithFormat:@"%@ - %@",college.collegeName,otherImpDate.eventName];
        otherImpDate.eventdateDescription = eventDescription;

        [otherImpDateItemsSet addObject:otherImpDate];
    }
    
    if(otherImpDateItemsSet && [otherImpDateItemsSet count] > 0) {
        calender.otherImportantDates = otherImpDateItemsSet;
    }
    else {
        calender.otherImportantDates = nil;
    }

    return calender;
}

- (STCIntendedStudy *)updateCollegeWithIntendedStudyDetails:(id)intendedStudyDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kIntendedStudy];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCIntendedStudy *intendedStudy = [STCIntendedStudy MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!intendedStudy) {
        intendedStudy = [STCIntendedStudy MR_createEntityInContext:localContext];
        intendedStudy.college = college;
        intendedStudy.isExpanded = [NSNumber numberWithBool:NO];
    }
    
    intendedStudy.collegeID = college.collegeID;
    intendedStudy.sectionID = sectionID;
    intendedStudy.sectionTitle = sectionName;
    intendedStudy.hasSeeMore = [NSNumber numberWithBool:YES];

    NSArray *intendedStudyPieChartArray = [intendedStudyDetails objectForKey:@"Study"];
    
    STCPieChart *pieChart = [STCPieChart MR_createEntityInContext:localContext];
    pieChart.intendedStudy = intendedStudy;
    
    NSMutableOrderedSet *pieChartItemSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *details in intendedStudyPieChartArray) {
        STCPieChartItem *pieChartItem = [STCPieChartItem MR_createEntityInContext:localContext];
        pieChartItem.pieChart = pieChart;
        
        if(![self isNullValueForObject:[details objectForKey:@"intendedStudyName"]]) {
            pieChartItem.key = [details objectForKey:@"intendedStudyName"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"intendedStudyPercentage"]]) {
            pieChartItem.value = [details objectForKey:@"intendedStudyPercentage"];
        }
        
        [pieChartItemSet addObject:pieChartItem];
    }
    
    if(pieChartItemSet && [pieChartItemSet count] > 0) {
        pieChart.pieChartItem = pieChartItemSet;
    }
    else {
        pieChart.pieChartItem = nil;
    }

    intendedStudy.intendedStudyPieChart = pieChart;
    
    NSArray *intendedStudyOptionsArray = [intendedStudyDetails objectForKey:@"IntendedStudyOption"];
    
    NSMutableOrderedSet *admissionItemSet = [NSMutableOrderedSet orderedSet];

    for (NSDictionary *details in intendedStudyOptionsArray) {
        
        NSMutableOrderedSet *itemSet = [NSMutableOrderedSet orderedSet];

        STCAdmissionItem *admissionItem = [STCAdmissionItem MR_createEntityInContext:localContext];
        admissionItem.intendedStudy = intendedStudy;

        STCItem *item = [STCItem MR_createEntityInContext:localContext];
        item.admissionItem = admissionItem;
        
        if(![self isNullValueForObject:[details objectForKey:@"optionValue"]]) {
            item.badgeText = [details objectForKey:@"optionValue"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"optionValueID"]]) {
            item.badgeType = [details objectForKey:@"optionValueID"];
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"sysIntendedStudyOptionName"]]) {
            item.itemName = [details objectForKey:@"sysIntendedStudyOptionName"];
        }
        
        [itemSet addObject:item];
        
        if(itemSet && [itemSet count] > 0) {
            admissionItem.items = itemSet;
        }
        else {
            admissionItem.items = nil;
        }
        
        [admissionItemSet addObject:admissionItem];
    }
    
    if(admissionItemSet && ([admissionItemSet count] > 0)) {
        intendedStudy.admissionItems = admissionItemSet;
    }
    else {
        intendedStudy.admissionItems = nil;
    }
    
    if(![self isNullValueForObject:[intendedStudyDetails objectForKey:@"StudentFacultyRatio"]]) {
        intendedStudy.studentFacultyRatio = [intendedStudyDetails objectForKey:@"StudentFacultyRatio"];
    }
    
    return intendedStudy;
}

- (STCFeesAndFinancialAid *)updateCollegeWithFeesAndFinancialAidsDetails:(id)feesAndFinancialAidsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSArray *inStateArray = [feesAndFinancialAidsDetails objectForKey:@"InState"];
    NSArray *outStateArray = [feesAndFinancialAidsDetails objectForKey:@"OutOfState"];
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kFeesAndFinancialAids];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCFeesAndFinancialAid *feesAndFinancialAid = [STCFeesAndFinancialAid MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!feesAndFinancialAid) {
        feesAndFinancialAid = [STCFeesAndFinancialAid MR_createEntityInContext:localContext];
        feesAndFinancialAid.college = college;
        feesAndFinancialAid.isExpanded = [NSNumber numberWithBool:NO];
        feesAndFinancialAid.feesSelectedIndex = [NSNumber numberWithInteger:0];
    }
    
    feesAndFinancialAid.collegeID = college.collegeID;
    feesAndFinancialAid.sectionID = sectionID;
    feesAndFinancialAid.sectionTitle = sectionName;
    feesAndFinancialAid.hasSeeMore = [NSNumber numberWithBool:YES];
    
    if(![self isNullValueForObject:[feesAndFinancialAidsDetails objectForKey:@"AverageFinancialAid"]]) {
        feesAndFinancialAid.averageFinancialAid = [feesAndFinancialAidsDetails objectForKey:@"AverageFinancialAid"];
    }
    
    if(![self isNullValueForObject:[feesAndFinancialAidsDetails objectForKey:@"ReceivingFinancialAid"]]) {
        feesAndFinancialAid.receivingFinancialAid = [feesAndFinancialAidsDetails objectForKey:@"ReceivingFinancialAid"];
    }
    
    if(![self isNullValueForObject:[feesAndFinancialAidsDetails objectForKey:@"AvgDebtUponGraduation"]]) {
        feesAndFinancialAid.averageDebtUponGraduation = [feesAndFinancialAidsDetails objectForKey:@"AvgDebtUponGraduation"];
    }
    
    if(![self isNullValueForObject:[feesAndFinancialAidsDetails objectForKey:@"AverageNeedMet"]]) {
        feesAndFinancialAid.averageNeedMet = [feesAndFinancialAidsDetails objectForKey:@"AverageNeedMet"];
    }
    
    if(![self isNullValueForObject:[feesAndFinancialAidsDetails objectForKey:@"AverageNetPrice"]]) {
        feesAndFinancialAid.averageNetPrice = [feesAndFinancialAidsDetails objectForKey:@"AverageNetPrice"];
    }
    
    if(![self isNullValueForObject:[feesAndFinancialAidsDetails objectForKey:@"averageMeritAward"]]) {
        feesAndFinancialAid.averageMeritAward = [feesAndFinancialAidsDetails objectForKey:@"averageMeritAward"];
    }
    
    if(![self isNullValueForObject:[feesAndFinancialAidsDetails objectForKey:@"receivingMeritAwards"]]) {
        feesAndFinancialAid.receivingMeritAwards = [feesAndFinancialAidsDetails objectForKey:@"receivingMeritAwards"];
    }
    
    NSMutableOrderedSet *inStateItemsSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *instateDetails in inStateArray) {
        
        STCInStateFees *inStateFees = [STCInStateFees MR_createEntityInContext:localContext];
        inStateFees.feesAndFinancialAid = feesAndFinancialAid;
        
        if(![self isNullValueForObject:[instateDetails objectForKey:@"sysFeesStructureName"]]) {
            inStateFees.key = [instateDetails objectForKey:@"sysFeesStructureName"];
        }
        
        if(![self isNullValueForObject:[instateDetails objectForKey:@"fees"]]) {
            inStateFees.value = [instateDetails objectForKey:@"fees"];
        }
        else {
        }
        
        [inStateItemsSet addObject:inStateFees];
    }
    
    if(inStateItemsSet && [inStateItemsSet count] > 0) {
        feesAndFinancialAid.inStateFees = inStateItemsSet;
    }
    else {
        feesAndFinancialAid.inStateFees = nil;
    }
    
    NSMutableOrderedSet *outStateItemsSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *outstateDetails in outStateArray) {
        
        STCOutStateFees *outStateFees = [STCOutStateFees MR_createEntityInContext:localContext];
        outStateFees.feesAndFinancialAid = feesAndFinancialAid;
        
        if(![self isNullValueForObject:[outstateDetails objectForKey:@"sysFeesStructureName"]]) {
            outStateFees.key = [outstateDetails objectForKey:@"sysFeesStructureName"];
        }
        
        if(![self isNullValueForObject:[outstateDetails objectForKey:@"fees"]]) {
            outStateFees.value = [outstateDetails objectForKey:@"fees"];
        }
        else {
        }
        
        [outStateItemsSet addObject:outStateFees];
    }
    
    if(outStateItemsSet && [outStateItemsSet count] > 0) {
        feesAndFinancialAid.outStateFees = outStateItemsSet;
    }
    else {
        feesAndFinancialAid.outStateFees = nil;
    }

    NSMutableOrderedSet *houseHoldIncomItemsSet = [NSMutableOrderedSet orderedSet];
    
    if(![self isNullValueForObject:[feesAndFinancialAidsDetails objectForKey:@"NetPriceHouseholdIncome"]]) {
        
        NSArray *houseHoldIncomArray = [feesAndFinancialAidsDetails objectForKey:@"NetPriceHouseholdIncome"];
        
        for (NSDictionary *houseHoldIncomeDetails in houseHoldIncomArray) {
            
            STCHouseholdIncome *houseHoldIncome = [STCHouseholdIncome MR_createEntityInContext:localContext];
            houseHoldIncome.feesAndFinancialAid = feesAndFinancialAid;
            
            if(![self isNullValueForObject:[houseHoldIncomeDetails objectForKey:@"incomeRange"]]) {
                houseHoldIncome.key = [houseHoldIncomeDetails objectForKey:@"incomeRange"];
            }
            
            if(![self isNullValueForObject:[houseHoldIncomeDetails objectForKey:@"incomeValue"]]) {
                houseHoldIncome.value = [houseHoldIncomeDetails objectForKey:@"incomeValue"];
            }
            
            [houseHoldIncomItemsSet addObject:houseHoldIncome];
        }
    }
    
    if(houseHoldIncomItemsSet && [houseHoldIncomItemsSet count] > 0) {
        feesAndFinancialAid.householdIncome = houseHoldIncomItemsSet;
    } else {
        feesAndFinancialAid.householdIncome = nil;
    }

    if(![self isNullValueForObject:[feesAndFinancialAidsDetails objectForKey:@"netPriceCalculatorURL"]]) {
        feesAndFinancialAid.netPriceCalculatorURL = [feesAndFinancialAidsDetails objectForKey:@"netPriceCalculatorURL"];
    }
    
    return feesAndFinancialAid;
}

- (STCSports *)updateCollegeWithSportsDetails:(id)sportsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kSports];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCSports *sports = [STCSports MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!sports) {
        sports = [STCSports MR_createEntityInContext:localContext];
        sports.college = [college MR_inContext:localContext];
        sports.isExpanded = [NSNumber numberWithBool:NO];
        sports.sportsSelectedIndex = [NSNumber numberWithInteger:0];
    }
    
    sports.collegeID = college.collegeID;
    sports.sectionID = sectionID;
    sports.sectionTitle = sectionName;
    
    NSDictionary *sportsDict = [sportsDetails objectForKey:@"Divisions"];
    NSDictionary *mensSportsDict = [sportsDict objectForKey:@"Men"];
    NSDictionary *womenSportsDict = [sportsDict objectForKey:@"Women"];
    
    STCMenSports *menSports = [STCMenSports MR_createEntityInContext:localContext];
    menSports.sports = sports;
    
    NSMutableOrderedSet *mensSportsDivisionSet = [NSMutableOrderedSet orderedSet];
    for (NSString *key in mensSportsDict) {
        
        STCSportsDivision *sportsDivision = [STCSportsDivision MR_createEntityInContext:localContext];
        sportsDivision.mensSports = menSports;
        sportsDivision.title = key;
        
        NSArray *sportsArray = [mensSportsDict objectForKey:key];
        
        NSMutableOrderedSet *mensSportsSet = [NSMutableOrderedSet orderedSet];
        for (NSDictionary *details in sportsArray) {
            
            STCSportsItem *item = [STCSportsItem MR_createEntityInContext:localContext];
            
            if(![self isNullValueForObject:[details objectForKey:@"syssportsName"]]) {
                item.name = [details objectForKey:@"syssportsName"];
            }
            
            [mensSportsSet addObject:item];
        }
        
        if(mensSportsSet && ([mensSportsSet count] > 0)) {
            sportsDivision.sportsItems = mensSportsSet;
            [mensSportsDivisionSet addObject:sportsDivision];
        }
        else {
            sportsDivision.sportsItems = nil;
        }
    }
    
    if(mensSportsDivisionSet && ([mensSportsDivisionSet count] > 0)) {
        menSports.sportsDivisions = mensSportsDivisionSet;
    }
    else {
        menSports.sportsDivisions = nil;
    }
    
    sports.menSports = menSports;
    
    
    STCWomenSports *womenSports = [STCWomenSports MR_createEntityInContext:localContext];
    womenSports.sports = sports;
    
    NSMutableOrderedSet *womenSportsDivisionSet = [NSMutableOrderedSet orderedSet];
    for (NSString *key in womenSportsDict) {
        
        STCSportsDivision *sportsDivision = [STCSportsDivision MR_createEntityInContext:localContext];
        sportsDivision.womenSports = womenSports;
        sportsDivision.title = key;
        
        NSArray *sportsArray = [womenSportsDict objectForKey:key];
        
        NSMutableOrderedSet *womenSportsSet = [NSMutableOrderedSet orderedSet];
        for (NSDictionary *details in sportsArray) {
            
            STCSportsItem *item = [STCSportsItem MR_createEntityInContext:localContext];
            
            if(![self isNullValueForObject:[details objectForKey:@"syssportsName"]]) {
                item.name = [details objectForKey:@"syssportsName"];
            }
            
            [womenSportsSet addObject:item];
        }
        
        if(womenSportsSet && ([womenSportsSet count] > 0)) {
            sportsDivision.sportsItems = womenSportsSet;
            [womenSportsDivisionSet addObject:sportsDivision];
        }
        else {
            sportsDivision.sportsItems = nil;
        }
    }
    
    if(womenSportsDivisionSet && ([womenSportsDivisionSet count] > 0)) {
        womenSports.sportsDivisions = womenSportsDivisionSet;
    }
    else {
        womenSports.sportsDivisions = nil;
    }
    
    sports.womenSports = womenSports;
    
    if(![self isNullValueForObject:[sportsDetails objectForKey:@"Intramurals"]]) {
        
        BOOL isIntramurals = [[sportsDetails objectForKey:@"Intramurals"] boolValue];
        
        NSMutableOrderedSet *admissionItemSet = [NSMutableOrderedSet orderedSet];
        NSMutableOrderedSet *itemSet = [NSMutableOrderedSet orderedSet];
        
        STCAdmissionItem *admissionItem = [STCAdmissionItem MR_createEntityInContext:localContext];
        admissionItem.sports = sports;
        
        STCItem *item = [STCItem MR_createEntityInContext:localContext];
        item.admissionItem = admissionItem;

        if(isIntramurals) {
            item.itemName = @"Intramurals?";
            item.badgeText = @"YES";
            item.badgeType = [NSNumber numberWithInteger:1];
        }
        else {
            item.itemName = @"Intramurals?";
            item.badgeText = @"NO";
            item.badgeType = [NSNumber numberWithInteger:2];
        }
        
        [itemSet addObject:item];
        
        if(itemSet && [itemSet count] > 0) {
            admissionItem.items = itemSet;
        }
        else {
            admissionItem.items = nil;
        }
        
        [admissionItemSet addObject:admissionItem];
        if(admissionItemSet && ([admissionItemSet count] > 0)) {
            sports.admissionItems = admissionItemSet;
        }
        else {
            sports.admissionItems = nil;
        }
    }

    if(![self isNullValueForObject:[sportsDetails objectForKey:@"Team Name"]]) {
        sports.mascotName = [sportsDetails objectForKey:@"Team Name"];
    }
    else {
        sports.mascotName = nil;
    }
    
    return sports;
}

- (STCWeather *)updateCollegeWithWeatherDetails:(id)weatherDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kWeather];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCWeather *weather = [STCWeather MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!weather) {
        weather = [STCWeather MR_createEntityInContext:localContext];
        weather.college = college;
        weather.isExpanded = [NSNumber numberWithBool:NO];
    }
    
    weather.collegeID = college.collegeID;
    weather.sectionID = sectionID;
    weather.sectionTitle = sectionName;

    STCAverageWeather *averageWeather = [STCAverageWeather MR_createEntityInContext:localContext];
    averageWeather.title = @"Average Weather";

    NSArray *averageWeatherArray = weatherDetails;
    
    NSMutableOrderedSet *averageWeatherSet = [NSMutableOrderedSet orderedSet];
    for (NSDictionary *details in averageWeatherArray) {
        
        STCAverageWeatherItem *item = [STCAverageWeatherItem MR_createEntityInContext:localContext];
        
        if(![self isNullValueForObject:[details objectForKey:@"Name"]]) {
            item.title = [details objectForKey:@"Name"];
            
            if([[details objectForKey:@"Name"] isEqualToString:@"Fall"]) {
                item.imageName = @"weather_tab_fall";
            }
            else if ([[details objectForKey:@"Name"] isEqualToString:@"Winter"]) {
                item.imageName = @"weather_tab_winter";
            }
            else if ([[details objectForKey:@"Name"] isEqualToString:@"Spring"]) {
                item.imageName = @"weather_tab_spring";
            }
            else if ([[details objectForKey:@"Name"] isEqualToString:@"Summer"]) {
                item.imageName = @"weather_tab_summer";
            }
            else {
                item.imageName = @"";
            }
        }
        else {
            item.title = @"";
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"Precipitation"]]) {
            item.precipitationValue = [NSNumber numberWithFloat:[[details objectForKey:@"Precipitation"] floatValue]];
        }
        else {
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"Low"]]) {
            item.lowValue = [NSNumber numberWithFloat:[[details objectForKey:@"Low"] floatValue]];
        }
        else {
        }

        if(![self isNullValueForObject:[details objectForKey:@"High"]]) {
            item.highValue = [NSNumber numberWithFloat:[[details objectForKey:@"High"] floatValue]];
        }
        else {
        }
        
        item.averageWeather = averageWeather;
        [averageWeatherSet addObject:item];
    }
    
    averageWeather.averageWeatherItems = averageWeatherSet;
    weather.averageWeather = averageWeather;
     
     return weather;
}

- (STCRankings *)updateCollegeWithPayScaleRankingsDetails:(id)payScaleRankingsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kPayScaleRankings];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCRankings *payscaleRanking = [STCRankings MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!payscaleRanking) {
        payscaleRanking = [STCRankings MR_createEntityInContext:localContext];
        payscaleRanking.college = college;
        payscaleRanking.isExpanded = [NSNumber numberWithBool:NO];
    }
    
    payscaleRanking.collegeID = college.collegeID;
    payscaleRanking.sectionID = sectionID;
    payscaleRanking.sectionTitle = sectionName;

    NSMutableOrderedSet *payScaleSet = [NSMutableOrderedSet orderedSet];
    for (NSDictionary *details in payScaleRankingsDetails) {
        
        STCRankingItem *item = [STCRankingItem MR_createEntityInContext:localContext];
        
        if(![self isNullValueForObject:[details objectForKey:@"ranking"]]) {
            item.name = [details objectForKey:@"ranking"];
        }
        else {
            item.name = @"";
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"rankingPoints"]]) {
            item.rank = [details objectForKey:@"rankingPoints"];
        }
        else {
        }

        if(![self isNullValueForObject:[details objectForKey:@"rankingUrl"]]) {
            item.rankingURL = [details objectForKey:@"rankingUrl"];
        }
        else {
        }

        item.collegeRanking = payscaleRanking;
        [payScaleSet addObject:item];
    }
    
    if(payScaleSet && [payScaleSet count] > 0) {
        payscaleRanking.rankingItems = payScaleSet;
    }
    else {
        payscaleRanking.rankingItems = nil;
    }

    return payscaleRanking;
}

- (STCProminentAlumini *)updateCollegeWithProminentAluminiDetails:(id)prominentAluminiDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {

    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kProminentAlumini];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCProminentAlumini *prominentAlumini = [STCProminentAlumini MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!prominentAlumini) {
        prominentAlumini = [STCProminentAlumini MR_createEntityInContext:localContext];
        prominentAlumini.college = college;
        prominentAlumini.isExpanded = [NSNumber numberWithBool:NO];
        prominentAlumini.hasSeeMore = [NSNumber numberWithBool:YES];
    }
    
    prominentAlumini.collegeID = college.collegeID;
    prominentAlumini.sectionID = sectionID;
    prominentAlumini.sectionTitle = sectionName;
    
    NSMutableOrderedSet *aluminiSet = [NSMutableOrderedSet orderedSet];
    for (NSDictionary *details in prominentAluminiDetails) {
        
        STCAluminiItem *item = [STCAluminiItem MR_createEntityInContext:localContext];
        
        if(![self isNullValueForObject:[details objectForKey:@"alumniName"]]) {
            item.key = [details objectForKey:@"alumniName"];
        }
        else {
            item.key = @"";
        }
        
        if(![self isNullValueForObject:[details objectForKey:@"alumniUrl"]]) {
            item.value = [details objectForKey:@"alumniUrl"];
        }
        else {
            item.value = @"";
        }
        
        item.alumini = prominentAlumini;
        [aluminiSet addObject:item];
    }
    
    if(aluminiSet && [aluminiSet count] > 0) {
        prominentAlumini.aluminiItems = aluminiSet;
    }
    else {
        prominentAlumini.aluminiItems = nil;
    }
    
    return prominentAlumini;
}

- (STCLinksAndAddresses *)updateCollegeWithLinksAndAddressesDetails:(id)linksAndAddressesDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {

    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kLinksAndAddresses];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCLinksAndAddresses *linksAndAddresses = [STCLinksAndAddresses MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!linksAndAddresses) {
        linksAndAddresses = [STCLinksAndAddresses MR_createEntityInContext:localContext];
        linksAndAddresses.college = college;
        linksAndAddresses.isExpanded = [NSNumber numberWithBool:NO];
    }

    linksAndAddresses.collegeID = college.collegeID;
    linksAndAddresses.sectionID = sectionID;
    linksAndAddresses.sectionTitle = sectionName;

    NSMutableOrderedSet *linksAndAddressesSet = [NSMutableOrderedSet orderedSet];
    
    for (NSDictionary *details in linksAndAddressesDetails) {

        STCLinksAndAddressesItem *item = [STCLinksAndAddressesItem MR_createEntityInContext:localContext];

        if(![self isNullValueForObject:[details objectForKey:@"websiteName"]]) {
            item.key = [details objectForKey:@"websiteName"];
        }
        else {
            item.key = @"";
        }

        if(![self isNullValueForObject:[details objectForKey:@"websiteUrl"]]) {
            item.value = [details objectForKey:@"websiteUrl"];
        }
        else {
            item.value = @"";
        }
        
        item.linksAdnAddresses = linksAndAddresses;
        [linksAndAddressesSet addObject:item];
    }
    
    if(linksAndAddressesSet && [linksAndAddressesSet count] > 0) {
        linksAndAddresses.linksAndAddressesItems = linksAndAddressesSet;
    }
    else {
        linksAndAddresses.linksAndAddressesItems = nil;
    }

    return linksAndAddresses;
}

- (STCQuickFacts *)updateCollegeWithQuickFactsDetails:(id)quickFactsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext {
    
    NSDictionary *details = [self getSectionDetailsForSectionWithKey:kQuickFacts];
    NSNumber *sectionID = [details objectForKey:@"sectionID"];
    NSString *sectionName = [details objectForKey:@"sectionName"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"college == %@",college];
    STCQuickFacts *quickFacts = [STCQuickFacts MR_findFirstWithPredicate:predicate inContext:localContext];
    
    if(!quickFacts) {
        quickFacts = [STCQuickFacts MR_createEntityInContext:localContext];
        quickFacts.college = college;
        quickFacts.isExpanded = [NSNumber numberWithBool:NO];
    }
    
    quickFacts.collegeID = college.collegeID;
    quickFacts.sectionID = sectionID;
    quickFacts.sectionTitle = sectionName;
    
    
    if(quickFactsDetails && (![quickFactsDetails isKindOfClass:[NSNull class]]) && ([[quickFactsDetails allKeys] count] > 0)) {
        if(![self isNullValueForObject:[quickFactsDetails objectForKey:@"quickFactsValue"]]) {
            quickFacts.quickFactsText = [quickFactsDetails objectForKey:@"quickFactsValue"];
        }
        else {
            quickFacts.quickFactsText = @"";
        }
    }
    else {
        quickFacts.quickFactsText = @"";
    }
    

    return quickFacts;
}

- (NSDictionary *) getSectionDetailsForSectionWithKey:(NSString *) key {
    
    NSDictionary *sectionDetails = nil;
    
    NSDictionary *sectionDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CollegeSections" ofType:@"plist"]];
    NSArray *sectionArray = [sectionDict objectForKey:@"Sections"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sectionKey == %@",key];
    NSArray *filteredArray = [sectionArray filteredArrayUsingPredicate:predicate];

    if(filteredArray && ([filteredArray count] > 0)) {
        sectionDetails = [NSMutableDictionary dictionaryWithDictionary:filteredArray[0]];
    }
    
    return sectionDetails;
}

- (NSDictionary *) getSectionDetailsForSectionWithName:(NSString *) name {
    
    NSDictionary *sectionDetails = nil;
    
    NSDictionary *sectionDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CollegeSections" ofType:@"plist"]];
    NSArray *sectionArray = [sectionDict objectForKey:@"Sections"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sectionName == %@", name];
    NSArray *filteredArray = [sectionArray filteredArrayUsingPredicate:predicate];
    
    if(filteredArray && ([filteredArray count] > 0)) {
        sectionDetails = [NSMutableDictionary dictionaryWithDictionary:filteredArray[0]];
    }
    
    return sectionDetails;
}
@end
