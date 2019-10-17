//
//  STCalenderViewCell.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 04/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCalenderViewCell.h"

@implementation STCalenderViewCell

+(STCalenderViewCell *)loadFromNib {
    STCalenderViewCell *cell = (STCalenderViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"STCalenderViewCell" owner:self options:nil] objectAtIndex:0];
    return cell;
}

- (IBAction)onDateButtonTapped:(id)sender{
    self.didDateAddedActionBlock();
    //UIButton *button = (UIButton *)sender;
    //NSLog(@"onDateButtonTapped: %ld",button.tag);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    NSLog(@"Dealloc");
    self.didDateAddedActionBlock = nil;
}

@end
