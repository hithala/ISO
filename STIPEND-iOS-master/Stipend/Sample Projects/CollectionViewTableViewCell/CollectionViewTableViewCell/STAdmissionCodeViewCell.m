//
//  STAdmissionCodeViewCell.m
//  CollectionViewTableViewCell
//
//  Created by mahesh on 01/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STAdmissionCodeViewCell.h"

@implementation STAdmissionCodeViewCell

+(STAdmissionCodeViewCell *)loadFromNib {
    STAdmissionCodeViewCell *cell = (STAdmissionCodeViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"STAdmissionCodeViewCell" owner:self options:nil] lastObject];
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
    NSLog(@"STAdmissionCodeViewCell");
}

@end
