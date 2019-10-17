//
//  STConstants.h
//  Stipend
//
//  Created by Arun S on 06/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Stipend_STConstants_h
#define Stipend_STConstants_h

//BASE URLS

#define BASE_URL                                    DEVELOPMENT_BASE_URL

// HTTPS Production Base URL
#define PRODUCTION_BASE_URL                         @"https://elb.collegehunch.com:8443/StipendProd/"

// Stipend Development Base URL
#define DEVELOPMENT_BASE_URL                        @"https://sourcepaneltestadmin.com:8443/Stipend/"

//  @"https://ec2-54-149-74-181.us-west-2.compute.amazonaws.com:8443/Stipend/"
//  @"https://sourcepaneltestadmin.com:8443/Stipend/"


// College Logo Base URL

#define COLLEGE_LOGO_BASE_URL                       IMAGES_PRODUCTION_BASE_URL

// Images production Base URL
#define IMAGES_PRODUCTION_BASE_URL                  @"https://elb.collegehunch.com:8443/StipendWeb/"

// Stipend Development Base URL
#define IMAGES_DEVELOPMENT_BASE_URL                 @"https://ec2-54-149-74-181.us-west-2.compute.amazonaws.com:8443/StipendWeb/"

//@"https://ec2-54-149-74-181.us-west-2.compute.amazonaws.com:8443/StipendWeb/"

#define WEATHER_SERVICE_SITE_URL                    @"https://darksky.net/poweredby/"

#define PRIVACY_POLICY_URL                          PRIVACY_POLICY_PRODUCTION_URL
#define TERMS_OF_USE_URL                            TERMS_OF_USE_PRODUCTION_URL

#define PRIVACY_POLICY_PRODUCTION_URL               @"https://www.collegehunch.com/appprivacy.html"
#define TERMS_OF_USE_PRODUCTION_URL                 @"https://www.collegehunch.com/appterms.html"

#define PRIVACY_POLICY_DEVELOPMENT_URL              @"https://sourcepaneltestadmin.com:8443/admin/partials/templates/privacy-test.html"
#define TERMS_OF_USE_DEVELOPMENT_URL                @"https://sourcepaneltestadmin.com:8443/admin/partials/templates/terms-test.html"

// IN-APP PURCHASE PRODUCT IDENTIFIERS
#define FILTER_PRODUCT_IDENTIFIER                   @"com.stipend.collegehunch.filterr"
#define COMPARE_PRODUCT_IDENTIFER                   @"com.stipend.collegehunch.comparee"
#define EXPORT_PRODUCT_IDENTIFIER                   @"com.stipend.collegehunch.exportspreadsheet"
#define EXPORT_NC_PRODUCT_IDENTIFIER                @"com.stipend.collegehunch.export"

// URL SCHEMES
#define FACEBOOK_SCHEME                             @"fb1636930623217536"
#define TWITTER_SCHEME                              @"twitterkit-mh2fn5F5qy9Sr1uHSqdPyO4xs"

// SERVER KEYS

#define kEmailID                                    @"emailId"
#define kPassword                                   @"password"

#define kUserID                                     @"userId"
#define kFirstName                                  @"firstName"
#define kLastName                                   @"lastName"
#define kUserRole                                   @"isAdmin"
#define kGenderType                                 @"genderId"
#define kUserType                                   @"sysusertypeId"
#define kErrorCode                                  @"ErrorCode"
#define kStatus                                     @"Status"

#define kPushNotificationState                      @"PushNotificationState"
#define kUserSortOrder                              @"SortOrder"

#define kFacebookID                                 @"facebookAccount"
#define kTwitterID                                  @"twitterAccount"
#define kOldPassword                                @"oldPassword"

#define kColleges                                   @"Colleges"
#define kCollege                                    @"College"
#define kMajors                                     @"majors"

#define kCollegeSummary                             @"CollegeSummary"
#define kLocation                                   @"Location"
#define kSimilarSchools                             @"SimilarSchools"
#define kTestScoresAndGrades                        @"TestScoresAndGrades"
#define kFreshManProfile                            @"FreshManProfile"
#define kAdmissions                                 @"Admissions"
#define kCalendar                                   @"Calendar"
#define kIntendedStudy                              @"IntendedStudy"
#define kFeesAndFinancialAids                       @"FeesAndFinancialAids"
#define kSports                                     @"Sports"
#define kWeather                                    @"Weather"
#define kPayScaleRankings                           @"PayScaleROIRankings"
#define kProminentAlumini                           @"ProminentAlumini"
#define kLinksAndAddresses                          @"LinksAndAddresses"
#define kQuickFacts                                 @"QuickFacts"

#define kCollegeID                                  @"collegeId"
#define kCollegeName                                @"collegeName"
#define kCollegeTypeID                              @"collegeTypeId"
#define kCollegeAccessTypeID                        @"accessTypeID"
#define kCollegeAreaTypeID                          @"collegeAreaID"
#define kCollegeLogoPath                            @"collegeLogoPath"
#define kCollegeWebSiteURL                          @"collegeWebsiteUrl"
#define kCollegeSteetName                           @"streetName"
#define kCollegeCity                                @"city"
#define kCollegeState                               @"state"
#define kCollegeCountry                             @"country"
#define kCollegeZip                                 @"zip"
#define kCollegeTelephone                           @"telephoneNumber"
#define kCollegeEmailID                             @"officeEmailAddress"
#define kCollegeAppleLattitude                      @"appleLatitude"
#define kCollegeAppleLongitude                      @"appleLongitude"
#define kCollegeGoogleLattitude                     @"collegeLatitude"
#define kCollegeGoogleLongitude                     @"collegeLongitude"
#define kCollegeTotalFreshman                       @"freshmen"
#define kCollegeTotalUndergrads                     @"totalUndergrads"
#define kCollegeAceeptanceRate                      @"acceptance"
#define kCollegeAverageSAT                          @"averageSat"
#define kCollegeAverageACT                          @"averageAct"
#define kCollegeAverageGPA                          @"averageGpa"
#define kCollegeClassSize                           @"classSize"
#define kCollegeLastUpdatedDate                     @"lastUpdated"
#define kCollegeActive                              @"isActive"
#define kCollegeNewAverageSAT                       @"newAverageSat"
#define kCollegeFourYrGraduationRate                @"fourYearGraduationRate"
#define kCollegeSixYrGraduationRate                 @"sixYearGraduationRate"
#define kCollegeOneYrRetentionRate                  @"retentionRate"

#define kShouldUpdateDatabase                       @"updateDatabase"

#define kFavorites                                  @"Favorites"
#define kIsSync                                     @"isSync"
#define kIsUpdate                                   @"isUpdate"
#define kFavoriteList                               @"favorites"
#define kPosition                                   @"position"
#define kCompareList                                @"compareList"
#define kClippings                                  @"clippings"
#define kSections                                   @"sections"
#define kSection                                    @"section"
#define kSectionId                                  @"sectionID"
#define kSectionName                                @"sectionName"
#define kImageName                                  @"imageName"
#define kFilterData                                 @"filterData"
#define kResetState                                 @"resetState"

#define KEY_SECTION_NAME                            @"kCollegeSectionNameKey"
#define KEY_SECTION_ID                              @"kCollegeSectionIDKey"
#define KEY_SECTION_ICON                            @"kCollegeSectionIconKey"

#define kFetchOffset                                @"offSet"
#define kFetchSize                                  @"size"
#define kLastUpdatedDate                            @"date"

//GENERAL CONSTANTS

#define EMAIL_ADDRESS_DETAILS                       @"kEmailAddressDetailsKey"
#define FIRST_NAME_DETAILS                          @"kFirstNameDetailsKey"
#define LAST_NAME_DETAILS                           @"kLastNameDetailsKey"
#define PASSWORD_DETAILS                            @"kPasswordDetailsKey"
#define CONFIRM_PASSWORD_DETAILS                    @"kConfirmPasswordDetailsKey"
#define USER_TYPE_DETAILS                           @"kUserTypeDetailsKey"
#define GENDER_DETAILS                              @"kGenderDetailsKey"

#define MY_DETAILS                                  @"kMyDetailsKey"
#define SORT_COLLEGE_DETAILS                        @"kSortCollegeDetailsKey"
#define ORGANISE_PAGE_DETAILS                       @"kOrgainisePageDetailsKey"
#define PUSH_NOTIFICATION_DETAILS                   @"kPushNotificationDetailsKey"
#define OTHER_DETAILS                               @"kOtherDetailsKey"
#define LOGOUT_DETAILS                              @"kLogoutDetailsKey"
#define MAP_APP_DETAILS                             @"kMapAppDetailsKey"
#define MAP_DETAILS                                 @"kMapDetailsKey"
#define ATTRIBUTION_DETAILS                         @"kAttributionKey"
#define ABOUT_COLLEGEHUNCH_DETAILS                  @"kAboutCollegeHunchKey"
#define TERMS_OF_USE_DETAILS                        @"kTermsOfUseKey"
#define PRIVACY_POLICY_DETAILS                      @"kPrivacyPolicyKey"
#define RATE_THE_APP_DETAILS                        @"kRateTheAppKey"
#define SUPPORT_DETAILS                             @"kSupportKey"

#define USER_TYPE_VIEW_MODE_DETAILS                 @"kUserTypeViewModeDetailsKey"
#define USER_TYPE_EDIT_MODE_DETAILS                 @"kUserTypeEditModeDetailsKey"

#define NEW_PASSWORD_DETAILS                        @"kNewPasswordDetailsKey"
#define OLD_PASSWORD_DETAILS                        @"kOldPasswordDetailsKey"
#define CONFIRM_PASSWORD_DETAILS                    @"kConfirmPasswordDetailsKey"

#define COLLEGE_LATITUDE                            @"kCollegeLatitudeKey"
#define COLLEGE_LONGITUDE                           @"kCollegeLongitudeKey"

#define KEY_LABEL                                   @"kLabelKey"
#define KEY_VALUE                                   @"kValueKey"
#define KEY_VALID                                   @"kValidKey"
#define KEY_ISACTIVE                                @"kIsActiveKey"
#define KEY_EXPAND                                  @"kExpandKey"
#define KEY_VALUES_ARRAY                            @"kValuesArrayKey"

// USER DEFAULTS CONSTANTS

#define USER_ID                                     @"userIDKey"
#define LOGIN_TYPE                                  @"loginTypeKey"
#define IS_NEW_USER                                 @"isNewUserKey"
#define FILTER_STATUS                               @"filterStatusKey"
#define CALENDER_DISCLAIMER_ACCEPTED                @"calenderDisclaimerAcceptedKey"
#define LAST_UPDATED_DATE                           @"lastUpdatedDataKey"
#define LAST_MAJORS_UPDATED_DATE                    @"lastMajorsUpdatedDataKey"
#define LAST_SEEN_PRIVACY_POLICY_ID                 @"privacyPolicyMessageIdKey"
#define PREVIOUS_VERSION_NO                         @"previousVersionKey"
#define MAJORS_FETCH_STATUS                         @"majorsFetchStatusKey"

#define TUTORIAL_SCREENS_SEEN                       @"tutorialScreensSeenKey"
#define COMPARE_TUTORIAL_SCREEN_SEEN                @"compareTutorialScreenSeenKey"
#define RESET_FILTER_TUTORIAL_SCREEN_SEEN           @"resetFilterTutorialScreenSeenKey"
#define EXPORT_TUTORIAL_SCREEN_SEEN                 @"exportTutorialScreenSeenKey"
#define EXPORT_PAYMENT_STATUS                       @"exportPaymentStatusKey"
#define EXPORT_MAIL_DELIVERY_STATUS                 @"exportMailDeliveryStatusKey"
#define VIRTUAL_CAMPUS_TOUR_SEEN                    @"virtualCampusTourSeenKey"
#define TEST_SCORE_TUTORIAL_SEEN                    @"testScoreTutorialSeenKey"
#define FILTER_LOCATION_SCREEN_SEEN                 @"filterLocationScreenSeenKey"
#define MAJORS_POPUP_SEEN                           @"majorsPopupSeenKey"

#define RATING_STATUS_KEY                           @"ratingStatusKey"
#define APP_v26_LAUNCH_DATE                         @"appV26LaunchDateKey"

#define LOGIN_SCREEN_PRESENTED                      @"loginScreenPresentedKey"

#define FAVORITES_SYNC_STATUS                       @"favoritesSyncStatusKey"
#define COMPARE_SYNC_STATUS                         @"compareSyncStatusKey"
#define CLIPPINGS_SYNC_STATUS                       @"clippingsSyncStatusKey"
#define FILTER_SYNC_STATUS                          @"filterSyncStatusKey"

//SOCIAL LOGIN MANAGER CONSTANTS

#define FACEBOOK_APP_ID                             @"1636930623217536"
#define TWITTER_CONSUMER_KEY                        @"mh2fn5F5qy9Sr1uHSqdPyO4xs"
#define TWITTER_CONSUMER_SECRET                     @"xRChHtRpC2UjfKdPgdDlIZyXNISgEmg0wuc6Av4JnxQGx5oWPA"

//FILTER CONSTANTS
#define COLLEGE_SORT_DETAILS                        @"kCollageSortDetailsKey"
#define FAVOURTIE_COLLEGE_DETAILS                   @"kFavouriteCollegeDetailsKey"
#define HIGHSCHOOL_GPA_DETAILS                      @"kHighSchollGPADetailsKey"
#define AVERAGE_SAT_DETAILS                         @"kAverageSATScoreDetailsKey"
#define AVERAGE_ACT_DETAILS                         @"kAverageACTScoreDetailsKey"
#define FRESHMEN_SIZE_DETAILS                       @"kFreshmenSizeDetailsKey"
#define ACCEPTANCE_RATE_DETAILS                     @"kAcceptanceRateDetailsKey"
#define FOUR_YR_GRADUATION_RATE_DETAILS             @"kFourYrGraduationRateDetailsKey"
#define SIX_YR_GRADUATION_RATE_DETAILS              @"kSixYrGraduationRateDetailsKey"
#define ONE_YR_RETENTION_RATE_DETAILS               @"kOneYrRetentionRateDetailsKey"
#define COLLEGE_TYPE_DETAILS                        @"kCollegeTypeDetailsKey"
#define ADMISSION_TYPE_DETAILS                      @"kAdmissionTypeDetailsKey"
#define RELIGIOUS_AFFILIATION_DETAILS               @"kReligiousAffiliationKey"
#define MAJORS_DETAILS                              @"kMajorsDetailsKey"
#define DISTANCE_CURRENTLOC_DETAILS                 @"kDistanceFromCurrentLocationDetailsKey"
#define STATE_DETAILS                               @"kStateDetailsKey"
#define EARLY_ADMISSION_DETAILS                     @"kEarlyAdmissionDetailsKey"
#define EARLY_ACTION_DETAILS                        @"kEarlyActionDetailsKey"
#define ROLLING_ADMISSION_DETAILS                   @"kRollingAdmissionDetailsKey"
#define COMMON_APP_ACCEPTED_DETAILS                 @"kCommonAppAcceptedDetailsKey"
#define TOTAL_FEES_DETAILS                          @"kTotalFeesDetailsKey"
#define FINANCIAL_AID_DETAILS                       @"kFinancialAidDetailsKey"
#define TEST_OPTIONAL_DETAILS                       @"kTestOptionalDetailsKey"

#define KEY_LABEL                                   @"kLabelKey"
#define KEY_VALUE                                   @"kValueKey"
#define KEY_RANGE                                   @"kRangeKey"
#define KEY_CURRENT_RANGE                           @"kCurRangeKey"
#define KEY_EXPAND                                  @"kExpandKey"
#define KEY_VALUES_ARRAY                            @"kValuesArrayKey"

#define KEY_FILTER_STATE_NAME                       @"kFilterStateName"
#define KEY_FILTER_STATE_CODE                       @"kFilterStateCode"

#define KEY_FILTER_RELIGIOUS                        @"kFilterReligious"
#define KEY_FILTER_MAJORS                           @"kFilterMajors"

#define IS_SELECTED                                 @"kIsSelected"

//ALL THE CONSTANTS SHOULD BE DEFINED HERE

//STORYBOARD SEGUE IDENTIFIERS

#define SIGNIN_SEGUE_ID                             @"SignInSegue"
#define SIGNUP_SEGUE_ID                             @"SignUpSegue"
#define FORGOTPASSWORD_SEGUE_ID                     @"ForgotPasswordSegue"
#define PROFILE_SEGUE_ID                            @"ProfileSegue"
#define TERMSANDCONDITIONS_SEGUE_ID                 @"TermsAndConditionsSegue"
#define PRIVACYPOLICY_SEGUE_ID                      @"PrivacyPolicySegue"
#define SETTINGS_SEGUE_ID                           @"SettingsSegue"
#define FEEDBACK_SEGUE_ID                           @"FeedbackSegue"
#define COLLEGE_REORDER_PAGE_SEGUE_ID               @"ReorderCollegePageSegue"
#define DATADEFINITION_SEGUE_ID                     @"DataDefinationsSegue"
#define ABOUT_STIPEND_SEGUE_ID                      @"AboutStipendSegue"
#define HELP_SEGUE_ID                               @"HelpSegue"
#define MYDETAILS_SEGUE_ID                          @"MyDetailsSegue"
#define EDIT_USERDETAILS_SEGUE_ID                   @"UserEditDetailsSegue"
#define FILTER_STATE_SEGUE_ID                       @"FilterStateControllerSegue"
#define FILTER_RELIGIOUS_SEGUE_ID                   @"FilterReligiousControllerSegue"
#define FILTER_MAJORS_SEGUE_ID                      @"FilterMajorsControllerSegue"
#define FILTER_SPECIFIC_MAJORS_SEGUE_ID             @"FilterSpecificMajorsControllerSegue"

#define ADD_COMPARE_STORYBOARD_ID                   @"AddCollegeViewController"
#define EDIT_COMPARE_STORYBOARD_ID                  @"EditCollegeViewController"
#define COMPARE_SECTION_STORYBOARD_ID               @"CompareSectionsViewController"


#define CALENDAR_DISCLAIMER_TEXT                    @"Although we have tried to provide an accurate snapshot of each school's academic calendar, the dates and deadlines shown may not be up to date for the upcoming year. Although schools with rolling admissions policies often have late final deadlines, we have tried to present dates based upon priority deadlines for application, scholarship or financial aid so that you do not miss an opportunity to qualify.  Schools with Early Decision and Early Action policies also have many different deadlines. In these cases, we have listed the first application deadline for each in the header, but have displayed beneath deadlines for test scores, recommendations, scholarship and financial consideration, and student replies that are based upon Regular Admission.\n\nMake sure to consult each college's website for up-to-date policies and deadlines before entering any date into your calendar or relying upon it in connection with your application."

//USER ENUMERATIONS

typedef enum {
    eLoginTypeNormalUser = 0,
    eLoginTypeFacebook = 1,
    eLoginTypeTwitter = 2,
    eLoginTypeGuest = 3
}LoginType;


typedef enum {
    eResponseTypeNormalLogin = 0,
    eResponseTypeGuestLogin = 1,
    eResponseTypeSignUp = 2,
    eResponseTypeFacebook = 3,
    eResponseTypeTwitter = 4,
    eResponseTypeForgotPassword = 5,
    eResponseTypeUpdateProfile = 6,
    eResponseTypeCollegeLists = 7,
    eResponseTypeCollegeDetails = 8,
    eResponseTypeAllFavorites = 9,
    eResponseTypeAddToFavorites = 10,
    eResponseTypeRemoveFromFavorites = 11,
    eResponseTypeAllClippings = 12,
    eResponseTypeAddToClippings = 13,
    eResponseTypeRemoveFromClippings = 14,
    eResponseTypeAllCompares = 15,
    eResponseTypeAddToCompare = 16,
    eResponseTypeRemoveFromCompare = 17,
    eResponseTypeSettings = 18,
    eResponseTypeUpdateFavorites = 19,
    eResponseTypeUpdateCompare = 20,
    eResponseTypeUpdateClippings = 21,
    eResponseTypeGetFilterData = 22,
    eResponseTypeUpdateFilterData = 23,
    eResponseTypeMajorsList = 24
}ResponseType;


// COLLEGE SUMMARY ENUMERATIONS

typedef enum {
    eCollegeTypeUniversity = 1,
    eCollegeTypeCollege = 2,
    eCollegeTypeSchool = 3
}CollegeType;

typedef enum {
    eCollegeAreaTypeCity = 1,
    eCollegeAreaTypeTown = 2,
    eCollegeAreaTypeRural = 3
}CollegeareaType;

typedef enum {
    eCollegeAccessTypePublic = 1,
    eCollegeAccessTypePrivate = 2
}CollegeAccessType;

// MAP SEARCH ENUMERATIONS

typedef enum {
    eSearchTypeName = 1,
    eSearchTypePlace = 2,
    eSearchTypeZIP = 3
}MapSearchType;

// MY DETAILS ENUMERATIONS

enum {
    eDetailView = 1,
    eDetailEdit = 2
};
typedef NSUInteger DetailsType;

//PROFILE ENUMERATIONS

typedef enum {
    eUserTypeNone = 0,
    eUserTypeFreshmen = 1,
    eUserTypeSophomore = 2,
    eUserTypeJunior = 3,
    eUserTypeSenior = 4,
    eUserTypeParent = 5,
    eUserTypeCounselor = 6
} UserType;

#define usersTypesArray @[@"Freshman",@"Sophomore",@"Junior",@"Senior",@"Parent",@"Counselor"]
#define userTypeString(enum) [@[@"None",@"Freshman",@"Sophomore",@"Junior",@"Senior",@"Parent", @"Counselor"] objectAtIndex:enum]
#define userTypeIndex(type) [@[@"None",@"Freshman",@"Sophomore",@"Junior",@"Senior",@"Parent", @"Counselor"] indexOfObject:type]

typedef enum {
    eGenderNone = 0,
    eGenderMale = 1,
    eGenderFemale = 2,
    eGenderNotToSay = 3
} GenderType;

#define genderTypesArray @[@"Male",@"Female"]
#define genderTypeString(enum) [@[@"None",@"Male",@"Female"] objectAtIndex:enum]
#define genderTypeIndex(type) [@[@"None",@"Male",@"Female"] indexOfObject:type]

typedef enum {
    eSortTypeAlphabetically = 0,
    eSortTypeNoOfFreshmen = 1,
    eSortTypeAverageGPA = 2,
    eSortTypeAverageSAT = 3,
    eSortTypeAverageACT= 4,
    eSortTypeAcceptanceRate = 5,
    eSortTypeSixYrGraduationRate = 6,
    eSortTypeDistance = 7
} SortType;

#define sortTypeString(enum) [@[@"Alphabetically",@"No. of Freshmen",@"Average GPA",@"Average SAT score",@"Average ACT Composite",@"Acceptance Rate", @"6-Year Graduation Rate", @"Distance"] objectAtIndex:enum]
#define sortTypeIndex(type) [@[@"None",@"Alphabetically",@"No. of Freshmen",@"Average GPA",@"Average SAT score",@"Average ACT Composite",@"Acceptance Rate",@"6-Year Graduation Rate",@"Distance"] indexOfObject:type]

// MAP APP ITEMS

typedef enum {
    eMapAppTypeAppleMaps = 0,
    eMapAppTypeGoogleMaps = 1,
    eMapAppTypeAlwaysAsk = 2
} MapAppType;

#define mapAppTypeString(enum) [@[@"Apple Maps",@"Google Maps",@"Always Ask"] objectAtIndex:enum]
#define mapAppTypeIndex(type) [@[@"Apple Maps",@"Google Maps",@"Always Ask"] indexOfObject:type]

//FONT ENUMERATIONS

typedef enum {
    eFontTypeAvenirBook = 0,
    eFontTypeAvenirHeavy = 1,
    eFontTypeAvenirBookOblique = 2,
    eFontTypeAvenirRoman = 3,
    eFontTypeAvenirMedium = 4,
    eFontTypeAvenirNextMedium = 5,
    eFontTypeAvenirLight = 6

} FontType;

// FRESHMEN ITEMS
typedef enum {
    FreshmenItemGraduationRate = 0,
    FreshmenItemRetentionRate = 1,
    FreshmenItemReligiousAffiliation = 2
} FreshmenItem;

#define freshmenItemsArray @[@"FreshmenItemGraduationRate", @"FreshmenItemRetentionRate", @"FreshmenItemReligiousAffiliation"]
#define freshmenItemString(enum) [@[@"FreshmenItemGraduationRate",@"FreshmenItemRetentionRate",@"FreshmenItemReligiousAffiliation"] objectAtIndex:enum]

//MENU ITEMS

#define MENU_ITEMS_ARRAY [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Colleges", KEY_LABEL, @"colleges_selected", KEY_SELECTED, @"colleges_unselected", KEY_UNSELECTED, nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Favorites", KEY_LABEL, @"favorites_selected", KEY_SELECTED, @"favorites_unselected", KEY_UNSELECTED, nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Compare", KEY_LABEL, @"compare_selected", KEY_SELECTED, @"compare_unselected", KEY_UNSELECTED, nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Clippings", KEY_LABEL, @"clippings_selected", KEY_SELECTED, @"clippings_unselected", KEY_UNSELECTED, nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Map", KEY_LABEL, @"map_selected", KEY_SELECTED, @"map_unselected", KEY_UNSELECTED, nil],[NSDictionary dictionaryWithObjectsAndKeys:@"Settings", KEY_LABEL, @"settings_selected", KEY_SELECTED, @"settings_unselected", KEY_UNSELECTED, nil],nil]

//COLLEGE PAGE

#define TILES_COLOR_ARRAY [NSArray arrayWithObjects:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1],[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1],nil]


#define BLUE_COLOR_ARRAY [NSArray arrayWithObjects:[UIColor colorWithRed:25/255.0 green:118/255.0 blue:210/255.0 alpha:1],[UIColor colorWithRed:30/255.0 green:136/255.0 blue:229/255.0 alpha:1],[UIColor colorWithRed:33/255.0 green:150/255.0 blue:243/255.0 alpha:1],[UIColor colorWithRed:66/255.0 green:165/255.0 blue:245/255.0 alpha:1],[UIColor colorWithRed:100/255.0 green:181/255.0 blue:246/255.0 alpha:1],[UIColor colorWithRed:165/255.0 green:211/255.0 blue:249/255.0 alpha:1],[UIColor colorWithRed:187/255.0 green:222/255.0 blue:251/255.0 alpha:1],nil]

#define GREEN_COLOR_ARRAY [NSArray arrayWithObjects:[UIColor colorWithRed:0/255.0 green:86/255.0 blue:36/255.0 alpha:1],[UIColor colorWithRed:0/255.0 green:140/255.0 blue:58/255.0 alpha:1],[UIColor colorWithRed:0/255.0 green:164/255.0 blue:68/255.0 alpha:1],[UIColor colorWithRed:0/255.0 green:200/255.0 blue:83/255.0 alpha:1],[UIColor colorWithRed:65/255.0 green:224/255.0 blue:131/255.0 alpha:1],[UIColor colorWithRed:105/255.0 green:232/255.0 blue:158/255.0 alpha:1],[UIColor colorWithRed:164/255.0 green:248/255.0 blue:199/255.0 alpha:1],nil]

//UIView Bounds Constants

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X  (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

//Tutorial View Constants
#define TUTORIAL_VIEW_TYPE_SWIPE           @"kTutorialViewTypeSwipe"
#define TUTORIAL_VIEW_TYPE_COMPARE         @"kTutorialViewTypeCompare"
#define TUTORIAL_VIEW_TYPE_ROTATE          @"kTutorialViewTypeRotate"
#define TUTORIAL_VIEW_TYPE_FILTER          @"kTutorialViewTypeFilter"
#define TUTORIAL_VIEW_TYPE_REORDER         @"kTutorialViewTypeReOrder"
#define TUTORIAL_VIEW_TYPE_CLOSETILE       @"kTutorialViewTypeCloseTile"
#define TUTORIAL_VIEW_TYPE_PAYSCALE        @"kTutorialViewTypePayScale"
#define TUTORIAL_VIEW_TYPE_CLIPPINGS       @"kTutorialViewTypeClippings"
#define TUTORIAL_VIEWS_COMPLETED           @"kTutorialViewsCompleted"

// Test Scores Default Text
#define TEST_SCORE_DEFAULT_TEXT            @"SAT/ACT Scores: If percentage range pie charts do not appear, the college has not yet updated its statistics or does not publish the ranges. GPA Scores: If an asterisk follows the Average GPA, the college does not report the GPA or does not report the percentage ranges. In the former case, the GPA is imputed from schools with similar academic characteristics. Also, since some colleges weight GPA’s, GPA’s are not comparable across all colleges."

// Financial Aid Items and Texts
typedef enum {
    FinancialAidItemNetPrice = 0,
    FinancialAidItemHouseholdIncome = 1,
    FinancialAidItemAverageMeritAward = 2,
    FinancialAidItemReceivingMeritAwards = 3
} FinancialAidItem;

#define FINANCIAL_AID_NET_PRICE             @"Average net price for students awarded grant or scholarship aid from the college or federal, state, or local governments."

#define FINANCIAL_AID_HOUSEHOLD_INCOME      @"Average net price for students awarded Title IV federal student aid, which includes federal grants or federal student loans: Since the latest statistics published on net price are based on an earlier year, net price data do not directly correlate with cost of attendance."

#define FINANCIAL_AID_AVG_MERIT_AWARDS      @"Average amount of institutional, non-need-based scholarship and grant aid (exc. athletic awards) awarded to first-time, full-time freshmen."

#define FINANCIAL_AID_REC_MERIT_AWARDS      @"% of first-time, full-time freshmen who had no financial need and were awarded institutional, non-need-based scholarship or grant aid (exc. athletic awards)."

// Broad Majors Default Text
#define BROAD_MAJORS_DEFAULT_TEXT           @"When you tap on the broad majors below, the specific majors of students who received bachelor’s degrees are displayed, based on standardized nomenclature published by the National Center for Education Statistics (NCES). The actual names of majors offered at individual colleges may differ. Colleges may discontinue or add majors depending upon enrollment and other factors so be sure to consult the college websites for the latest information. Although many pre-med students major in biology, pre-med is a track that can be fulfilled by majoring in other subjects."

#define MAJORS_POPUP_TEXT                   @"If you filter by more than one major, colleges that offered any of the majors will be displayed."

// Filter Screen Sections
#define RESET_ALL_SECTION               0
#define TEST_SCORE_SECTION              1
#define TEST_OPTIONAL_SECTION           2
#define FRESHMEN_SECTION                3
#define GRADUATION_RATE_SECTION         4
#define ADDMISSION_SECTION              5
#define RELIGIOUS_AFFILIATION_SECTION   6
#define MAJORS_SECTION                  7
#define LOCATION_SECTION                8
#define FINANCIAL_AID_SECTION           9

#define DEFAULT_ROW_HEIGHT              50.0

//STLOG

#ifdef DEBUG

#define STLog(...) NSLog(@"%s@%i: %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])

#else

#define STLog(...) {}

#endif

#endif
