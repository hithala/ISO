//
//  STSportsDivisionTitleView.h
//  Stipend
//
//  Created by Mahesh on 22/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSportsDivisionTitleView : UIView


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *cellSeparatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorViewHeightConstraint;

@end
