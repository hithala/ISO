//
//  CustomTextView.m
//  Stipend
//
//  Created by Ganesh Kumar on 24/04/19.
//  Copyright © 2019 Sourcebits. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [self resignFirstResponder];
    return NO;
}

@end
