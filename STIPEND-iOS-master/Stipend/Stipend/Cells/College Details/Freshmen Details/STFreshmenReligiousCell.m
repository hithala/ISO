//
//  STFreshmenReligiousCell.m
//  Stipend
//
//  Created by Ganesh Kumar on 10/06/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "STFreshmenReligiousCell.h"

@implementation STFreshmenReligiousCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.startingSeparatorHeightConstraint.constant = 0.5f;
    self.endingSeparatorHeightConstraint.constant = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
}

@end
