//
//  STClippingsCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 27/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STClippingsItem.h"
#import "STClippingSectionItem.h"

@interface STClippingsCell : UITableViewCell

@property (nonatomic, retain) STClippingSectionItem *clippingItem;
@property (nonatomic, retain) NSIndexPath *currentIndexPath;

@property (copy, nonatomic) void (^clippingTapActionBlock)(NSIndexPath *indexPath);

- (void)updateCellWithDetails:(STClippingsItem *)clippingsItem forIndexPath:(NSIndexPath *)indexPath;

@end
