//
//  STProfileDetailsViewCell.h
//  Stipend
//
//  Created by Mahesh A on 19/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STProfileDetailsViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *ibLabelField;
@property (nonatomic, weak) IBOutlet UILabel *ibDetailedLabelField;
@property (weak, nonatomic) IBOutlet UIView *ibSeparatorView;

@end
