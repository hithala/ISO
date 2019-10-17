//
//  STUserDetailsViewCell.h
//  SwitchDemo
//
//  Created by mahesh on 14/05/15.
//  Copyright (c) 2015 Tarun Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STUserDetailsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *ibUserProfileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ibUserEmailLabelValue;
@property (weak, nonatomic) IBOutlet UIView *ibOverlayView;
@end
