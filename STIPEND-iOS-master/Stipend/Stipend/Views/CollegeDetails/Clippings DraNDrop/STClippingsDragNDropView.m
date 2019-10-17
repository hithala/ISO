//
//  STClippingsDragNDropView.m
//  Stipend
//
//  Created by Arun S on 05/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STClippingsDragNDropView.h"
#import "STCollegeSectionHeaderView.h"

#define KEY_LABEL                       @"kLabelKey"
#define KEY_VALUE                       @"kValueKey"
#define KEY_EXPAND                      @"kExpandKey"
#define TILE_CLOSE                      @"tile_close"
#define TILE_OPEN                       @"tile_open"
#define KEY_ICON                        @"kIconKey"

#define KEY_COLLEGE_ID                  @"kCollegeIDKey"
#define KEY_COLLEGE_NAME                @"kCollegeNameKey"

#define SECTION_HEIGHT                  60.0

@implementation STClippingsDragNDropView

- (void) awakeFromNib {

    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
    
    self.clippingLabel.text = @"Drop here to save to Clippings";
    self.clippingImageView.image = [UIImage imageNamed:@"drop_clippings"];
    self.clippingDropView.backgroundColor = [UIColor whiteColor];
    
    self.sectionDragView = (STCollegeSectionHeaderView *)[[NSBundle mainBundle] loadNibNamed:@"STCollegeSectionHeaderView" owner:self options:nil][0];
    self.sectionDragView.longPressGesture = nil;
    self.sectionDragView.backgroundColor = [UIColor whiteColor];
    self.sectionDragView.ibTapButton.enabled = NO;
    [self addSubview:self.sectionDragView];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestureAction:)];
    self.panGesture.delegate = self;
    self.panGesture.minimumNumberOfTouches = 1;
    self.panGesture.maximumNumberOfTouches = 1;
    [self.sectionDragView addGestureRecognizer:self.panGesture];

    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGestureAction:)];
    [self.tapGesture setNumberOfTapsRequired:1];
    [self.tapGesture setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:self.tapGesture];
}

- (void) onTapGestureAction:(UITapGestureRecognizer *) gestureRecognizer {

    if(self.cancelActionBlock) {
        self.cancelActionBlock();
    }

    STClippingsDragNDropView *weakSelf = self;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (void)onPanGestureAction:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        [self performFinishAnimation];
    }
    else {
        
        CGPoint translation = [gestureRecognizer translationInView:self];
        CGFloat screenHeight = self.frame.size.height;
        
        CGFloat yMinOrigin = self.sectionDragView.frame.origin.y;
        CGFloat yMaxOrigin = (self.sectionDragView.frame.origin.y + self.sectionDragView.frame.size.height);
        
        if(yMinOrigin >= 0.0 && (yMaxOrigin <= screenHeight)) {
            
            CGPoint secctionPosition = self.sectionDragView.center;
            secctionPosition.y += translation.y;
            self.sectionDragView.center = secctionPosition;
        }
        else {
            
            CGRect sectionFrame = self.sectionDragView.frame;
            if(yMinOrigin <= 0.0) {
                sectionFrame.origin.y = 0.0;
            }
            else if(yMaxOrigin >= screenHeight) {
                sectionFrame.origin.y =  (screenHeight - 60.0);
            }

            self.sectionDragView.frame = sectionFrame;
        }
        
        [gestureRecognizer setTranslation:CGPointZero inView:self];
    }
}

- (void) performFinishAnimation {
    
    __weak STClippingsDragNDropView *weakSelf = self;
    
    CGRect dropViewFrame = [self.clippingDropView frame];
    CGRect dragViewFrame = [self.sectionDragView frame];
    CGPoint dragPoint = CGPointMake(dragViewFrame.origin.x, (dragViewFrame.origin.y + dragViewFrame.size.height)) ;
    
    if(CGRectContainsPoint(dropViewFrame, dragPoint)) {
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            CGRect dropArea = self.sectionDragView.frame;
            dropArea.origin.y = (self.clippingDropView.frame.origin.y + self.clippingDropView.frame.size.height);
            
            weakSelf.sectionDragView.frame = dropArea;
            weakSelf.sectionDragView.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            self.clippingLabel.text = @"Dropped to Clippings";
            self.clippingImageView.image = [UIImage imageNamed:@"drop_confirm"];

            
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                weakSelf.alpha = 0.0;
            } completion:^(BOOL finished) {
                
                if(weakSelf.completeActionBlock) {
                    weakSelf.completeActionBlock(weakSelf.collegeSectionDetails);
                }

                [weakSelf removeFromSuperview];
            }];
        }];
    }
    else {
        [self resetAnimation];
    }
}

- (void) resetAnimation {

    __weak STClippingsDragNDropView *weakSelf = self;

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.sectionDragView.center = self.center;
    } completion:^(BOOL finished) {
    }];
}

- (void) setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    CGRect dragViewFrame = self.bounds;
    dragViewFrame.size.height = SECTION_HEIGHT;
    self.sectionDragView.frame = dragViewFrame;
    self.sectionDragView.center = self.center;
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
}

- (void) updateViewWithDetails:(NSMutableDictionary *) details {
    
    self.collegeSectionDetails = details;
    [self updateDragAndDropView];
}

- (void) updateDragAndDropView {
    
    NSString *sectionName = [self.collegeSectionDetails objectForKey:KEY_SECTION_NAME];
    NSString *sectionImageName = [self.collegeSectionDetails objectForKey:KEY_SECTION_ICON];
    
    BOOL isExpanded = [[self.collegeSectionDetails objectForKey:KEY_EXPAND] boolValue];
    
    if([sectionName isEqualToString:@"PayScale ROI Rank"]) {
        self.sectionDragView.payScaleRankView.hidden = NO;
        self.sectionDragView.payScaleRankView.backgroundColor = [UIColor whiteColor];
        self.sectionDragView.payScaleLabel.hidden = YES;
    }
    else {
        self.sectionDragView.payScaleRankView.hidden = YES;
    }
    
    self.sectionDragView.ibTapButton.enabled = NO;
    self.sectionDragView.ibSectionHeaderName.text = sectionName;
    self.sectionDragView.ibSectionHeaderIcon.image = [UIImage imageNamed:sectionImageName];
    
    if(isExpanded) {
        self.sectionDragView.overlayView.hidden = YES;
        self.sectionDragView.ibSectionHeaderArrow.image = [UIImage imageNamed:TILE_CLOSE];
    }
    else {
        self.sectionDragView.overlayView.hidden = NO;
        self.sectionDragView.ibSectionHeaderArrow.image = [UIImage imageNamed:TILE_OPEN];
    }
}

- (void)dealloc {
    
    self.sectionDragView = nil;
    self.collegeSectionDetails = nil;
    
    [self removeGestureRecognizer:self.tapGesture];
    [self removeGestureRecognizer:self.panGesture];
}

@end
