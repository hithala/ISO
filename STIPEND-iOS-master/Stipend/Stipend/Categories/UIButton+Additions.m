//
//  UIButton+Additions.m
//  Stipend
//
//  Created by Arun S on 08/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "UIButton+Additions.h"

@implementation UIButton(Additions)

- (void) applyRoundedBorderWithBakgroundColor:(UIColor *) color {

    self.backgroundColor = color;
    self.layer.cornerRadius = 6.0;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.8] forState:UIControlStateHighlighted];
    [self setTintColor:[UIColor whiteColor]];
}

- (void) addUnderlineToButton {
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    [self setAttributedTitle:titleString forState:UIControlStateNormal];
}

@end
