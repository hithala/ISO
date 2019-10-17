//
//  STBroadMajorCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 18/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STBroadMajorCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *topSeparatorView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomSeparatorViewLeadingConstraint;

@end
