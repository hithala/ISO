//
//  STCollegeSectionHeaderView.h
//  Stipend
//
//  Created by Ganesh Kumar on 28/05/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCollegeSectionHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView                  *ibSectionHeaderIcon;
@property (weak, nonatomic) IBOutlet UILabel                      *ibSectionHeaderName;
@property (weak, nonatomic) IBOutlet UIImageView                 *ibSectionHeaderArrow;
@property (weak, nonatomic) IBOutlet UIButton                             *ibTapButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView                             *viewSeparator;

@property (weak, nonatomic) IBOutlet UIView                          *payScaleRankView;
@property (weak, nonatomic) IBOutlet UILabel                            *payScaleLabel;

@property (weak, nonatomic) IBOutlet UIView                               *overlayView;
@property (nonatomic,retain) UILongPressGestureRecognizer            *longPressGesture;

- (IBAction)clickAction:(UIButton *)sender;

@property (nonatomic, copy) void (^clickActionBlock)(NSInteger tag);
@property (nonatomic, copy) void (^longPressActionBlock)(NSInteger tag);

@end
