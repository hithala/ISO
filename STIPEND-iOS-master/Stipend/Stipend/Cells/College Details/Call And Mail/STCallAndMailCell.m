//
//  STCallAndMMailCell.h
//  Stipend
//
//  Created by Ganesh Kumar on 01/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//


#import "STCallAndMailCell.h"

@implementation STCallAndMailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellSeparatorHeightConstraint.constant = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)clickAction:(UIButton *)sender {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:self.tag];

    if([self.title isEqualToString:@"phone"]) {
        
        if(self.callActionBlock) {
            self.callActionBlock(indexPath);
        }
    }
    else {
        
        if(self.mailActionBlock) {
            self.mailActionBlock(indexPath);
        }
    }
}

- (void)dealloc {
    self.callActionBlock = nil;
    self.mailActionBlock = nil;
}

@end
