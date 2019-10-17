//
//  STSportsListView.h
//  SwitchDemo
//
//  Created by mahesh on 19/06/15.
//  Copyright (c) 2015 Tarun Tyagi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STSportsListView : UIView

@property (weak, nonatomic) IBOutlet UILabel *ibLeftLabel;
@property (weak, nonatomic) IBOutlet UIView *ibLeftCellSeparatorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorViewHeightConstraint;

@end
