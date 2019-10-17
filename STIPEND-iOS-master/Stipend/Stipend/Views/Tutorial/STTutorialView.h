//
//  TutorialView.h
//  Stipend
//
//  Created by sourcebits on 30/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//


typedef enum {
    kTutorialViewTypeSwipe                  = 1,
    kTutorialViewTypeSort                   = 2,
    kTutorialViewTypeOrganize               = 3,
    kTutorialViewTypeFavoties               = 4,
    kTutorialViewTypeClippings              = 5,
    kTutorialViewTypeCompare                = 6,
    kTutorialViewTypePayScale               = 7,
    kTutorialViewTypeFilter                 = 8,
    kTutorialViewTypeCompareScreen          = 9,
    kTutorialViewTypeResetFilter            = 10,
    kTutorialViewTypeExportSpreadsheet      = 11,
    kTutorialViewTypeTestScores             = 12,
    kTutorialViewTypeResetTestScore         = 13,
    kTutorialViewTypeLocation               = 14,
    kTutorialViewTypeNone                   = 15
}TutorialViewType;

typedef enum {
    kAnchorViewTypeUP   = 1,
    kAnchorViewTypeDown = 2
}AnchorViewType;

#import <UIKit/UIKit.h>
#import "STCollegeHeaderView.h"

@interface STTutorialView : UIView

@property (assign, nonatomic) STCollegeHeaderView *headerView;
@property (assign, nonatomic) UITabBar *tabBar;

// Top View Constraints and properties
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewRightHandWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewRightHandTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLeftHandWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLeftHandLeadingingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewAnchorYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewOKBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLabelBottomConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *topViewRightHandImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topViewLeftHandImageView;
@property (weak, nonatomic) IBOutlet UILabel *topViewLabel;

// Bottom View Constraints and properties
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewAnchorYConstraint;

@property (weak, nonatomic) IBOutlet UILabel *bottomViewLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topViewOKBtnView;

- (IBAction)onOKButtonAction:(id)sender;

@property (nonatomic, assign) TutorialViewType  tutorialType;
@property (nonatomic,assign)  NSInteger         currentIndex;

@property (nonatomic, copy) void (^tutorialActionBlock)(NSNumber *nextIndex);

- (void)updateTutorialViewType:(TutorialViewType)tutorialType;

+ (STTutorialView *)loadFromNib;

@property(nonatomic,assign) BOOL isVisible;
//@property(nonatomic,assign) BOOL isPresenting;

+ (STTutorialView *)shareView;
- (void)showInView:(UIView *) view withTutorialType:(TutorialViewType)tutorialType;
- (void)hide;


@end
