//
//  STDefaultCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 15/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STDefaultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint       *cellSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorLeadingSpaceConstraint;

@property (weak, nonatomic) IBOutlet UILabel                               *ibCellTitleLabel;

@end
