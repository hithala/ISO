//
//  STAdmissionsSwitchView.h
//  Stipend
//
//  Created by Ganesh Kumar on 19/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCItem.h"

@interface STAdmissionsSwitchView : UIView

@property (weak, nonatomic) IBOutlet UILabel                                   *ibLabelValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint       *ibLabelLeadingSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView                             *ibSeparatorLineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint            *badgeViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView                             *badgeImageView;
@property (weak, nonatomic) IBOutlet UILabel                                     *badgeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint       *cellSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorLeadingSpaceConstraint;

- (void)updateViewWithdetails:(STCItem *)item withFontType:(NSInteger)fontType;



@end
