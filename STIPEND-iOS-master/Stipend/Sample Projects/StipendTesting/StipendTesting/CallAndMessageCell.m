//
//  CallAndMessageCell.m
//  StipendTesting
//
//  Created by Ganesh Kumar on 01/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "CallAndMessageCell.h"

@implementation CallAndMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickAction:(UIButton *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:self.tag];
    self.clickActionBlock(indexPath);
}


@end
