//
//  STCollegeHeaderView.h
//  Stipend
//
//  Created by Arun S on 23/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIPanGestureRecognizerDirection) {
    UIPanGestureRecognizerDirectionUndefined,
    UIPanGestureRecognizerDirectionUp,
    UIPanGestureRecognizerDirectionDown,
    UIPanGestureRecognizerDirectionLeft,
    UIPanGestureRecognizerDirectionRight
};

static UIPanGestureRecognizerDirection direction = UIPanGestureRecognizerDirectionUndefined;

@interface STCollegeHeaderView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, copy) void (^reorderActionBlock)(void);
//@property (nonatomic, copy) void (^shareActionBlock)();
@property (nonatomic, copy) void (^sortActionBlock)(void);
@property (nonatomic, copy) void (^compareActionBlock)(void);
@property (nonatomic, copy) void (^favoriteActionBlock)(void);

@property (weak, nonatomic) IBOutlet UIImageView                     *collegeImageView;
@property (weak, nonatomic) IBOutlet UIView                               *summaryView;
@property (weak, nonatomic) IBOutlet UIView                             *subHeaderView;
@property (weak, nonatomic) IBOutlet UIView                         *viewSeperatorView;

@property (weak, nonatomic) IBOutlet UILabel                               *ibFreshmen;
@property (weak, nonatomic) IBOutlet UILabel                        *ibTotalUndergrads;
@property (weak, nonatomic) IBOutlet UILabel                             *ibAcceptance;
@property (weak, nonatomic) IBOutlet UILabel                             *ibAverageGPA;
@property (weak, nonatomic) IBOutlet UILabel                             *ibAverageSAT;
@property (weak, nonatomic) IBOutlet UILabel                             *ibAverageACT;

@property (nonatomic,retain) UIPanGestureRecognizer                        *panGesture;

@property (nonatomic,assign) CGFloat                                  headerViewHeight;

@property (nonatomic,assign) BOOL                                      isSummaryHidden;
@property (nonatomic,assign) BOOL                                    shouldAllowScroll;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint   *summaryViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSeparatorHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton                        *collegeTypeImage;
@property (weak, nonatomic) IBOutlet UIButton                    *collegeAreaTypeImage;
@property (weak, nonatomic) IBOutlet UIButton                  *collegeAccessTypeImage;

@property (weak, nonatomic) IBOutlet UIButton                              *sortButton;
@property (weak, nonatomic) IBOutlet UIButton                          *organizeButton;
@property (weak, nonatomic) IBOutlet UIButton                          *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton                           *compareButton;

@property (weak, nonatomic) IBOutlet UILabel                         *collegeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel                     *collegeAreaTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel                   *collegeAccessTypeLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView    *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIView               *collegeImagePlaceholderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *placeholderImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityIndicatorViewTopConstraint;

- (IBAction)onReorderAction     :(id)sender;
//- (IBAction)onShareAction       :(id)sender;
- (IBAction)onSortAction       :(id)sender;
- (IBAction)onCompareAction     :(id)sender;
- (IBAction)onFavoriteAction    :(id)sender;


- (void)toggleSumaryViewWithAnimation:(BOOL)animation;
- (void)updateCollegeSummaryForCollegeID:(NSNumber *)collegeID;

- (void) updateFavoriteButtonWithStatus:(BOOL) isFavorite;
- (void) updateCompareButtonWithStatus:(BOOL) isAddedToCompare;

@end
