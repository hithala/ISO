//
//  STClippingsDragNDropView.h
//  Stipend
//
//  Created by Arun S on 05/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STCollegeSectionHeaderView;

@interface STClippingsDragNDropView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,retain) UITapGestureRecognizer            *tapGesture;
@property (nonatomic,retain) UIPanGestureRecognizer            *panGesture;
@property (nonatomic,retain) NSMutableDictionary    *collegeSectionDetails;
@property (nonatomic,retain) STCollegeSectionHeaderView   *sectionDragView;

@property (nonatomic,weak) IBOutlet UIView               *clippingDropView;
@property (nonatomic,weak) IBOutlet UILabel                 *clippingLabel;
@property (nonatomic,weak) IBOutlet UIImageView         *clippingImageView;

@property (nonatomic, copy) void (^cancelActionBlock)(void);
@property (nonatomic, copy) void (^completeActionBlock)(NSMutableDictionary * details);

- (void) updateViewWithDetails:(NSMutableDictionary *) details;

@end
