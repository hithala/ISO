//
//  STCollegeDataSource.h
//  Stipend
//
//  Created by Ganesh Kumar on 12/02/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCollegeDataSource : NSObject

+ (STCollegeDataSource *)sharedInstance;

- (id) getCollegeSectionForSectionID:(NSNumber *) sectionID andCollegeID:(NSNumber *)collegeID;

- (id)getObjectForFreshman:(STCFreshman *)freshman atIndexPath:(NSIndexPath *)indexPath;

- (NSOrderedSet *)getObjectForSports:(STCSports *)sports atSelectionIndex:(NSInteger)index;

- (NSOrderedSet *)getObjectForFees:(STCFeesAndFinancialAid *)feesAndFinancialAid atSelectionIndex:(NSInteger)index;

- (id)getObjectForTestScores:(STCTestScoresAndGrades *)tesScoresAndGrades atIndex:(NSInteger)index;

- (id)getObjectForTestScoreBarChart:(STCTestScoresAndGrades *)testScoresAndGrades atSelectionIndex:(NSInteger)index;

- (id)getObjectForTestScorePieChart:(STCTestScoresAndGrades *)testScoresAndGrades atSelectionIndex:(NSInteger)index;

- (CGFloat)getHeightOfSATPieChartDescription:(STCSATPieChartLayout *)satPieChartLayout;
- (CGFloat) getIntendedStudyPieChartHeightFromSet:(NSOrderedSet *)pieChartItems;


- (id)getObjectForLinksAndAddresses:(STCLinksAndAddresses *)linksAndAddresses atIndex:(NSInteger)index forCollegeID:(NSNumber *)collegeID;

- (NSInteger)getTotalCountOfItemsInLinksAndAddresses:(STCLinksAndAddresses *)linksAndAddress forCollegeID:(NSNumber *)collegeID;

- (NSString *)getCollegeAddressForCollegeID:(NSNumber *)collegeID;

// DataSource methods

- (NSInteger)numberOfRowsForSectionID:(NSNumber *)sectionID andSectionTitle:(NSString *)sectionTitle andCollegeID:(NSNumber *)collegeID;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath forSectionID:(NSNumber *)sectionID andSectionTitle:(NSString *)sectionTitle andCollegeID:(NSNumber *)collegeID;

@end
