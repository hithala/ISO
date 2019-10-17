//
//  SeeMoreCell.h
//  StipendTesting
//
//  Created by Youflik33 on 5/30/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeeMoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *ibTapButton;

- (IBAction)clickAction:(UIButton *)sender;

@property (nonatomic, copy) void (^clickActionBlock)(NSInteger tag);

@end
