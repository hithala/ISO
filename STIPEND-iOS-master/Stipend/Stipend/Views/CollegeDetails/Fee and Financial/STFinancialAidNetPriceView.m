//
//  STFinancialAidNetPriceView.m
//  Stipend
//
//  Created by Ganesh kumar on 10/07/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import "STFinancialAidNetPriceView.h"

@implementation STFinancialAidNetPriceView


-(void)singleTapping:(UIGestureRecognizer *)recognizer {
    STLog(@"image clicked");
    if(self.imageClickActionBlock) {
        self.imageClickActionBlock(self.questionmarkView);
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.questionmarkView addGestureRecognizer:singleTap];
}


@end
