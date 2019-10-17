//
//  STBarChartView.m
//  Stipend
//
//  Created by Arun S on 27/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STBarChartView.h"

@interface STBarChartView()

@property NSMutableArray<NSDictionary*> *barPaths;
@end

@implementation STBarChartView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        self.barPaths = [[ NSMutableArray alloc ]init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        
        self.minYValue = 0;
        self.maxYValue = 1000;
        self.stepYValue = self.maxYValue/6.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    rect = [self bounds];
    
    NSInteger numberOfBars = 0;
    
    if([self.delegate respondsToSelector:@selector(numberOfBarsInBarChart:)]) {
        numberOfBars = [self.delegate numberOfBarsInBarChart:self];
    }
        
    if(numberOfBars > 0) {
        
        CGRect xyRect = rect;
        xyRect.origin.x += 60.0;
        xyRect.origin.y += 20.0;
        xyRect.size.height -= 130;
        xyRect.size.width -= 80.0;
        
        [self drawXYAxisInRect:xyRect];
        [self drawYLabelPointsInRect:xyRect];
        [self drawBarsInRect:xyRect];
        
        CGRect labelRect = rect;
        labelRect.size.height = 20.0;
        
        [self drawPercentile75LabelInRect:labelRect];
        [self drawPercentile25LabelInRect:labelRect];
        
        CGRect percentageRect = rect;
        percentageRect.size.height = 60.0;
        percentageRect.origin.y = xyRect.origin.y + xyRect.size.height + 50.0;
        
        [self drawPercentageLabelsAndValuesInRect:percentageRect];
    }
    else {
        
        CGRect labelRect = rect;
        labelRect.size.height = 20.0;
        
        [self drawPercentile75LabelInRect:labelRect];
        [self drawPercentile25LabelInRect:labelRect];

        CGRect percentageRect = rect;
        percentageRect.size.height = 60.0;
        percentageRect.origin.y = 30.0;
        
        [self drawPercentageLabelsAndValuesInRect:percentageRect];
    }

    [ self.delegate setBar: self.barPaths ];

}

- (void) drawPercentile25LabelInRect:(CGRect) rect {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirLight FontForSize:11.0],
                                  NSForegroundColorAttributeName: [UIColor cellTextFieldTextColor],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    NSString *text = @"25th Percentile";
    NSAttributedString *attributedText =    [[NSAttributedString alloc] initWithString:text attributes:attributes];
    CGRect textRect = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, 10.0}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
    
    CGFloat width = textRect.size.width;
    
    CGRect percentile25TextRect = rect;
    percentile25TextRect.origin.x = (rect.size.width - width - (2 * 70.0));
    percentile25TextRect.size.width = width;
    percentile25TextRect.origin.y -= 1.0;
    
    [text drawInRect:percentile25TextRect withAttributes:attributes];
    
    CGRect boxRect = percentile25TextRect;
    boxRect.origin.x -= 15.0;
    boxRect.size.width = 10.0;
    boxRect.size.height = 10.0;
    boxRect.origin.y += 1.5;
    
    [self.percentile25thColor set];
    UIBezierPath *xPath = [UIBezierPath bezierPathWithRect:boxRect];
    [xPath fill];
}

- (void) drawPercentile75LabelInRect:(CGRect) rect {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirLight FontForSize:11.0],
                                  NSForegroundColorAttributeName: [UIColor cellTextFieldTextColor],
                                  NSParagraphStyleAttributeName: paragraphStyle };

    NSString *text = @"75th Percentile";
    NSAttributedString *attributedText =    [[NSAttributedString alloc] initWithString:text attributes:attributes];
    CGRect textRect = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, 10.0}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    CGFloat width = textRect.size.width;
    
    CGRect percentile75TextRect = rect;
    percentile75TextRect.origin.x = ((rect.size.width - width) - 30.0);
    percentile75TextRect.size.width = width;
    percentile75TextRect.origin.y -= 1.0;

    [text drawInRect:percentile75TextRect withAttributes:attributes];
    
    CGRect boxRect = percentile75TextRect;
    boxRect.origin.x -= 15.0;
    boxRect.size.width = 10.0;
    boxRect.size.height = 10.0;
    boxRect.origin.y += 1.5;
    
    [self.percentile75thColor set];
    UIBezierPath *xPath = [UIBezierPath bezierPathWithRect:boxRect];
    [xPath fill];
}

- (void) drawPercentageLabelsAndValuesInRect:(CGRect) rect {
    
    CGRect percentageTitleRect = rect;
    percentageTitleRect.size.width = 90.0;
    
    [self drawPercentageTitleInRect:percentageTitleRect];
    
    CGRect percentageChart = rect;
    percentageChart.origin.x += percentageTitleRect.origin.x + percentageTitleRect.size.width;
    percentageChart.size.width = (rect.size.width - (percentageTitleRect.size.width + percentageTitleRect.origin.x + 20.0));
    [self drawPercentageChartInRect:percentageChart];
}

- (void)drawPercentageTitleInRect:(CGRect) rect  {
    
    CGRect titleRect = CGRectMake(rect.origin.x, rect.origin.y + 22.0, rect.size.width - 10.0, 20.0);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    UIColor *titleColor = [UIColor cellTextFieldTextColor];
    
    NSString *titleString = self.percentageTitle;
    
    if(titleString) {
        NSDictionary *attributes = @{
                                     NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:13.0],
                                     NSForegroundColorAttributeName: titleColor,
                                     NSParagraphStyleAttributeName: paragraphStyle
                                     };
        
        [titleString drawInRect:titleRect withAttributes:attributes];
    }
}

- (void) drawPercentageChartInRect:(CGRect) rect {
    
    CGRect percentageRect = rect;
    percentageRect.origin.x += 0.0;
    percentageRect.origin.y += 5.0;
    percentageRect.size.height = 50.0;
    
    [[UIColor lightGrayColor] set];
    
    if([self.delegate respondsToSelector:@selector(valueOfFirstPercentageInBarChart:)]) {
        self.firstPercentage = [self.delegate valueOfFirstPercentageInBarChart:self];
    }
    else {
        self.firstPercentage = 0;
    }
    
    if([self.delegate respondsToSelector:@selector(valueOfSecondPercentageInBarChart:)]) {
        self.secondPercentage = [self.delegate valueOfSecondPercentageInBarChart:self];
    }
    else {
        self.secondPercentage = 0;
    }
    
    UIBezierPath *percentagePath = [UIBezierPath bezierPathWithRoundedRect:percentageRect cornerRadius:0.0];
    [percentagePath fill];

    NSDictionary *totalScoreGraphPath =  @{ @"graphPath" :  percentagePath,
                                            @"graphTitle" : @"TotalScore"};

    [self.barPaths addObject:totalScoreGraphPath ];

    CGFloat firsRectPercentage = (CGFloat)(((CGFloat)self.firstPercentage/((CGFloat)self.firstPercentage + (CGFloat)self.secondPercentage)) * 100.0);
    
    CGRect percentile25thRect = percentageRect;
    CGFloat reqMWidth = ((percentageRect.size.width * firsRectPercentage)/100.0);
    percentile25thRect.size.width = (reqMWidth - 0.5);
    
    [[UIColor colorWithRed:54.0/255.0 green:145.0/255.0 blue:242.0/255.0 alpha:1.0] set];
    
    UIBezierPath *percentile25thPath = [UIBezierPath bezierPathWithRoundedRect:percentile25thRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(0.0, 0.0)];
    [percentile25thPath fill];
    
    [[UIColor whiteColor] set];
    
    CGRect seperatorRect = percentageRect;
    seperatorRect.origin.x += ((percentile25thRect.size.width) - 0.5);
    seperatorRect.size.width = 1.0;
    
    UIBezierPath *seperatorPath = [UIBezierPath bezierPathWithRect:seperatorRect];
    [seperatorPath fill];
    
    [[UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:66.0/255.0 alpha:1.0] set];
    
    CGFloat secondRectPercentage = (CGFloat)(((CGFloat)self.secondPercentage/((CGFloat)self.firstPercentage + (CGFloat)self.secondPercentage)) * 100.0);
    
    CGRect percentile75Rect = percentageRect;
    CGFloat reqFOrigin = (percentile25thRect.size.width) + 0.5;
    CGFloat reqFWidth = ((percentageRect.size.width * secondRectPercentage)/100.0);
    percentile75Rect.origin.x += reqFOrigin;
    percentile75Rect.size.width = (reqFWidth - 0.5);
    
    UIBezierPath *percentile75thPath = [UIBezierPath bezierPathWithRoundedRect:percentile75Rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(0.0, 0.0)];
    [percentile75thPath fill];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    CGRect percentage25TextRect = percentile25thRect;
    percentage25TextRect.origin.y += 20.0;
    percentage25TextRect.size.height = 20.0;
    percentage25TextRect.size.width -= 10.0;
    
    NSDictionary *attributes;
    
    attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:13.0],
                    NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:1.0],
                    NSParagraphStyleAttributeName: paragraphStyle };
    
    [[NSString stringWithFormat:@"%ld",(long)self.firstPercentage] drawInRect:percentage25TextRect withAttributes:attributes];
    
    CGRect percentage75TextRect = percentile75Rect;
    percentage75TextRect.origin.y += 20.0;
    percentage75TextRect.size.height = 20.0;
    percentage75TextRect.size.width -= 10.0;
    
    [[NSString stringWithFormat:@"%ld",(long)self.secondPercentage] drawInRect:percentage75TextRect withAttributes:attributes];
}

- (void) drawXYAxisInRect:(CGRect) rect {
    
    CGRect xAxisRect = rect;
    xAxisRect.size.height = 1.0;
    xAxisRect.origin.y += rect.size.height;
    
    [[UIColor darkGrayColor] set];
    UIBezierPath *xPath = [UIBezierPath bezierPathWithRect:xAxisRect];
    [xPath fill];
    
    CGRect yAxisRect = rect;
    yAxisRect.size.width = 1.0;
    
    UIBezierPath *yPath = [UIBezierPath bezierPathWithRect:yAxisRect];
    [yPath fill];
}

- (void) drawYLabelPointsInRect:(CGRect) rect {
    
    if([self.delegate respondsToSelector:@selector(minimumYValueOfBarChart:)]) {
        self.minYValue = [self.delegate minimumYValueOfBarChart:self];
    }
    
    if([self.delegate respondsToSelector:@selector(maximumYValueOfBarChart:)]) {
        self.maxYValue = [self.delegate maximumYValueOfBarChart:self];
    }

    self.stepYValue = (self.maxYValue - self.minYValue)/6.0;

    CGFloat height = rect.size.height - 20.0;
    CGFloat minmaxDiff = self.maxYValue - self.minYValue;
    CGFloat numberOfPoints = minmaxDiff/self.stepYValue;
    
    for (NSInteger i = 0 ; i < (numberOfPoints + 1); i++) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentRight;
        
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:12.0],
                                      NSForegroundColorAttributeName: [UIColor cellTextFieldTextColor],
                                      NSParagraphStyleAttributeName: paragraphStyle };
      
        CGRect valueRect = rect;
        valueRect.size.width = 40.0;
        valueRect.size.height = 20.0;
        valueRect.origin.x -= 50.0;
        
        CGFloat yOrigin;
        yOrigin = (rect.size.height - (i * (height/numberOfPoints)));

        if(i != 0)
        {
            CGRect lineRect = rect;
            lineRect.size.height = 1.0;
            lineRect.size.width = rect.size.width;
            lineRect.origin.y += yOrigin;
            lineRect.origin.x += 1.0;
            
            [[UIColor whiteColor] set];
            UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:lineRect];
            [linePath fill];
        }
        
        
        valueRect.origin.y += (yOrigin - 5.0);
        CGFloat pointVal = (self.minYValue + (i * self.stepYValue));
        [[NSString stringWithFormat:@"%.0f",pointVal] drawInRect:valueRect withAttributes:attributes];
    }
}

- (void) drawBarsInRect:(CGRect) rect {
    
//    CGFloat width = rect.size.width - 30.0;
    CGFloat barWidth = 60.0;
    CGFloat numberOfBars = 0;
    
    if([self.delegate respondsToSelector:@selector(numberOfBarsInBarChart:)]) {
        numberOfBars = [self.delegate numberOfBarsInBarChart:self];
    }
    
    for (NSInteger i = 0 ; i < numberOfBars; i++) {
        
        CGFloat value25thPercentile = 0.0;
        CGFloat value75thPercentile = 0.0;
        
        if([self.delegate respondsToSelector:@selector(barChart:valueFor25thPercentileAtIndex:)]) {
            value25thPercentile = [self.delegate barChart:self valueFor25thPercentileAtIndex:i];
        }

        if([self.delegate respondsToSelector:@selector(barChart:valueFor75thPercentileAtIndex:)]) {
            value75thPercentile = [self.delegate barChart:self valueFor75thPercentileAtIndex:i];
        }

        CGFloat height = (rect.size.height - 20.0);
        CGFloat minmaxDiff = self.maxYValue - self.minYValue;
        
        //calculate 25th percentile height & origin
        
        CGFloat difference25thPercentile = value25thPercentile - self.minYValue;

        CGRect barRect25thPercentile = rect;
        barRect25thPercentile.size.width = barWidth;

        CGFloat reqHeight25thPercentile = (height * (difference25thPercentile/minmaxDiff));
        barRect25thPercentile.size.height = reqHeight25thPercentile;
        barRect25thPercentile.origin.y += (rect.size.height - reqHeight25thPercentile);

// For Centering Bars        
//        CGFloat freeSpace = (width - (numberOfBars * barWidth));
//        CGFloat barDifference = freeSpace/numberOfBars;
//        CGFloat xOrigin25thPercentile = barDifference + (i * (width/(numberOfBars)));

        CGFloat xOrigin25thPercentile = 40.0 + (i * 100.0);
        barRect25thPercentile.origin.x += xOrigin25thPercentile;

        //calculate 75th percentile height & origin

        CGFloat difference75thPercentile = value75thPercentile - self.minYValue;

        CGRect barRect75thPercentile = rect;
        barRect75thPercentile.size.width = barWidth;
        
        CGFloat reqHeight75thPercentile = (height * (difference75thPercentile/minmaxDiff));
        barRect75thPercentile.size.height = reqHeight75thPercentile;
        barRect75thPercentile.origin.y += (rect.size.height - reqHeight75thPercentile);
   
// For Centering Bars
//        CGFloat xOrigin75thPercentile = barDifference + (i * (width/(numberOfBars)));
        
        CGFloat xOrigin75thPercentile = 40.0 + (i * 100.0);

        barRect75thPercentile.origin.x += xOrigin75thPercentile;

        //Get Color of Bars
        
        UIColor *color25thPercentile;
        UIColor *color75thPercentile;
        
        if([self.delegate respondsToSelector:@selector(barChart:colorFor25thPercentileAtIndex:)]) {
            color25thPercentile = [self.delegate barChart:self colorFor25thPercentileAtIndex:i];
            self.percentile25thColor = color25thPercentile;
        }

        if([self.delegate respondsToSelector:@selector(barChart:colorFor75thPercentileAtIndex:)]) {
            color75thPercentile = [self.delegate barChart:self colorFor75thPercentileAtIndex:i];
            self.percentile75thColor = color75thPercentile;
        }

        UIBezierPath *tapDetectionPath = [[ UIBezierPath alloc ] init ];

        if(value25thPercentile < value75thPercentile) {
        
            [color75thPercentile set];
            UIBezierPath *path75thPercentile = [UIBezierPath bezierPathWithRect:barRect75thPercentile];
            [path75thPercentile fill];

            [color25thPercentile set];
            UIBezierPath *path25thPercentile = [UIBezierPath bezierPathWithRect:barRect25thPercentile];
            [path25thPercentile fill];

            CGRect seperatorRect = barRect25thPercentile;
            seperatorRect.size.width = barWidth;
            seperatorRect.origin.y += barRect25thPercentile.size.height - reqHeight25thPercentile;
            seperatorRect.size.height = 1.0;
            
            [[UIColor whiteColor] set];
            UIBezierPath *seperatorPath = [UIBezierPath bezierPathWithRect:seperatorRect];
            [seperatorPath fill];

            [ tapDetectionPath appendPath:path75thPercentile ];
            [ tapDetectionPath appendPath:path25thPercentile ];
            [ tapDetectionPath appendPath: seperatorPath ];
        }
        else {
          
            [color25thPercentile set];
            UIBezierPath *path25thPercentile = [UIBezierPath bezierPathWithRect:barRect25thPercentile];
            [path25thPercentile fill];

            [color75thPercentile set];
            UIBezierPath *path75thPercentile = [UIBezierPath bezierPathWithRect:barRect75thPercentile];
            [path75thPercentile fill];

            CGRect seperatorRect = barRect75thPercentile;
            seperatorRect.size.width = barWidth;
            seperatorRect.origin.y += barRect75thPercentile.size.height - reqHeight75thPercentile;
            seperatorRect.size.height = 1.0;
            
            [[UIColor whiteColor] set];
            UIBezierPath *seperatorPath = [UIBezierPath bezierPathWithRect:seperatorRect];
            [seperatorPath fill];

            [ tapDetectionPath appendPath:path75thPercentile ];
            [ tapDetectionPath appendPath:path25thPercentile ];
            [ tapDetectionPath appendPath: seperatorPath ];
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:12.0],
                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSParagraphStyleAttributeName: paragraphStyle};
        
        CGRect label25thPercentileRect = barRect25thPercentile;
        label25thPercentileRect.origin.y += 2.0;
        label25thPercentileRect.size.height = 20.0;

        [[NSString stringWithFormat:@"%.0f",value25thPercentile] drawInRect:label25thPercentileRect withAttributes:attributes];

        CGRect label75thPercentileRect = barRect75thPercentile;
        label75thPercentileRect.origin.y += 2.0;
        label75thPercentileRect.size.height = 20.0;
        
        CGFloat barHeight25Percentile = (barRect25thPercentile.size.height);
        CGFloat barHeight75Percentile = (barRect75thPercentile.size.height);
        CGFloat difference = (barHeight75Percentile - barHeight25Percentile);
        
        if(difference < 15.0) {
            
            attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:12.0],
                            NSForegroundColorAttributeName: color75thPercentile,
                            NSParagraphStyleAttributeName: paragraphStyle };
            
            label75thPercentileRect.origin.y -= 18.0;
        }
        else {
            
        }
        
        [[NSString stringWithFormat:@"%.0f",value75thPercentile] drawInRect:label75thPercentileRect withAttributes:attributes];
        
        NSString *barLabel = @"";
        
        if([self.delegate respondsToSelector:@selector(barChart:labelForPercentilesAtIndex:)]) {
            barLabel = [self.delegate barChart:self labelForPercentilesAtIndex:i];
            NSDictionary *graphPathDictionary = @{@"graphPath" :  tapDetectionPath,
                                                  @"graphTitle" : barLabel };

            [ self.barPaths addObject:graphPathDictionary ];
        }

        CGFloat labeWidth = 70.0;
        
        CGRect labelRect = barRect25thPercentile;
        labelRect.size.width = labeWidth;
        labelRect.size.height = 50.0;
        labelRect.origin.x -= (5.0);
        labelRect.origin.y += reqHeight25thPercentile + 5.0;
        
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;

        attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:12.0],
                        NSForegroundColorAttributeName: [UIColor cellTextFieldTextColor],
                        NSParagraphStyleAttributeName: paragraphStyle
                        };
        
        [barLabel drawInRect:labelRect withAttributes:attributes];
    }
}

- (void)dealloc {
    
    self.delegate = nil;
}

@end
