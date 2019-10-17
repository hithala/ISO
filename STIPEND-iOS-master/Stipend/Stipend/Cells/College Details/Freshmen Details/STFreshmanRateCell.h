//
//  STFreshmanRateCell.h
//  Stipend
//
//  Created by Ganesh kumar on 07/02/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STFreshmanRateView.h"
#import "STCFreshmanGraduationDetails.h"

@interface STFreshmanRateCell : UITableViewCell

@property (nonatomic,weak) IBOutlet STFreshmanRateView    *ratesView;

- (void) updateRatesPercentageWithDetails:(STCFreshmanGraduationDetails *) details forType:(FreshmenItem) type;

@property (nonatomic, copy) void (^imageClickActionBlock)(UIImageView* questionMarkview);

@end
