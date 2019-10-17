//
//  CallAndMessageCell.h
//  StipendTesting
//
//  Created by Ganesh Kumar on 01/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallAndMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellIcon;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@property (copy, nonatomic) void (^clickActionBlock)(NSIndexPath *indexPath);

- (IBAction)clickAction:(UIButton *)sender;

@end
