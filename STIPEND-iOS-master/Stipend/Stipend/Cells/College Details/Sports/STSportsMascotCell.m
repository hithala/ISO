//
//  STSportsMascotCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 23/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STSportsMascotCell.h"

@implementation STSportsMascotCell

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
