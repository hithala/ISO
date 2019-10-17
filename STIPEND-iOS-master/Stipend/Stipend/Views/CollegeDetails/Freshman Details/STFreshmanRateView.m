//
//  STFreshmanRateView.m
//  Stipend
//
//  Created by Ganesh Kumar on 07/02/18.
//  Copyright (c) 2018 Sourcebits. All rights reserved.
//

#import "STFreshmanRateView.h"

#define FIRST_PER 60.0
#define SECOND_PER 40.0

@implementation STFreshmanRateView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.firstPercentage = FIRST_PER;
        self.secondPercentage = SECOND_PER;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        
        self.firstPercentage = FIRST_PER;
        self.secondPercentage = SECOND_PER;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self.questionmarkView removeFromSuperview];
    [super drawRect:rect];
    [self drawTitle];
    [self drawRateBarChart];
}

- (void)drawTitle  {
    
    CGRect titleRect = CGRectMake(self.bounds.origin.x + 15.0, self.bounds.origin.y + 20.0, ((self.bounds.size.width) - 100.0), 20.0);
    titleRect.origin.y -= 5.0;
    
//    CGFloat totalValue = self.firstPercentage + self.secondPercentage;
//    if(self.freshmenItem == FreshmenItemGraduationRate) {
//        if((self.firstPercentage/totalValue < 0.15 && self.firstPercentage > 0) || (self.secondPercentage/totalValue < 0.15 && self.secondPercentage > 0)) {
//            titleRect.origin.y -= 10.0;
//        }
//    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    UIColor *titleColor = [UIColor cellTextFieldTextColor];
    
    NSString *titleString = @"";

    if(self.freshmenItem == FreshmenItemGraduationRate) {
        titleString = @"GRADUATION RATE";
    } else if (self.freshmenItem == FreshmenItemRetentionRate) {
        titleString = @"1-YEAR RETENTION RATE";
    }
    
    if(titleString) {
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirHeavy FontForSize:13.0],
                                      NSForegroundColorAttributeName: titleColor,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        [titleString drawInRect:titleRect withAttributes:attributes];
        
    }

    if (self.freshmenItem == FreshmenItemRetentionRate) {

        CGRect labelRect = [titleString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20.0)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: [UIFont fontType:eFontTypeAvenirHeavy FontForSize:13.0]}
                                                                   context:nil];
        int labelWidth = ceilf(labelRect.size.width);

        UIImage *questionmark = [UIImage imageNamed:@"question_mark"];
        CGRect questionMarkRect = titleRect;
        questionMarkRect.origin.x = (titleRect.origin.x + labelWidth + 5.0);
        questionMarkRect.origin.y -= 2.0;
        questionMarkRect.size = CGSizeMake(18.0, 18.0);
//        [questionmark drawInRect:questionMarkRect];
        
        self.questionmarkView = [[UIImageView alloc] initWithImage:questionmark];
        self.questionmarkView.frame = questionMarkRect;
        self.questionmarkView.userInteractionEnabled = YES;

        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [self.questionmarkView addGestureRecognizer:singleTap];
        
        [self addSubview:self.questionmarkView];
    }
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer {
    STLog(@"image clicked");
    if(self.imageClickActionBlock) {
        self.imageClickActionBlock(self.questionmarkView);
    }
}

- (void) drawRateBarChart {
    
    CGFloat totalValue = 100.0; //self.firstPercentage + self.secondPercentage;
    UIColor *blueColor = [UIColor colorWithRed:54.0/255.0 green:145.0/255.0 blue:242.0/255.0 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:66.0/255.0 alpha:1.0];
    UIColor *labelColor = [UIColor colorWithWhite:1.0 alpha:0.75];
    UIColor *percentageColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    CGFloat secondPercentageValue = 0.0;

    if(self.freshmenItem == FreshmenItemRetentionRate) {
        totalValue = 100.0;
    } else {
        secondPercentageValue = self.secondPercentage;
        self.secondPercentage = 100.0 - self.firstPercentage;
    }

    CGRect rateBarRect = self.bounds;
    rateBarRect.origin.x += 15.0;
//    rateBarRect.origin.y += (self.freshmenItem == FreshmenItemRetentionRate) ? 50.0 : 65.0;
    rateBarRect.origin.y +=  45.0;
    rateBarRect.size.width = (self.bounds.size.width - 30.0);
    rateBarRect.size.height = 50.0;
    
//    if(self.freshmenItem == FreshmenItemGraduationRate) {
//        if((self.firstPercentage/totalValue < 0.15 && self.firstPercentage > 0) || (self.secondPercentage/totalValue < 0.15 && self.secondPercentage > 0)) {
//            rateBarRect.origin.y += 75.0;
//        } else {
//            rateBarRect.origin.y += 50.0;
//        }
//    } else {
//        rateBarRect.origin.y +=  50.0;
//    }
    
    // Rate bar background color
    if(self.freshmenItem == FreshmenItemGraduationRate) {
        [[UIColor clearColor] set];
    } else {
        [blueColor set];
    }
    
    UIBezierPath *rateBarPath = [UIBezierPath bezierPathWithRoundedRect:rateBarRect cornerRadius:6.0];
    [rateBarPath fill];

    // First bar rect
    CGRect firstBarRect = rateBarRect;
    CGFloat reqFWidth = ((rateBarRect.size.width * self.firstPercentage)/totalValue);
    firstBarRect.size.width = (reqFWidth - 0.5);

    if(self.firstPercentage > 0) {
    
        // First bar color
        if(self.freshmenItem == FreshmenItemRetentionRate) {
            [greenColor set];
        } else {
            [blueColor set];
        }
        
        UIBezierPath *firstPath;
        
        if(self.firstPercentage == totalValue) {
            firstPath = [UIBezierPath bezierPathWithRoundedRect:firstBarRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6.0, 6.0)];
        } else {
            firstPath = [UIBezierPath bezierPathWithRoundedRect:firstBarRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(6.0, 6.0)];
        }
        
        [firstPath fill];
    }

    if(self.freshmenItem == FreshmenItemGraduationRate) {
        
        if(self.firstPercentage > 0 && self.secondPercentage > 0) {
            
            // Drawing white separator view in Raduation Rate view
            if((self.firstPercentage/totalValue < 0.10) || (self.secondPercentage/totalValue < 0.10)) {
                [[UIColor lightGrayColor] set];
            } else {
                [[UIColor whiteColor] set];
            }
            
            CGRect seperatorRect = rateBarRect;
            seperatorRect.origin.x += ((firstBarRect.size.width) - 0.5);
            seperatorRect.size.width = 1.0;
            
            UIBezierPath *seperatorPath = [UIBezierPath bezierPathWithRect:seperatorRect];
            [seperatorPath fill];
        }
    } else {
        
        // Drawing white separator view in Retention Rate view
        if(self.firstPercentage/totalValue < 0.10) {
            [[UIColor lightGrayColor] set];
        } else {
            [[UIColor whiteColor] set];
        }
        
        CGRect seperatorRect = rateBarRect;
        seperatorRect.origin.x += ((firstBarRect.size.width) - 0.5);
        seperatorRect.size.width = 1.0;
        
        UIBezierPath *seperatorPath = [UIBezierPath bezierPathWithRect:seperatorRect];
        [seperatorPath fill];
    }

    // Second bar rect
    CGRect secondBarRect = rateBarRect;
    CGFloat reqOrigin = (firstBarRect.size.width) + 0.5;
    CGFloat reqSWidth = ((secondBarRect.size.width * self.secondPercentage)/totalValue);
    secondBarRect.origin.x += reqOrigin;
    secondBarRect.size.width = (reqSWidth - 0.5);
    
    if(self.secondPercentage > 0) {

        // Second bar color
        [greenColor set];

        UIBezierPath *secondPath = [UIBezierPath bezierPathWithRoundedRect:secondBarRect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(6.0, 6.0)];
        
        if(self.secondPercentage == totalValue) {
            secondPath = [UIBezierPath bezierPathWithRoundedRect:secondBarRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6.0, 6.0)];
        } else {
            secondPath = [UIBezierPath bezierPathWithRoundedRect:secondBarRect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(6.0, 6.0)];
        }
        
        [secondPath fill];
    }

    if(self.firstPercentage > 0) {
        
        //        UIImage *maleImage = [UIImage imageNamed:@"gender_male"];
        
        CGRect maleImageRect = firstBarRect;
        maleImageRect.size.width = 0.0; // 17.0;
        maleImageRect.size.height = 40.0;
        maleImageRect.origin.y += 5.0;
        maleImageRect.origin.x += 0.0; // 10.0;
        
        UIColor *maleTextColor = labelColor;
        UIColor *malePercentageColor = percentageColor;

        
        /*if((self.freshmenItem == FreshmenItemRetentionRate) && (self.firstPercentage/totalValue < 0.15)) {
            maleTextColor = greenColor;
            malePercentageColor = greenColor;
        } else if((self.freshmenItem == FreshmenItemGraduationRate) && (self.firstPercentage/totalValue < 0.15)) {
            maleTextColor = blueColor;
            malePercentageColor = blueColor;
        }
         */
        
        //        [maleImage drawInRect:maleImageRect];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirBook FontForSize:11.0],
                                      NSForegroundColorAttributeName: maleTextColor,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        if(self.freshmenItem == FreshmenItemGraduationRate) {
            
            CGRect maleTextRect = firstBarRect;
//            maleTextRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 2.0);
//            maleTextRect.origin.y += 30.0;
            maleTextRect.size.height = 20.0;
            maleTextRect.size.width = 100.0;
            
            if(self.firstPercentage/totalValue < 0.10) {
                maleTextRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 10.0);
//                maleTextRect.origin.y += -15.0;
                maleTextRect.origin.y += 30.0;
            } else if(self.firstPercentage/totalValue < 0.15) {
//                maleTextRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 5.0);
//                maleTextRect.origin.y += -15.0;
                maleTextRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 10.0);
                maleTextRect.origin.y += 30.0;
            } else {
                maleTextRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 2.0);
                maleTextRect.origin.y += 30.0;
            }
            
            [@"4-Year" drawInRect:maleTextRect withAttributes:attributes];
            
            CGRect malePercentageRect = firstBarRect;
            
            if(self.firstPercentage/totalValue < 0.10) {
//                malePercentageRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 5.0 + 33.0);
//                malePercentageRect.origin.y += -25.0;
                malePercentageRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 12.0);
//                malePercentageRect.origin.y += -40.0;
                malePercentageRect.origin.y += 7.0;
            } else if(self.firstPercentage/totalValue < 0.15) {
//                malePercentageRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 7.0);
                malePercentageRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 12.0);
//                malePercentageRect.origin.y += -40.0;
                malePercentageRect.origin.y += 7.0;
            } else {
                malePercentageRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 5.0);
                malePercentageRect.origin.y += 7.0;
            }
            malePercentageRect.size.height = 20.0;
            malePercentageRect.size.width = 100.0;
            
            attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirBook FontForSize:18.0],
                            NSForegroundColorAttributeName: malePercentageColor,
                            NSParagraphStyleAttributeName: paragraphStyle };
            
            [[NSString stringWithFormat:@"%.0f%%", self.firstPercentage] drawInRect:malePercentageRect withAttributes:attributes];
            
        } else {
            
            CGRect malePercentageRect = firstBarRect;
            malePercentageRect.origin.y += 15.0;
            malePercentageRect.size.height = 20.0;
            malePercentageRect.size.width = 100.0;
            
            if(self.firstPercentage/totalValue < 0.15) {
//                malePercentageRect.origin.x = ((firstBarRect.origin.x + firstBarRect.size.width) + 5.0);
                malePercentageRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 10.0);
            } else {
                malePercentageRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 5.0);
            }
            
            attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirBook FontForSize:18.0],
                            NSForegroundColorAttributeName: malePercentageColor,
                            NSParagraphStyleAttributeName: paragraphStyle };
            
            [[NSString stringWithFormat:@"%.0f%%", self.firstPercentage] drawInRect:malePercentageRect withAttributes:attributes];
        }
    }
    
    if(self.secondPercentage > 0) {
        
//        UIImage *femaleImage = [UIImage imageNamed:@"gender_female"];
        
        CGRect femaleImageRect = secondBarRect;
        femaleImageRect.size.width = 17.0;
        femaleImageRect.size.height = 40.0;
        femaleImageRect.origin.y += 5.0;
        femaleImageRect.origin.x = secondBarRect.origin.x + secondBarRect.size.width;// - 25.0;
        
        UIColor *femaleTextColor = labelColor;
        UIColor *femalePercentageColor = percentageColor;

        if((self.freshmenItem == FreshmenItemGraduationRate) && (self.secondPercentage/totalValue < 0.15)) {
//            femaleTextColor = greenColor;
//            femalePercentageColor = greenColor;
        }

//        [femaleImage drawInRect:femaleImageRect];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentRight;
        
        if(self.freshmenItem == FreshmenItemGraduationRate) {
            
            CGRect femaleTextRect = secondBarRect;
//            femaleTextRect.origin.y += 30.0;
            femaleTextRect.size.height = 20.0;
//            femaleTextRect.origin.x = femaleImageRect.origin.x - 112.0;
            femaleTextRect.size.width = 100.0;
            
            NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirBook FontForSize:11.0],
                                          NSForegroundColorAttributeName: femaleTextColor,
                                          NSParagraphStyleAttributeName: paragraphStyle };
            
            if(self.secondPercentage/totalValue < 0.10) {
                femaleTextRect.origin.x = femaleImageRect.origin.x - 102.0;
//                femaleTextRect.origin.y += -15.0;
                femaleTextRect.origin.y += 30.0;
            } else if(self.secondPercentage/totalValue < 0.15) {
                femaleTextRect.origin.x = femaleImageRect.origin.x - 107.0;
                femaleTextRect.origin.y += 30.0;
            } else {
                femaleTextRect.origin.x = femaleImageRect.origin.x - 112.0;
                femaleTextRect.origin.y += 30.0;
            }

            [@"6-Year" drawInRect:femaleTextRect withAttributes:attributes];
            
            CGRect femalePercentageRect = secondBarRect;            
            if(self.secondPercentage/totalValue < 0.10) {
                femalePercentageRect.origin.x = femaleImageRect.origin.x - 100.0;
                femalePercentageRect.origin.y += 7.0;
            } else if(self.secondPercentage/totalValue < 0.15) {
                femalePercentageRect.origin.x = femaleImageRect.origin.x - 105.0;
                femalePercentageRect.origin.y += 7.0;
            } else {
                femalePercentageRect.origin.x = femaleImageRect.origin.x - 110.0;
                femalePercentageRect.origin.y += 7.0;
            }
            femalePercentageRect.size.height = 20.0;
            femalePercentageRect.size.width = 100.0;
            
            attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirBook FontForSize:18.0],
                            NSForegroundColorAttributeName: femalePercentageColor,
                            NSParagraphStyleAttributeName: paragraphStyle };
            
            [[NSString stringWithFormat:@"%.0f%%", secondPercentageValue] drawInRect:femalePercentageRect withAttributes:attributes];
        }
    }
}

- (void)dealloc {
    
}

@end
