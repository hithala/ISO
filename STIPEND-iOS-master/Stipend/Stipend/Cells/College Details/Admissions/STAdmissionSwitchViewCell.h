//
//  STAdmissionSwitchViewCell.h
//  CollectionViewTableViewCell
//
//  Created by mahesh on 02/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STAdmissionsSwitchView.h"
#import "STCItem.h"

@interface STAdmissionSwitchViewCell : UITableViewCell

@property (strong, nonatomic) STAdmissionsSwitchView *admissionsSwitchView;

- (void)updateCellWithDetails:(STCItem *)item;

@end
