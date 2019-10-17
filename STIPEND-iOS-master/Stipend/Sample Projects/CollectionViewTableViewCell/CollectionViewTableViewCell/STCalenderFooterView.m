//
//  STCalenderFooterView.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 25/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STCalenderFooterView.h"

@implementation STCalenderFooterView

+(STCalenderFooterView *)loadFromNib {
    STCalenderFooterView *cell = (STCalenderFooterView *)[[[NSBundle mainBundle] loadNibNamed:@"STCalenderFooterView" owner:self options:nil] lastObject];
    return cell;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)onAddDateButtonAction:(id)sender {
}
@end
