//
//  STSeeMoreCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 5/30/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STSeeMoreCell.h"

@implementation STSeeMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.topCellSeparatorHeightConstraint.constant = 0.5;
    self.bottomCellSeparatorHeightConstraint.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)clickAction:(UIButton *)sender {
    self.clickActionBlock(sender.tag);
}

- (void)dealloc {
    self.clickActionBlock = nil;
}

@end
