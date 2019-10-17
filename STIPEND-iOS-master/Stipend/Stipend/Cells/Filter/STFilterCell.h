//
//  STFilterCell.h
//  Stipend
//
//  Created by Arun S on 19/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFilterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidthConstraint;
@property (nonatomic,retain) NSIndexPath  *cellIndexPath;

- (void)updateTitleFontIfNeeded;

@end
