//
//  STFinancialListView.m
//  Stipend
//
//  Created by Ganesh Kumar on 26/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STFinancialListView.h"

@implementation STFinancialListView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.questionmarkView removeFromSuperview];
    [super drawRect:rect];
//    [self updatQuestionMarkView];
}

- (void)updatQuestionMarkView  {
    
    CGRect titleRect = CGRectMake(self.bounds.origin.x + 15.0, self.bounds.origin.y + 20.0, ((self.bounds.size.width) - 100.0), 20.0);
    titleRect.origin.y -= 5.0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSString *titleString = self.ibLabelField.text;
    
    CGRect labelRect = [titleString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20.0)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: [UIFont fontType:eFontTypeAvenirBook FontForSize:16.0]}
                                                 context:nil];
    int labelWidth = ceilf(labelRect.size.width);
    
    UIImage *questionmark = [UIImage imageNamed:@"question_mark"];
    CGRect questionMarkRect = titleRect;
    questionMarkRect.origin.x = (titleRect.origin.x + labelWidth + 5.0);
    questionMarkRect.origin.y += 1.0;
    questionMarkRect.size = CGSizeMake(18.0, 18.0);
    
    self.questionmarkView = [[UIImageView alloc] initWithImage:questionmark];
    self.questionmarkView.frame = questionMarkRect;
    self.questionmarkView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.questionmarkView addGestureRecognizer:singleTap];
    
    [self addSubview:self.questionmarkView];
    
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer {
    STLog(@"image clicked");
    if(self.imageClickActionBlock) {
        self.imageClickActionBlock(self.questionmarkView);
    }
}


@end
