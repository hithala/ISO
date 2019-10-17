//
//  UIImageView+Additions.m
//  Stipend
//
//  Created by Arun S on 12/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView(Additions)

- (void) applyRoundedBorderWithBakgroundColor:(UIColor *) color {
    
    self.backgroundColor = color;
    self.layer.cornerRadius = 6.0;
}


@end
