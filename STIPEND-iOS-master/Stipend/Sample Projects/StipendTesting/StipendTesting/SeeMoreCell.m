//
//  SeeMoreCell.m
//  StipendTesting
//
//  Created by Youflik33 on 5/30/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "SeeMoreCell.h"

@implementation SeeMoreCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickAction:(UIButton *)sender {
    self.clickActionBlock(sender.tag);
}

@end
