//
//  STSportsMascotCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 23/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSportsMascotCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel                               *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel                               *valueLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorHeightConstraint;

@end
