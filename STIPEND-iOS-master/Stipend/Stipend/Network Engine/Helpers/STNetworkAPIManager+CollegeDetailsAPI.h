//
//  STNetworkAPIManager+CollegeDetailsAPI.h
//  Stipend
//
//  Created by Ganesh Kumar on 17/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNetworkAPIManager.h"
#import "STCollege.h"

#import "STCQuickFacts.h"

#import "STCLinksAndAddresses.h"
#import "STCLinksAndAddressesItem.h"

#import "STCRankings.h"
#import "STCRankingItem.h"

#import "STCSimilarSchools.h"
#import "STCSimilarSchoolItem.h"

#import "STCProminentAlumini.h"
#import "STCAluminiItem.h"

#import "STCLocation.h"

#import "STCWeather.h"
#import "STCAverageWeather.h"
#import "STCAverageWeatherItem.h"

#import "STCCalender.h"
#import "STCMostImportantCalenderDates.h"
#import "STCOtherCalenderDates.h"

#import "STCIntendedStudy.h"

#import "STCPieChart.h"
#import "STCPieChartItem.h"

#import "STCAdmissions.h"
#import "STCAdmissionCodes.h"
#import "STCAdmissionItem.h"
#import "STCItem.h"

#import "STCFeesAndFinancialAid.h"
#import "STCInStateFees.h"
#import "STCOutStateFees.h"
#import "STCHouseholdIncome.h"

#import "STCSports.h"
#import "STCMenSports.h"
#import "STCWomenSports.h"
#import "STCSportsDivision.h"
#import "STCSportsItem.h"

#import "STCFreshman.h"
#import "STCFreshmanRepresentedStates.h"
#import "STCFreshmanDetailItem.h"
#import "STCFreshmanGenderDetails.h"
#import "STCFreshmanGreekLife.h"

#import "STCTestScoresAndGrades+CoreDataProperties.h"
#import "STCTestScoresHSCRBarChart+CoreDataProperties.h"

#import "STCTestScoresBarChart.h"
#import "STCBarChartItem.h"
#import "STCAverageScoreItem.h"

#import "STCSATPieChartLayout.h"
#import "STCSATPieChart.h"
#import "STCSATPieChartItem.h"

#import "STCFreshmanGraduationDetails.h"

#import "STBroadMajor.h"
#import "STSpecificMajor.h"

@interface STNetworkAPIManager (CollegeDetailsAPI)

- (void) fetchCollegeWithDetails:(NSMutableDictionary *) details success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void) updateCollegeToCoreDataWithDetails:(NSMutableDictionary *) details forResponseType:(ResponseType) type success:(STSuccessBlock)successBlock failure:(STErrorBlock)failureBlock;

- (void)updateCollegeWithSummaryDetails:(id)summaryDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;

- (STCLocation *)updateCollegeWithLocationDetails:(id)locationDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCSimilarSchools *)updateCollegeWithSimilarSchoolsDetails:(id)similarSchoolsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;

- (STCTestScoresAndGrades *)updateCollegeWithTestScoresAndGradesDetails:(id)testScoresAndGradesDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCFreshman *)updateCollegeWithFreshManProfileDetails:(id)freshManProfileDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCAdmissions *)updateCollegeWithAdmissionsDetails:(id)admissionsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCCalender *)updateCollegeWithCalendarDetails:(id)calendarDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCIntendedStudy *)updateCollegeWithIntendedStudyDetails:(id)intendedStudyDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCFeesAndFinancialAid *)updateCollegeWithFeesAndFinancialAidsDetails:(id)feesAndFinancialAidsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCSports *)updateCollegeWithSportsDetails:(id)sportsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCWeather *)updateCollegeWithWeatherDetails:(id)weatherDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;

- (STCRankings *)updateCollegeWithPayScaleRankingsDetails:(id)payScaleRankingsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCProminentAlumini *)updateCollegeWithProminentAluminiDetails:(id)prominentAluminiDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCLinksAndAddresses *)updateCollegeWithLinksAndAddressesDetails:(id)linksAndAddressesDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;
- (STCQuickFacts *)updateCollegeWithQuickFactsDetails:(id)quickFactsDetails forCollege:(STCollege *)college inContext:(NSManagedObjectContext *)localContext;

- (NSDictionary *) getSectionDetailsForSectionWithKey:(NSString *) key;
- (NSDictionary *) getSectionDetailsForSectionWithName:(NSString *) name;

@end
