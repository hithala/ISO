//
//  STGenderView.m
//  PieChartSample
//
//  Created by Arun S on 27/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STGenderView.h"

#define MALE_PER 60.0
#define FEM_PER 40.0

@implementation STGenderView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.malePercentage = MALE_PER;
        self.femalePercentage = FEM_PER;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        
        self.malePercentage = MALE_PER;
        self.femalePercentage = FEM_PER;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    [self drawTitle];
    [self drawGenderChart];
}

- (void)drawTitle  {
    
    CGRect titleRect = CGRectMake(self.bounds.origin.x + 10.0, self.bounds.origin.y + 10.0, ((self.bounds.size.width) - 40.0), 20.0);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    UIColor *titleColor = [UIColor blackColor];
    
    NSString *titleString = @"GENDER";
    
    if(titleString) {
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:12.0],
                                      NSForegroundColorAttributeName: titleColor,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        [titleString drawInRect:titleRect withAttributes:attributes];
    }
}

- (void) drawGenderChart {
    
    CGRect genderRect = self.bounds;
    genderRect.origin.x += 10.0;
    genderRect.origin.y += 40.0;
    genderRect.size.width = (self.bounds.size.width - 20.0);
    genderRect.size.height = 50.0;
    
    [[UIColor lightGrayColor] set];
    
    UIBezierPath *genderPath = [UIBezierPath bezierPathWithRoundedRect:genderRect cornerRadius:6.0];
    [genderPath fill];
    
    CGRect maleRect = genderRect;
    CGFloat reqMWidth = ((genderRect.size.width * self.malePercentage)/100.0);
    maleRect.size.width = (reqMWidth - 0.5);

    [[UIColor colorWithRed:54.0/255.0 green:145.0/255.0 blue:242.0/255.0 alpha:1.0] set];

    UIBezierPath *malePath = [UIBezierPath bezierPathWithRoundedRect:maleRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(6.0, 6.0)];
    [malePath fill];
    
    [[UIColor whiteColor] set];
    
    CGRect seperatorRect = genderRect;
    seperatorRect.origin.x += ((maleRect.size.width) - 0.5);
    seperatorRect.size.width = 1.0;
    
    UIBezierPath *seperatorPath = [UIBezierPath bezierPathWithRect:seperatorRect];
    [seperatorPath fill];

    [[UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:66.0/255.0 alpha:1.0] set];
    
    CGRect femaleRect = genderRect;
    CGFloat reqFOrigin = (maleRect.size.width) + 0.5;
    CGFloat reqFWidth = ((genderRect.size.width * self.femalePercentage)/100.0);
    femaleRect.origin.x += reqFOrigin;
    femaleRect.size.width = (reqFWidth - 0.5);

    UIBezierPath *femalePath = [UIBezierPath bezierPathWithRoundedRect:femaleRect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(6.0, 6.0)];
    [femalePath fill];
    
    UIImage *maleImage = [UIImage imageNamed:@"male_icon"];

    CGRect maleImageRect = maleRect;
    maleImageRect.size.width = 30.0;
    maleImageRect.size.height = 30.0;
    maleImageRect.origin.y += 12.0;
    maleImageRect.origin.x += 5.0;
    
    [maleImage drawInRect:maleImageRect];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;

    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:11.0],
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    

    CGRect maleTextRect = maleRect;
    maleTextRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 5.0);
    maleTextRect.origin.y += 25.0;
    maleTextRect.size.height = 20.0;
    maleTextRect.size.width = maleRect.size.width - maleImageRect.size.width - 20.0;
    
    [@"Male" drawInRect:maleTextRect withAttributes:attributes];

    CGRect malePercentageRect = maleRect;
    malePercentageRect.origin.x += ((maleImageRect.origin.x + maleImageRect.size.width) - 5.0);
    malePercentageRect.origin.y += 13.0;
    malePercentageRect.size.height = 20.0;
    maleTextRect.size.width = maleRect.size.width - maleImageRect.size.width - 20.0;

    [[NSString stringWithFormat:@"%.0f%%",self.malePercentage] drawInRect:malePercentageRect withAttributes:attributes];
    
    UIImage *femaleImage = [UIImage imageNamed:@"female_icon"];
    
    CGRect femaleImageRect = femaleRect;
    femaleImageRect.size.width = 30.0;
    femaleImageRect.size.height = 30.0;
    femaleImageRect.origin.y += 12.0;
    femaleImageRect.origin.x = femaleRect.origin.x + femaleRect.size.width - 40.0;
    
    [femaleImage drawInRect:femaleImageRect];
    
    paragraphStyle.alignment = NSTextAlignmentRight;

    CGRect femaleTextRect = femaleRect;
    femaleTextRect.origin.y += 25.0;
    femaleTextRect.size.height = 20.0;
    femaleTextRect.size.width = femaleRect.size.width - femaleImageRect.size.width - 15.0;
    
    [@"Female" drawInRect:femaleTextRect withAttributes:attributes];
    
    CGRect femalePercentageRect = femaleRect;
    femalePercentageRect.origin.y += 13.0;
    femalePercentageRect.size.height = 20.0;
    femalePercentageRect.size.width = femaleRect.size.width - femaleImageRect.size.width - 15.0;
    
    [[NSString stringWithFormat:@"%.0f%%",self.femalePercentage] drawInRect:femalePercentageRect withAttributes:attributes];
}

@end
