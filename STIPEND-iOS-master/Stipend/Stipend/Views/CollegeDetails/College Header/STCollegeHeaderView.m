//
//  STCollegeHeaderView.m
//  Stipend
//
//  Created by Arun S on 23/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCollegeHeaderView.h"
#import "UIImageView+WebCache.h"


#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_VALUES_DICT                 @"kValuesDictKey"

#define KEY_ACCEPTANCE_KEY              @"kAcceptanceSummaryKey"
#define KEY_AVERAGE_ACT_KEY             @"kAverageACTSummaryKey"
#define KEY_AVERAGE_GPA_KEY             @"kAverageGPASummaryKey"
#define KEY_AVERAGE_SAT_KEY             @"kAverageSATSummaryKey"
#define KEY_FRESHMAN_KEY                @"kFreshmanSummaryKey"
#define KEY_TOTAL_UNDERGRADE_KEY        @"kTotalUnderGradsSummaryKey"

#define DEFAULT_HEADER_VIEW_HEIGHT      self.bounds.size.height
#define SUB_HEADER_HEIGHT               150.0

#define COLLEGE_TYPE_UNIVERSITY         @"summary_university"
#define COLLEGE_TYPE_COLLEGE            @"summary_college"
#define COLLEGE_TYPE_SCHOOL             @"summary_school"

#define COLLEGE_AREA_TYPE_CITY          @"summary_city"
#define COLLEGE_AREA_TYPE_TOWN          @"summary_town"
#define COLLEGE_AREA_TYPE_RURAL         @"summary_rural"

#define COLLEGE_ACCESS_TYPE_PUBLIC      @"summary_public"
#define COLLEGE_ACCESS_TYPE_PRIVATE     @"summary_private"


@implementation STCollegeHeaderView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    self.viewSeparatorHeightConstraint.constant = 0.5f;

    [self.collegeImageView setUserInteractionEnabled:YES];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    self.panGesture.delegate = self;
    self.panGesture.minimumNumberOfTouches = 1;
    self.panGesture.maximumNumberOfTouches = 1;
//    [self.collegeImageView addGestureRecognizer:self.panGesture];
    
    
    if(IS_IPHONE_5) {
        self.placeholderImageTopConstraint.constant = 25;
        self.activityIndicatorViewTopConstraint.constant = 25;
    }
}

- (void) setFrame:(CGRect)frame {
    
    CGRect headerFrame = frame;
    
    if(self.headerViewHeight > 0.0) {
        headerFrame.size.height = self.headerViewHeight;
    }
    
    [super setFrame:headerFrame];
}

- (void)toggleSumaryViewWithAnimation:(BOOL)animation {
    
    self.isSummaryHidden = !self.isSummaryHidden;
    
    if(self.isSummaryHidden) {
        self.summaryViewHeightConstraint.constant = 0.0;
    }
    else {
        self.summaryViewHeightConstraint.constant = 150.0;
    }

    if(animation) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [self layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                         }];
    }
    else {
        [self layoutIfNeeded];
    }
}

- (void) onPanGesture:(UIPanGestureRecognizer *) gesture {
        
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
        case UIGestureRecognizerStateChanged: {
            switch (direction) {
                case UIPanGestureRecognizerDirectionUp: {
                    [self handleUpwardsGesture:gesture];
                    break;
                }
                case UIPanGestureRecognizerDirectionDown: {
                    [self handleDownwardsGesture:gesture];
                    break;
                }
                case UIPanGestureRecognizerDirectionLeft: {
                    [self handleLeftGesture:gesture];
                    break;
                }
                case UIPanGestureRecognizerDirectionRight: {
                    [self handleRightGesture:gesture];
                    break;
                }
                default: {
                    break;
                }
            }
        }
        case UIGestureRecognizerStateEnded: {
            direction = UIPanGestureRecognizerDirectionUndefined;
            break;
        }
        default:
            break;
    }
}

- (void)handleUpwardsGesture:(UIPanGestureRecognizer *)sender {
    
    if(self.isSummaryHidden) {
        [self toggleSumaryViewWithAnimation:YES];
    }
}

- (void)handleDownwardsGesture:(UIPanGestureRecognizer *)sender {
    
    if(!self.isSummaryHidden) {
        [self toggleSumaryViewWithAnimation:YES];
    }
}

- (void)handleLeftGesture:(UIPanGestureRecognizer *)sender {
}

- (void)handleRightGesture:(UIPanGestureRecognizer *)sender {
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if([gestureRecognizer isEqual:self.panGesture]) {

        CGPoint velocity = [self.panGesture velocityInView:self];
        
        BOOL isVerticalGesture = fabs(velocity.y) > fabs(velocity.x);
        
        if (isVerticalGesture) {
            if (velocity.y > 0) {
                direction = UIPanGestureRecognizerDirectionDown;
            } else {
                direction = UIPanGestureRecognizerDirectionUp;
            }
        }
        
        else {
            if (velocity.x > 0) {
                direction = UIPanGestureRecognizerDirectionRight;
            } else {
                direction = UIPanGestureRecognizerDirectionLeft;
            }
        }
        
        if((self.isSummaryHidden) && (direction == UIPanGestureRecognizerDirectionUp)) {
            self.shouldAllowScroll = YES;
        }
        else if((!self.isSummaryHidden) && (direction == UIPanGestureRecognizerDirectionDown)) {
            self.shouldAllowScroll = YES;
        }
        else {
            self.shouldAllowScroll = NO;
        }
    }

    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return !self.shouldAllowScroll;
}

- (IBAction)onReorderAction:(id)sender {
    
    if(self.reorderActionBlock) {
        self.reorderActionBlock();
    }
}

/*
- (IBAction)onShareAction:(id)sender {
    
    if(self.shareActionBlock) {
        self.shareActionBlock();
    }
}
*/

- (IBAction)onSortAction:(id)sender {
    
    if(self.sortActionBlock) {
        self.sortActionBlock();
    }
}

- (IBAction)onCompareAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if(btn.selected) {
        btn.selected = NO;
    } else {
        btn.selected = YES;
    }
    
    if(self.compareActionBlock) {
        self.compareActionBlock();
    }
}

- (IBAction)onFavoriteAction:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if(btn.selected) {
        btn.selected = NO;
    } else {
        btn.selected = YES;
    }
    
    if(self.favoriteActionBlock) {
        self.favoriteActionBlock();
    }
}

- (void)updateCollegeSummaryForCollegeID:(NSNumber *)collegeID {
    
    STCollege *college = [STCollege MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"collegeID == %@", collegeID]];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if((![self isNullValueForObject:college.logoPath]) && [self isValidObject:college.logoPath]){
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@", COLLEGE_LOGO_BASE_URL, college.logoPath];
        
        [self.activityIndicatorView startAnimating];
        
        
        __weak STCollegeHeaderView *weakSelf = self;
        [self.collegeImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            weakSelf.collegeImageView.image = image;
            [weakSelf.activityIndicatorView stopAnimating];
            
            
        }];
        
    } else {
        self.collegeImageView.image = nil;
    }
    
    if((![self isNullValueForObject:college.totalFreshmens]) && [self isValidObject:college.totalFreshmens]){
       self.ibFreshmen.text = [formatter stringFromNumber:college.totalFreshmens];
    } else {
        self.ibFreshmen.text = @"N/A";
    }
    
    if((![self isNullValueForObject:college.totalUndergrads]) && [self isValidObject:college.totalUndergrads]){
        self.ibTotalUndergrads.text = [formatter stringFromNumber:college.totalUndergrads];
    } else {
        self.ibTotalUndergrads.text = @"N/A";
    }
    
    if((![self isNullValueForObject:college.acceptanceRate]) && [self isValidObject:college.acceptanceRate]){
        self.ibAcceptance.text = [NSString stringWithFormat:@"%.1f%%", [college.acceptanceRate floatValue]];
    } else {
        self.ibAcceptance.text = @"N/A";
    }
    
    if((![self isNullValueForObject:college.averageGPA]) && [self isValidObject:college.averageGPA]){
        self.ibAverageGPA.text = [NSString stringWithFormat:@"%.2f", [college.averageGPA floatValue]];
    } else {
        self.ibAverageGPA.text = @"N/A";
    }
    
    if((![self isNullValueForObject:college.averageSATNew]) && [self isValidObject:college.averageSATNew]){
        
        self.ibAverageSAT.text = [NSString stringWithFormat:@"%@", college.averageSATNew];
    } else {
        self.ibAverageSAT.text = @"N/A";
    }
    
    if((![self isNullValueForObject:college.averageACT]) && [self isValidObject:college.averageACT]){
        self.ibAverageACT.text = [college.averageACT stringValue];
    } else {
        self.ibAverageACT.text = @"N/A";
    }
    
    if(![self isNullValueForObject:college.collegeType]) {
        
        if([college.collegeType integerValue] == eCollegeTypeUniversity) {
            [self.collegeTypeImage setImage:[UIImage imageNamed:COLLEGE_TYPE_UNIVERSITY] forState:UIControlStateNormal];
            self.collegeTypeLabel.text = @"University";
        } else if([college.collegeType integerValue] == eCollegeTypeCollege) {
            [self.collegeTypeImage setImage:[UIImage imageNamed:COLLEGE_TYPE_COLLEGE] forState:UIControlStateNormal];
            self.collegeTypeLabel.text = @"College";
        } else if([college.collegeType integerValue] == eCollegeTypeSchool) {
            [self.collegeTypeImage setImage:[UIImage imageNamed:COLLEGE_TYPE_SCHOOL] forState:UIControlStateNormal];
            self.collegeTypeLabel.text = @"School";
        }
    }
    
    
    if(![self isNullValueForObject:college.collegeAreaType]) {
        
        if([college.collegeAreaType integerValue] == eCollegeAreaTypeCity) {
            [self.collegeAreaTypeImage setImage:[UIImage imageNamed:COLLEGE_AREA_TYPE_CITY] forState:UIControlStateNormal];
            self.collegeAreaTypeLabel.text = @"City";
        } else if([college.collegeAreaType integerValue] == eCollegeAreaTypeTown) {
            [self.collegeAreaTypeImage setImage:[UIImage imageNamed:COLLEGE_AREA_TYPE_TOWN] forState:UIControlStateNormal];
            self.collegeAreaTypeLabel.text = @"Town";
        } else if([college.collegeAreaType integerValue] == eCollegeAreaTypeRural) {
            [self.collegeAreaTypeImage setImage:[UIImage imageNamed:COLLEGE_AREA_TYPE_RURAL] forState:UIControlStateNormal];
            self.collegeAreaTypeLabel.text = @"Rural";
        }
    }
    
    if(![self isNullValueForObject:college.collegeAccessType]) {
        
        if([college.collegeAccessType integerValue] == eCollegeAccessTypePublic) {
            [self.collegeAccessTypeImage setImage:[UIImage imageNamed:COLLEGE_ACCESS_TYPE_PUBLIC] forState:UIControlStateNormal];
            self.collegeAccessTypeLabel.text = @"Public";
        } else if([college.collegeAccessType integerValue] == eCollegeAccessTypePrivate) {
            [self.collegeAccessTypeImage setImage:[UIImage imageNamed:COLLEGE_ACCESS_TYPE_PRIVATE] forState:UIControlStateNormal];
            self.collegeAccessTypeLabel.text = @"Private";
        }
    }
}

- (void) updateFavoriteButtonWithStatus:(BOOL) isFavorite {
    
    if(isFavorite) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"button_fav_remove"] forState:UIControlStateNormal];
        [self.favoriteButton setImage:[UIImage imageNamed:@"button_fav_remove"] forState:UIControlStateSelected];
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"button_fav"] forState:UIControlStateNormal];
        [self.favoriteButton setImage:[UIImage imageNamed:@"button_fav"] forState:UIControlStateSelected];
    }
}

- (void) updateCompareButtonWithStatus:(BOOL) isAddedToCompare {

    if(isAddedToCompare) {
        [self.compareButton setImage:[UIImage imageNamed:@"button_compare_remove"] forState:UIControlStateNormal];
        [self.compareButton setImage:[UIImage imageNamed:@"button_compare_remove"] forState:UIControlStateSelected];
    }
    else {
        [self.compareButton setImage:[UIImage imageNamed:@"button_compare"] forState:UIControlStateNormal];
        [self.compareButton setImage:[UIImage imageNamed:@"button_compare"] forState:UIControlStateSelected];
    }
}

- (BOOL) isNullValueForObject:(id) object {
    
    if(object && (![object isEqual:[NSNull null]])) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isValidObject:(id)object {
    
    if([object isKindOfClass:[NSNumber class]]) {
        if([object integerValue] == 0) {
            return NO;
        }
    }
    return YES;
}

- (void)dealloc {
    
    [self removeGestureRecognizer:self.panGesture];
    
    self.reorderActionBlock = nil;
   // self.shareActionBlock = nil;
    self.sortActionBlock = nil;
    self.compareActionBlock = nil;
    self.favoriteActionBlock = nil;
}

@end
