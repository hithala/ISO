//
//  STFilterStateCell.h
//  Stipend
//
//  Created by sourcebits on 06/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFilterStateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelField;
@property (weak, nonatomic) IBOutlet UIView *seperatorView;
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorViewTrailingConstraint;

@end
