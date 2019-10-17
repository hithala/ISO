//
//  UIColor+Additions.m
//  Stipend
//
//  Created by Arun S on 09/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor(Additions)

+ (UIColor *) aquaColor {
    return [UIColor colorWithRed:66.0/255.0 green:199.0/255.0 blue:218.0/255.0 alpha:1.0];
}

+ (UIColor *) aquaColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:66.0/255.0 green:199.0/255.0 blue:218.0/255.0 alpha:0.95];
}

+ (UIColor *) cellTextFieldTextColor {
    return [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0];
}

+ (UIColor *) cellLabelTextColor {
    return [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
}

+ (UIColor *) defaultCellUnderlineColor {
    return [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
}

+ (UIColor *) highlightedCellUnderlineColor {
    return [UIColor colorWithRed:77.0/255.0 green:208.0/255.0 blue:225.0/255.0 alpha:1.0];
}

+ (UIColor *) placeHolderTextColor {
    return [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:0.5];
}

+ (UIColor *) errorBGColor {
    return [UIColor colorWithRed:240.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0];
}

+ (UIColor *) rangeLabelColor {
    return [UIColor colorWithRed:0.0/255.0 green:113.0/255.0 blue:128.0/255.0 alpha:1.0];
}

+ (UIColor *) cursorColor {
    return [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:225.0/255.0 alpha:1.0];
}

+ (UIColor *) tutorialOverlayViewColor {
    return [UIColor colorWithRed:0.0/255.0 green:113.0/255.0 blue:128.0/255.0 alpha:1.0];
}

@end
