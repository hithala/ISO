//
//  STHighSchoolClassRankBarChartView.m
//  Stipend
//
//  Created by Ganesh kumar on 29/05/17.
//  Copyright © 2017 Sourcebits. All rights reserved.
//

#import "STHighSchoolClassRankBarChartView.h"

@interface STHighSchoolClassRankBarChartView()

@property NSMutableArray<NSDictionary*> *barPaths;
@end

@implementation STHighSchoolClassRankBarChartView

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
        self.stepYValue = self.maxYValue/5.0;
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
        xyRect.origin.x += 40.0;
        xyRect.origin.y += 20.0;
        xyRect.size.height -= 130;
        xyRect.size.width -= 60.0;
        
        [self drawXYAxisInRect:xyRect];
        [self drawYLabelPointsInRect:xyRect];
        [self drawBarsInRect:xyRect];
        
        CGRect labelRect = rect;
        labelRect.size.height = 20.0;
        
        CGRect percentageRect = rect;
        percentageRect.size.height = 60.0;
        percentageRect.origin.y = xyRect.origin.y + xyRect.size.height + 50.0;
        
        [self drawPercentageLabelsAndValuesInRect:percentageRect];
    }
    else {
        
        CGRect labelRect = rect;
        labelRect.size.height = 20.0;
        
        CGRect percentageRect = rect;
        percentageRect.size.height = 60.0;
        percentageRect.origin.y = 30.0;
        
        [self drawPercentageLabelsAndValuesInRect:percentageRect];
    }
    
    [ self.delegate setBar: self.barPaths ];
    
}

- (void) drawPercentageLabelsAndValuesInRect:(CGRect) rect {
    
    CGRect percentageTitleRect = rect;
    percentageTitleRect.size.width = 120.0;
    
    [self drawPercentageTitleInRect:percentageTitleRect];
    
    CGRect percentageChart = rect;
    percentageChart.origin.x += percentageTitleRect.origin.x + percentageTitleRect.size.width;
    percentageChart.size.width = (rect.size.width - (percentageTitleRect.size.width + percentageTitleRect.origin.x + 20.0));
    [self drawPercentageChartInRect:percentageChart];
}

- (void)drawPercentageTitleInRect:(CGRect) rect  {
    
    CGRect titleRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - 10.0, 80.0);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    UIColor *titleColor = [UIColor cellTextFieldTextColor];
    
    NSString *titleString = self.percentageTitle;
    
    if(titleString) {
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:13.0],
                                      NSForegroundColorAttributeName: titleColor,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        [titleString drawInRect:titleRect withAttributes:attributes];
    }
}

- (void) drawPercentageChartInRect:(CGRect) rect {
    
    CGRect percentageRect = rect;
    percentageRect.origin.x += 0.0;
    percentageRect.origin.y += 0.0;
    percentageRect.size.height = 35.0;
    
    [[UIColor clearColor] set];
    
    if([self.delegate respondsToSelector:@selector(valueOfFreshmenRankPercentageInBarChart:)]) {
        self.freshmenPercentage = [self.delegate valueOfFreshmenRankPercentageInBarChart:self];
    }
    else {
        self.freshmenPercentage = 0;
    }

    if(self.freshmenPercentage > 0) {
        UIBezierPath *percentagePath = [UIBezierPath bezierPathWithRoundedRect:percentageRect cornerRadius:0.0];
        [percentagePath fill];
        
        NSDictionary *totalScoreGraphPath =  @{ @"graphPath" :  percentagePath,
                                                @"graphTitle" : @"TotalScore"};
        
        [self.barPaths addObject:totalScoreGraphPath ];
        
        CGFloat firsRectPercentage = (CGFloat)self.freshmenPercentage;
        
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
        
        //    UIBezierPath *seperatorPath = [UIBezierPath bezierPathWithRect:seperatorRect];
        //    [seperatorPath fill];
        
        [[UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:66.0/255.0 alpha:1.0] set];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentRight;
        
        CGRect percentageTextRect = percentile25thRect;
        percentageTextRect.origin.x += 5;
        percentageTextRect.origin.y += 8.5;
        percentageTextRect.size.height = 20.0;
        percentageTextRect.size.width -= 10.0;
        
        UIColor *fontColor = [UIColor whiteColor];
        
        if(self.freshmenPercentage <= 20) {
            fontColor = [UIColor colorWithRed:54.0/255.0 green:145.0/255.0 blue:242.0/255.0 alpha:1.0];
            percentageTextRect.origin.x += self.freshmenPercentage < 10 ? -2 : 5;
            percentageTextRect.size.width += 30;
        }
        
        NSDictionary *attributes;
        
        attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:13.0],
                        NSForegroundColorAttributeName: fontColor,
                        NSParagraphStyleAttributeName: paragraphStyle };
        
        [[NSString stringWithFormat:@"%ld%%",(long)self.freshmenPercentage] drawInRect:percentageTextRect withAttributes:attributes];
    }
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
    
    self.stepYValue = (self.maxYValue - self.minYValue)/5.0;
    
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
    CGFloat barWidth = 40.0;
    CGFloat numberOfBars = 0;
    
    if([self.delegate respondsToSelector:@selector(numberOfBarsInBarChart:)]) {
        numberOfBars = [self.delegate numberOfBarsInBarChart:self];
    }
    
    for (NSInteger i = 0 ; i < numberOfBars; i++) {
        
        CGFloat valuePercentile = 0.0;
        
        if([self.delegate respondsToSelector:@selector(barChart:valueForPercentileAtIndex:)]) {
            valuePercentile = [self.delegate barChart:self valueForPercentileAtIndex:i];
        }
        
        CGFloat height = (rect.size.height - 20.0);
        CGFloat minmaxDiff = self.maxYValue - self.minYValue;
        
        //calculate percentile height & origin
        
        CGFloat differencePercentile = valuePercentile - self.minYValue;
        
        CGRect barRectPercentile = rect;
        barRectPercentile.size.width = barWidth;
        
        CGFloat reqHeight25thPercentile = (height * (differencePercentile/minmaxDiff));
        barRectPercentile.size.height = reqHeight25thPercentile;
        barRectPercentile.origin.y += (rect.size.height - reqHeight25thPercentile);
        
        CGFloat xOrigin25thPercentile = 20.0 + (i * 60.0);
        barRectPercentile.origin.x += xOrigin25thPercentile;
        
        //Get Color of Bars
        
        UIColor *colorPercentile = [UIColor colorWithRed:54.0/255.0 green:145.0/255.0 blue:242.0/255.0 alpha:1.0];
        
        [colorPercentile set];
        UIBezierPath *pathPercentile = [UIBezierPath bezierPathWithRect:barRectPercentile];
        [pathPercentile fill];
        
       /* CGRect seperatorRect = barRectPercentile;
        seperatorRect.size.width = barWidth;
        seperatorRect.origin.y += barRectPercentile.size.height - reqHeight25thPercentile;
        seperatorRect.size.height = 1.0;
        
        [[UIColor whiteColor] set];
        UIBezierPath *seperatorPath = [UIBezierPath bezierPathWithRect:seperatorRect];
        [seperatorPath fill]; */
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        UIColor *fontColor = [UIColor whiteColor];
        
        if(valuePercentile < 10) {
            fontColor = [UIColor colorWithRed:54.0/255.0 green:145.0/255.0 blue:242.0/255.0 alpha:1.0];
        }
        
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:12.0],
                                      NSForegroundColorAttributeName: fontColor,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        CGRect label25thPercentileRect = barRectPercentile;
        label25thPercentileRect.origin.y += 2.0;
        label25thPercentileRect.size.height = 20.0;
        
        if(valuePercentile < 10) {
            label25thPercentileRect.origin.y -= 20.0;
        }
        
        if(valuePercentile > 0) {
            [[NSString stringWithFormat:@"%.0f%%",valuePercentile] drawInRect:label25thPercentileRect withAttributes:attributes];
        }
        
        NSString *barLabel = @"";
        
        if([self.delegate respondsToSelector:@selector(barChart:labelForPercentilesAtIndex:)]) {
            barLabel = [self.delegate barChart:self labelForPercentilesAtIndex:i];
        }

        CGFloat labeWidth = 42.0;
        
        CGRect labelRect = barRectPercentile;
        labelRect.size.width = labeWidth;
        labelRect.size.height = 50.0;
        labelRect.origin.x -= (5.0);
        labelRect.origin.y += reqHeight25thPercentile + 5.0;
        
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:12.0],
                        NSForegroundColorAttributeName: [UIColor cellTextFieldTextColor],
                        NSParagraphStyleAttributeName: paragraphStyle };
        
        [barLabel drawInRect:labelRect withAttributes:attributes];
    }
}

- (void)dealloc {
    
    self.delegate = nil;
}

@end
