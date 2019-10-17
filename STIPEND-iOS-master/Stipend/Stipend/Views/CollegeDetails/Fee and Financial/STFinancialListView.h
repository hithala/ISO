//
//  STFinancialListView.h
//  Stipend
//
//  Created by Ganesh Kumar on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFinancialListView : UIView


@property (nonatomic, weak) IBOutlet UILabel                             *ibLabelField;
@property (nonatomic, weak) IBOutlet UILabel                             *ibLabelValue;
@property (weak, nonatomic) IBOutlet UIView                           *ibSeparatorLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorHeightConstraint;

@property (nonatomic, strong) UIImageView *questionmarkView;

- (void)updatQuestionMarkView;

@property (nonatomic, copy) void (^imageClickActionBlock)(UIImageView* questionMarkview);


@end
