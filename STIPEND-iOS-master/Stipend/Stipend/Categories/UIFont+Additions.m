//
//  UIFont+Additions.m
//  Stipend
//
//  Created by Mahesh A on 02/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)fontType:(FontType)type FontForSize:(CGFloat)fontSize {
    
    switch (type) {
        case eFontTypeAvenirBook:
            return [self fontWithName:@"Avenir-Book" size:fontSize];
            break;
        case eFontTypeAvenirHeavy:
            return [self fontWithName:@"Avenir-Heavy" size:fontSize];
            break;
        case eFontTypeAvenirBookOblique:
            return [self fontWithName:@"Avenir-BookOblique" size:fontSize];
            break;
        case eFontTypeAvenirMedium:
            return [self fontWithName:@"Avenir-Medium" size:fontSize];
            break;
        case eFontTypeAvenirRoman:
            return [self fontWithName:@"Avenir-Roman" size:fontSize];
            break;
        case eFontTypeAvenirNextMedium:
            return [self fontWithName:@"AvenirNext-Roman" size:fontSize];
        case eFontTypeAvenirLight:
            return [self fontWithName:@"Avenir-Light" size:fontSize];
        default:
            break;
    }
}
@end
