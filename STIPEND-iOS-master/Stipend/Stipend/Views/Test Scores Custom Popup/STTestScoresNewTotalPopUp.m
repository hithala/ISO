//
//  STTestScoresNewTotalPopUp.m
//  Stipend
//
//  Created by Ganesh kumar on 09/06/17.
//  Copyright © 2017 Sourcebits. All rights reserved.
//

#import "STTestScoresNewTotalPopUp.h"

#define ANCHOR_VIEW_TAG          1000

@implementation STTestScoresNewTotalPopUp


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    UIView *anchorView = [self getAnchorViewWithType];
    anchorView.tag = ANCHOR_VIEW_TAG;
    CGRect anchorViewFrame = anchorView.frame;
    anchorViewFrame.origin.x = rect.size.width/2.0 - 10;
    anchorViewFrame.origin.y = 52;
    anchorView.frame = anchorViewFrame;
    
    [self addSubview:anchorView];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self addGestureRecognizer:tapGestureRecognizer];

}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    [self removeFromSuperview];
}

- (UIView *)getAnchorViewWithType {
    
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint centerPoint = CGPointMake(10, 10);
    CGPoint endPoint = CGPointMake(20, 0);
    
    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:startPoint];
    [trianglePath addLineToPoint:centerPoint];
    [trianglePath addLineToPoint:endPoint];
    [trianglePath closePath];
    
    CAShapeLayer *triangleMaskLayer = [CAShapeLayer layer];
    [triangleMaskLayer setPath:trianglePath.CGPath];
    
    UIView *anchorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    
    anchorView.backgroundColor = [UIColor aquaColorWithAlpha:0.95];
    anchorView.layer.mask = triangleMaskLayer;
    
    return anchorView;
}


@end
