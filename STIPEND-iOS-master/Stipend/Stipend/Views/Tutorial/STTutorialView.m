//
//  TutorialView.m
//  Stipend
//
//  Created by sourcebits on 30/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#define TUTORIALVIEW_TAG                1111
#define DEFAULT_HEADER_VIEW_HEIGHT      self.frame.size.height/2
#define SUB_HEADER_HEIGHT               150.0
#define CONTENTSET_Y                     50.0
#define COMPARE_CIRCLE_VIEW_WIDTH       120.0
#define COMPARE_CIRCLE_VIEW_HEIGHT      120.0
#define COMPARE_CIRCLE_VIEW_ORIGIN_X    143.0
#define SCREEN_OFFSET_X                  10.0
#define SCREEN_OFFSET_Y                  10.0

#define FILTER_CIRCLE_VIEW_WIDTH         90.0
#define FILTER_CIRCLE_VIEW_HEIGHT        90.0

#define FILTER_CIRCLE_ORIGIN_X          self.frame.size.width
#define FILTER_CIRCLE_ORIGIN_Y            0.0

#define TOP_VIEW_UP_ANCHOR_TAG          1000
#define TOP_VIEW_DOWN_ANCHOR_TAG        1010
#define BOTTOM_VIEW_ANCHOR_TAG          2000


#import "STTutorialView.h"

@interface STTutorialView (){
    CGFloat subHeaderHeight;
}

@end

@implementation STTutorialView

#pragma mark Singleton Methods

+ (STTutorialView *)loadFromNib{

    return [[NSBundle mainBundle] loadNibNamed:@"STTutorialView" owner:self options:nil].firstObject;
}

+ (STTutorialView *)shareView {
    
    static dispatch_once_t pred = 0;
    static STTutorialView *shareView = nil;
    dispatch_once(&pred, ^{
        shareView = [self loadFromNib];
    });
    return shareView;
}

#pragma mark Initialize Method
- (void)awakeFromNib{
    [super awakeFromNib];
    self.hidden = YES;
    self.alpha = 0.0;
    self.backgroundColor = [UIColor clearColor];
}

- (void)showInView:(UIView *) view withTutorialType:(TutorialViewType)tutorialType{
    
    [self setFrame:view.frame];
    self.tag = TUTORIALVIEW_TAG;
    self.tutorialType = tutorialType;
    [self initializeUI];
    
    self.alpha = 0.0;
    self.hidden = NO;
    //self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    
    
    BOOL doesContain = [view.subviews containsObject:self];
    if (!doesContain) {
        [view addSubview:self];
    }
    [self setNeedsDisplay];
    
    __weak STTutorialView *weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 1.0;
    } completion:^(BOOL finished) {        
    }];
}

- (void)updateTutorialViewType:(TutorialViewType)tutorialType {
    self.tutorialType = tutorialType;
    [self initializeUI];
    self.alpha = 0.0;
    self.hidden = NO;
    [self setNeedsDisplay];
    
    __weak STTutorialView *weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];

}

- (void)hide {
    
}

- (void)initializeUI{
    
    float topPaddingValue = 0;
    float bottomPaddingValue = 0;
    
    CGFloat viewHeight = [[UIScreen mainScreen] bounds].size.height;
    
    if(viewHeight >= 812) {
        topPaddingValue = 24;
        bottomPaddingValue = 34;
    }

//    if(IS_IPHONE_X) {
//        topPaddingValue = 24;
//        bottomPaddingValue = 34;
//    }
    
    switch (self.tutorialType) {
        case kTutorialViewTypeSwipe:{
            self.currentIndex = 0;
            
            self.bottomView.hidden = YES;
            
            self.topViewLabel.text = @"swipe to move between colleges";
            self.topViewLabel.textAlignment = NSTextAlignmentLeft;
            
            self.topViewLeftHandImageView.image = [UIImage imageNamed:@"tutorial-swipe.png"];
            self.topViewLeftHandWidthConstraint.constant = 45;
            self.topViewLeftHandLeadingingConstraint.constant = 30;
            
            self.topViewRightHandTrailingConstraint.constant = 10;
            self.topViewRightHandWidthConstraint.constant = 0;

            self.topViewOKBtnView.hidden = NO;
            self.topViewLabelBottomConstraint.constant = 60;
        
            self.topViewYConstraint.constant = self.headerView.frame.size.height - self.topViewHeightConstraint.constant - 50 + topPaddingValue;
            
        }
            break;
        case kTutorialViewTypeSort: {
            
            CGRect sortButtonRect = self.headerView.sortButton.frame;

            self.bottomView.hidden = YES;
            
            self.topViewLabel.text = @"tap to change the order in which colleges are displayed when swiping across";
            self.topViewLabel.textAlignment = NSTextAlignmentLeft;
            
            self.topViewLeftHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewLeftHandWidthConstraint.constant = 45;
            self.topViewLeftHandLeadingingConstraint.constant = sortButtonRect.origin.x + (sortButtonRect.size.width/2) - (self.topViewLeftHandWidthConstraint.constant/2);
            

            self.topViewRightHandTrailingConstraint.constant = 10;
            self.topViewRightHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = NO;
            self.topViewLabelBottomConstraint.constant = 50;

            self.topViewYConstraint.constant = 165 + topPaddingValue;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 80;
            }
            
            UIView *anchorView = [self getAnchorViewWithType:kAnchorViewTypeUP];
            anchorView.tag = TOP_VIEW_UP_ANCHOR_TAG;
            CGRect anchorViewFrame = anchorView.frame;
            anchorViewFrame.origin.x = sortButtonRect.origin.x + (sortButtonRect.size.width/2) - (anchorViewFrame.size.width/2);
            anchorViewFrame.origin.y = self.topViewYConstraint.constant - anchorViewFrame.size.height;
            
            anchorView.frame = anchorViewFrame;
            
            [self addSubview:anchorView];

        }
            break;
        case kTutorialViewTypeOrganize: {
            
            CGRect organizeButtonRect = self.headerView.organizeButton.frame;
            
            self.bottomView.hidden = YES;
            
            self.topViewLabel.text = @"tap to change the order of the information on this screen";
            self.topViewLabel.textAlignment = NSTextAlignmentLeft;

            
            self.topViewLeftHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewLeftHandWidthConstraint.constant = 45;
            self.topViewLeftHandLeadingingConstraint.constant = organizeButtonRect.origin.x + (organizeButtonRect.size.width/2) - (self.topViewLeftHandWidthConstraint.constant/2);
            
            self.topViewRightHandTrailingConstraint.constant = 0;
            self.topViewRightHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = NO;
            self.topViewLabelBottomConstraint.constant = 50;

            self.topViewYConstraint.constant = 165 + topPaddingValue;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 80;
            } else {
                self.topViewHeightConstraint.constant += 10;
            }
            
            UIView *anchorView = (UIView *)[self viewWithTag:TOP_VIEW_UP_ANCHOR_TAG];
            CGRect anchorViewFrame = anchorView.frame;
            anchorViewFrame.origin.x = organizeButtonRect.origin.x + (organizeButtonRect.size.width/2) - (anchorViewFrame.size.width/2);
            anchorViewFrame.origin.y = self.topViewYConstraint.constant - anchorViewFrame.size.height;
            
            anchorView.frame = anchorViewFrame;
            

        }
            break;
        case kTutorialViewTypeFavoties: {
            
            CGRect favoriteButtonRect = self.headerView.favoriteButton.frame;

            self.bottomView.hidden = NO;
            
            self.topViewLabel.text = @"tap to add this college to your favorites";
            self.topViewLabel.textAlignment = NSTextAlignmentRight;
            self.bottomViewLabel.text = @"all your favorite colleges are saved under the Favorites tab";
            
            self.topViewRightHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewRightHandWidthConstraint.constant = 45;
            self.topViewRightHandTrailingConstraint.constant = ([UIScreen mainScreen].bounds.size.width - (favoriteButtonRect.origin.x + favoriteButtonRect.size.width)) + (self.topViewRightHandWidthConstraint.constant/2);
            
            self.topViewLeftHandLeadingingConstraint.constant = 0;
            self.topViewLeftHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = YES;
            self.topViewLabelBottomConstraint.constant = 10;
            
            self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant - 40;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 30;
            } else {
                self.topViewHeightConstraint.constant -= 10;
            }
            
            self.topViewYConstraint.constant = self.headerView.frame.size.height - self.topViewHeightConstraint.constant - 114 + topPaddingValue;
            self.bottomViewYConstraint.constant = 69 + bottomPaddingValue;
            
            
            UIView *topUpAnchorView = (UIView *)[self viewWithTag:TOP_VIEW_UP_ANCHOR_TAG];
            topUpAnchorView.hidden = YES;
            
            UIView *topDownAnchorView = [self getAnchorViewWithType:kAnchorViewTypeDown];
            topDownAnchorView.tag = TOP_VIEW_DOWN_ANCHOR_TAG;
            
            CGRect topAnchorViewFrame = topDownAnchorView.frame;
            topAnchorViewFrame.origin.x = favoriteButtonRect.origin.x + (favoriteButtonRect.size.width/2) - (topAnchorViewFrame.size.width/2);
            topAnchorViewFrame.origin.y = self.topViewYConstraint.constant + self.topViewHeightConstraint.constant;
            
            topDownAnchorView.frame = topAnchorViewFrame;
            
            [self addSubview:topDownAnchorView];
            
            
            CGRect favoriteTabBarButtonRect = [self rectForTabBarItemAtIndex:1];
            
            UIView *bottomAnchorView = [self getAnchorViewWithType:kAnchorViewTypeDown];
            bottomAnchorView.tag = BOTTOM_VIEW_ANCHOR_TAG;
            CGRect bottomAnchorViewFrame = bottomAnchorView.frame;
            bottomAnchorViewFrame.origin.x = favoriteTabBarButtonRect.origin.x + (favoriteTabBarButtonRect.size.width/2) - 10;
            bottomAnchorViewFrame.origin.y =  favoriteTabBarButtonRect.origin.y - (bottomAnchorViewFrame.size.height * 2);
            
            bottomAnchorView.frame = bottomAnchorViewFrame;
            
            [self addSubview:bottomAnchorView];
            
        }
            break;
        case kTutorialViewTypeCompare: {
            
            CGRect compareButtonRect = self.headerView.compareButton.frame;

            self.bottomView.hidden = NO;
            
            self.topViewLabel.text = @"tap to add to this college to your comparison spreadsheet";
            self.topViewLabel.textAlignment = NSTextAlignmentRight;
            self.bottomViewLabel.text = @"see a spreadsheet comparing the colleges you have chosen";
            
            self.topViewRightHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewRightHandWidthConstraint.constant = 45;
            self.topViewRightHandTrailingConstraint.constant = ([UIScreen mainScreen].bounds.size.width - (compareButtonRect.origin.x + compareButtonRect.size.width)) + (self.topViewRightHandWidthConstraint.constant/2);
            
            
            self.topViewLeftHandLeadingingConstraint.constant = 0;
            self.topViewLeftHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = YES;
            self.topViewLabelBottomConstraint.constant = 10;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 60;
            } else {
                self.topViewHeightConstraint.constant += 10;
            }
            
            self.topViewYConstraint.constant = self.headerView.frame.size.height - self.topViewHeightConstraint.constant - 114 + topPaddingValue;
            
            UIView *topDownAnchorView = (UIView *)[self viewWithTag:TOP_VIEW_DOWN_ANCHOR_TAG];
            CGRect topAnchorViewFrame = topDownAnchorView.frame;
            topAnchorViewFrame.origin.x = compareButtonRect.origin.x + (compareButtonRect.size.width/2) - (topAnchorViewFrame.size.width/2);
            topAnchorViewFrame.origin.y = self.topViewYConstraint.constant + self.topViewHeightConstraint.constant;
            
            topDownAnchorView.frame = topAnchorViewFrame;
            

            CGRect compareTabBarButtonRect = [self rectForTabBarItemAtIndex:3];
            
            UIView *bottomAnchorView = (UIView *)[self viewWithTag:BOTTOM_VIEW_ANCHOR_TAG];
            CGRect bottomAnchorViewFrame = bottomAnchorView.frame;
            bottomAnchorViewFrame.origin.x = compareTabBarButtonRect.origin.x + (compareTabBarButtonRect.size.width/2) - 10;
            bottomAnchorViewFrame.origin.y =  compareTabBarButtonRect.origin.y - (bottomAnchorViewFrame.size.height * 2);
            
            bottomAnchorView.frame = bottomAnchorViewFrame;
            
            
        }
            break;
        case kTutorialViewTypeFilter:{
            
            self.bottomView.hidden = YES;
            
            self.topViewLabel.text = @"tap filter to narrow the schools displayed by criteria you choose";
            self.topViewLabel.textAlignment = NSTextAlignmentRight;

            
            self.topViewRightHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewRightHandWidthConstraint.constant = 45;
            self.topViewRightHandTrailingConstraint.constant = 10;
            
            self.topViewLeftHandLeadingingConstraint.constant = 0;
            self.topViewLeftHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = NO;
            self.topViewLabelBottomConstraint.constant = 60;

            self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + 40;

            self.topViewYConstraint.constant = 84 + topPaddingValue;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 70;
            }
            
            UIView *topDownAnchorView = (UIView *)[self viewWithTag:TOP_VIEW_DOWN_ANCHOR_TAG];
            topDownAnchorView.hidden = YES;
            
            UIView *topUpAnchorView = (UIView *)[self viewWithTag:TOP_VIEW_UP_ANCHOR_TAG];
            topUpAnchorView.hidden = NO;
            CGRect anchorViewFrame = topUpAnchorView.frame;
            anchorViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width - 40;
            anchorViewFrame.origin.y = 74 + topPaddingValue;
            
            topUpAnchorView.frame = anchorViewFrame;
            
            UIView *bottomAnchorView = (UIView *)[self viewWithTag:BOTTOM_VIEW_ANCHOR_TAG];
            bottomAnchorView.hidden = YES;
            
        }
            break;
        case kTutorialViewTypeResetFilter: {
            
            self.bottomView.hidden = YES;
            
            self.topViewLabel.text = @"be sure to reset filter after using it to see all colleges";
            self.topViewLabel.textAlignment = NSTextAlignmentLeft;
            
            self.topViewLeftHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewLeftHandWidthConstraint.constant = 45;
            //self.topViewLeftHandLeadingingConstraint.constant = sortButtonRect.origin.x + (sortButtonRect.size.width/2) - (self.topViewLeftHandWidthConstraint.constant/2);
            
            
            self.topViewRightHandTrailingConstraint.constant = 10;
            self.topViewRightHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = NO;
            self.topViewLabelBottomConstraint.constant = 60;
            
            self.topViewYConstraint.constant = 140 + topPaddingValue;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 90;
            }
            
            UIView *anchorView = [self getAnchorViewWithType:kAnchorViewTypeUP];
            anchorView.tag = TOP_VIEW_UP_ANCHOR_TAG;
            CGRect anchorViewFrame = anchorView.frame;
            anchorViewFrame.origin.x = (([UIScreen mainScreen].bounds.size.width) / 2) - 10;
            anchorViewFrame.origin.y = self.topViewYConstraint.constant - anchorViewFrame.size.height;
            
            anchorView.frame = anchorViewFrame;
            
            [self addSubview:anchorView];
            
        }
            break;
        case kTutorialViewTypeClippings: {
            
            self.bottomView.hidden = NO;
            
            self.topViewLabel.text = @"press and hold a tile until it turns white to drag it down to your clippings drawer";
            self.topViewLabel.textAlignment = NSTextAlignmentLeft;
            self.bottomViewLabel.text = @"all your clippings are saved under the Clippings tab";
            
            self.topViewLeftHandImageView.image = [UIImage imageNamed:@"tutorial-tap-hold.png"];
            self.topViewLeftHandLeadingingConstraint.constant = 20;
            self.topViewLeftHandWidthConstraint.constant = 45;

            self.topViewRightHandTrailingConstraint.constant = 10;
            self.topViewRightHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = YES;
            self.topViewLabelBottomConstraint.constant = 5;

            self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant - 40;
            
            self.topViewYConstraint.constant = 64 + 60 * 3 + 5 + topPaddingValue;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 30;
            }

            UIView *anchorView = (UIView *)[self viewWithTag:TOP_VIEW_UP_ANCHOR_TAG];
            CGRect anchorViewFrame = anchorView.frame;
            anchorViewFrame.origin.x = ([UIScreen mainScreen].bounds.size.width / 2) - 10;
            anchorViewFrame.origin.y = self.topViewYConstraint.constant - 10;
            
            anchorView.frame = anchorViewFrame;
            
            
            CGRect clippingsTabBarButtonRect = [self rectForTabBarItemAtIndex:2];
            
            UIView *bottomAnchorView = (UIView *)[self viewWithTag:BOTTOM_VIEW_ANCHOR_TAG];
            bottomAnchorView.hidden = NO;
            CGRect bottomAnchorViewFrame = bottomAnchorView.frame;
            bottomAnchorViewFrame.origin.x = clippingsTabBarButtonRect.origin.x + (clippingsTabBarButtonRect.size.width/2) - 10;
            bottomAnchorViewFrame.origin.y =  clippingsTabBarButtonRect.origin.y - (bottomAnchorViewFrame.size.height * 2);
            
            bottomAnchorView.frame = bottomAnchorViewFrame;
            
        }
            break;
        case kTutorialViewTypePayScale: {
            
            self.bottomView.hidden = YES;
            
            self.topViewLabel.text = @"tap on rank to get more info from PayScale’s website";
            self.topViewLabel.textAlignment = NSTextAlignmentRight;

            self.topViewRightHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewRightHandTrailingConstraint.constant = 20;
            self.topViewRightHandWidthConstraint.constant = 45;

            
            self.topViewLeftHandLeadingingConstraint.constant = 10;
            self.topViewLeftHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = NO;
            self.topViewLabelBottomConstraint.constant = 60;

            self.topViewHeightConstraint.constant = self.topViewHeightConstraint.constant + 40;

            self.topViewYConstraint.constant = 64 + 60 * 5 + 5 + topPaddingValue;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 90;
            }

            UIView *anchorView = (UIView *)[self viewWithTag:TOP_VIEW_UP_ANCHOR_TAG];
            CGRect anchorViewFrame = anchorView.frame;
            anchorViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width - 50;
            anchorViewFrame.origin.y = self.topViewYConstraint.constant - 10;
            
            anchorView.frame = anchorViewFrame;
            
            UIView *bottomAnchorView = (UIView *)[self viewWithTag:BOTTOM_VIEW_ANCHOR_TAG];
            bottomAnchorView.hidden = YES;
            
        }
            break;
        case kTutorialViewTypeCompareScreen: {
            
            self.bottomView.hidden = YES;
            
            self.topViewLabel.text = @"tap here to change the fields that are compared";
            self.topViewLabel.textAlignment = NSTextAlignmentLeft;
            
            self.topViewLeftHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewLeftHandLeadingingConstraint.constant = 20;
            self.topViewLeftHandWidthConstraint.constant = 45;
            
            
            self.topViewRightHandTrailingConstraint.constant = 10;
            self.topViewRightHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = NO;
            self.topViewLabelBottomConstraint.constant = 60;

            self.topViewHeightConstraint.constant = 135;
            
            self.topViewYConstraint.constant = 64 + 20 + topPaddingValue;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 90;
            }
            
            UIView *anchorView = [self getAnchorViewWithType:kAnchorViewTypeUP];
            anchorView.tag = TOP_VIEW_UP_ANCHOR_TAG;
            CGRect anchorViewFrame = anchorView.frame;
            anchorViewFrame.origin.x = ([UIScreen mainScreen].bounds.size.width/2) - 10;
            anchorViewFrame.origin.y = self.topViewYConstraint.constant - 10;
            
            anchorView.frame = anchorViewFrame;
            
            [self addSubview:anchorView];
            
        }
            break;
        case kTutorialViewTypeExportSpreadsheet: {
            
            self.bottomView.hidden = YES;
            
            self.topViewLabel.text = @"Click here to complete an in-app purchase to export by email spreadsheet comparing up to 15 colleges in ready-to-print format.";
            
            self.topViewLabel.textAlignment = NSTextAlignmentLeft;
            
            self.topViewLeftHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewLeftHandLeadingingConstraint.constant = 20;
            self.topViewLeftHandWidthConstraint.constant = 45;
            
            self.topViewRightHandTrailingConstraint.constant = 10;
            self.topViewRightHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = NO;
            self.topViewLabelBottomConstraint.constant = 60;

            
            self.topViewYConstraint.constant = 64 + 20 + topPaddingValue;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 130;
            }
            
            UIView *anchorView = [self getAnchorViewWithType:kAnchorViewTypeUP];
            anchorView.tag = TOP_VIEW_UP_ANCHOR_TAG;
            CGRect anchorViewFrame = anchorView.frame;
            anchorViewFrame.origin.x = 15;
            anchorViewFrame.origin.y = self.topViewYConstraint.constant - 10;
            
            anchorView.frame = anchorViewFrame;
            
            [self addSubview:anchorView];
            
        }
            break;
        case kTutorialViewTypeTestScores: {
            
            self.bottomView.hidden = YES;
            
            self.topViewLabel.text = @"Tap on horizontal 25th/75th percentile bar to display new SAT test equivalents.";
            self.topViewLabel.textAlignment = NSTextAlignmentLeft;
            
            self.topViewLeftHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewLeftHandLeadingingConstraint.constant = 20;
            self.topViewLeftHandWidthConstraint.constant = 45;
            
            self.topViewRightHandTrailingConstraint.constant = 10;
            self.topViewRightHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = NO;
            self.topViewLabelBottomConstraint.constant = 60;
            
            self.topViewYConstraint.constant = 64 + 230 + topPaddingValue;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            
            if(labelHeight > 55) {
                self.topViewHeightConstraint.constant = labelHeight + 130;
            } else {
                self.topViewHeightConstraint.constant = labelHeight + 110;
            }
            
            UIView *anchorView = [self getAnchorViewWithType:kAnchorViewTypeUP];
            anchorView.tag = TOP_VIEW_UP_ANCHOR_TAG;
            CGRect anchorViewFrame = anchorView.frame;
            anchorViewFrame.origin.x = [UIScreen mainScreen].bounds.size.width / 2;
            anchorViewFrame.origin.y = self.topViewYConstraint.constant - 10;
            
            anchorView.frame = anchorViewFrame;
            
            [self addSubview:anchorView];
            
        }
            break;
        case kTutorialViewTypeLocation: {
            
            self.bottomView.hidden = YES;
            
            self.topViewLabel.text = @"If you wish to view the colleges in order of distance from your location as you swipe through the colleges, be sure to set the SORT order on the main screen to Distance.";
            self.topViewLabel.textAlignment = NSTextAlignmentLeft;
            
            self.topViewLeftHandImageView.image = [UIImage imageNamed:@"tutorial-tap.png"];
            self.topViewLeftHandWidthConstraint.constant = 0;
            
            self.topViewRightHandTrailingConstraint.constant = 10;
            self.topViewRightHandWidthConstraint.constant = 0;
            
            self.topViewOKBtnView.hidden = NO;
            self.topViewLabelBottomConstraint.constant = 60;
            
            self.topViewYConstraint.constant = 140 + topPaddingValue;
            
            CGFloat labelHeight = [self getHeightForLabel:self.topViewLabel];
            self.topViewHeightConstraint.constant = labelHeight + 130;
            self.topViewYConstraint.constant = ((self.frame.size.height - labelHeight - 130) / 2);
            
        }
            break;
        case kTutorialViewTypeNone: {
            
            UIView *topUpAnchorView = (UIView *)[self viewWithTag:TOP_VIEW_UP_ANCHOR_TAG];
            [topUpAnchorView removeFromSuperview];
            UIView *topDownAnchorView = (UIView *)[self viewWithTag:TOP_VIEW_DOWN_ANCHOR_TAG];
            [topDownAnchorView removeFromSuperview];
            UIView *bottomAnchorView = (UIView *)[self viewWithTag:BOTTOM_VIEW_ANCHOR_TAG];
            [bottomAnchorView removeFromSuperview];
            
        }
            break;

        default:
            break;
    }
}

- (CGFloat)getHeightForLabel:(UILabel *)label {
    
    CGSize constraintSize = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    
    CGRect rect = [label.text boundingRectWithSize:constraintSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: label.font}
                                           context:nil];
    
    return rect.size.height;
}

- (UIView *)getAnchorViewWithType:(AnchorViewType)anchorViewType {

    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint centerPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, 0);

    if(anchorViewType == kAnchorViewTypeUP) {
        startPoint = CGPointMake(0, 10);
        centerPoint = CGPointMake(10, 0);
        endPoint = CGPointMake(20, 10);
    } else {
        startPoint = CGPointMake(0, 0);
        centerPoint = CGPointMake(10,10);
        endPoint = CGPointMake(20, 0);
    }
    
    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:startPoint];
    [trianglePath addLineToPoint:centerPoint];
    [trianglePath addLineToPoint:endPoint];
    [trianglePath closePath];
    
    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];
    
    UIView *anchorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    
    anchorView.backgroundColor = [UIColor aquaColorWithAlpha:0.95];
    anchorView.layer.mask = triangleMaskLayer;
    
    return anchorView;
}

-(CGRect)rectForTabBarItemAtIndex:(NSInteger)index {
    
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    CGFloat originX = containingWidth * index ;
    CGRect containingRect = CGRectMake( originX, tabBarRect.origin.y, containingWidth, self.tabBar.frame.size.height);
   
    return containingRect;
}


/*
#pragma mark Layout subviews methods
- (void)layoutSubviews{

    if (self.tutorialType == kTutorialViewTypeCompare || self.tutorialType == kTutorialViewTypeFilter || self.tutorialType == kTutorialViewTypeReOrder || self.tutorialType == kTutorialViewTypePayScale) {
        self.ibImageViewWidthConstraint.constant = 64.0f;
        self.ibImageViewHeightConstraint.constant = 105.0f;
    }else if (self.tutorialType == kTutorialViewTypeRotate){
        self.ibImageViewWidthConstraint.constant = 126.0f;
        self.ibImageViewHeightConstraint.constant = 126.0f;
    }else if (self.tutorialType == kTutorialViewTypeClippings){
        self.ibImageViewWidthConstraint.constant = 74.0f;
        self.ibImageViewHeightConstraint.constant = 105.0f;
    }else if (self.tutorialType == kTutorialViewTypeSwipe){
        self.ibImageViewWidthConstraint.constant = 90.0f;
        self.ibImageViewHeightConstraint.constant = 90.0f;
    }
    
    if (self.tutorialType == kTutorialViewTypeFilter) {
        self.ibImageViewCenterAlignmentXConstraint.constant = -(self.frame.size.width/2.0 - self.ibImageViewWidthConstraint.constant + 3 * SCREEN_OFFSET_X) ;
        self.ibImageViewCenterAlignmentYConstraint.constant = self.frame.size.height/2.0 - self.ibImageViewHeightConstraint.constant + 2 * SCREEN_OFFSET_Y;
        self.ibTopLabelTopSpaceConstraint.constant = self.frame.size.height/2.0 - self.ibImageView.frame.size.height - 50.0;
    }else{
        self.ibImageViewCenterAlignmentXConstraint.constant = 0.0;
        self.ibImageViewCenterAlignmentYConstraint.constant = 0.0;
        self.ibTopLabelTopSpaceConstraint.constant = 20.0;

        if (IS_IPHONE_4_OR_LESS && (self.tutorialType == kTutorialViewTypeCompare)) {
            self.ibImageViewCenterAlignmentYConstraint.constant = 30.0;
        }
    }
    [super layoutSubviews];
}


#pragma mark Gesture Methods
- (void)onTapAction:(UIGestureRecognizer *)gestureRecognizer{

    if((self.tutorialType == kTutorialViewTypeRotate) || (self.tutorialType == kTutorialViewTypePayScale)) {
        
        __weak STTutorialView *weakSelf = self;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.alpha = 0.0;
        } completion:^(BOOL finished) {
            weakSelf.hidden = YES;
        }];
    }

    if(self.tutorialActionBlock) {
        self.currentIndex++;
        NSNumber *nextIndex = [NSNumber numberWithInteger:self.currentIndex];
        self.tutorialActionBlock(nextIndex);
    }
} */

- (IBAction)onOKButtonAction:(id)sender {
    
    if(self.tutorialActionBlock) {
        self.currentIndex++;
        NSNumber *nextIndex = [NSNumber numberWithInteger:self.currentIndex];
        self.tutorialActionBlock(nextIndex);
    }
}

- (void)dealloc{
    STLog(@"Dealloc");
}
@end
