//
//  STFinancialTotalView.h
//  Stipend
//
//  Created by Ganesh Kumar on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFinancialTotalView : UIView

@property (weak, nonatomic) IBOutlet UILabel                           *totalFeesLabel;
@property (weak, nonatomic) IBOutlet UILabel                           *totalFeesValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorHeightConstraint;


@end
