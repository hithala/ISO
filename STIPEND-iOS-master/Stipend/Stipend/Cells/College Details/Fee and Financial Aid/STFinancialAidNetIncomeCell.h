//
//  STFinancialAidNetIncomeCell.h
//  Stipend
//
//  Created by Ganesh kumar on 12/07/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCHouseholdIncome.h"

@interface STFinancialAidNetIncomeCell : UITableViewCell

@property (nonatomic, retain) NSOrderedSet *netHouseholdIncome;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topSeparatorViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomSeparatorViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *endSeparatorViewHeightConstraint;

- (void)updateWithNetIncomeDetails:(NSOrderedSet *)netHouseHoldIncomeDetails;

@property (nonatomic, weak) IBOutlet UIImageView* questionmarkView;

@property (nonatomic, copy) void (^imageClickActionBlock)(UIImageView* questionMarkview, CGRect imageViewRect, int position);

@end
