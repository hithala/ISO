//
//  STHintPopUpView.m
//  Stipend
//
//  Created by Ganesh kumar on 11/07/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import "STHintPopUpView.h"

@implementation STHintPopUpView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGPoint startPoint = CGPointMake(0, 10);
    CGPoint centerPoint = CGPointMake(10, 0);
    CGPoint endPoint = CGPointMake(20, 10);
    
    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:startPoint];
    [trianglePath addLineToPoint:centerPoint];
    [trianglePath addLineToPoint:endPoint];
    [trianglePath closePath];
    
    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];
    
//    UIView *anchorView = [[UIView alloc] initWithFrame:CGRectMake(((self.bounds.size.width/2) - 1), 0, 20, 10)];
    
    UIView *anchorView = [[UIView alloc] initWithFrame:CGRectMake(self.imageviewXPosition, 0, 20, 10)];

    anchorView.backgroundColor = [UIColor aquaColorWithAlpha:0.95];
    anchorView.layer.mask = triangleMaskLayer;
    
    [self addSubview:anchorView];
    
    UITapGestureRecognizer *gestureRecognition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    gestureRecognition.numberOfTapsRequired = 1;
    [self.backgroundView addGestureRecognizer:gestureRecognition];
}

- (void)handleTap:(UIGestureRecognizer*)tap {
    [self removeFromSuperview];
}

@end
