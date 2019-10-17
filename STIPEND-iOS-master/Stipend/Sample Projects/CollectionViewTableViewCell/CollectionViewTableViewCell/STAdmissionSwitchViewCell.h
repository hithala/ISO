//
//  STAdmissionSwitchViewCell.h
//  CollectionViewTableViewCell
//
//  Created by mahesh on 02/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAdmissionSwitchViewCell : UITableViewCell

+(STAdmissionSwitchViewCell *)loadFromNib;
@property (weak, nonatomic) IBOutlet UILabel *ibLabelValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibLabelLeadingSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *ibSeparatorLineView;

@end
