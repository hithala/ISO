//
//  STAddressCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 01/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STAddressCell.h"

@implementation STAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellSeparatorHeightConstraint.constant = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
}

@end
