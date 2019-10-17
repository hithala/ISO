//
//  STNavigationtitle.m
//  Stipend
//
//  Created by Ganesh Kumar on 24/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STNavigationtitle.h"

@implementation STNavigationtitle

- (void) updateNavigationTitleWithCollegeName:(NSString *)collegeName andPlace:(NSString *) place {

    NSAttributedString *nameAttributedString;
    
    @try {
        nameAttributedString = [[NSAttributedString alloc] initWithString:collegeName
                                                                                   attributes:[NSDictionary dictionaryWithObject:
                                                                                               [UIFont fontType:eFontTypeAvenirMedium FontForSize:16.0]
                                                                                                                          forKey:NSFontAttributeName]];
        
    }
    @catch (NSException *exception) {
        STLog(@"%@", exception);
    };
    
    CGFloat maxWidth = 0.0;
    
    if(self.isPresenting) {
        maxWidth = [[UIScreen mainScreen] bounds].size.width - 50.0;
    }
    else {
        // 70% of navigation bar width is navigation title view
        maxWidth = [[UIScreen mainScreen] bounds].size.width * 0.70;
    }
    
    CGFloat collegeNameWidth;
    
    @try {
        collegeNameWidth = [self getWidthForCollegeName:collegeName];
    }
    @catch (NSException *exception) {
        STLog(@"%@", exception);
    };
    
    collegeNameWidth += 2;
    NSAttributedString *placeAttributedString;
    
    @try {
        if(collegeNameWidth < maxWidth) {
            placeAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", place]
                                                                    attributes:[NSDictionary dictionaryWithObject:
                                                                                [UIFont fontType:eFontTypeAvenirRoman FontForSize:14.0]
                                                                                                           forKey:NSFontAttributeName]];
        }
        else {
            placeAttributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@", place]
                                                                    attributes:[NSDictionary dictionaryWithObject:
                                                                                [UIFont fontType:eFontTypeAvenirRoman FontForSize:14.0]
                                                                                                           forKey:NSFontAttributeName]];
        }
    }
    @catch (NSException *exception) {
        STLog(@"%@", exception);
    };
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:nameAttributedString];
    [attributedString appendAttributedString:placeAttributedString];
    
    [self.collegeName setAttributedText:attributedString];
}

- (CGFloat) getWidthForCollegeName:(NSString *) collegeName {
    
    CGFloat width = 0.0;
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:collegeName
                                                                         attributes:@{NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:16.0]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, 44.0}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    width = ceilf(size.width);
    
    return width;
}

@end
