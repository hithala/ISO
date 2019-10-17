//
//  STFreshmenReligiousCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 10/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFreshmenReligiousCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel                             *ibReligiousLabel;
@property (weak, nonatomic) IBOutlet UILabel                             *ibReligiousValue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startingSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint   *endingSeparatorHeightConstraint;


@end
