//
//  STClippingsSectionView.h
//  Stipend
//
//  Created by Ganesh Kumar on 28/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STClippingsSectionView : UIView


@property (weak, nonatomic) IBOutlet UIImageView                  *ibSectionHeaderIcon;
@property (weak, nonatomic) IBOutlet UILabel                      *ibSectionHeaderName;
@property (weak, nonatomic) IBOutlet UIImageView                 *ibSectionHeaderArrow;
@property (weak, nonatomic) IBOutlet UIButton                             *ibTapButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView                             *viewSeparator;

@property (weak, nonatomic) IBOutlet UIView                          *payScaleRankView;
@property (weak, nonatomic) IBOutlet UILabel                            *payScaleLabel;

@property (weak, nonatomic) IBOutlet UIView                            *backgroundView;
@property (weak, nonatomic) IBOutlet UIView                               *overlayView;

- (IBAction)clickAction:(UIButton *)sender;

@property (nonatomic, copy) void (^clickActionBlock)(NSInteger tag);
@property (nonatomic, copy) void (^deleteActionBlock)(NSInteger tag);
@property (nonatomic, copy) void (^removeActionBlock)(NSInteger tag);

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteIconLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteIconWidthConstraint;

- (IBAction)deleteIconAction:(id)sender;
- (IBAction)removeButtonAction:(id)sender;

@end
