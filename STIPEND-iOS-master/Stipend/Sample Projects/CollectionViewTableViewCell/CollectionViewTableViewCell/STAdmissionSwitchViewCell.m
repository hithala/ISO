//
//  STAdmissionSwitchViewCell.m
//  CollectionViewTableViewCell
//
//  Created by mahesh on 02/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAdmissionSwitchViewCell.h"

@implementation STAdmissionSwitchViewCell

+(STAdmissionSwitchViewCell *)loadFromNib {
    STAdmissionSwitchViewCell *cell = (STAdmissionSwitchViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"STAdmissionSwitchViewCell" owner:self options:nil] lastObject];
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    NSLog(@"STAdmissionSwitchViewCell");
}

@end
