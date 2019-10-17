//
//  STCallAndMailCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 01/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCallAndMailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView                              *cellIcon;
@property (weak, nonatomic) IBOutlet UILabel                                 *cellTitle;
@property (weak, nonatomic) IBOutlet UIButton                              *clickButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint  *cellSeparatorHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorLeadingConstraint;

@property (nonatomic,retain) NSString                                            *title;

@property (copy, nonatomic) void (^callActionBlock)(NSIndexPath *indexPath);
@property (copy, nonatomic) void (^mailActionBlock)(NSIndexPath *indexPath);

- (IBAction)clickAction:(UIButton *)sender;

@end
