//
//  STMyDetailsHeaderView.m
//  Stipend
//
//  Created by Mahesh A on 21/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STMyDetailsHeaderView.h"

@implementation STMyDetailsHeaderView
@synthesize headerViewButtonActionBlock;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.ibLabelField.textColor = [UIColor cellLabelTextColor];
    self.ibLabelValue.textColor = [UIColor cellTextFieldTextColor];
    
    self.ibLabelField.font = [UIFont fontType:eFontTypeAvenirBook FontForSize:16.0f];
    self.ibLabelValue.font = [UIFont fontType:eFontTypeAvenirRoman FontForSize:16.0f];
}

- (IBAction)headerViewButtonAction:(id)sender {
    
    if(self.headerViewButtonActionBlock) {
        self.headerViewButtonActionBlock();
    }
}

- (void)dealloc {

    self.headerViewButtonActionBlock = nil;
}

@end
