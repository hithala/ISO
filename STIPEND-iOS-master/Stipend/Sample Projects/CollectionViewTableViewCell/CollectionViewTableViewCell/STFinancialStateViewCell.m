//
//  STFinancialStateViewCell.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 11/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFinancialStateViewCell.h"

@implementation STFinancialStateViewCell
@synthesize onButtonActionBlock;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onButtonAction:(id)sender {
    onButtonActionBlock(sender);
}
@end
