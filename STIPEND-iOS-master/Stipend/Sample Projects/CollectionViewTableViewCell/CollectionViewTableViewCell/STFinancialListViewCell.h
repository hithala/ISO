//
//  STFinancialListViewCell.h
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 11/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFinancialListViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *ibLabelField;
@property(nonatomic, strong) IBOutlet UILabel *ibLabelValue;
@property (weak, nonatomic) IBOutlet UIView *ibSeparatorLine;

@end
