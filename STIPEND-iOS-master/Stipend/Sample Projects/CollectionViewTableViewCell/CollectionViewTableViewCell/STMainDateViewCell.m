//
//  STMainDateViewCell.m
//  CollectionViewTableViewCell
//
//  Created by mahesh on 03/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STMainDateViewCell.h"

@implementation STMainDateViewCell

+(STMainDateViewCell *)loadFromNib {
    STMainDateViewCell *cell = (STMainDateViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"STMainDateViewCell" owner:self options:nil] objectAtIndex:0];
    return cell;
}

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
