//
//  CustomHeaderView.m
//  StipendTesting
//
//  Created by Ganesh Kumar on 26/05/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import "CustomHeaderView.h"

@implementation CustomHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)customizeView {
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    [self.blurView addGestureRecognizer:panRecognizer];
}

- (void)move:(UIPanGestureRecognizer *)gesture {
    
    if(gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"gesture begain");
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        
        CGPoint translation = [gesture translationInView:gesture.view.superview];
        
        NSLog(@"gesture state changed y:%f", translation.y);
        
       /* rowHeight += translation.y;
        
        if(rowHeight < self.view.frame.size.height/2+150 && rowHeight > self.view.frame.size.height/2) {
            [self.tableView beginUpdates];
            [self updateHeaderView];
            [self.tableView endUpdates];
        } else {
            rowHeight -= translation.y;
        } */
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"gesture ended");
        
    }
}

@end
