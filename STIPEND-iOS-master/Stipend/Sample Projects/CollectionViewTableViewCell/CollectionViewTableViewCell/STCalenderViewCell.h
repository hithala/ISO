//
//  STCalenderViewCell.h
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 04/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCalenderViewCell : UITableViewCell

@property (nonatomic, strong) void (^didDateAddedActionBlock)();

+(STCalenderViewCell *)loadFromNib;
- (IBAction)onDateButtonTapped:(id)sender;

@end
