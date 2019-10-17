//
//  STImportantDateDetailView.m
//  CollectionViewTableViewCell
//
//  Created by Mahesh A on 25/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STImportantDateDetailView.h"

#define DAY_LABEL_HEIGHT_CONSTANT 44.0

@implementation STImportantDateDetailView

@synthesize dayLabel, monthLabel, button;

- (id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]){
        
        dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - DAY_LABEL_HEIGHT_CONSTANT)];
        dayLabel.backgroundColor = [UIColor whiteColor];
        dayLabel.text = @"1";
        dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dayLabel];
        
        monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dayLabel.frame.origin.y + dayLabel.frame.size.height, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(dayLabel.frame))];
        monthLabel.backgroundColor = [UIColor redColor];
        monthLabel.text = @"JUNE";
        monthLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:monthLabel];
        
        button = [[UIButton alloc] initWithFrame:self.bounds];
        [button addTarget:self action:@selector(onButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        return self;
    }
    return nil;
}

- (void)onButtonAction:(UIButton *)sender{
    // didDateAddedActionBlock();
}

@end
