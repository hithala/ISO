//
//  STFinancialDetailsCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCollegeSegmentControl.h"

@interface STFinancialDetailsCell : UITableViewCell <STSegmentControlDelegate>

@property (nonatomic, retain) STCFeesAndFinancialAid *feeAndFinancialDetails;
@property (nonatomic,assign)  NSUInteger                    selectedIndex;

@property (nonatomic, copy) void (^toggleAction)(void);

@property (nonatomic, copy) void (^imageClickActionBlock)(UIImageView* questionMarkview, CGRect imageViewRect, int position, FinancialAidItem type);

- (void)updateFeeAndFinancialWithDetails:(STCFeesAndFinancialAid *)details;

@end
