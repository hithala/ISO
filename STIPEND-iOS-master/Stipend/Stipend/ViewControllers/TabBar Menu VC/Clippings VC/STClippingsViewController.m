//
//  STClippingsViewController.m
//  Stipend
//
//  Created by Ganesh Kumar on 13/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STClippingsViewController.h"
#import "STUser.h"
#import "STClippingsItem.h"
#import "STClippingSectionItem.h"
#import "STClippingsSectionHeaderView.h"
#import "STClippingsSectionView.h"
#import "STClippingsCell.h"
#import "STLocationViewController.h"


#import "STCollegeDetailViewController+ShareAdditions.h"

#import "STSocialLoginManager.h"
#import "STEventKitManager.h"

#import "STCollegeSectionFooterView.h"

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

#import "STWebViewController.h"

#import "STFreshmanRateView.h"
#import "STFreshmanRateCell.h"

#import "RetentionRatePopupView.h"
#import "STHintPopUpView.h"

#import "STSpecificMajorsViewController.h"

#define ROW_HEIGHT                      50.0
#define ADDRESS_ROW_HEIGHT              130.0
#define FRESHMEN_DETAILS_ROW_HEIGHT     60.0

#define SECTION_BASE_TAG                9999

#define PIE_CHART_ROW_HEIGHT            200.0
#define INTENDED_STUDY_CELL_1           70.0

#define TAG_GEOGRAPHICS                 100
#define TAG_ETHNICITY                   101
#define TAG_INTENDED_STUDY              102

#define TITLE_SECTION_HEIGHT            44.0
#define CONTENT_SECTION_HEIGHT          60.0

#define TILE_CLOSE                      @"tile_close"
#define TILE_OPEN                       @"tile_open"

#define KEY_LABEL                       @"kLabelKey"

#define COLLEGE_LATITUDE                @"kCollegeLatitudeKey"
#define COLLEGE_LONGITUDE               @"kCollegeLongitudeKey"
#define COLLEGE_NAME                    @"kCollegeNameKey"
#define COLLEGE_LOCATION_NAME           @"kCollegeLocationNameKey"

#define IMPORTANT_DATE_VIEW_HEIGHT_CONSTANT  140.0
#define OTHER_DATE_VIEW_HEIGHT_CONSTANT      70.0
#define CALENDER_FOOTER_VIEW_HEIGHT_CONSTANT 70.0

@interface STClippingsViewController ()

@property (nonatomic, assign) NSInteger index;

@property (strong, nonatomic) RetentionRatePopupView* ratePopupView;
@property (strong, nonatomic) STHintPopUpView* hintPopupView;

@end

@implementation STClippingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STDefaultCell" bundle:nil] forCellReuseIdentifier:@"STDefaultCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STCollegeLocationCell" bundle:nil] forCellReuseIdentifier:@"STCollegeLocationCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STSeeMoreCell" bundle:nil] forCellReuseIdentifier:@"STSeeMoreCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STAddressCell" bundle:nil] forCellReuseIdentifier:@"STAddressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STCallAndMailCell" bundle:nil] forCellReuseIdentifier:@"STCallAndMailCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STCollegeRankingsViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"STCollegeRankingsViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STAdmissionCodeViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"STAdmissionCodeViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STAdmissionSwitchViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"STAdmissionSwitchViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STAdmissionRecommendationCell" bundle:nil] forCellReuseIdentifier:@"STAdmissionRecommendationCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STIntendedStudyPieChartCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"STIntendedStudyPieChartCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STIntendedStudyDetailsCell" bundle:nil] forCellReuseIdentifier:@"STIntendedStudyDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STBroadMajorCell" bundle:nil] forCellReuseIdentifier:@"STBroadMajorCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"STFreshmenGeographicsCell" bundle:nil] forCellReuseIdentifier:@"STFreshmenGeographicsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFreshmenEthnicityCell" bundle:nil] forCellReuseIdentifier:@"STFreshmenEthnicityCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFreshmanGenderCell" bundle:nil] forCellReuseIdentifier:@"STFreshmanGenderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFreshmanRateCell" bundle:nil] forCellReuseIdentifier:@"STFreshmanRateCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STMostRepresentedStatesCell" bundle:nil] forCellReuseIdentifier:@"STMostRepresentedStatesCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFreshmenDetailsCell" bundle:nil] forCellReuseIdentifier:@"STFreshmenDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFreshmenReligiousCell" bundle:nil] forCellReuseIdentifier:@"STFreshmenReligiousCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFreshmenGreekLifeCell" bundle:nil] forCellReuseIdentifier:@"STFreshmenGreekLifeCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"STQuickFactsViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"STQuickFactsViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STFinancialDetailsCell" bundle:nil] forCellReuseIdentifier:@"STFinancialDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STFinancialAidNetIncomeCell" bundle:nil] forCellReuseIdentifier:@"STFinancialAidNetIncomeCell"];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"STSportsDetailsCell" bundle:nil] forCellReuseIdentifier:@"STSportsDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STSportsMascotCell" bundle:nil] forCellReuseIdentifier:@"STSportsMascotCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STCalenderDetailsCell" bundle:nil] forCellReuseIdentifier:@"STCalenderDetailsCell"];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STTestScoresDetailCell" bundle:nil] forCellReuseIdentifier:@"STTestScoresDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STTestScoresPieChartCell" bundle:nil] forCellReuseIdentifier:@"STTestScoresPieChartCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STTestScoresBarChartCell" bundle:nil] forCellReuseIdentifier:@"STTestScoresBarChartCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STTestScoresHSCRCell" bundle:nil] forCellReuseIdentifier:@"STTestScoresHSCRCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STWeatherDetailCell" bundle:nil] forCellReuseIdentifier:@"STWeatherDetailCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableView.rowHeight = ROW_HEIGHT;
//    self.tableView.estimatedRowHeight = ROW_HEIGHT;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEventToCalender:) name:@"AddEventToCalenderDatabaseNotification" object:nil];
    
//    [self getClippingsDataSource];
//    [self updateView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.index = 0;

    __weak STClippingsViewController *weakSelf = self;

    if(!([[STUserManager sharedManager] isGuestUser]) && !([STUserManager sharedManager].clippingsUpdate)) {
        [STProgressHUD show];
        [[STNetworkAPIManager sharedManager] getClippingsForCurrentUserWithSuccess:^(id response) {
            [STProgressHUD dismiss];
            [STUserManager sharedManager].clippingsUpdate = true;
            [weakSelf getClippingsDataSource];
            [weakSelf updateCollegeDetailsIfAny];
        } failure:^(NSError *error) {
            [STProgressHUD dismiss];
        }];
    } else {
        [self getClippingsDataSource];
        [self updateCollegeDetailsIfAny];
    }
}

// Setting navigation bar with menu and edit button
- (void)setupNavigationBar {
    
    self.title = @"Clippings";
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navbar_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuButtonAction:)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

}

- (void) updateCollegeDetailsIfAny {
    
    if (self.clippedColleges && ([self.clippedColleges count] > 0) && self.index < [self.clippedColleges count]) {
        
        STClippingsItem *item = [self.clippedColleges objectAtIndex:self.index];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", item.collegeID];
        STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
        
        if([college.shouldUpdate boolValue] == YES) {
            STLog(@"update college");
            
            NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObject:college.collegeID forKey:kCollegeID];
            
            [STProgressHUD show];
            
            [[STNetworkAPIManager sharedManager] fetchCollegeWithDetails:details success:^(id response) {
                
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    STCollege *localCollege = [college MR_inContext:localContext];
                    localCollege.shouldUpdate = [NSNumber numberWithBool:NO];
                    
                } completion:^(BOOL success, NSError *error) {
                    
                    [STProgressHUD dismiss];
                    
                    self.index++;
                    [self updateCollegeDetailsIfAny];
                    
                }];
            } failure:^(NSError *error) {
                [STProgressHUD dismiss];
            }];
        } else {
            
            self.index++;
            [self updateCollegeDetailsIfAny];
        }
    } else {
        [self updateView];
    }
}


// Clippings list editing mode changing
- (void)editORDoneRows {
    
    if(self.editing) {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [self doneButtonAction];
    }
    else {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        [self updateViewForEditMode];
    }
    
    [self.tableView reloadData];
}

- (void) updateView {
    
    if(self.clippingsDataSource && ([self.clippingsDataSource count] > 0)) {
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
        
        [self.tableView reloadData];
    }
    else {
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
    }
    
    [self updateRightBarButtonItems];
}

- (void) updateRightBarButtonItems {
    
    if((self.clippingsDataSource) && (self.clippingsDataSource.count > 0)) {
        
        if(self.editing) {
           
            UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(editORDoneRows)];
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton, nil];
        } else {
           
            UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editORDoneRows)];
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton, nil];
        }
    }
    else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)updateViewForEditMode {
    
    for(id clippingItem in self.clippingsDataSource) {
        
        if ([clippingItem isKindOfClass:[STClippingSectionItem class]]) {
            STClippingSectionItem *item = clippingItem;
            item.isExpanded = [NSNumber numberWithBool:NO];
        }
    }
}

- (void)doneButtonAction {
    
}

- (void)getClippingsDataSource {
    
    STUser *localUser = [[STUserManager sharedManager] getCurrentUserInDefaultContext];
    NSOrderedSet *clippingsList = localUser.clippings;

    self.clippingsDataSource = [NSMutableArray array];
    self.clippedColleges = [NSMutableArray array];
    
    if(clippingsList.count > 0) {
        
        for(STClippingsItem *clippingsItem in clippingsList) {
            
            [self.clippingsDataSource addObject:clippingsItem];
            [self.clippedColleges addObject:clippingsItem];
            
            for(STClippingSectionItem *sectionItem in clippingsItem.clippingSections) {
                [self.clippingsDataSource addObject:sectionItem];
            }
        }
    }
    else {
    }
}

// Left bar button item action
- (void)onMenuButtonAction:(id)sender {
    
    CGRect viewRect = self.view.frame;
    viewRect.size.width = self.view.frame.size.width*0.75;
    
    UIGraphicsBeginImageContext(viewRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.navigationController.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.delegate capturedImage:image];
    [self.delegate showMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.clippingsDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    id clippingItem = [self.clippingsDataSource objectAtIndex:section];
    
    if([clippingItem isKindOfClass:[STClippingsItem class]]) {
        return TITLE_SECTION_HEIGHT;
    } else if ([clippingItem isKindOfClass:[STClippingSectionItem class]]) {
        return CONTENT_SECTION_HEIGHT;
    }
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    id clippingItem = [self.clippingsDataSource objectAtIndex:section];
    
    if([clippingItem isKindOfClass:[STClippingsItem class]]) {
        
        return 0.0001f;
        
    } else if ([clippingItem isKindOfClass:[STClippingSectionItem class]]) {
        
        STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:section];
        NSNumber *sectionID = sectionItem.sectionID;
        NSString *sectionTitle = sectionItem.sectionTitle;
        
        STClippingsItem *clippingItem = sectionItem.clipping;
        NSNumber *collegeID = clippingItem.collegeID;
        
        STCollegeSections *collegeSection = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        
        if(collegeSection) {
            
            if(([sectionTitle isEqualToString:@"Fast Facts"]) ||([sectionTitle isEqualToString:@"Calendar"]) || ([sectionTitle isEqualToString:@"Fees And Financial Aid"]) || [sectionTitle isEqualToString:@"Test Scores & Grades"] || ([sectionTitle isEqualToString:@"PayScale ROI Rank"]) || ([sectionTitle isEqualToString:@"Weather"]) || ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"])) {

            }
            else {
                
                BOOL isExpanded = [sectionItem.isExpanded boolValue];
                
                if(isExpanded) {
                    return 30.0f;
                }
            }
        }
    }
    
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    id item = [self.clippingsDataSource objectAtIndex:section];
    
    if([item isKindOfClass:[STClippingsItem class]]) {
    }
    else {

        STCollegeSectionFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"STCollegeSectionFooterView" owner:self options:nil][0];
        NSInteger colorIndex = (section % 2);
        footerView.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
        

        STClippingSectionItem *sectionItem = item;
        NSString *sectionTitle = sectionItem.sectionTitle;
        
        if ([sectionTitle isEqualToString:@"Links And Addresses"] || [sectionTitle isEqualToString:@"Similar Schools"] || [sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"] || [sectionTitle isEqualToString:@"Sports"] || [sectionTitle isEqualToString:@"Weather"] || [sectionTitle isEqualToString:@"Notable Alumini"] || [sectionTitle isEqualToString:@"Notable Alumni"] || [sectionTitle isEqualToString:@"Test Scores & Grades"]) {

            footerView.topViewSeparator.hidden = YES;
        } else {
            footerView.topViewSeparator.hidden = NO;
        }
        
        return footerView;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    id clippingItem = [self.clippingsDataSource objectAtIndex:section];
    
    if([clippingItem isKindOfClass:[STClippingsItem class]]) {
        
        STClippingsItem *clippingsItem = [self.clippingsDataSource objectAtIndex:section];

        NSPredicate *collegePredicate = [NSPredicate predicateWithFormat:@"collegeID == %@", clippingsItem.collegeID];
        STCollege *college = [STCollege MR_findFirstWithPredicate:collegePredicate];

        STClippingsSectionHeaderView *sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:@"STClippingsSectionHeaderView" owner:self options:nil][0];
        sectionHeaderView.sectionTitle.text = college.collegeName;
        
        return sectionHeaderView;
        
    } else if ([clippingItem isKindOfClass:[STClippingSectionItem class]]) {
        
        STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:section];
        NSString *sectionName = sectionItem.sectionTitle;
        NSNumber *collegeID = sectionItem.collegeID;
        NSNumber *sectionID = sectionItem.sectionID;
        
        if([sectionName isEqualToString:@"Freshman Profile"] || [sectionName isEqualToString:@"Freshmen Profile"]) {
            sectionName = @"Freshmen Profile";
        }
        
        if ([sectionName isEqualToString:@"Notable Alumini"] || [sectionName isEqualToString:@"Notable Alumni"]) {
            sectionName = @"Notable Alumni";
        }
        
        if ([sectionName isEqualToString:@"Intended Study"] || [sectionName isEqualToString:@"Popular Majors"]) {
            sectionName = @"Popular Majors";
        }
        
        STClippingsSectionView *sectionHeaderView = [[NSBundle mainBundle] loadNibNamed:@"STClippingsSectionView" owner:self options:nil][0];
        sectionHeaderView.tag = (section + SECTION_BASE_TAG);
        
        NSInteger colorIndex = (section % 2);
        sectionHeaderView.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
        sectionHeaderView.backgroundView.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
        
        BOOL isExpanded = [sectionItem.isExpanded boolValue];
        
        sectionHeaderView.ibSectionHeaderName.text = sectionName;
        sectionHeaderView.ibSectionHeaderIcon.image = [UIImage imageNamed:sectionItem.imageName];
        
        if(isExpanded) {
            sectionHeaderView.ibSectionHeaderArrow.image = [UIImage imageNamed:TILE_CLOSE];
            
            sectionHeaderView.overlayView.hidden = YES;

            sectionHeaderView.ibSectionHeaderIcon.alpha = 1.0;
            sectionHeaderView.ibSectionHeaderName.alpha = 1.0;
            
        } else {
            sectionHeaderView.ibSectionHeaderArrow.image = [UIImage imageNamed:TILE_OPEN];
            
            sectionHeaderView.overlayView.hidden = YES;

            sectionHeaderView.ibSectionHeaderIcon.alpha = 0.5;
            sectionHeaderView.ibSectionHeaderName.alpha = 0.5;
        }
        
        
        sectionHeaderView.clickActionBlock = ^(NSInteger tag) {
            [self onSectionTapAction:tag-SECTION_BASE_TAG];
        };
        
        sectionHeaderView.deleteActionBlock = ^(NSInteger tag) {
            [self deleteSectionAtIndex:tag-SECTION_BASE_TAG];
        };
        
        sectionHeaderView.removeActionBlock = ^(NSInteger tag) {
            [self removeSectionAtIndex:tag-SECTION_BASE_TAG];
        };
        
        if(self.isEditing) {
            sectionHeaderView.deleteIconLeadingConstraint.constant = 15;
            sectionHeaderView.deleteIconWidthConstraint.constant = 20;
        } else {
            sectionHeaderView.deleteIconLeadingConstraint.constant = 0;
            sectionHeaderView.deleteIconWidthConstraint.constant = 0;
        }
        
        NSString *sectionTitle =  sectionName;
        
        if (([sectionTitle isEqualToString:@"Location"]) || ([sectionTitle isEqualToString:@"Admissions"]) || ([sectionTitle isEqualToString:@"Intended Study"]) || [sectionTitle isEqualToString:@"Popular Majors"] || ([sectionTitle isEqualToString:@"Freshmen Profile"] || [sectionTitle isEqualToString:@"Freshman Profile"]) || ([sectionTitle isEqualToString:@"Fast Facts"]) || ([sectionTitle isEqualToString:@"Fees And Financial Aid"]) || ([sectionTitle isEqualToString:@"Sports"]) || ([sectionTitle isEqualToString:@"Calendar"]) || ([sectionTitle isEqualToString:@"Test Scores & Grades"]) || ([sectionTitle isEqualToString:@"Weather"])) {
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
            
            
            STCRankings *ranking = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            
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
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id clippingItem = [self.clippingsDataSource objectAtIndex:indexPath.section];
    
    if([clippingItem isKindOfClass:[STClippingsItem class]]) {
        return 0;
    } else if ([clippingItem isKindOfClass:[STClippingSectionItem class]]) {
        
        STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:indexPath.section];
        NSNumber *sectionID = sectionItem.sectionID;
        NSString *sectionTitle = sectionItem.sectionTitle;
        
        STClippingsItem *clippingItem = sectionItem.clipping;
        NSNumber *collegeID = clippingItem.collegeID;
        
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
                return [self heightofQuickFactsCellAtIndexPath:indexPath];
            } else if ([sectionTitle isEqualToString:@"Notable Alumini"] || [sectionTitle isEqualToString:@"Notable Alumni"] || [sectionTitle isEqualToString:@"Similar Schools"]) {
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
                    
                    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
                    
                    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, (self.tableView.frame.size.width - 70.0 - 27.0), 100)];
                    textView.text = [self getCollegeAddress:college];
                    textView.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0];
                    [textView sizeToFit];
                    
                    return textView.frame.size.height+10;
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
                }
                else if(indexPath.row == 1) { //Gender
                    return 115.0;
                }
                else {
                    
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
            else if([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) {

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

//                    BOOL isSeeMore = [intendedStudy.hasSeeMore boolValue];
//
//                    if(!isSeeMore && (indexPath.row == 4)) {
//
//                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width - 30.0, 50.0)];
//                        label.text = BROAD_MAJORS_DEFAULT_TEXT;
//                        label.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:14.0];
//                        [label setNumberOfLines:0];
//                        [label sizeToFit];
//
//                        CGFloat height = label.frame.size.height + 20.0;
//
//                        return height;
//                    }
//
//                    return UITableViewAutomaticDimension;
                    
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
                    
//                    if(([feesAndFinancialAid.averageDebtUponGraduation intValue] > 0) && ([feesAndFinancialAid.averageNeedMet intValue] > 0) && ([feesAndFinancialAid.averageNetPrice intValue] > 0)) {
//                        rowHeight += 160.0;
//                    } else if(([feesAndFinancialAid.averageDebtUponGraduation intValue] > 0) || ([feesAndFinancialAid.averageNeedMet intValue] > 0) || ([feesAndFinancialAid.averageNetPrice intValue] > 0)) {
//                        rowHeight += 80.0;
//                    }
                    
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
                NSOrderedSet *otherDates = calender.otherImportantDates;
                
                return IMPORTANT_DATE_VIEW_HEIGHT_CONSTANT + ((ceilf(otherDates.count/2.0)) * OTHER_DATE_VIEW_HEIGHT_CONSTANT) + CALENDER_FOOTER_VIEW_HEIGHT_CONSTANT;
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
                    }
                    else {
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
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width - 30.0, 50.0)];
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
        
    }
    
    
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    id clippingItem = [self.clippingsDataSource objectAtIndex:section];
    
    if([clippingItem isKindOfClass:[STClippingsItem class]]) {
        return 0;
    } else if ([clippingItem isKindOfClass:[STClippingSectionItem class]]) {
        
        STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:section];
        NSNumber *sectionID = sectionItem.sectionID;
        NSString *sectionTitle = sectionItem.sectionTitle;
        
        STClippingsItem *clippingItem = sectionItem.clipping;
        NSNumber *collegeID = clippingItem.collegeID;
        
        
        STCollegeSections *collegeSection = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        
        if(collegeSection) {
            
            BOOL isExpanded = [sectionItem.isExpanded boolValue];
            
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
            }
            else if ([sectionTitle isEqualToString:@"Notable Alumini"] || [sectionTitle isEqualToString:@"Notable Alumni"]) {
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
                    }
                    else {
                        rowCount = totalNumberOfRows;
                    }
                    
                    return rowCount;
                }
                else {
                    return 0;
                }
                
            }
            else if ([sectionTitle isEqualToString:@"Similar Schools"]) {
                
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
                    }
                    else {
                        rowCount = totalNumberOfRows;
                    }
                    
                    return rowCount;
                }
                else {
                    return 0;
                }
            }
            else if ([sectionTitle isEqualToString:@"Admissions"]) {
                
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
                    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];

                    NSInteger totalNumberOfRows = [self getTotalCountOfItemsInLinksAndAddresses:linksAndAddresses forCollege:college];
                    
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
            else if ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) {
                
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
                    }                }
                else {
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
            }
            else if([sectionTitle isEqualToString:@"PayScale ROI Rank"]) {

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
        else {
            return 0;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id clippingItem = [self.clippingsDataSource objectAtIndex:indexPath.section];
    
    if([clippingItem isKindOfClass:[STClippingsItem class]]) {
        return nil;
    } else if ([clippingItem isKindOfClass:[STClippingSectionItem class]]) {
        
        STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:indexPath.section];
        NSNumber *sectionID = sectionItem.sectionID;
        NSString *sectionTitle = sectionItem.sectionTitle;
        
        STClippingsItem *clippingItem = sectionItem.clipping;
        NSNumber *collegeID = clippingItem.collegeID;
        
        STCollegeSections *collegeSection = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        
        __weak STClippingsViewController *weakSelf = self;
        __weak UITableView *weakTableview = self.tableView;
        
        if(collegeSection) {
            
            NSInteger colorIndex = (indexPath.section % 2);
            
            UITableViewCell *cell;
            
            if ([sectionTitle isEqualToString:@"Location"]) {
                
                STCLocation *collegeLocation = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
                if(indexPath.row == 0) {
                    
                    STCollegeLocationCell *locationCell = [tableView dequeueReusableCellWithIdentifier:@"STCollegeLocationCell"];
                    locationCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                    [locationCell updateMapWithLatitude:[collegeLocation.lattitude doubleValue] andLongitude:[collegeLocation.longitude doubleValue]];
                    
                    locationCell.mapClickAction = ^{
                        [self mapClickAction:collegeLocation];
                    };
                    
                    cell = locationCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                else {
                    
                    STDefaultCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"STDefaultCell"];
                    defaultCell.ibCellTitleLabel.text = [NSString stringWithFormat:@"More about %@, %@", collegeSection.college.city, collegeSection.college.state];
                    
                    cell = defaultCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    
                }
            } else if ([sectionTitle isEqualToString:@"Fast Facts"]) {
                
                STQuickFactsViewCell *quickFactsCell = [tableView dequeueReusableCellWithIdentifier:@"STQuickFactsViewCell"];
                quickFactsCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                
                STCQuickFacts *collegeQuickFacts = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
                quickFactsCell.ibTopLabelValue.text = collegeQuickFacts.quickFactsText;
                cell = quickFactsCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }  else if ([sectionTitle isEqualToString:@"Notable Alumini"] || [sectionTitle isEqualToString:@"Notable Alumni"]) {
                
                STCProminentAlumini *alumini = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                BOOL isSeeMore = [alumini.hasSeeMore boolValue];
                
                if(isSeeMore) {
                    
                    if(indexPath.row == 5) {
                        
                        STSeeMoreCell *seeMoreCell = [tableView dequeueReusableCellWithIdentifier:@"STSeeMoreCell"];
                        [seeMoreCell.ibTapButton setBackgroundColor:[UIColor whiteColor]];
                        seeMoreCell.ibTapButton.tag = indexPath.section;
                        [seeMoreCell.ibTapButton setTitle:@"See More..." forState:UIControlStateNormal];
                        seeMoreCell.topCellSeparatorView.hidden = YES;
                        seeMoreCell.clickActionBlock = ^(NSInteger tag) {
                            [self seeMoreClicked:tag];
                        };
                        
                        cell = seeMoreCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                    
                    cell = defaultCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
            } else if ([sectionTitle isEqualToString:@"Similar Schools"]) {
                
                STCSimilarSchools *similarSchool = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                BOOL isSeeMore = [similarSchool.hasSeeMore boolValue];
                
                if(isSeeMore) {
                    
                    if(indexPath.row == 5) {
                        
                        STSeeMoreCell *seeMoreCell = [tableView dequeueReusableCellWithIdentifier:@"STSeeMoreCell"];
                        [seeMoreCell.ibTapButton setBackgroundColor:[UIColor whiteColor]];
                        seeMoreCell.ibTapButton.tag = indexPath.section;
                        [seeMoreCell.ibTapButton setTitle:@"See More..." forState:UIControlStateNormal];
                        seeMoreCell.topCellSeparatorView.hidden = YES;
                        seeMoreCell.clickActionBlock = ^(NSInteger tag) {
                            [self seeMoreClicked:tag];
                        };
                        
                        cell = seeMoreCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    } else {
                        
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
                    
                    cell = defaultCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
            } else if ([sectionTitle isEqualToString:@"Admissions"]) {
                
                if (indexPath.row == 0) {
                    
                    STCAdmissions *admission = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                    NSOrderedSet *admissionCodes = admission.admissionCodes;
                    
                    STAdmissionCodeViewCell *admissionCodeViewCell = [tableView dequeueReusableCellWithIdentifier:@"STAdmissionCodeViewCell"];
                    [admissionCodeViewCell updateCellWithDetails:admissionCodes];
                    admissionCodeViewCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                    
                    cell = admissionCodeViewCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                } else {
                    
                    STCAdmissions *admission = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                    STCAdmissionItem *admissionItem = [admission.admissionItems objectAtIndex:(indexPath.row - 1)];
                    
                    if(admissionItem.items.count > 1) {
                        
                        STAdmissionRecommendationCell *recommendationCell = [tableView dequeueReusableCellWithIdentifier:@"STAdmissionRecommendationCell"];
                        [recommendationCell updateCellWithDetails:admissionItem];
                        recommendationCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                        
                        cell = recommendationCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    } else {
                        
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
                
                STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
                
                STCLinksAndAddresses *linksAndAddress = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
                NSInteger linksAndAddressCount = (linksAndAddress.linksAndAddressesItems.count);
                
                if(indexPath.row == linksAndAddressCount) {
                    
                    STAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"STAddressCell"];
                    
                    addressCell.cellIcon.image = [UIImage imageNamed:@"address"];
                    addressCell.addressTextview.text = [self getCollegeAddress:college];
                    
                    cell = addressCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else if ((indexPath.row == (linksAndAddressCount + 1)) || (indexPath.row == (linksAndAddressCount + 2))) {
                    
                    __weak STClippingsViewController *weakSelf = self;
                    
                    STCallAndMailCell *callAndMailCell = [tableView dequeueReusableCellWithIdentifier:@"STCallAndMailCell"];
                    
                    callAndMailCell.tag = indexPath.section;
                    callAndMailCell.clickButton.tag = indexPath.row;
                    
                    NSInteger itemIndex = (indexPath.row - 1) - linksAndAddressCount;
                    NSString *linksObject = [self getObjectForLinksAndAddresses:linksAndAddress atIndex:itemIndex forCollege:college];
                    
                    if([linksObject isEqualToString:@"EMAIL"]) {
                        
                        NSString *emailID = college.emailID;
                        
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
                        callAndMailCell.cellTitle.text = college.telephoneNumber;
                        
                        callAndMailCell.callActionBlock = ^(NSIndexPath *indexPath) {
                            [weakSelf callAction:indexPath];
                        };
                    }
                    
                    NSInteger totalItemsCount = [self getTotalCountOfItemsInLinksAndAddresses:linksAndAddress forCollege:college];
                    
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
                    cell = defaultCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
            }
            else if([sectionTitle isEqualToString:@"Freshmen Profile"] || [sectionTitle isEqualToString:@"Freshman Profile"]) {
                
                STCFreshman *freshman = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
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
                    
                    id freshmanItem = [self getObjectForFreshman:freshman atIndexPath:indexPath];
                    
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
                        
                      /*  NSString *religiousAffiliation = freshmanItem;
                        
                        STFreshmenReligiousCell *freshmenReligiousCell = [tableView dequeueReusableCellWithIdentifier:@"STFreshmenReligiousCell"];
                        freshmenReligiousCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                        freshmenReligiousCell.ibReligiousLabel.text = @"Religious Affiliation";
                        freshmenReligiousCell.ibReligiousValue.text = religiousAffiliation;
                        cell = freshmenReligiousCell;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone; */
                        {
                            
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
                                
                                __weak STClippingsViewController *weakSelf = self;
                                __weak UITableView *weakTableview = self.tableView;
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
                    }
                    else {
                        
                    }
                }
            }
            else if ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) {
                
                STCIntendedStudy *intendedStudy = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                STCPieChart *pieChart = intendedStudy.intendedStudyPieChart;
                
                if(indexPath.row == 0) {
                    
                    STIntendedStudyPieChartCell *intendedStudyCell = [tableView dequeueReusableCellWithIdentifier:@"STIntendedStudyPieChartCell"];
                    
                    [intendedStudyCell updatePieChartViewWithDetails:[pieChart pieChartItem]];
                    intendedStudyCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                    
                    cell = intendedStudyCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else if (indexPath.row == 1) {//Student Faculty Ratio
                    
                    STIntendedStudyDetailsCell *studyDetailsCell = [tableView dequeueReusableCellWithIdentifier:@"STIntendedStudyDetailsCell"];
                    studyDetailsCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                    
                    [studyDetailsCell updateStudentFacultyRatioWithDetails:intendedStudy.studentFacultyRatio];
                    
                    cell = studyDetailsCell;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else if ((indexPath.row == 2) || (indexPath.row == 3)) {
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
                    
                } else {
                    
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
                        STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
                        NSOrderedSet *broadMajors = college.broadMajors;
                        
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
                    
                    STCFeesAndFinancialAid *feesAndFinancialAid = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                    
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
                    
                    STCFeesAndFinancialAid *feesAndFinancialAid = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];

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
                
                STCCalender *calender = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
                [calenderDetailsCell updateCalenderSectionWithDetails:calender];
                
                calenderDetailsCell.contentView.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                
                cell = calenderDetailsCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            else if ([sectionTitle isEqualToString:@"Weather"]) {
                
                STCWeather *weather = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
                STWeatherDetailCell *weatherCell = [tableView dequeueReusableCellWithIdentifier:@"STWeatherDetailCell"];
                weatherCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                [weatherCell updateCellWithDetails:weather];
                
                cell = weatherCell;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if ([sectionTitle isEqualToString:@"Sports"]) {
                
                STCSports *sports = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
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
                
                STCTestScoresAndGrades *testScoreAndGrades = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
                id testScoreItem = [self getObjectForTestScores:testScoreAndGrades atIndex:indexPath.row];
                
                if([testScoreItem isEqualToString:@"AVERAGE SCORES"]) {
                    STTestScoresDetailCell *testScoresDetailCell = [tableView dequeueReusableCellWithIdentifier:@"STTestScoresDetailCell"];
                    testScoresDetailCell.backgroundColor = [TILES_COLOR_ARRAY objectAtIndex:colorIndex];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
                    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];
                    
                    [testScoresDetailCell updateTestScoresWithDetails:testScoreAndGrades.averageScores withTestScoresAndGrades:testScoreAndGrades forCollege:college];
                    
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
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:indexPath.section];
    NSNumber *sectionID = sectionItem.sectionID;
    NSString *sectionTitle = sectionItem.sectionTitle;
    
    STClippingsItem *clippingItem = sectionItem.clipping;
    NSNumber *collegeID = clippingItem.collegeID;
    
    
    if([sectionTitle isEqualToString:@"Location"]) {
        
        if(indexPath.row == 1) {
            STCollegeSections *collegeSection = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            
            if(collegeSection.college.place && (collegeSection.college.place != 0)) {
                
                NSString *searchString = [NSString stringWithFormat:@"More about %@", collegeSection.college.place];
                NSString *urlString = [[NSString stringWithFormat:@"https://en.wikipedia.org/wiki/%@",searchString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
                webView.urlString = urlString;
                webView.titleText = searchString;
                
                [self.navigationController pushViewController:webView animated:YES];
            }
        }
    } else if([sectionTitle isEqualToString:@"Similar Schools"]) {
        
        STCSimilarSchools *similarSchool = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        
        STCSimilarSchoolItem *similarSchoolItem = [similarSchool.simlarSchoolItems objectAtIndex:indexPath.row];
        
        UIStoryboard *tabBarStoryBoard = [UIStoryboard storyboardWithName:@"TabBarMenu" bundle:nil];
        
        STCollegeDetailViewController *detailViewController = [tabBarStoryBoard instantiateViewControllerWithIdentifier:@"STCollegeDetailViewController"];
        
        detailViewController.isPresenting = YES;
        detailViewController.collegeID = similarSchoolItem.schoolID;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        detailViewController.edgesForExtendedLayout = UIRectEdgeNone;
        [self presentViewController:navController animated:YES completion:nil];

        
    } else if ([sectionTitle isEqualToString:@"Links And Addresses"]) {
        
        STCLinksAndAddresses *linksAndAddress = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        
        NSInteger linksAndAddressCount = (linksAndAddress.linksAndAddressesItems.count);
        
        if(indexPath.row < linksAndAddressCount) {
            
            STCLinksAndAddressesItem *item = [linksAndAddress.linksAndAddressesItems objectAtIndex:indexPath.row];
            
            if(item.value && (item.value.length != 0)) {
                
                STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
                webView.urlString = item.value;
                webView.titleText = item.key;
                
                [self.navigationController pushViewController:webView animated:YES];
            }
        }
    } else if ([sectionTitle isEqualToString:@"Notable Alumini"] || [sectionTitle isEqualToString:@"Notable Alumni"]) {
        
        STCProminentAlumini *alumini = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        STCAluminiItem *item = [alumini.aluminiItems objectAtIndex:indexPath.row];
        
        STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
        
        NSString *searchString = [NSString stringWithFormat:@"%@", item.key];
        NSString *urlString = [[NSString stringWithFormat:@"https://en.wikipedia.org/wiki/%@",searchString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        webView.urlString = urlString;
        webView.titleText = searchString;
        
        [self.navigationController pushViewController:webView animated:YES];
    } else if ([sectionTitle isEqualToString:@"Fees And Financial Aid"]) {
        
        if(indexPath.row == 2) {
            
            STCFeesAndFinancialAid *feesAndFinancialAid = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
            
            if(feesAndFinancialAid.netPriceCalculatorURL && (feesAndFinancialAid.netPriceCalculatorURL.length != 0)) {
                
                STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
                
                NSString *urlString = [feesAndFinancialAid.netPriceCalculatorURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                
                webView.urlString = urlString;
                webView.titleText = @"Net Price Calculator";
                
                [self.navigationController pushViewController:webView animated:YES];
            }
        }
    } else if ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) {
        
        STCIntendedStudy *intendedStudy = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];

        NSInteger noOfRowsBeforeMajors = intendedStudy.admissionItems.count + 1 + 1;
        NSOrderedSet *broadMajors = college.broadMajors;
        
        NSInteger currentIndex = indexPath.row - noOfRowsBeforeMajors - 1;
        
        if(currentIndex >= 0) {
            STBroadMajor *broadMajor = [broadMajors objectAtIndex:currentIndex];
            
            STSpecificMajorsViewController *specificMajorsView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STSpecificMajorsViewController"];
            specificMajorsView.specificMajors = broadMajor.specificMajors;
            
            [self.navigationController pushViewController:specificMajorsView animated:YES];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[STFreshmanRateCell class]]) {
        [self hideRetentionRatePopupView];
    }
    
    [self hideFinancialAidPopupView];
}

#pragma mark Retention Rate View popup view

- (void) showRetentionRatePopupAtRect:(CGRect)rect {
    
    int viewTag = 100200;
    
    CGRect frame = rect;
    frame.origin.x -= (276.0 / 2);
    frame.origin.y += 20.0;
    frame.size.width = 276.0;
    frame.size.height = 112.0;
    
    if(![self.tableView viewWithTag:viewTag]) {
        self.ratePopupView = [[NSBundle mainBundle] loadNibNamed:@"RetentionRatePopupView" owner:self options:nil].firstObject;
        self.ratePopupView.frame = frame;
        self.ratePopupView.tag = viewTag;
        [self.tableView addSubview:self.ratePopupView];
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
        mainRect.origin.x += (self.tableView.frame.size.width / 2);
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
        frameWidth = self.tableView.frame.size.width - 40.0;
        
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
        
        if((frame.origin.x + frame.size.width) > self.tableView.frame.size.width) {
            frame.origin.x -= ((frame.origin.x + frame.size.width) - self.tableView.frame.size.width) + 10;
            if(position == 2) {
                imageviewXPosition += (frameXPosition - frame.origin.x - 5);
            } else {
                imageviewXPosition = frameXPosition - frame.origin.x - 20;
            }
        }
    } else if((position == 1) || (position == 3)) {
        imageviewXPosition = rect.origin.x - 16;
    }
    
    if(![self.tableView viewWithTag:viewTag]) {
        self.hintPopupView = [[NSBundle mainBundle] loadNibNamed:@"STHintPopUpView" owner:self options:nil].firstObject;
        self.hintPopupView.frame = frame;
        self.hintPopupView.tag = viewTag;
//        self.hintPopupView.backgroundColor = [UIColor greenColor];
        self.hintPopupView.imageviewXPosition = imageviewXPosition;
        self.hintPopupView.position = position;
        self.hintPopupView.textLabel.text = financialText;
        [self.tableView addSubview:self.hintPopupView];
        
    } else {
        [self hideFinancialAidPopupView];
    }
}

- (void) hideFinancialAidPopupView {
    
    [self.hintPopupView removeFromSuperview];
}

- (CGFloat) getIntendedStudyPieChartHeightFromSet:(NSOrderedSet *) pieChrtItems {
    
    CGFloat height = 0.0;
    
    for (STCPieChartItem *item in pieChrtItems) {
        @autoreleasepool {
            NSString *labelString = [item.key stringByAppendingString:[NSString stringWithFormat:@" - %@%%",[item value]]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, ((self.view.frame.size.width/2.0) - 40.0), 50.0)];
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


// Delete Section Action

- (void)deleteSectionAtIndex:(NSInteger)index {
    
    if(self.isSelected) {
        self.isSelected = NO;
        [self.tableView reloadData];
    } else {
        self.isSelected = !self.isSelected;
    }
}

- (void)removeSectionAtIndex:(NSInteger)index {

    STLog(@"section index :%ld", (long)index);

    if(index >= self.clippingsDataSource.count) {
        [STProgressHUD showImage:[UIImage imageNamed:@"toast_removed"] andStatus:@"Something went wrong!, Please try later"];
        return;
    }
    
    STClippingSectionItem *clippingsItem = [self.clippingsDataSource objectAtIndex:index];
    NSNumber *sectionID = clippingsItem.sectionID;
    NSNumber *collegeID = clippingsItem.clipping.collegeID;
    NSString *sectionName = clippingsItem.sectionTitle;
    
    if([sectionName isEqualToString:@"Intended Study"]) {
        sectionName = @"Popular Majors";
    }

    NSMutableDictionary *details = [NSMutableDictionary dictionaryWithObjectsAndKeys:collegeID, kCollegeID, sectionID, KEY_SECTION_ID, sectionName, KEY_SECTION_NAME, nil];
    
    [[STNetworkAPIManager sharedManager] removeCollegeSectionFromClippingsWithDetails:details success:^(id response) {

        @try {
            
            id prevItem = [self.clippingsDataSource objectAtIndex:index-1];
            id nextItem;
            
            if(index+1 < [self.clippingsDataSource count]) {
                nextItem = [self.clippingsDataSource objectAtIndex:index+1];
            }
            
            NSRange deleteItemsRange;
            
            if([prevItem isKindOfClass:[STClippingSectionItem class]]) {
                deleteItemsRange = NSMakeRange((index), 1);
                [self.clippingsDataSource removeObjectsInRange:NSMakeRange((index), 1)];
            } else {
                if([nextItem isKindOfClass:[STClippingSectionItem class]]) {
                    deleteItemsRange = NSMakeRange((index), 1);
                    [self.clippingsDataSource removeObjectsInRange:NSMakeRange((index), 1)];
                }
                else if([nextItem isKindOfClass:[STClippingsItem class]]){
                    deleteItemsRange = NSMakeRange((index-1), 2);
                    [self.clippingsDataSource removeObjectsInRange:NSMakeRange((index - 1), 2)];
                }
                else {
                    deleteItemsRange = NSMakeRange((index-1), 2);
                    [self.clippingsDataSource removeObjectsInRange:NSMakeRange((index - 1), 2)];
                }
            }
            
            if(self.clippingsDataSource.count == 0) {
                self.navigationItem.rightBarButtonItem = nil;
                [super setEditing:NO animated:NO];
                [self.tableView setEditing:NO animated:NO];
            }
            
            self.isSelected = NO;
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:deleteItemsRange] withRowAnimation:UITableViewRowAnimationFade];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self updateView];
                //[self.tableView reloadData];
            });
        } @catch (NSException *exception) {
            STLog(@"******* Exception: %@ *******", exception);
        }
    } failure:^(NSError *error) {
        
    }];
}

// Section Click Action

- (void)onSectionTapAction:(NSInteger)section {
    
    // Removing Financial Aid Popips if any.
    [self hideFinancialAidPopupView];
    
    if(self.isEditing) {
        
        self.isSelected = NO;
        [self.tableView reloadData];
        
    } else {
        
        STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:section];
        NSNumber *sectionID = sectionItem.sectionID;
        NSString *sectionTitle = sectionItem.sectionTitle;
        
        STClippingsItem *clippingItem = sectionItem.clipping;
        NSNumber *collegeID = clippingItem.collegeID;
        
        STCollegeSections *collegeSection = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        
        STClippingsSectionView *sectionHeaderView = (STClippingsSectionView *)[self.tableView viewWithTag:(section + SECTION_BASE_TAG)];
        UIImageView *sectionArrowImage = [sectionHeaderView ibSectionHeaderArrow];
        UIView *overlayView = [sectionHeaderView overlayView];
        
        if(collegeSection) {
            
            BOOL isExpanded = [sectionItem.isExpanded boolValue];
            sectionItem.isExpanded = [NSNumber numberWithBool:!isExpanded];
            
            if(!isExpanded) {
                sectionArrowImage.image = [UIImage imageNamed:TILE_CLOSE];
                
                overlayView.hidden = YES;
                
                sectionHeaderView.ibSectionHeaderIcon.alpha = 1.0;
                sectionHeaderView.ibSectionHeaderName.alpha = 1.0;
            }
            else {
                sectionArrowImage.image = [UIImage imageNamed:TILE_OPEN];
                
                overlayView.hidden = YES;
                
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
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
                    
                    [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
                
            } else if ([sectionTitle isEqualToString:@"Fast Facts"]) {
                
                if(!isExpanded) {
                    
                    sectionHeaderView.viewSeparator.hidden = YES;
                    
                    NSInteger rowCount = 1;
                    
                    [self insertRows:rowCount inSection:section withAnimation:UITableViewRowAnimationFade];
                    
                } else {
                    
                    sectionHeaderView.viewSeparator.hidden = NO;
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
                    
                    [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
            } else if([sectionTitle isEqualToString:@"Notable Alumini"] || [sectionTitle isEqualToString:@"Notable Alumni"]) {
                
                STCProminentAlumini *alumini = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
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
                    
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
                    
                    [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
                
                
            } else if([sectionTitle isEqualToString:@"Similar Schools"]) {
                
                STCSimilarSchools *similarSchool = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
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
                    
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
                    
                    [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
            } else if ([sectionTitle isEqualToString:@"Admissions"]) {
                
                STCAdmissions *admissions = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
                if(!isExpanded) {
                    sectionHeaderView.viewSeparator.hidden = YES;
                    
                    NSInteger totalNumberOfRows = (admissions.admissionItems.count + 1);
                    [self insertRows:totalNumberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
                else {
                    
                    sectionHeaderView.viewSeparator.hidden = NO;
                    
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
                    
                    [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
                
            }
            else if ([sectionTitle isEqualToString:@"Links And Addresses"]) {
                
                STCLinksAndAddresses *linksAndAddresses = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
                if(!isExpanded) {
                    
                    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
                    
                    NSInteger totalNumberOfRows = [self getTotalCountOfItemsInLinksAndAddresses:linksAndAddresses forCollege:college];
                    
                    [self insertRows:totalNumberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
                else {
                    
                    sectionHeaderView.viewSeparator.hidden = NO;
                    
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
                    [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
                
            }  else if ([sectionTitle isEqualToString:@"Fees And Financial Aid"]) {
                
                STCFeesAndFinancialAid *feesAndFinancialAid = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
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
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
                    [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
                
            } else if ([sectionTitle isEqualToString:@"Freshmen Profile"] || [sectionTitle isEqualToString:@"Freshman Profile"]) {
                
                if(!isExpanded) {
                    
                    sectionHeaderView.viewSeparator.hidden = YES;
                    
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
                    
                    totalNumberOfRows++;
                    
                    [self insertRows:totalNumberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
                else {
                    
                    sectionHeaderView.viewSeparator.hidden = NO;
                    
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
                    [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
            }
            else if ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) {
                
                STCIntendedStudy *intendedStudy = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];

                if(!isExpanded) {
                    
                    sectionHeaderView.viewSeparator.hidden = YES;
                    
                    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];

                    BOOL isSeeMore = [intendedStudy.hasSeeMore boolValue];
                    NSInteger broadMajorsCount =  college.broadMajors.count;

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
                    
                }
                else {
                    
                    intendedStudy.hasSeeMore = [NSNumber numberWithBool:YES];
                    sectionHeaderView.viewSeparator.hidden = NO;
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
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
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
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
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
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
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
                    [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
                
            } else if ([sectionTitle isEqualToString:@"PayScale ROI Rank"]) {
                
                STCRankings *rankings = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                
                STCRankingItem *item = [rankings.rankingItems firstObject];
                
                if(item.rankingURL) {
                    STWebViewController *webView = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"STWebViewController"];
                    webView.urlString = item.rankingURL;
                    webView.titleText = @"PayScale ROI Rank";
                    
                    [self.navigationController pushViewController:webView animated:YES];
                }
            }
            else if ([sectionTitle isEqualToString:@"Test Scores & Grades"]) {
                
                if(!isExpanded) {
                    
                    sectionHeaderView.viewSeparator.hidden = YES;
                    
                    STCTestScoresAndGrades *testScores = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
                    
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
                }
                else {
                    sectionHeaderView.viewSeparator.hidden = NO;
                    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
                    [self deleteRows:numberOfRows inSection:section withAnimation:UITableViewRowAnimationFade];
                }
            }
        }
    }
}

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


- (id) getObjectForFreshman:(STCFreshman *)freshman atIndexPath:(NSIndexPath *) indexPath {
    
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


- (id) getObjectForLinksAndAddresses:(STCLinksAndAddresses *) linksAndAddresses atIndex:(NSInteger) index forCollege:(STCollege *) college {
    
    NSMutableOrderedSet *linksAndAddressSet = [NSMutableOrderedSet orderedSet];

    if(college.telephoneNumber && (![college.telephoneNumber isEqualToString:@""])) {
        [linksAndAddressSet addObject:@"TELEPHONE"];
    }
    
    if(college.emailID && (![college.emailID isEqualToString:@""])) {
        [linksAndAddressSet addObject:@"EMAIL"];
    }
    
    return [linksAndAddressSet objectAtIndex:index];
}

- (NSInteger) getTotalCountOfItemsInLinksAndAddresses:(STCLinksAndAddresses *) linksAndAddress forCollege:(STCollege *) college {
    
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
    
    offset = ((5 - maxItems) * 10.0);
    
    return ((maxItems * 30.0) + 10.0 + offset);
}

// Location map clicked action

- (void)mapClickAction:(STCLocation *)location {
    
    NSDictionary *locationDict = @{KEY_LABEL:location.college.collegeName, COLLEGE_LATITUDE:location.lattitude, COLLEGE_LONGITUDE:location.longitude};
    
    STLocationViewController *locationViewController = [[UIStoryboard storyboardWithName:@"DrawerMenu" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationViewController"];
    locationViewController.locationDetails = locationDict;
    
    [self.navigationController pushViewController:locationViewController animated:YES];
}

// See more action from similar schools and prominent alumni sctions

- (void)seeMoreClicked:(NSInteger)section {
    
    STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:section];
    NSNumber *sectionID = sectionItem.sectionID;
    NSString *sectionTitle = sectionItem.sectionTitle;
    
    STClippingsItem *clippingItem = sectionItem.clipping;
    NSNumber *collegeID = clippingItem.collegeID;
    
    if([sectionTitle isEqualToString:@"Similar Schools"]) {
        
        STCSimilarSchools *similarSchool = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        similarSchool.hasSeeMore = [NSNumber numberWithBool:NO];
        
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        
        NSInteger rowCount = similarSchool.simlarSchoolItems.count;
        rowCount--;
        
        for (NSInteger i = 5; i < rowCount; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        
        @try {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        } @catch (NSException *exception) {
            STLog(@"******* Exception: %@ *******", exception);
        }
        
    } else if([sectionTitle isEqualToString:@"Notable Alumini"] || [sectionTitle isEqualToString:@"Notable Alumni"]) {
        
        STCProminentAlumini *alumini = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        alumini.hasSeeMore = [NSNumber numberWithBool:NO];
        
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        
        NSInteger rowCount = alumini.aluminiItems.count;
        rowCount--;
        
        for (NSInteger i = 5; i < rowCount; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        
        @try {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:5 inSection:section]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        } @catch (NSException *exception) {
            STLog(@"******* Exception: %@ *******", exception);
        }
    } else if([sectionTitle isEqualToString:@"Fees And Financial Aid"]) {
        
        STCFeesAndFinancialAid *financialAid = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        financialAid.hasSeeMore = [NSNumber numberWithBool:NO];
        
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    } else if ([sectionTitle isEqualToString:@"Intended Study"] || [sectionTitle isEqualToString:@"Popular Majors"]) {
        
        STCIntendedStudy *intendedStudy = [self getCollegeSectionForSectionID:sectionID andCollegeID:collegeID];
        STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];

        bool hasSeeMoreValue = [intendedStudy.hasSeeMore boolValue];
        
        if(hasSeeMoreValue) {
            intendedStudy.hasSeeMore = [NSNumber numberWithBool:NO];
            
            NSInteger broadMajorsCount = college.broadMajors.count;
            
            NSInteger totalRowsBeforeMajors = 0;
            totalRowsBeforeMajors = intendedStudy.admissionItems.count + 1;// + 1; //1 for pie chart , 1 for student faculty ratio
            
            NSInteger totalRows = totalRowsBeforeMajors + broadMajorsCount;// + 1;
            
            NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
            
            for (NSInteger i = totalRowsBeforeMajors; i < totalRows; i++) {
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            @try {
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            } @catch (NSException *exception) {
                STLog(@"******* Exception: %@ *******", exception);
            }
        } else {
            intendedStudy.hasSeeMore = [NSNumber numberWithBool:YES];
            
            NSInteger broadMajorsCount = college.broadMajors.count;
            
            NSInteger totalRowsBeforeMajors = 0;
            totalRowsBeforeMajors = intendedStudy.admissionItems.count + 1 + 1; //1 for pie chart , 1 for student faculty ratio
            
            NSInteger totalRows = totalRowsBeforeMajors + broadMajorsCount + 1;
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            
            for (NSInteger i = totalRowsBeforeMajors; i < totalRows; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            @try {
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:totalRowsBeforeMajors inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            } @catch (NSException *exception) {
                STLog(@"******* Exception: %@ *******", exception);
            }
        }
    }
}

- (void) insertRows:(NSInteger)totalRows inSection:(NSInteger) section withAnimation:(UITableViewRowAnimation) animation {

    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];

    for (NSInteger i = 0; i < totalRows; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }

    @try {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:animation];
        [self.tableView endUpdates];
    } @catch (NSException *exception) {
        STLog(@"******* Exception: %@ *******", exception);
    }
}

- (void) deleteRows:(NSInteger)totalRows inSection:(NSInteger) section withAnimation:(UITableViewRowAnimation) animation {

    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];

    for (NSInteger i = 0; i < totalRows; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }

    @try {
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:animation];
        [self.tableView endUpdates];
    } @catch (NSException *exception) {
        STLog(@"******* Exception: %@ *******", exception);
    }
}


// call and mail actions

- (void) callAction:(NSIndexPath *) indexPath {
    
    STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:indexPath.section];

    STClippingsItem *clippingItem = sectionItem.clipping;
    NSNumber *collegeID = clippingItem.collegeID;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];

    NSString *telephoneNo = college.telephoneNumber;
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
    
    STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:indexPath.section];
    STClippingsItem *clippingItem = sectionItem.clipping;
    NSNumber *collegeID = clippingItem.collegeID;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collegeID == %@", collegeID];
    STCollege *college = [STCollege MR_findFirstWithPredicate:predicate];

    NSString *emailTitle = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:college.emailID];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        [mailComposeVC setSubject:emailTitle];
        [mailComposeVC setToRecipients:toRecipents];
        mailComposeVC.navigationBar.tintColor = [UIColor whiteColor];
        
        [self presentViewController:mailComposeVC animated:YES completion:nil];
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

- (CGFloat)heightofQuickFactsCellAtIndexPath:(NSIndexPath *)indexPath {
    
    STClippingSectionItem *sectionItem = [self.clippingsDataSource objectAtIndex:indexPath.section];
    NSNumber *sectionID = sectionItem.sectionID;
    
    STClippingsItem *clippingItem = sectionItem.clipping;
    NSNumber *collegeID = clippingItem.collegeID;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(collegeID == %@) AND (sectionID == %@)", collegeID, sectionID];
    
    STCQuickFacts *collegeQuickFacts = [STCQuickFacts MR_findFirstWithPredicate:predicate];
    
    NSString *text = collegeQuickFacts.quickFactsText;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width - 30.0, 50.0)];
    label.text = text;
    label.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0];
    [label setNumberOfLines:0];
    [label sizeToFit];
    
    CGFloat height = label.frame.size.height + 20.0;
    
    return height;
}

// Get Address of college

- (NSString *)getCollegeAddress:(STCollege *)college {
    
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

#pragma mark - Event kit Methods

- (void)addEventToCalender:(NSNotification *)notificationObj{
    
    NSDictionary *infoDict = notificationObj.userInfo;
    [[STEventKitManager sharedManager] addEventToCalenderWithDetails:infoDict];
}

- (void)dealloc {
    STLog(@"clippings dealloc");
    
    self.delegate = nil;
    self.clippingsDataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddEventToCalenderDatabaseNotification" object:nil];
}


@end
