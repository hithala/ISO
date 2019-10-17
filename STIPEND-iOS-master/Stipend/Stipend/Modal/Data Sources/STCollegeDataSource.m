//
//  STCollegeDataSource.m
//  Stipend
//
//  Created by Ganesh Kumar on 12/02/16.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

#import "STCollegeDataSource.h"

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

#define IMPORTANT_DATE_VIEW_HEIGHT_CONSTANT  140.0
#define OTHER_DATE_VIEW_HEIGHT_CONSTANT      70.0
#define CALENDER_FOOTER_VIEW_HEIGHT_CONSTANT 70.0

@implementation STCollegeDataSource

+ (STCollegeDataSource *) sharedInstance {
    
    static STCollegeDataSource *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[STCollegeDataSource alloc] init];
    });
    
    return sharedInstance;
}


- (id) getCollegeSectionForSectionID:(NSNumber *)sectionID forCollege:(STCollege *)college; {
    
    NSOrderedSet *collegeSections = college.collegeSections;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sectionID == %@",sectionID];
    NSOrderedSet *filteredSet = [collegeSections filteredOrderedSetUsingPredicate:predicate];
    
    if(filteredSet && ([filteredSet count] > 0)) {
        return filteredSet[0];
    }
    
    return nil;
}

- (id) getObjectForFreshman:(STCFreshman *)freshman atIndexPath:(NSIndexPath *)indexPath {
    
    NSOrderedSet *freshmemDetailItems = freshman.freshmanDetailItems;
    STCFreshmanGenderDetails *genderDetails = freshman.genderDetails;
    NSOrderedSet *mostRepresentedStates = freshman.freshmanMostRepresentedStates;
    NSOrderedSet *pieCharts = freshman.pieCharts;
    NSString *religiousAffiliation = freshman.religiousAffiliation;
    NSOrderedSet *greekLife = freshman.freshmanGreekLife;
    STCFreshmanGraduationDetails *graduationDetails = freshman.graduationDetails;
    
    NSMutableOrderedSet *items = [NSMutableOrderedSet orderedSet];
    [items addObject:freshmemDetailItems];
    [items addObject:genderDetails];
    
    if([graduationDetails.sixYearGraduationRate integerValue] > 0 || [graduationDetails.fourYearGraduationRate integerValue] > 0) {
        [items addObject:freshmenItemString(FreshmenItemGraduationRate)];
    }
    
    if([graduationDetails.retentionRate integerValue] > 0) {
        [items addObject:freshmenItemString(FreshmenItemRetentionRate)];
    }
    
    for (STCPieChart *pieChart in pieCharts) {
        if([pieChart.name isEqualToString:@"Geography"]) {
            [items addObject:pieChart];
            break;
        }
    }
    
    if(mostRepresentedStates.count > 0) {
        [items addObject:mostRepresentedStates];
    }
    
    for (STCPieChart *pieChart in pieCharts) {
        if([pieChart.name isEqualToString:@"Ethnicity"]) {
            [items addObject:pieChart];
            break;
        }
    }
    
    if(religiousAffiliation) {
//        [items addObject:religiousAffiliation];
        [items addObject:freshmenItemString(FreshmenItemReligiousAffiliation)];
    }
    
    if(greekLife.count > 0) {
        [items addObject:greekLife];
    }
    
    return [items objectAtIndex:indexPath.row];
}

- (NSOrderedSet *) getObjectForSports:(STCSports *) sports atSelectionIndex:(NSInteger) index {
    
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    
    if(sports.menSports.sportsDivisions.count > 0) {
        [orderedSet addObject:sports.menSports.sportsDivisions];
    }
    
    if(sports.womenSports.sportsDivisions.count > 0) {
        [orderedSet addObject:sports.womenSports.sportsDivisions];
    }

    if(orderedSet.count > 0) {
        return [orderedSet objectAtIndex:index];
    } else {
        return nil;
    }
}

- (NSOrderedSet *) getObjectForFees:(STCFeesAndFinancialAid *) feesAndFinancialAid atSelectionIndex:(NSInteger) index {
    
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    
    if(feesAndFinancialAid.inStateFees) {
        [orderedSet addObject:feesAndFinancialAid.inStateFees];
    }
    
    if(feesAndFinancialAid.outStateFees) {
        [orderedSet addObject:feesAndFinancialAid.outStateFees];
    }

    return [orderedSet objectAtIndex:index];
}

- (id) getObjectForTestScores:(STCTestScoresAndGrades *) tesScoresAndGrades atIndex:(NSInteger) index {
    
    NSMutableOrderedSet *testScoresItemsSet = [NSMutableOrderedSet orderedSet];
    
    if(tesScoresAndGrades.averageScores) {
        [testScoresItemsSet addObject:@"AVERAGE SCORES"];
    }
    
    if(tesScoresAndGrades.testScoresBarCharts && ([tesScoresAndGrades.testScoresBarCharts count] > 0)) {
        [testScoresItemsSet addObject:@"BAR CHARTS"];
    }
    
    if((tesScoresAndGrades.testScoresPieCharts && ([tesScoresAndGrades.testScoresPieCharts count] > 0)) || (tesScoresAndGrades.testScoreSATPieChart)) {
        [testScoresItemsSet addObject:@"PIE CHARTS"];
    }
    
    [testScoresItemsSet addObject:@"FOOTER VIEW"];
    
    if(tesScoresAndGrades.testScoreHSCRBarCharts) {
        [testScoresItemsSet addObject:@"HSCR VIEW"];
    }
    
    return [testScoresItemsSet objectAtIndex:index];
}

- (id) getObjectForTestScoreBarChart:(STCTestScoresAndGrades *) testScoresAndGrades atSelectionIndex:(NSInteger) index {
    
    NSMutableOrderedSet *testScoresBarChartSet = [NSMutableOrderedSet orderedSet];
    
    for (STCBarChartItem *item in testScoresAndGrades.testScoresBarCharts) {
        if([item.title isEqualToString:@"SAT SCORE"]) {
            [testScoresBarChartSet addObject:@"SAT SCORE"];
        }
        else if([item.title isEqualToString:@"ACT SCORE"]) {
            [testScoresBarChartSet addObject:@"ACT SCORE"];
        }
    }
    
    return [testScoresBarChartSet objectAtIndex:index];
}

- (id) getObjectForTestScorePieChart:(STCTestScoresAndGrades *) testScoresAndGrades atSelectionIndex:(NSInteger) index {
    
    NSMutableOrderedSet *testScoresPieChartSet = [NSMutableOrderedSet orderedSet];
    
    for (STCPieChart *item in testScoresAndGrades.testScoresPieCharts) {
        if([item.name isEqualToString:@"GPA SCORES"]) {
            [testScoresPieChartSet addObject:item];
            break;
        }
    }
    
    if(testScoresAndGrades.testScoreSATPieChart) {
        [testScoresPieChartSet addObject:testScoresAndGrades.testScoreSATPieChart];
    }
    
    for (STCPieChart *item in testScoresAndGrades.testScoresPieCharts) {
        if([item.name isEqualToString:@"ACT SCORES"]) {
            [testScoresPieChartSet addObject:item];
            break;
        }
    }

    if(testScoresPieChartSet.count > index) {
        return [testScoresPieChartSet objectAtIndex:index];
    } else {
        return testScoresPieChartSet.lastObject;
    }
}

- (CGFloat) getHeightOfSATPieChartDescription:(STCSATPieChartLayout *) satPieChartLayout {
    
    NSInteger maxItems = 0;
    NSOrderedSet *pieCharts = satPieChartLayout.items;
    CGFloat offset = 0.0;
    
    if(pieCharts.count > 0) {
        
        NSInteger index = 0;
        
        for (NSInteger i = 0 ; i < pieCharts.count; i++) {
            STCSATPieChart *item = [pieCharts objectAtIndex:i];
            
            if(item.pieChartItems.count > maxItems) {
                index = i;
                maxItems = item.pieChartItems.count;
            }
        }
    }
    
    offset = ((5 - maxItems) * 10.0);//5 is the max items it can come from server
    
    return ((maxItems * 30.0) + 10.0 + offset);
}

- (CGFloat) getIntendedStudyPieChartHeightFromSet:(NSOrderedSet *)pieChartItems {
    
    CGFloat height = 0.0;
    
    for (STCPieChartItem *item in pieChartItems) {
        @autoreleasepool {
            NSString *labelString = [item.key stringByAppendingString:[NSString stringWithFormat:@" - %@%%",[item value]]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (([UIScreen mainScreen].bounds.size.width/2.0) - 40.0), 50.0)];
            label.text = labelString;
            label.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:12.0];
            [label setNumberOfLines:0];
            [label sizeToFit];
            
            height += label.frame.size.height;
        }
    }
    
    height = height + 70.0;
    
    return height;
}

- (id) getObjectForLinksAndAddresses:(STCLinksAndAddresses *) linksAndAddresses atIndex:(NSInteger) index forCollegeID:(NSNumber *)collegeID {
    
    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
    
    NSMutableOrderedSet *linksAndAddressSet = [NSMutableOrderedSet orderedSet];
    
    if(college.telephoneNumber && (![college.telephoneNumber isEqualToString:@""])) {
        [linksAndAddressSet addObject:@"TELEPHONE"];
    }
    
    if(college.emailID && (![college.emailID isEqualToString:@""])) {
        [linksAndAddressSet addObject:@"EMAIL"];
    }
    
    return [linksAndAddressSet objectAtIndex:index];
}

- (NSInteger) getTotalCountOfItemsInLinksAndAddresses:(STCLinksAndAddresses *) linksAndAddress forCollegeID:(NSNumber *)collegeID {
    
    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
    
    NSInteger totalItemsCount = linksAndAddress.linksAndAddressesItems.count;
    
    if(college.telephoneNumber && (![college.telephoneNumber isEqualToString:@""])) {
        totalItemsCount++;
    }
    
    if(college.emailID && (![college.emailID isEqualToString:@""])) {
        totalItemsCount++;
    }
    
    totalItemsCount++;
    
    return totalItemsCount;
}

// Returning number of rows

- (id) getCollegeSectionForSectionID:(NSNumber *) sectionID andCollegeID:(NSNumber *)collegeID {
    
    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
    
    NSOrderedSet *collegeSections = college.collegeSections;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sectionID == %@",sectionID];
    NSOrderedSet *filteredSet = [collegeSections filteredOrderedSetUsingPredicate:predicate];
    
    if(filteredSet && ([filteredSet count] > 0)) {
        return filteredSet[0];
    }
    
    return nil;
}


- (NSInteger)numberOfRowsForSectionID:(NSNumber *)sectionID andSectionTitle:(NSString *)sectionTitle andCollegeID:(NSNumber *)collegeID {
    
    STCollegeSections *collegeSection = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
    
    if(collegeSection) {
        
        BOOL isExpanded = [collegeSection.isExpanded boolValue];
        
        if([sectionTitle isEqualToString:@"Location"]) {
            
            if(isExpanded) {
                return 2;
            }
            else {
                return 0;
            }
        } else if ([sectionTitle isEqualToString:@"Fast Facts"]) {
            
            if(isExpanded) {
                return 1;
            }
            else {
                return 0;
            }
        } else if ([sectionTitle isEqualToString:@"Notable Alumini"]) {
            STCProminentAlumini *alumini = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            BOOL isSeeMore = [alumini.hasSeeMore boolValue];
            
            if(isExpanded) {
                
                NSInteger totalNumberOfRows = alumini.aluminiItems.count;
                NSInteger rowCount = 0;
                
                if(isSeeMore) {
                    
                    if(totalNumberOfRows > 5) {
                        rowCount = 6;
                    }
                    else {
                        alumini.hasSeeMore = [NSNumber numberWithBool:NO];
                        rowCount = totalNumberOfRows;
                    }
                } else {
                    rowCount = totalNumberOfRows;
                }
                
                return rowCount;
            } else {
                return 0;
            }
            
        } else if ([sectionTitle isEqualToString:@"Similar Schools"]) {
            
            STCSimilarSchools *similarSchool = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            BOOL isSeeMore = [similarSchool.hasSeeMore boolValue];
            
            if(isExpanded) {
                
                NSInteger totalNumberOfRows = similarSchool.simlarSchoolItems.count;
                NSInteger rowCount = 0;
                
                if(isSeeMore) {
                    
                    if(totalNumberOfRows > 5) {
                        rowCount = 6;
                    }
                    else {
                        similarSchool.hasSeeMore = [NSNumber numberWithBool:NO];
                        rowCount = totalNumberOfRows;
                    }
                } else {
                    rowCount = totalNumberOfRows;
                }
                
                return rowCount;
            } else {
                return 0;
            }
            
        } else if ([sectionTitle isEqualToString:@"Admissions"]) {
            
            STCAdmissions *admissions = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            
            if(isExpanded) {
                NSInteger totalNumberOfRows = (admissions.admissionItems.count + 1);
                return totalNumberOfRows;
            }
            else {
                return 0;
            }
        } else if ([sectionTitle isEqualToString:@"Links And Addresses"]) {
            
            STCLinksAndAddresses *linksAndAddresses = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            
            if(isExpanded) {
                NSInteger totalNumberOfRows = [self getTotalCountOfItemsInLinksAndAddresses:linksAndAddresses forCollegeID:collegeID];
                
                return totalNumberOfRows;
            }
            else {
                return 0;
            }
        }
        else if ([sectionTitle isEqualToString:@"Freshmen Profile"] || [sectionTitle isEqualToString:@"Freshman Profile"]) {
            
            if(isExpanded) {
                
                STCFreshman *freshman = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
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
                
                return totalNumberOfRows + 1; // +1 for gender
            }
            else {
                return 0;
            }
        }
        else if ([sectionTitle isEqualToString:@"Intended Study"]) { // Popular Majors
            
            if(isExpanded) {

                STCIntendedStudy *intendedStudy = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];

                BOOL isSeeMore = [intendedStudy.hasSeeMore boolValue];
                NSInteger broadMajorsCount = college.broadMajors.count;

                NSInteger totalNumberOfRows = 0;
                totalNumberOfRows = intendedStudy.admissionItems.count + 1 + 1; //1 for pie chart , 1 for student faculty ratio

                if(broadMajorsCount > 0) {
                    if(isSeeMore) {
                        totalNumberOfRows += 1; // See More Button Row
                    } else {
                        totalNumberOfRows += broadMajorsCount + 1;// + 1; // Broad Majors, Default text and See Less Button Rows
                    }
                }
                
                return totalNumberOfRows;
            }
            else {
                return 0;
            }
        }
        else if ([sectionTitle isEqualToString:@"Fees And Financial Aid"]) {
            
            STCFeesAndFinancialAid *feesAndFinancialAid = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            
            BOOL isSeeMore = [feesAndFinancialAid.hasSeeMore boolValue];
            NSInteger householdIncomeCount = feesAndFinancialAid.householdIncome.count;

            if(isExpanded) {
                if(isSeeMore && (householdIncomeCount > 0)) {
                    return 2;
                } else {
                    if(householdIncomeCount > 0) {
                        if(feesAndFinancialAid.netPriceCalculatorURL && (feesAndFinancialAid.netPriceCalculatorURL.length != 0)) {
                            return 3;
                        } else {
                            return 2;
                        }
                    } else {
                        return 1;
                    }
                }
            } else {
                return 0;
            }
        }
        else if ([sectionTitle isEqualToString:@"Calendar"]) {
            
            if(isExpanded) {
                return 1;
            } else {
                return 0;
            }
        }
        else if ([sectionTitle isEqualToString:@"Sports"]) {
            
            if(isExpanded) {
                return 3;
            }
            else {
                
                return 0;
            }
            
        }
        else if ([sectionTitle isEqualToString:@"Weather"]) {
            
            if(isExpanded) {
                return 1;
            }
            else {
                return 0;
            }
        } else if([sectionTitle isEqualToString:@"PayScale ROI Rank"]) {
            
            return 0;
        }
        else if ([sectionTitle isEqualToString:@"Test Scores & Grades"]) {
            
            if(isExpanded) {
                
                STCTestScoresAndGrades *testScores = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
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
                
                return (totalNumberOfRows + 1);
            }
            else {
                
                return 0;
            }
        }
        else {
            
            return 0;
        }
    }
    
    return 0;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath forSectionID:(NSNumber *)sectionID andSectionTitle:(NSString *)sectionTitle andCollegeID:(NSNumber *)collegeID {
    
    STCollegeSections *collegeSection = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
    
    if(collegeSection) {
        
        if([sectionTitle isEqualToString:@"Location"]) {
            
            if(indexPath.row == 0) {
                return 200;
            }
            else {
                return ROW_HEIGHT;
            }
        } else if ([sectionTitle isEqualToString:@"Fast Facts"]) {
            return [self heightofQuickFactsCellForSectionID:sectionID andCollegeID:collegeID];
        } else if ([sectionTitle isEqualToString:@"Notable Alumini"] || [sectionTitle isEqualToString:@"Similar Schools"]) {
            return ROW_HEIGHT;
        } else if ([sectionTitle isEqualToString:@"Admissions"]) {
            
            STCAdmissions *admissions = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            
            if(indexPath.row == 0) {
                return 60.0;
            } else {
                STCAdmissionItem *admissionItem = [admissions.admissionItems objectAtIndex:(indexPath.row - 1)];
                
                if(admissionItem.items.count > 1) {
                    return (18.0 + (ROW_HEIGHT * admissionItem.items.count));
                } else {
                    return  ROW_HEIGHT;
                }
            }
        }
        else if ([sectionTitle isEqualToString:@"Links And Addresses"]) {
            
            STCLinksAndAddresses *linksAndAddresses = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            NSInteger linksCount = linksAndAddresses.linksAndAddressesItems.count;
            
            if(indexPath.row == linksCount) {
                
                UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 70.0 - 27.0 - 13.0), 100)];
                textView.text = [self getCollegeAddressForCollegeID:collegeID];
                textView.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0];
                [textView sizeToFit];
                
                return (textView.frame.size.height + 10.0);
            }
            else {
                return ROW_HEIGHT;
            }
        }
        else if([sectionTitle isEqualToString:@"Freshmen Profile"] || [sectionTitle isEqualToString:@"Freshman Profile"]) {
            
            STCFreshman *freshman = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            
            if(indexPath.row == 0) {// Detail Items
                
                NSOrderedSet *detailItems = freshman.freshmanDetailItems;
                
                NSInteger freshmenDetailsCount = [detailItems count];
                float noOfRows = (float)freshmenDetailsCount/2;
                NSInteger freshmenDetailsRowCount = ceilf(noOfRows);
                
                return (FRESHMEN_DETAILS_ROW_HEIGHT * freshmenDetailsRowCount); //Detail Items
            } else if(indexPath.row == 1) { //Gender
                return 115.0;
            } else {
                
                id freshmanItem = [self getObjectForFreshman:freshman atIndexPath:indexPath];
                
                if([freshmanItem isKindOfClass:[STCPieChart class]]) {
                    return 200.0;
                } else if([freshmanItem isKindOfClass:[NSOrderedSet class]]) {
                    
                    NSOrderedSet *object = freshmanItem;
                    
                    if(object && ([object count] > 0)) {
                        if([object[0] isKindOfClass:[STCFreshmanRepresentedStates class]]) {
                            return 140.0;
                        } else if ([object[0] isKindOfClass:[STCFreshmanGreekLife class]]) {
                            return 110.0;
                        }
                    } else {
                        return ROW_HEIGHT;
                    }
                } else if([freshmanItem isKindOfClass:[NSString class]]) {
                    
                    if([freshmanItem isEqualToString:freshmenItemString(FreshmenItemGraduationRate)]) {
                        return 110.0;
                    } else if([freshmanItem isEqualToString:freshmenItemString(FreshmenItemRetentionRate)]) {
                        return 110.0;
                    }
                    return ROW_HEIGHT;
                } else {
                    return ROW_HEIGHT;
                }
            }
        }
        else if([sectionTitle isEqualToString:@"Intended Study"]) { // Popular Majors
            
            STCIntendedStudy *intendedStudy = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];

            if(indexPath.row == 0) {
                
                STCPieChart *pieChart = intendedStudy.intendedStudyPieChart;
                CGFloat height = [self getIntendedStudyPieChartHeightFromSet:[pieChart pieChartItem]];
                
                if(height < 180.0){
                    height = 180.0;
                }
                
                return height;
            } else if ((indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 3)) {
                return ROW_HEIGHT;
            } else {
                
                BOOL isSeeMore = [intendedStudy.hasSeeMore boolValue];
                
                if(isSeeMore) {
                    return ROW_HEIGHT;
                } else {
                    
                    NSInteger noOfRowsBeforeMajors = intendedStudy.admissionItems.count + 1 + 1;
                    
                    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
                    NSOrderedSet *broadMajors = college.broadMajors;
                    
                    NSInteger currentIndex = indexPath.row - noOfRowsBeforeMajors;
                    
                    if(currentIndex == 0) {
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width - 30.0, 50.0)];
                        label.text = BROAD_MAJORS_DEFAULT_TEXT;
                        label.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:14.0];
                        [label setNumberOfLines:0];
                        [label sizeToFit];
                        
                        CGFloat height = label.frame.size.height + 20.0; // Label height and (Top + Bottom padding)
                        
                        return height;
                        
                    } else if(currentIndex <= broadMajors.count) {
                        
                        NSInteger majorsIndex = currentIndex - 1;
                        STBroadMajor *broadMajor = [broadMajors objectAtIndex:majorsIndex];
                        
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 0.0, [UIScreen mainScreen].bounds.size.width - 47.0, 50.0)];
                        label.text = broadMajor.name;
                        label.font = [UIFont fontType:eFontTypeAvenirBook FontForSize:16.0];
                        [label setNumberOfLines:0];
                        [label sizeToFit];
                        
                        CGFloat height = label.frame.size.height + 29.0; // Label height and (Top + Bottom padding)
                        
                        return height;
                        
                    } else {
                        return ROW_HEIGHT;
                    }
                }
            }
        }
        else if ([sectionTitle isEqualToString:@"Fees And Financial Aid"]) {
            
            STCFeesAndFinancialAid *feesAndFinancialAid = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            CGFloat rowHeight = 0.0;
            
            BOOL isSeeMore = [feesAndFinancialAid.hasSeeMore boolValue];
            
            if(indexPath.row == 0) {
                
                NSInteger feesSelectedIndex = [feesAndFinancialAid.feesSelectedIndex integerValue];
                NSOrderedSet *feesItemSet = [self getObjectForFees:feesAndFinancialAid atSelectionIndex:feesSelectedIndex];
                
                NSInteger itemsCount = feesItemSet.count;
                rowHeight = 60.0 + (itemsCount * ROW_HEIGHT);
                
                float fieldsCount = 0.0;
                
                if([feesAndFinancialAid.averageDebtUponGraduation intValue] > 0) {
                    fieldsCount++;
                }
                
                if([feesAndFinancialAid.averageFinancialAid intValue] > 0) {
                    fieldsCount++;
                }
                
                if([feesAndFinancialAid.receivingFinancialAid intValue] > 0) {
                    fieldsCount++;
                }
                
                if([feesAndFinancialAid.averageMeritAward intValue] > 0) {
                    fieldsCount++;
                }
                
                if([feesAndFinancialAid.receivingMeritAwards intValue] > 0) {
                    fieldsCount++;
                }
                
                if([feesAndFinancialAid.averageNeedMet intValue] > 0) {
                    fieldsCount++;
                }
                
                if([feesAndFinancialAid.averageNetPrice intValue] > 0) {
                    fieldsCount++;
                }
                
                float noOfRowsNeeded = ceilf(fieldsCount / 2);
                
                rowHeight += (noOfRowsNeeded * 80);
                
//                if(([feesAndFinancialAid.averageDebtUponGraduation intValue] > 0) && ([feesAndFinancialAid.averageNeedMet intValue] > 0) && ([feesAndFinancialAid.averageNetPrice intValue] > 0) && ([feesAndFinancialAid.averageMeritAward intValue] > 0)) {
//                    rowHeight += 240.0;
//                } else if(([feesAndFinancialAid.averageDebtUponGraduation intValue] > 0) && ([feesAndFinancialAid.averageNeedMet intValue] > 0) && ([feesAndFinancialAid.averageNetPrice intValue] > 0)) {
//                    rowHeight += 160.0;
//                } else if(([feesAndFinancialAid.averageDebtUponGraduation intValue] > 0) || ([feesAndFinancialAid.averageNeedMet intValue] > 0) || ([feesAndFinancialAid.averageNetPrice intValue] > 0)) {
//                    rowHeight += 80.0;
//                }
                
            } else if(indexPath.row == 1) {
                
                if(isSeeMore) {
                    rowHeight = ROW_HEIGHT;
                } else {
                    rowHeight = 300.0;
                }
            } else {
                rowHeight = ROW_HEIGHT;
            }
            
            return rowHeight;
        }
        else if ([sectionTitle isEqualToString:@"Weather"]) {
            
            return 490.0;
        }
        else if ([sectionTitle isEqualToString:@"Calendar"]) {
            
            STCCalender *calender = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            NSOrderedSet *importantDates = calender.mostImportantDates;
            NSOrderedSet *otherDates = calender.otherImportantDates;
            
            return (importantDates.count > 0 ? IMPORTANT_DATE_VIEW_HEIGHT_CONSTANT : 0) + ((ceilf(otherDates.count/2.0)) * OTHER_DATE_VIEW_HEIGHT_CONSTANT) + CALENDER_FOOTER_VIEW_HEIGHT_CONSTANT;
        }
        else if ([sectionTitle isEqualToString:@"Sports"]) {
            
            if(indexPath.row == 0) {
                
                STCSports *sports = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                NSInteger sportsSelectedIndex = [sports.sportsSelectedIndex integerValue];
                
                id sportsItem = [self getObjectForSports:sports atSelectionIndex:sportsSelectedIndex];
                
                CGFloat rowHeight = 0.0;
                
                rowHeight += 60.0;//segment Control
                
                NSOrderedSet *sportsDivisions = sportsItem;
                
                for (STCSportsDivision *division in sportsDivisions) {
                    
                    NSOrderedSet *sportsItems = division.sportsItems;
                    CGFloat sportsDetailsRowCount = ceilf([sportsItems count]/2.0);
                    rowHeight += (60.0 + (ROW_HEIGHT * sportsDetailsRowCount));
                }
                
                return rowHeight;
            }
            else {
                return ROW_HEIGHT;
            }
        }
        else if ([sectionTitle isEqualToString:@"Test Scores & Grades"]) {
            
            STCTestScoresAndGrades *testScores = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            
            id testScoreItem = [self getObjectForTestScores:testScores atIndex:indexPath.row];
            
            if([testScoreItem isEqualToString:@"AVERAGE SCORES"]) {
                return 80.0;
            }
            else if([testScoreItem isEqualToString:@"BAR CHARTS"]) {
                
                id object = [self getObjectForTestScoreBarChart:testScores atSelectionIndex:[testScores.barChartSelectedIndex integerValue]];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",object];
                NSOrderedSet *barChartSet = [testScores.testScoresBarCharts filteredOrderedSetUsingPredicate:predicate];
                
                if(barChartSet) {
                    STCTestScoresBarChart *barChart = [barChartSet objectAtIndex:0];
                    
                    NSInteger count = barChart.barChartItems.count;
                    
                    if(count > 0) {
                        return 370.0;
                    }
                    else {
                        return 170.0;
                    }
                }
                
                return ROW_HEIGHT;
            }
            else if([testScoreItem isEqualToString:@"PIE CHARTS"]) {
                id object = [self getObjectForTestScorePieChart:testScores atSelectionIndex:[testScores.pieChartSelectedIndex integerValue]];
                
                if([object isKindOfClass:[STCSATPieChartLayout class]]) {
                    
                    CGFloat descriptionHeight = [self getHeightOfSATPieChartDescription:object];
                    CGFloat radius = ((([UIScreen mainScreen].bounds.size.width/2.0)/2.0) - 20.0);
                    
                    radius = radius > 70.0 ? 70.0 : radius;
                    
                    return ((radius * 2) + 50 + descriptionHeight);
                    
                } else {
                    return 220.0;
                }
            } else if([testScoreItem isEqualToString:@"HSCR VIEW"]) {
                
                STCTestScoresHSCRBarChart *barChartValues = testScores.testScoreHSCRBarCharts;
                
                if(barChartValues.totalPercentageValue.integerValue > 0) {
                    return 315.0;
                } else {
                    return 270.0;
                }
            }
            else {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width - 30.0, 50.0)];
                label.text = TEST_SCORE_DEFAULT_TEXT;
                label.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:14.0];
                [label setNumberOfLines:0];
                [label sizeToFit];
                
                CGFloat height = label.frame.size.height + 20.0;// + 15.0;
                
                return height;
            }
        }
        else {
            return 0.0;
        }
    }
    else {
        return 0.0;
    }
    
    return 0;
}

// Get height for Quick facts

- (CGFloat)heightofQuickFactsCellForSectionID:(NSNumber *)sectionID andCollegeID:(NSNumber *)collegeID {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(collegeID == %@) AND (sectionID == %@)", collegeID, sectionID];
    
    STCQuickFacts *collegeQuickFacts = [STCQuickFacts MR_findFirstWithPredicate:predicate];
    
    NSString *text = collegeQuickFacts.quickFactsText;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width - 30.0, 50.0)];
    label.text = text;
    label.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0];
    [label setNumberOfLines:0];
    [label sizeToFit];
    
    CGFloat height = label.frame.size.height + 20.0;
    
    return height;
}

// Get Address of college

- (NSString *)getCollegeAddressForCollegeID:(NSNumber *)collegeID {
    
    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
    
    NSString *collegeAddress = [NSString stringWithFormat:@"%@\n", college.collegeName];
    
    if(college.streetName) {
        collegeAddress = [NSString stringWithFormat:@"%@%@\n", collegeAddress, college.streetName];
    }
    
    if(college.place) {
        collegeAddress = [NSString stringWithFormat:@"%@%@", collegeAddress, college.place];
    }
    
    if(college.zipCode) {
        collegeAddress = [NSString stringWithFormat:@"%@ %@", collegeAddress, college.zipCode];
    }
    
    return collegeAddress;
}

@end
