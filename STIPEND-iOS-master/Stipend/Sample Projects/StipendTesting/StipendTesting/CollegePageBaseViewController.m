//
//  CollegePageBaseViewController.m
//  StipendTesting
//
//  Created by Ganesh Kumar on 26/05/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "CollegePageBaseViewController.h"
#import <MessageUI/MessageUI.h>

#import "SectionHeaderView.h"
#import "SeeMoreCell.h"
#import "AddressCell.h"
#import "CallAndMessageCell.h"

#import "STBarChartView.h"
#import "STIntendedStudyDetailsCell.h"
#import "STSwitchCell.h"

#import "MostRepresentedStatesCell.h"
#import "STGenderView.h"
#import "FreshmenDetailsCell.h"
#import "FreshmenReligiousCell.h"

#import "STCollegeLocationCell.h"

#import "STLocationViewController.h"

#define DEFAULT_HEADER_VIEW_HEIGHT      self.view.bounds.size.height/2
#define TABLEVIEW_FOOTER_HEIGHT         70.0
#define SECTION_HEADER_HEIGHT           70.0
#define SECTION_FOOTER_HEIGHT           40.0
#define ROW_HEIGHT                      60.0
#define BLUR_VIEW_HEIGHT                150.0
#define ADDRESS_ROW_HEIGHT              100.0
#define PIE_CHART_ROW_HEIGHT            200.0
#define INTENDED_STUDY_CELL_1           100.0


#define LOCATION_DETAILS                @"kLocationKey"
#define SIMILAR_SCHOOLS_DETAILS         @"kSimilarSchoolsKey"
#define TEST_SCORES_DETAILS             @"kTestScoresKey"
#define FRESHMAN_PROFILE_DETAILS        @"kFreshmanProfileKey"
#define ADMISSIONS_DETAILS              @"kAdmissionsKey"
#define CALENDAR_DETAILS                @"kCalendarKey"
#define INTENDED_STUDY_DETAILS          @"kIntendedStudyKey"
#define FEES_FINANCIAL_AID_DETAILS      @"kFees&FinancialAidKey"
#define SPORTS_DETAILS                  @"kSportsKey"
#define WEATHER_DETAILS                 @"kWeatherKey"
#define COLLEGE_RANKINGS_DETAILS        @"kCollegeRankingsKey"
#define PROMINENT_ALUMNI_DETAILS        @"KProminentAlumniKey"
#define LINKS_ADDRESSES_DETAILS         @"kLinks&AddressesKey"

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_EXPAND                      @"kExpandKey"

#define KEY_SEEMORE                     @"kSeeMoreKey"
#define KEY_SEEMORE_PRESENT             @"kSeeMorePresentKey"

#define KEY_VALUES_ARRAY                @"kValuesArrayKey"
#define KEY_VALID                       @"kValidKey"
#define KEY_ICON                        @"kIconKey"

#define UP_ARROW                        @"arrow-up.png"
#define DOWN_ARROW                      @"arrow-down.png"

#define ICON                            @"typeIcon"
#define NAME                            @"typeName"

#define KEY_TEXT_ARRAY                  @"kTextArrayKey"
#define KEY_PERCENTAGE_ARRAY            @"kPercentageArrayKey"

#define TAG_GEOGRAPHICS                 100
#define TAG_ETHNICITY                   101

#define GEOGRAPHICS_DETAILS             @"kGeographicsKey"
#define ETHNICITY_DETAILS               @"kEthnicityKey"
//#define TEST_SCORES_DETAILS             @"kTestScoresKey"

#define FRESHMEN_DETAIL_TITLE           @"kTitleKey"
#define FRESHMEN_DETAIL_SUBTITLE        @"kSubTitleKey"

#define COLLEGE_LATITUDE                @"kCollegeLatitudeKey"
#define COLLEGE_LONGITUDE               @"kCollegeLongitudeKey"
#define COLLEGE_NAME                    @"kCollegeNameKey"
#define COLLEGE_LOCATION_NAME           @"kCollegeLocationNameKey"


#define SimilarSchoolsArray @[@"Dartmouth College",@"Massachusetts Institution of Technology",@"Princeton University",@"Yale University",@"Harward University", @"Dartmouth College1",@"Massachusetts Institution of Technology1",@"Princeton University1",@"Yale University1"]
#define ProminentAlumniArray @[@"John Adams",@"Rutherford B. Hayes",@"Theodore Roosevelt",@"Franklin Delano Roosevelt",@"Stanley Marcus", @"John Adams1",@"Rutherford B. Hayes1",@"Theodore Roosevel1t",@"Franklin Delano Roosevelt1"]
#define LinksAndAddressesArray @[@"Home Page", @"Prospective Students", @"Admissions", @"Financial Aid", @"Housing", @"Greek Life", @"Campus Tours/Visits", @"Majors", @"Harvard University,Massachusetts House,Cambridge, Massachusetts,02183", @"617-495-1000", @"info@harvard.edu"]
#define IntendedStudyArray @[@"Pie chart", @"Class Details", @"Study Abroad?", @"Double Majors Allowed?"]

#define GeographicsLabelArray @[@"Mountain Pacific", @"New England", @"Central", @"Mid-Atlantic", @"Mid West", @"South", @"International"]
#define GeographicsPercentageArray @[@"19", @"19", @"17", @"15", @"15", @"9", @"6"]

#define EthnicityLabelArray @[@"White/Caucasian", @"African/American", @"Hispanic/Latino", @"Asian", @"International", @"American Indian/Alaskan Native", @"Unknown/Other"]
#define EthnicityPercentageArray @[@"19", @"19", @"17", @"15", @"15", @"9", @"6"]

@interface CollegePageBaseViewController ()<MFMailComposeViewControllerDelegate> {
    float headerHeight;
    UIView *headerView;
    NSMutableDictionary *collegeDataSourceDictionary;
    NSArray *orderedSectionList;
    
    NSArray *sliceArray;
    NSArray *colorsArray;
    
    NSMutableDictionary *pieChartsDataSourceDictionary;
    
}

@end

@implementation CollegePageBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    orderedSectionList = [NSArray arrayWithObjects:LOCATION_DETAILS, SIMILAR_SCHOOLS_DETAILS, TEST_SCORES_DETAILS, FRESHMAN_PROFILE_DETAILS, ADMISSIONS_DETAILS, CALENDAR_DETAILS, INTENDED_STUDY_DETAILS, FEES_FINANCIAL_AID_DETAILS, SPORTS_DETAILS, WEATHER_DETAILS, COLLEGE_RANKINGS_DETAILS, PROMINENT_ALUMNI_DETAILS, LINKS_ADDRESSES_DETAILS, nil];
    
    
    NSArray *slices = [NSArray arrayWithObjects:[NSNumber numberWithFloat:20],
                       [NSNumber numberWithFloat:19],
                       [NSNumber numberWithFloat:17],
                       [NSNumber numberWithFloat:15],
                       [NSNumber numberWithFloat:13],
                       [NSNumber numberWithFloat:9],
                       [NSNumber numberWithFloat:7],
                       nil];
    sliceArray = slices;
    
    // Set up the colors for the slices
    NSArray *colors = [NSArray arrayWithObjects:
                       [UIColor colorWithRed:16/255.0 green:92/255.0 blue:203/255.0 alpha:1],
                       [UIColor colorWithRed:19/255.0 green:111/255.0 blue:226/255.0 alpha:1],
                       [UIColor colorWithRed:30/255.0 green:128/255.0 blue:240/255.0 alpha:1],
                       [UIColor colorWithRed:49/255.0 green:143/255.0 blue:246/255.0 alpha:1],
                       [UIColor colorWithRed:80/255.0 green:163/255.0 blue:247/255.0 alpha:1],
                       [UIColor colorWithRed:146/255.0 green:197/255.0 blue:247/255.0 alpha:1],
                       [UIColor colorWithRed:173/255.0 green:213/255.0 blue:254/255.0 alpha:1],nil];
    
    colorsArray = colors;
    
    headerHeight = DEFAULT_HEADER_VIEW_HEIGHT;
    [self setupHeaderView];
    [self setupFooterView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"sectionHeaderView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SeeMoreCell" bundle:nil] forCellReuseIdentifier:@"SeeMoreCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellReuseIdentifier:@"AddressCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CallAndMessageCell" bundle:nil] forCellReuseIdentifier:@"CallAndMessageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STIntendedStudyDetailsCell" bundle:nil] forCellReuseIdentifier:@"IntendedStudyDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"STSwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MostRepresentedStatesCell" bundle:nil] forCellReuseIdentifier:@"MostRepresentedStatesCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FreshmenDetailsCell" bundle:nil] forCellReuseIdentifier:@"FreshmenDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FreshmenReligiousCell" bundle:nil] forCellReuseIdentifier:@"FreshmenReligiousCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"STCollegeLocationCell" bundle:nil] forCellReuseIdentifier:@"STCollegeLocationCell"];

    collegeDataSourceDictionary = [[NSMutableDictionary alloc] init];
    collegeDataSourceDictionary = [self getCollageDataSource];
    
    pieChartsDataSourceDictionary = [[NSMutableDictionary alloc] init];
    pieChartsDataSourceDictionary = [self getPieChartDataSource];
    
    //self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(shareAction:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
}

- (void)shareAction:(id)sender {
    NSLog(@"share btn click");
}

- (NSMutableDictionary *) getPieChartDataSource {
    
    NSMutableDictionary *dataSourceDict = [NSMutableDictionary dictionary];
    
    NSMutableArray *geographicLabelArray = [NSMutableArray arrayWithArray:GeographicsLabelArray];
    NSMutableArray *geographicsPercentageArray = [NSMutableArray arrayWithArray:GeographicsPercentageArray];
    
    NSMutableArray *ethnicityLabelArray = [NSMutableArray arrayWithArray:EthnicityLabelArray];
    NSMutableArray *ethnicityPercentageArray = [NSMutableArray arrayWithArray:EthnicityPercentageArray];
    
    
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"GEOGRAPHICS",KEY_LABEL,geographicsPercentageArray,KEY_PERCENTAGE_ARRAY,geographicLabelArray,KEY_TEXT_ARRAY, nil] forKey:GEOGRAPHICS_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"ETHNICITY",KEY_LABEL,ethnicityPercentageArray,KEY_PERCENTAGE_ARRAY,ethnicityLabelArray,KEY_TEXT_ARRAY, nil] forKey:ETHNICITY_DETAILS];
    
    return dataSourceDict;
}

- (NSMutableDictionary *) getCollageDataSource {
    
    NSMutableDictionary *dataSourceDict = [NSMutableDictionary dictionary];
    
    NSArray *freshmenDetailsArray = [NSArray arrayWithObjects:
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"35,023", FRESHMEN_DETAIL_TITLE, @"Total Applicants", FRESHMEN_DETAIL_SUBTITLE, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"2,047", FRESHMEN_DETAIL_TITLE, @"Total Accepted", FRESHMEN_DETAIL_SUBTITLE, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"5.8%", FRESHMEN_DETAIL_TITLE, @"Acceptance Rate", FRESHMEN_DETAIL_SUBTITLE, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"1,659", FRESHMEN_DETAIL_TITLE, @"Total Enrolled", FRESHMEN_DETAIL_SUBTITLE, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"24%", FRESHMEN_DETAIL_TITLE, @"Early Decision", FRESHMEN_DETAIL_SUBTITLE, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"16%", FRESHMEN_DETAIL_TITLE, @"From Waiting List", FRESHMEN_DETAIL_SUBTITLE, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"86%", FRESHMEN_DETAIL_TITLE, @"From Out Of State", FRESHMEN_DETAIL_SUBTITLE, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"67%", FRESHMEN_DETAIL_TITLE, @"From Public High School", FRESHMEN_DETAIL_SUBTITLE, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"$41,555", FRESHMEN_DETAIL_TITLE, @"Average Financial Aid", FRESHMEN_DETAIL_SUBTITLE, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"89%", FRESHMEN_DETAIL_TITLE, @"Receiving Financial Aid", FRESHMEN_DETAIL_SUBTITLE, nil], nil];
    

    NSArray *locationDetails = [NSArray arrayWithObjects:
                                [NSDictionary dictionaryWithObjectsAndKeys:@"42.3744", COLLEGE_LATITUDE, @"-71.1169", COLLEGE_LONGITUDE, @"Harvard University", COLLEGE_NAME, nil],
                                [NSDictionary dictionaryWithObjectsAndKeys:@"Cambridge, MA", COLLEGE_LOCATION_NAME, nil], nil];
    
    
    
    NSMutableArray *prominentAlumniArray = [NSMutableArray arrayWithArray:ProminentAlumniArray];
    NSMutableArray *similarSchoolsArray = [NSMutableArray arrayWithArray:SimilarSchoolsArray];
    NSMutableArray *linksAndAddressesArray = [NSMutableArray arrayWithArray:LinksAndAddressesArray];
    NSMutableArray *intendedStudyArray = [NSMutableArray arrayWithArray:IntendedStudyArray];
    
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Location",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE, locationDetails,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:LOCATION_DETAILS];
    
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Similar Schools",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,similarSchoolsArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID,[NSNumber numberWithBool:NO],KEY_SEEMORE, [NSNumber numberWithBool:NO],KEY_SEEMORE_PRESENT, nil] forKey:SIMILAR_SCHOOLS_DETAILS];
    
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Test Scores & Grades",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:TEST_SCORES_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Freshman Profile",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,freshmenDetailsArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:FRESHMAN_PROFILE_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Admissions",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:ADMISSIONS_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Calendar",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:CALENDAR_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Intended Study",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,intendedStudyArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:INTENDED_STUDY_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Fees & Financial Aid",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:FEES_FINANCIAL_AID_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Sports",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:SPORTS_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Weather",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:WEATHER_DETAILS];
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"College Rankings",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,nil,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:COLLEGE_RANKINGS_DETAILS];
    
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Prominent Alumni",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,prominentAlumniArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, [NSNumber numberWithBool:NO],KEY_SEEMORE, [NSNumber numberWithBool:NO],KEY_SEEMORE_PRESENT, nil] forKey:PROMINENT_ALUMNI_DETAILS];
    
    [dataSourceDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Links & Addresses",KEY_LABEL,@"cellIcon.png",KEY_ICON,@"",KEY_VALUE,linksAndAddressesArray,KEY_VALUES_ARRAY,[NSNumber numberWithBool:NO],KEY_EXPAND,[NSNumber numberWithBool:YES],KEY_VALID, nil] forKey:LINKS_ADDRESSES_DETAILS];
    
    
    return dataSourceDict;
}

- (void)setupHeaderView {
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, headerHeight)];
    [headerView setBackgroundColor:[UIColor darkGrayColor]];
    
    UIImageView *backgroundImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, DEFAULT_HEADER_VIEW_HEIGHT)];
    backgroundImageview.image = [UIImage imageNamed:@"collegeImage.jpg"];
    [backgroundImageview setContentMode:UIViewContentModeScaleToFill];
    backgroundImageview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [headerView addSubview:backgroundImageview];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-BLUR_VIEW_HEIGHT/2, headerView.frame.size.width, 2)];
    lineView.backgroundColor = [UIColor blackColor];
   // [headerView addSubview:lineView];
    
    UIView *blurView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-BLUR_VIEW_HEIGHT, headerView.frame.size.width, BLUR_VIEW_HEIGHT)];
    blurView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    blurView.tag = 100;
    [headerView addSubview:blurView];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    //[blurView addGestureRecognizer:panRecognizer];
    
    backgroundImageview.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *imageSwipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    imageSwipe.minimumNumberOfTouches = 1;
    imageSwipe.maximumNumberOfTouches = 1;
    //[backgroundImageview addGestureRecognizer:imageSwipe];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.minimumPressDuration = 0.5; //seconds
    [headerView addGestureRecognizer:longPressGesture];
    
    
    self.tableView.tableHeaderView = headerView;
}

- (void)hideORShowBlurViewWithAnimation:(BOOL)animation {
    
    UIView *blurView = [self.tableView.tableHeaderView viewWithTag:100];
    
    if(animation) {
        
        if(blurView.hidden) {
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 
                                 blurView.hidden = NO;
                                 CGRect newBlurViewFrame = blurView.frame;
                                 
                                 newBlurViewFrame.origin.y -= BLUR_VIEW_HEIGHT;
                                 newBlurViewFrame.size.height += BLUR_VIEW_HEIGHT;
                                 blurView.frame = newBlurViewFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 
                             }];
            
        } else {
            
            [UIView animateWithDuration:0.3
                             animations:^{
                                 
                                 CGRect newBlurViewFrame = blurView.frame;
                                 
                                 newBlurViewFrame.origin.y += BLUR_VIEW_HEIGHT;
                                 newBlurViewFrame.size.height -= BLUR_VIEW_HEIGHT;
                                 blurView.frame = newBlurViewFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 blurView.hidden = YES;
                             }];
            
        }
    } else {
        
        if(blurView.hidden) {
            
            blurView.hidden = NO;
            CGRect newBlurViewFrame = blurView.frame;
            
            newBlurViewFrame.origin.y -= BLUR_VIEW_HEIGHT;
            newBlurViewFrame.size.height += BLUR_VIEW_HEIGHT;
            blurView.frame = newBlurViewFrame;
        }
    }
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self hideORShowBlurViewWithAnimation:YES];
    }

    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
     CGPoint offset = scrollView.contentOffset;
    
    if(offset.y > DEFAULT_HEADER_VIEW_HEIGHT) {
        
        [self hideORShowBlurViewWithAnimation:NO];
    }
}

- (void)setupFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, TABLEVIEW_FOOTER_HEIGHT)];
    footerView.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
    cellIcon.image = [UIImage imageNamed:@"cellIcon.png"];
    
    UILabel *celltitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, self.tableView.frame.size.width-70, 30)];
    celltitle.backgroundColor = [UIColor clearColor];
    celltitle.text = @"Back to Top";
    celltitle.textColor = [UIColor whiteColor];
    
    UIButton *backToTopClick = [UIButton buttonWithType:UIButtonTypeCustom];
    backToTopClick.frame = footerView.frame;
    backToTopClick.backgroundColor = [UIColor clearColor];
    [backToTopClick setTitle:@"" forState:UIControlStateNormal];
    [backToTopClick addTarget:self action:@selector(backToTopAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:cellIcon];
    [footerView addSubview:celltitle];
    [footerView addSubview:backToTopClick];
    
    self.tableView.tableFooterView = footerView;
}

- (void)backToTopAction {
    
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint bottomOffset = CGPointMake(0, 0);
        [self.tableView setContentOffset:bottomOffset animated:YES];
    }];
}



- (void)swipe:(UIPanGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        CGPoint translation = [gesture translationInView:gesture.view.superview];
        
        NSLog(@"gesture ended :%f", translation.y);
        
        UIView *blurView = [headerView viewWithTag:100];
        
        if(translation.y > 0) {
            
            if(blurView.hidden) {
                
                NSLog(@"no more down");
                
                [self.tableView becomeFirstResponder];
                
            } else {
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     CGRect newBlurViewFrame = blurView.frame;
                                     
                                     newBlurViewFrame.origin.y += BLUR_VIEW_HEIGHT;
                                     newBlurViewFrame.size.height -= BLUR_VIEW_HEIGHT;
                                     blurView.frame = newBlurViewFrame;
                                     
                                 } completion:^(BOOL finished) {
                                     
                                     UIView *blurView = [headerView viewWithTag:100];
                                     blurView.hidden = YES;
                                 }];
                
            }

            
        } else {
            
            if(blurView.hidden) {
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     
                                     blurView.hidden = NO;
                                     CGRect newBlurViewFrame = blurView.frame;
                                     
                                     newBlurViewFrame.origin.y -= BLUR_VIEW_HEIGHT;
                                     newBlurViewFrame.size.height += BLUR_VIEW_HEIGHT;
                                     blurView.frame = newBlurViewFrame;
                                     
                                 } completion:^(BOOL finished) {
                                     
                                 }];
            } else {
                
                NSLog(@"no more up");
                
                [UIView animateWithDuration:0.5 animations:^{
                    CGPoint bottomOffset = CGPointMake(0, self.view.frame.size.height/2);
                    [self.tableView setContentOffset:bottomOffset animated:YES];
                    

                }];
            }
        }
        
        
        
       /* if(translation.y > 0) {
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 
                                 UIView *blurView = [headerView viewWithTag:100];
                                 CGRect newBlurViewFrame = blurView.frame;
                                 
                                 newBlurViewFrame.origin.y += BLUR_VIEW_HEIGHT;
                                 newBlurViewFrame.size.height -= BLUR_VIEW_HEIGHT;
                                 blurView.frame = newBlurViewFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 UIView *blurView = [headerView viewWithTag:100];
                                 blurView.hidden = YES;
                             }];
        } else {
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 
                                 UIView *blurView = [headerView viewWithTag:100];
                                 blurView.hidden = NO;
                                 CGRect newBlurViewFrame = blurView.frame;
                                 
                                 newBlurViewFrame.origin.y -= BLUR_VIEW_HEIGHT;
                                 newBlurViewFrame.size.height += BLUR_VIEW_HEIGHT;
                                 blurView.frame = newBlurViewFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
        } */
    
    }
    
}


- (void)move:(UIPanGestureRecognizer *)gesture {
    

    if(gesture.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"gesture begain");
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:gesture.view.superview];
        
       /* if(translation.y > 0) {
            
            
            if(headerHeight < DEFAULT_HEADER_VIEW_HEIGHT + BLUR_VIEW_HEIGHT) {
                
                headerHeight = DEFAULT_HEADER_VIEW_HEIGHT;
                headerHeight += translation.y;

                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     CGRect newHeaderViewFrame = headerView.frame;
                                     newHeaderViewFrame.size.height = headerHeight;
                                     
                                     headerView.frame = newHeaderViewFrame;
                                     
                                     UIView *blurView = [headerView viewWithTag:100];
                                     CGRect newBlurViewFrame = blurView.frame;
                                     
                                     newBlurViewFrame.origin.y = headerView.frame.size.height-BLUR_VIEW_HEIGHT;
                                     blurView.frame = newBlurViewFrame;
                                     
                                     [self.tableView beginUpdates];
                                     self.tableView.tableHeaderView = headerView;
                                     [self.tableView endUpdates];
                                 }];
            } else {
                // headerHeight -= translation.y;
            }
        } else if(translation.y < 0) {
            
            
            
            if(headerHeight > DEFAULT_HEADER_VIEW_HEIGHT) {
                
                headerHeight += translation.y;
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     CGRect newHeaderViewFrame = headerView.frame;
                                     newHeaderViewFrame.size.height = headerHeight;
                                     
                                     headerView.frame = newHeaderViewFrame;
                                     
                                     UIView *blurView = [headerView viewWithTag:100];
                                     CGRect newBlurViewFrame = blurView.frame;
                                     
                                     newBlurViewFrame.origin.y = headerView.frame.size.height-BLUR_VIEW_HEIGHT;
                                     blurView.frame = newBlurViewFrame;
                                     
                                     [self.tableView beginUpdates];
                                     self.tableView.tableHeaderView = headerView;
                                     [self.tableView endUpdates];
                                 }];
            } else {
               // headerHeight -= translation.y;
            }
        } */
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"gesture ended");
        
        CGPoint translation = [gesture translationInView:gesture.view.superview];
        
       // NSLog(@"gesture state changed y:%f and h:%f", translation.y, headerHeight);
       
        /*
        if(translation.y > 0) {
            
            if(headerHeight < DEFAULT_HEADER_VIEW_HEIGHT + BLUR_VIEW_HEIGHT) {
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     CGRect newHeaderViewFrame = headerView.frame;
                                     newHeaderViewFrame.size.height = DEFAULT_HEADER_VIEW_HEIGHT+BLUR_VIEW_HEIGHT;
                                     
                                     headerView.frame = newHeaderViewFrame;
                                     
                                     UIView *blurView = [headerView viewWithTag:100];
                                     CGRect newBlurViewFrame = blurView.frame;
                                     
                                     newBlurViewFrame.origin.y = headerView.frame.size.height-BLUR_VIEW_HEIGHT;
                                     blurView.frame = newBlurViewFrame;
                                     
                                     [self.tableView beginUpdates];
                                     self.tableView.tableHeaderView = headerView;
                                     [self.tableView endUpdates];
                                 }];
            } else {
                headerHeight -= translation.y;
            }
        } else if(translation.y < 0) {
            
            if(headerHeight > DEFAULT_HEADER_VIEW_HEIGHT) {
                
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     
                                     CGRect newHeaderViewFrame = headerView.frame;
                                     newHeaderViewFrame.size.height = DEFAULT_HEADER_VIEW_HEIGHT;
                                     
                                     headerView.frame = newHeaderViewFrame;
                                     
                                     UIView *blurView = [headerView viewWithTag:100];
                                     CGRect newBlurViewFrame = blurView.frame;
                                     
                                     newBlurViewFrame.origin.y = headerView.frame.size.height-BLUR_VIEW_HEIGHT;
                                     blurView.frame = newBlurViewFrame;
                                     
                                     [self.tableView beginUpdates];
                                     self.tableView.tableHeaderView = headerView;
                                     [self.tableView endUpdates];
                                 }];
            } else {
                headerHeight -= translation.y;
            }
        }
        */
        
       /* float halfPoint = DEFAULT_HEADER_VIEW_HEIGHT-BLUR_VIEW_HEIGHT/2;
        
        UIView *blurView = [headerView viewWithTag:100];

        if(blurView.frame.origin.y > halfPoint) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                headerHeight = DEFAULT_HEADER_VIEW_HEIGHT + BLUR_VIEW_HEIGHT;
                
                CGRect newHeaderViewFrame = headerView.frame;
                newHeaderViewFrame.size.height = headerHeight;
                
                headerView.frame = newHeaderViewFrame;
                
                UIView *blurView = [headerView viewWithTag:100];
                CGRect newBlurViewFrame = blurView.frame;
                newBlurViewFrame.origin.y = headerView.frame.size.height-BLUR_VIEW_HEIGHT;
                
                blurView.frame = newBlurViewFrame;
                
                [self.tableView beginUpdates];
                self.tableView.tableHeaderView = headerView;
                [self.tableView endUpdates];
            }];
        } else {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                headerHeight = DEFAULT_HEADER_VIEW_HEIGHT;
                
                CGRect newHeaderViewFrame = headerView.frame;
                newHeaderViewFrame.size.height = headerHeight;
                
                headerView.frame = newHeaderViewFrame;
                
                UIView *blurView = [headerView viewWithTag:100];
                CGRect newBlurViewFrame = blurView.frame;
                newBlurViewFrame.origin.y = headerView.frame.size.height-BLUR_VIEW_HEIGHT;
                
                blurView.frame = newBlurViewFrame;
                
                [self.tableView beginUpdates];
                self.tableView.tableHeaderView = headerView;
                [self.tableView endUpdates];
                
            }];
        } */
        
        if(translation.y >= BLUR_VIEW_HEIGHT/2) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                CGRect newHeaderViewFrame = headerView.frame;
                newHeaderViewFrame.size.height = DEFAULT_HEADER_VIEW_HEIGHT+BLUR_VIEW_HEIGHT;
                
                headerView.frame = newHeaderViewFrame;
                
                UIView *blurView = [headerView viewWithTag:100];
                CGRect newBlurViewFrame = blurView.frame;
                newBlurViewFrame.origin.y = headerView.frame.size.height-BLUR_VIEW_HEIGHT;
                
                blurView.frame = newBlurViewFrame;
                
                //[self.tableView beginUpdates];
                self.tableView.tableHeaderView = headerView;
                //[self.tableView endUpdates];
                
                [self.view layoutIfNeeded];
            }];
        } else {
            
            
            [UIView animateWithDuration:0.5 animations:^{
                
                CGRect newHeaderViewFrame = headerView.frame;
                newHeaderViewFrame.size.height = DEFAULT_HEADER_VIEW_HEIGHT;
                
                headerView.frame = newHeaderViewFrame;
                
                UIView *blurView = [headerView viewWithTag:100];
                CGRect newBlurViewFrame = blurView.frame;
                newBlurViewFrame.origin.y = headerView.frame.size.height-BLUR_VIEW_HEIGHT;
                
                blurView.frame = newBlurViewFrame;
                
                [self.tableView beginUpdates];
                self.tableView.tableHeaderView = headerView;
                [self.tableView endUpdates];

            }];
        }
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [orderedSectionList count];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:section]];
    
    NSString *sectionTitle =  [sectionDetailDict objectForKey:KEY_LABEL];
    BOOL isExpanded = [[sectionDetailDict objectForKey:KEY_EXPAND] boolValue];
    
    if([sectionTitle isEqualToString:@"Similar Schools"]) {
        
        if(isExpanded) {
            
            NSMutableArray *totalNumberOfRows = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
            BOOL isSeeMore = [[sectionDetailDict objectForKey:KEY_SEEMORE] boolValue];
            BOOL isSeeMorePresent = [[sectionDetailDict objectForKey:KEY_SEEMORE_PRESENT] boolValue];
            
            if(isSeeMore) {
                return 6;
            } else if (isSeeMorePresent) {
                return totalNumberOfRows.count + 1;
            } else {
                return totalNumberOfRows.count;
            }
        }
        else {
            return 0;
        }
    } else if([sectionTitle isEqualToString:@"Prominent Alumni"]) {
        
        if(isExpanded) {
            
            NSMutableArray *totalNumberOfRows = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
            BOOL isSeeMore = [[sectionDetailDict objectForKey:KEY_SEEMORE] boolValue];
            BOOL isSeeMorePresent = [[sectionDetailDict objectForKey:KEY_SEEMORE_PRESENT] boolValue];
            
            if(isSeeMore) {
                return 6;
            } else if (isSeeMorePresent) {
                return totalNumberOfRows.count + 1;
            } else {
                return totalNumberOfRows.count;
            }
            
        }
        else {
            return 0;
        }
    } else if ([sectionTitle isEqualToString:@"Links & Addresses"]) {
      
        if(isExpanded) {
            
            NSMutableArray *totalNumberOfRows = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
            
            return totalNumberOfRows.count;
            
        } else {
            return 0;
        }
        
    } else if ([sectionTitle isEqualToString:@"Intended Study"]) {
        
        if(isExpanded) {
            
            NSMutableArray *totalNumberOfRows = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
            
            return totalNumberOfRows.count;
            
        } else {
            return 0;
        }
    } else if([sectionTitle isEqualToString:@"Freshman Profile"]) {
        
        if(isExpanded) {
            
            NSInteger freshmenDetailsCount = [[sectionDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            float noOfRows = (float)freshmenDetailsCount/2;
            NSInteger freshmenDetailsRowCount = ceilf(noOfRows);
            
            
            NSInteger totalNumberOfRows = 5+freshmenDetailsRowCount;
            
            return totalNumberOfRows;
            
        } else {
            return 0;
        }
    } else if([sectionTitle isEqualToString:@"Location"]) {
        
        if(isExpanded) {
            
            NSMutableArray *totalNumberOfRows = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
            
            return totalNumberOfRows.count;
            
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:indexPath.section]];
    
    NSString *sectionTitle =  [sectionDetailDict objectForKey:KEY_LABEL];
    
    if([sectionTitle isEqualToString:@"Links & Addresses"]) {
        
        if(indexPath.row == 8) {
            return ADDRESS_ROW_HEIGHT;
        }
    } else if([sectionTitle isEqualToString:@"Intended Study"]) {
        
        if(indexPath.row == 0) {
            return PIE_CHART_ROW_HEIGHT;
        } else if(indexPath.row == 1) {
            return INTENDED_STUDY_CELL_1;
        }
    }  else if([sectionTitle isEqualToString:@"Freshman Profile"]) {
        
        NSInteger freshmenDetailsCount = [[sectionDetailDict objectForKey:KEY_VALUES_ARRAY] count];
        float noOfRows = (float)freshmenDetailsCount/2;
        NSInteger freshmenDetailsRowCount = ceilf(noOfRows);
        freshmenDetailsRowCount--;
        
        if (indexPath.row == freshmenDetailsRowCount+1 || indexPath.row == freshmenDetailsRowCount+3) {
            return 120;
        } else if (indexPath.row == freshmenDetailsRowCount+2 || indexPath.row == freshmenDetailsRowCount+4) {
            return 200;
        }
    } else if([sectionTitle isEqualToString:@"Location"]) {
        
        if(indexPath.row == 0) {
            return 200;
        }
    }
    
    return ROW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  SECTION_HEADER_HEIGHT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    
    NSDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:section]];
    
    BOOL isExpanded = [[sectionDetailDict objectForKey:KEY_EXPAND] boolValue];

    if(isExpanded) {
        return 20.0f;
    }
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20.0f)];
    footerView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    
    return footerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"sectionHeaderView"];
    sectionHeaderView.contentView.backgroundColor = [UIColor lightGrayColor];
    
    NSDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:section]];
    
    BOOL isExpanded = [[sectionDetailDict objectForKey:KEY_EXPAND] boolValue];
    
    sectionHeaderView.ibSectionHeaderName.text = [sectionDetailDict objectForKey:KEY_LABEL];
    sectionHeaderView.ibSectionHeaderIcon.image = [UIImage imageNamed:[sectionDetailDict objectForKey:KEY_ICON]];
    
    if(isExpanded) {
        sectionHeaderView.ibSectionHeaderArrow.image = [UIImage imageNamed:UP_ARROW];
    } else {
        sectionHeaderView.ibSectionHeaderArrow.image = [UIImage imageNamed:DOWN_ARROW];
    }

    
    [sectionHeaderView.ibTapButton setTitle:@"" forState:UIControlStateNormal];
    sectionHeaderView.ibTapButton.tag = section;
    sectionHeaderView.clickActionBlock = ^(NSInteger tag){
        [self sectionTap:tag];
    };
    
    return sectionHeaderView;
}

- (void)sectionTap:(NSInteger)section {
    
    
    UIView *sectionHeaderView = [self.tableView headerViewForSection:section];
    
    UIImageView *sectionArrowImage = (UIImageView *)[sectionHeaderView viewWithTag:1000];
    
    
    NSLog(@" section is:%ld", (long)section);
    
    NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:section]];
    
    NSString *sectionTitle =  [sectionDetailDict objectForKey:KEY_LABEL];
    
    if([sectionTitle isEqualToString:@"Similar Schools"] || [sectionTitle isEqualToString:@"Prominent Alumni"]) {
        
        BOOL isExpanded = [[sectionDetailDict objectForKey:KEY_EXPAND] boolValue];
        [sectionDetailDict setObject:[NSNumber numberWithBool:!isExpanded] forKey:KEY_EXPAND];
        
        if(!isExpanded) {
            
            NSInteger totalNumberOfRows = [[sectionDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            
            NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
            
            BOOL isSeeMore = [[sectionDetailDict objectForKey:KEY_SEEMORE] boolValue];
            BOOL isSeeMorePresent = [[sectionDetailDict objectForKey:KEY_SEEMORE_PRESENT] boolValue];
            
            NSInteger rowCount;
            
            if(totalNumberOfRows > 5) {
               
                [sectionDetailDict setObject:[NSNumber numberWithBool:!isSeeMore] forKey:KEY_SEEMORE];
                [sectionDetailDict setObject:[NSNumber numberWithBool:!isSeeMorePresent] forKey:KEY_SEEMORE_PRESENT];
                rowCount = 6;
            } else {
                rowCount = totalNumberOfRows;
            }
            
            
            for (NSInteger i = 0; i < rowCount; i++) {
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
            //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            
            
            sectionArrowImage.image = [UIImage imageNamed:@"arrow-up.png"];
            
            
        } else {
            
            NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
            
            [sectionDetailDict setObject:[NSNumber numberWithBool:false] forKey:KEY_SEEMORE];
            [sectionDetailDict setObject:[NSNumber numberWithBool:false] forKey:KEY_SEEMORE_PRESENT];
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < numberOfRows; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            
            sectionArrowImage.image = [UIImage imageNamed:@"arrow-down.png"];
        }
    } else if ([sectionTitle isEqualToString:@"Links & Addresses"]) {
        
        BOOL isExpanded = [[sectionDetailDict objectForKey:KEY_EXPAND] boolValue];
        [sectionDetailDict setObject:[NSNumber numberWithBool:!isExpanded] forKey:KEY_EXPAND];
        
        if(!isExpanded) {
            
            NSInteger totalNumberOfRows = [[sectionDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            
            NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0; i < totalNumberOfRows; i++) {
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            sectionArrowImage.image = [UIImage imageNamed:@"arrow-up.png"];
            
        } else {
            
            
            NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
            
            BOOL isSeeMore = [[sectionDetailDict objectForKey:KEY_SEEMORE] boolValue];
            [sectionDetailDict setObject:[NSNumber numberWithBool:!isSeeMore] forKey:KEY_SEEMORE];
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < numberOfRows; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            sectionArrowImage.image = [UIImage imageNamed:@"arrow-down.png"];
        }
    } else if ([sectionTitle isEqualToString:@"Intended Study"]) {
        
        BOOL isExpanded = [[sectionDetailDict objectForKey:KEY_EXPAND] boolValue];
        [sectionDetailDict setObject:[NSNumber numberWithBool:!isExpanded] forKey:KEY_EXPAND];
        
        if(!isExpanded) {
            
            NSInteger totalNumberOfRows = [[sectionDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            
            NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0; i < totalNumberOfRows; i++) {
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            sectionArrowImage.image = [UIImage imageNamed:@"arrow-up.png"];
            
        } else {
            
            
            NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
            
            BOOL isSeeMore = [[sectionDetailDict objectForKey:KEY_SEEMORE] boolValue];
            [sectionDetailDict setObject:[NSNumber numberWithBool:!isSeeMore] forKey:KEY_SEEMORE];
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < numberOfRows; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            sectionArrowImage.image = [UIImage imageNamed:@"arrow-down.png"];
        }
    } else if ([sectionTitle isEqualToString:@"Freshman Profile"]) {
        
        BOOL isExpanded = [[sectionDetailDict objectForKey:KEY_EXPAND] boolValue];
        [sectionDetailDict setObject:[NSNumber numberWithBool:!isExpanded] forKey:KEY_EXPAND];
        
        if(!isExpanded) {
            
            NSInteger freshmenDetailsCount = [[sectionDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            float noOfRows = (float)freshmenDetailsCount/2;
            NSInteger freshmenDetailsRowCount = ceilf(noOfRows);

            
            NSInteger totalNumberOfRows = 5+freshmenDetailsRowCount;
            
            NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0; i < totalNumberOfRows; i++) {
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            sectionArrowImage.image = [UIImage imageNamed:@"arrow-up.png"];
            
        } else {
            
            
            NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
            
            BOOL isSeeMore = [[sectionDetailDict objectForKey:KEY_SEEMORE] boolValue];
            [sectionDetailDict setObject:[NSNumber numberWithBool:!isSeeMore] forKey:KEY_SEEMORE];
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < numberOfRows; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            sectionArrowImage.image = [UIImage imageNamed:@"arrow-down.png"];
        }
    } else if ([sectionTitle isEqualToString:@"Location"]) {
        
        BOOL isExpanded = [[sectionDetailDict objectForKey:KEY_EXPAND] boolValue];
        [sectionDetailDict setObject:[NSNumber numberWithBool:!isExpanded] forKey:KEY_EXPAND];
        
        if(!isExpanded) {
            
            NSInteger totalNumberOfRows = [[sectionDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            
            NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0; i < totalNumberOfRows; i++) {
                [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            sectionArrowImage.image = [UIImage imageNamed:@"arrow-up.png"];
            
        } else {
            
            
            NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < numberOfRows; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
            }
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            sectionArrowImage.image = [UIImage imageNamed:@"arrow-down.png"];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    static NSString *seeMoreCellIdentifier = @"SeeMoreCell";
    static NSString *addressCellIdentifier = @"AddressCell";
    static NSString *callAndMessageCellIdentifier = @"CallAndMessageCell";
    static NSString *intendedStudyPieChartCellIdentifier = @"intendedStudyPieChartCell";
    static NSString *intendedStudyDetailsCellIdentifier = @"IntendedStudyDetailsCell";
    static NSString *switchCellIdentifier = @"SwitchCell";
    static NSString *mostRepresentedStatesCellIdentifier = @"MostRepresentedStatesCell";
    static NSString *freshmenGenderCellIdentifier = @"FreshmenGenderCell";
    static NSString *freshmenDetailsCellIdentifier = @"FreshmenDetailsCell";
    
    static NSString *freshmenEthniCityPieChartCellIdentifier = @"freshmenEthniCityPieChartCell";
    static NSString *freshmenReligiousCellIdentifier = @"FreshmenReligiousCell";
    
    static NSString *collegeLocationCellIdentifier = @"STCollegeLocationCell";
    
    
    NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:indexPath.section]];
    
    NSString *sectionTitle =  [sectionDetailDict objectForKey:KEY_LABEL];
    
    UITableViewCell *cell;
    
    
    if([sectionTitle isEqualToString:@"Similar Schools"]) {
        
        NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:indexPath.section]];
        NSArray *array = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];

        BOOL isSeeMore = [[sectionDetailDict objectForKey:KEY_SEEMORE] boolValue];
        
        if(isSeeMore) {
            
            if(indexPath.row == 5) {
                SeeMoreCell *seeMoreCell = [tableView dequeueReusableCellWithIdentifier:seeMoreCellIdentifier];
                
                seeMoreCell.ibTapButton.tag = indexPath.section;
                seeMoreCell.clickActionBlock = ^(NSInteger tag) {
                    [self seeMoreClicked:tag];
                };
                
                cell = seeMoreCell;
                
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                cell.textLabel.text = [array objectAtIndex:indexPath.row];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
        } else {
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    } else if([sectionTitle isEqualToString:@"Prominent Alumni"]) {
        
        NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:indexPath.section]];
        NSArray *array = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
        
        BOOL isSeeMore = [[sectionDetailDict objectForKey:KEY_SEEMORE] boolValue];
        
        if(isSeeMore) {
            
            if(indexPath.row == 5) {
                SeeMoreCell *seeMoreCell = [tableView dequeueReusableCellWithIdentifier:seeMoreCellIdentifier];
                
                seeMoreCell.ibTapButton.tag = indexPath.section;
                seeMoreCell.clickActionBlock = ^(NSInteger tag) {
                    [self seeMoreClicked:tag];
                };
                
                cell = seeMoreCell;
                
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                if(cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                
                cell.textLabel.text = [array objectAtIndex:indexPath.row];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
        } else {
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    } else if([sectionTitle isEqualToString:@"Links & Addresses"]) {
    
        NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:indexPath.section]];
        NSArray *array = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
        
        if(indexPath.row == 8) {
            
            AddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
            
            addressCell.cellIcon.image = [UIImage imageNamed:[sectionDetailDict objectForKey:KEY_ICON]];
            addressCell.addressTextview.text = [array objectAtIndex:indexPath.row];
            addressCell.addressTextview.contentInset = UIEdgeInsetsMake(-10, -5, 0, 0);
            
            cell = addressCell;
        } else if (indexPath.row == 9 || indexPath.row == 10) {
            
            CallAndMessageCell *callAndMessageCell = [tableView dequeueReusableCellWithIdentifier:callAndMessageCellIdentifier];
            
            callAndMessageCell.tag = indexPath.section;
            callAndMessageCell.cellIcon.image = [UIImage imageNamed:[sectionDetailDict objectForKey:KEY_ICON]];
            callAndMessageCell.cellTitle.text = [array objectAtIndex:indexPath.row];
            callAndMessageCell.clickButton.tag = indexPath.row;
            callAndMessageCell.clickActionBlock = ^(NSIndexPath *indexPath) {
                [self callAndMessageAction:indexPath];
            };
            cell = callAndMessageCell;
            
        } else {
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.textLabel.text = [array objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    
    } else if ([sectionTitle isEqualToString:@"Intended Study"]) {
        
        NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:indexPath.section]];
        NSArray *array = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
        
        if(indexPath.row == 0) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:intendedStudyPieChartCellIdentifier];
            
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:intendedStudyPieChartCellIdentifier];
                
                STPieChartView *pieChartView = [[STPieChartView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, PIE_CHART_ROW_HEIGHT)];
                pieChartView.delegate = self;
                pieChartView.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:pieChartView];
            }
        } else if (indexPath.row == 1) {
            
            STIntendedStudyDetailsCell *studyDetailsCell = [tableView dequeueReusableCellWithIdentifier:intendedStudyDetailsCellIdentifier];
            
            cell = studyDetailsCell;
        } else {
            
            STSwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:switchCellIdentifier];
            switchCell.cellLabel.text = [array objectAtIndex:indexPath.row];
            cell = switchCell;
        }
        
    } else if ([sectionTitle isEqualToString:@"Freshman Profile"]) {
        
        NSArray *freshmenDetails = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
        NSInteger freshmenDetailsCount = [freshmenDetails count];
        float noOfRows = (float)freshmenDetailsCount/2;
        NSInteger freshmenDetailsRowCount = ceilf(noOfRows);
        freshmenDetailsRowCount--;
        
        if(indexPath.row == freshmenDetailsRowCount+1) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:freshmenGenderCellIdentifier];
            
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:freshmenGenderCellIdentifier];
                
                STGenderView *genderView = [[STGenderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 120)];
                genderView.backgroundColor = [UIColor whiteColor];
                genderView.malePercentage = 40.0;
                genderView.femalePercentage = 60.0;
                [cell.contentView addSubview:genderView];
            }
        } else if(indexPath.row == freshmenDetailsRowCount+2) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:freshmenEthniCityPieChartCellIdentifier];
            
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:freshmenEthniCityPieChartCellIdentifier];
                
                STPieChartView *pieChartView = [[STPieChartView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, PIE_CHART_ROW_HEIGHT)];
                pieChartView.delegate = self;
                pieChartView.tag = TAG_GEOGRAPHICS;
                pieChartView.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:pieChartView];
            }
        } else if (indexPath.row == freshmenDetailsRowCount+3) {
            
            MostRepresentedStatesCell *mostRepresentedStatesCell = [tableView dequeueReusableCellWithIdentifier:mostRepresentedStatesCellIdentifier];
            
            cell = mostRepresentedStatesCell;
            
        } else if(indexPath.row == freshmenDetailsRowCount+4) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:freshmenEthniCityPieChartCellIdentifier];
            
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:freshmenEthniCityPieChartCellIdentifier];
                
                STPieChartView *pieChartView = [[STPieChartView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, PIE_CHART_ROW_HEIGHT)];
                pieChartView.delegate = self;
                pieChartView.tag = TAG_ETHNICITY;
                pieChartView.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:pieChartView];
            }
        } else if (indexPath.row == freshmenDetailsRowCount+5) {
            
            FreshmenReligiousCell *freshmenReligiousCell = [tableView dequeueReusableCellWithIdentifier:freshmenReligiousCellIdentifier];
            
            cell = freshmenReligiousCell;
            
        } else {
            
            FreshmenDetailsCell *detailCell = [tableView dequeueReusableCellWithIdentifier:freshmenDetailsCellIdentifier];
            
            NSInteger freshmenDetailsCount = [[sectionDetailDict objectForKey:KEY_VALUES_ARRAY] count];
            
            NSInteger rowNumber = indexPath.row*2;
            
            NSDictionary *detailDict = [freshmenDetails objectAtIndex:rowNumber];
            detailCell.ibTitleLabel1.text = [detailDict objectForKey:FRESHMEN_DETAIL_TITLE];
            detailCell.ibSubTitleLabel1.text = [detailDict objectForKey:FRESHMEN_DETAIL_SUBTITLE];
            
            rowNumber++;
            if(rowNumber < freshmenDetailsCount) {
                detailDict = [freshmenDetails objectAtIndex:rowNumber];
                detailCell.ibTitleLabel2.text = [detailDict objectForKey:FRESHMEN_DETAIL_TITLE];
                detailCell.ibSubTitleLabel2.text = [detailDict objectForKey:FRESHMEN_DETAIL_SUBTITLE];
            } else {
                detailCell.ibTitleLabel2.text = @"";
                detailCell.ibSubTitleLabel2.text = @"";
            }
            
            
            cell = detailCell;
            
        }
    } else if ([sectionTitle isEqualToString:@"Location"]) {
        
        NSArray *locationDetails = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
        NSDictionary *locationDict = [locationDetails objectAtIndex:indexPath.row];
        
        if(indexPath.row == 0) {
            
            STCollegeLocationCell *locationCell = [tableView dequeueReusableCellWithIdentifier:collegeLocationCellIdentifier];
            
            [locationCell updateMapWithLatitude:[[locationDict objectForKey:COLLEGE_LATITUDE] doubleValue] andLongitude:[[locationDict objectForKey:COLLEGE_LONGITUDE] doubleValue] andPlaceName:[locationDict objectForKey:COLLEGE_NAME]];
            
            locationCell.mapClickAction = ^{
                [self mapClickAction];
            };
            cell = locationCell;
        } else {
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if(cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            
            cell.textLabel.text = [NSString stringWithFormat:@"More about %@", [locationDict objectForKey:COLLEGE_LOCATION_NAME]];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }

        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"cell clicked");
}

- (void)mapClickAction {
   
    NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:LOCATION_DETAILS];
    NSArray *locationDetails = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
    NSDictionary *locationDict = [locationDetails objectAtIndex:0];
    
    STLocationViewController *locationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationViewController"];
    locationViewController.locationDetails = locationDict;
    
    [self.navigationController pushViewController:locationViewController animated:YES];
    
}

- (void)callAndMessageAction:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:indexPath.section]];
    NSArray *array = [sectionDetailDict objectForKey:KEY_VALUES_ARRAY];
    
    if(indexPath.row == 9) {
        NSLog(@"call to :%@", [array objectAtIndex:indexPath.row]);
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [array objectAtIndex:indexPath.row]]]]) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [array objectAtIndex:indexPath.row]]]];
            
        } else {
             NSLog(@"can't call");
        }
        
    } else if(indexPath.row == 10) {
        NSLog(@"message to %@", [array objectAtIndex:indexPath.row]);
        
        NSString *emailTitle = @"New Message";
        NSArray *toRecipents = [NSArray arrayWithObject:[array objectAtIndex:indexPath.row]];
        
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        [mailComposeVC setSubject:emailTitle];
        [mailComposeVC setToRecipients:toRecipents];
        
        [self presentViewController:mailComposeVC animated:YES completion:nil];
    }
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Email Cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Email Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Email Sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Email Failed");
            break;
        default:
            NSLog(@"Email Not Sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - See more action

- (void)seeMoreClicked:(NSInteger)section {
    
    NSMutableDictionary *sectionDetailDict = [collegeDataSourceDictionary objectForKey:[orderedSectionList objectAtIndex:section]];
    
    NSString *sectionTitle =  [sectionDetailDict objectForKey:KEY_LABEL];
    
    if([sectionTitle isEqualToString:@"Similar Schools"]) {
        
        NSInteger totalNumberOfRows = [[sectionDetailDict objectForKey:KEY_VALUES_ARRAY] count];
        BOOL isSeeMore = [[sectionDetailDict objectForKey:KEY_SEEMORE] boolValue];
        [sectionDetailDict setObject:[NSNumber numberWithBool:!isSeeMore] forKey:KEY_SEEMORE];
        
        BOOL isSeeMorePresent = [[sectionDetailDict objectForKey:KEY_SEEMORE_PRESENT] boolValue];
        
        NSInteger rowsInSection = [self.tableView numberOfRowsInSection:section]-1;
        NSInteger rowCount;
        
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        rowCount = totalNumberOfRows - rowsInSection;
        
        
        for (NSInteger i = 0; i < rowCount; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:rowsInSection+i inSection:section]];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
               
        if(isSeeMorePresent) {
            
            [sectionDetailDict setObject:[NSNumber numberWithBool:false] forKey:KEY_SEEMORE];
            [sectionDetailDict setObject:[NSNumber numberWithBool:false] forKey:KEY_SEEMORE_PRESENT];

             NSInteger updatedRows = [self.tableView numberOfRowsInSection:section];
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:updatedRows-1 inSection:section]];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
       
        
    } else if([sectionTitle isEqualToString:@"Prominent Alumni"]) {
        NSLog(@"Prominent Alumni see more");
        
        NSInteger totalNumberOfRows = [[sectionDetailDict objectForKey:KEY_VALUES_ARRAY] count];
        BOOL isSeeMore = [[sectionDetailDict objectForKey:KEY_SEEMORE] boolValue];
        [sectionDetailDict setObject:[NSNumber numberWithBool:!isSeeMore] forKey:KEY_SEEMORE];
        
        BOOL isSeeMorePresent = [[sectionDetailDict objectForKey:KEY_SEEMORE_PRESENT] boolValue];
        
        NSInteger rowsInSection = [self.tableView numberOfRowsInSection:section]-1;
        NSInteger rowCount;
        
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        rowCount = totalNumberOfRows - rowsInSection;
        
        for (NSInteger i = 0; i < rowCount; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:rowsInSection+i inSection:section]];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        
        if(isSeeMorePresent) {
            
            [sectionDetailDict setObject:[NSNumber numberWithBool:false] forKey:KEY_SEEMORE];
            [sectionDetailDict setObject:[NSNumber numberWithBool:false] forKey:KEY_SEEMORE_PRESENT];
            
            NSInteger updatedRows = [self.tableView numberOfRowsInSection:section];
            
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:updatedRows-1 inSection:section]];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            
        }

    }
    
}


//PIE CHART DATASOURCES
#pragma mark - Pie chart DataSources

- (NSUInteger)numberOfSlicesInPieChart:(STPieChartView *)pieChart {
    
    if(pieChart.tag == TAG_GEOGRAPHICS) {
        
        NSDictionary *geographicDict = [pieChartsDataSourceDictionary objectForKey:GEOGRAPHICS_DETAILS];
        NSInteger sliceCount = [[geographicDict objectForKey:KEY_PERCENTAGE_ARRAY] count];
        
        return sliceCount;
    }
    
    return [sliceArray count];
}

- (CGFloat)pieChart:(STPieChartView *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    
    if(pieChart.tag == TAG_GEOGRAPHICS) {
        
        NSDictionary *geographicDict = [pieChartsDataSourceDictionary objectForKey:GEOGRAPHICS_DETAILS];
        NSArray *slicePercentageArray = [geographicDict objectForKey:KEY_PERCENTAGE_ARRAY];
        
        return [[slicePercentageArray objectAtIndex:index] floatValue];
    } else if (pieChart.tag == TAG_ETHNICITY) {
        
        NSDictionary *ethnicityDict = [pieChartsDataSourceDictionary objectForKey:ETHNICITY_DETAILS];
        NSArray *slicePercentageArray = [ethnicityDict objectForKey:KEY_PERCENTAGE_ARRAY];
        
        return [[slicePercentageArray objectAtIndex:index] floatValue];
    }
    
    return [[sliceArray objectAtIndex:index] floatValue];
}

- (UIColor *)pieChart:(STPieChartView *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    
    return [colorsArray objectAtIndex:index];
}

- (NSUInteger)numberOfDescriptionsInPieChart:(STPieChartView *)pieChart {
    
    if(pieChart.tag == TAG_GEOGRAPHICS) {
        
        NSDictionary *geographicDict = [pieChartsDataSourceDictionary objectForKey:GEOGRAPHICS_DETAILS];
        NSInteger sliceCount = [[geographicDict objectForKey:KEY_PERCENTAGE_ARRAY] count];
        
        return sliceCount;
    } else if(pieChart.tag == TAG_ETHNICITY) {
        
        NSDictionary *ethnicityDict = [pieChartsDataSourceDictionary objectForKey:ETHNICITY_DETAILS];
        NSInteger sliceCount = [[ethnicityDict objectForKey:KEY_PERCENTAGE_ARRAY] count];
        
        return sliceCount;
    }
    
    return [sliceArray count];
}

- (NSString *)pieChart:(STPieChartView *)pieChart valueForDescriptionAtIndex:(NSUInteger)index {
    
    if(pieChart.tag == TAG_GEOGRAPHICS) {
        
        NSDictionary *geographicDict = [pieChartsDataSourceDictionary objectForKey:GEOGRAPHICS_DETAILS];
        NSArray *slicePercentageArray = [geographicDict objectForKey:KEY_PERCENTAGE_ARRAY];
        NSArray *sliceTextArray = [geographicDict objectForKey:KEY_TEXT_ARRAY];
        
        return [NSString stringWithFormat:@"%@ - %.0f%%", [sliceTextArray objectAtIndex:index], [[slicePercentageArray objectAtIndex:index] floatValue]];
    } else if(pieChart.tag == TAG_ETHNICITY) {
        
        NSDictionary *ethnicityDict = [pieChartsDataSourceDictionary objectForKey:ETHNICITY_DETAILS];
        NSArray *slicePercentageArray = [ethnicityDict objectForKey:KEY_PERCENTAGE_ARRAY];
        NSArray *sliceTextArray = [ethnicityDict objectForKey:KEY_TEXT_ARRAY];
        
        return [NSString stringWithFormat:@"%@ - %.0f%%", [sliceTextArray objectAtIndex:index], [[slicePercentageArray objectAtIndex:index] floatValue]];
    }
    
    return [NSString stringWithFormat:@"1900 - 1600  %.0f%%",[[sliceArray objectAtIndex:index] floatValue]];
}

- (UIColor *)pieChart:(STPieChartView *)pieChart colorForDescriptionBulletAtIndex:(NSUInteger)index {
    
    return [colorsArray objectAtIndex:index];
}

- (NSString *)valueOfTitleText:(STPieChartView *)pieChart {
    
    if(pieChart.tag == TAG_GEOGRAPHICS) {
        
        NSDictionary *geographicDict = [pieChartsDataSourceDictionary objectForKey:GEOGRAPHICS_DETAILS];
        
        
        return [geographicDict objectForKey:KEY_LABEL];
    } else if(pieChart.tag == TAG_ETHNICITY) {
        
        NSDictionary *ethnicityDict = [pieChartsDataSourceDictionary objectForKey:ETHNICITY_DETAILS];
        
        return [ethnicityDict objectForKey:KEY_LABEL];
    }
    
    return @"ETHNICITY";
}

- (UIColor *)colorOfTitleText:(STPieChartView *)pieChart {
    
    return [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
