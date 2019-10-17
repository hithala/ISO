//
//  STBarChartView.m
//  PieChartSample
//
//  Created by Arun S on 27/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STBarChartView.h"

@implementation STBarChartView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        
        self.minYValue = 0;
        self.maxYValue = 1000;
        self.stepYValue = self.maxYValue/4.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    rect = [self bounds];
    
    CGRect xyRect = rect;
    xyRect.origin.x += 50.0;
    xyRect.origin.y += 30.0;
    xyRect.size.height -= 60;
    xyRect.size.width -= 80.0;
        
    [self drawXYAxisInRect:xyRect];
    [self drawYLabelPointsInRect:xyRect];
    [self drawBarsInRect:xyRect];
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

    self.stepYValue = self.maxYValue/4.0;

    CGFloat height = rect.size.height - 20.0;
    CGFloat minmaxDiff = self.maxYValue - self.minYValue;
    CGFloat numberOfPoints = minmaxDiff/self.stepYValue;
    
    for (NSInteger i = 0 ; i < (numberOfPoints + 1); i++) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentRight;
        
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:9.0],
                                      NSForegroundColorAttributeName: [UIColor darkGrayColor],
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
    
    CGFloat width = rect.size.width - 30.0;
    CGFloat barWidth = 30.0;
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

        CGFloat freeSpace = (width - (numberOfBars * barWidth));
        CGFloat barDifference = freeSpace/numberOfBars;

        CGFloat xOrigin25thPercentile = barDifference + (i * (width/(numberOfBars)));
        barRect25thPercentile.origin.x += xOrigin25thPercentile;

        //calculate 75th percentile height & origin

        CGFloat difference75thPercentile = value75thPercentile - self.minYValue;

        CGRect barRect75thPercentile = rect;
        barRect75thPercentile.size.width = barWidth;
        
        CGFloat reqHeight75thPercentile = (height * (difference75thPercentile/minmaxDiff));
        barRect75thPercentile.size.height = reqHeight75thPercentile;
        barRect75thPercentile.origin.y += (rect.size.height - reqHeight75thPercentile);
        
        CGFloat xOrigin75thPercentile = barDifference + (i * (width/(numberOfBars)));
        barRect75thPercentile.origin.x += xOrigin75thPercentile;

        //Get Color of Bars
        
        UIColor *color25thPercentile;
        UIColor *color75thPercentile;
        
        if([self.delegate respondsToSelector:@selector(barChart:colorFor25thPercentileAtIndex:)]) {
            color25thPercentile = [self.delegate barChart:self colorFor25thPercentileAtIndex:i];
        }

        if([self.delegate respondsToSelector:@selector(barChart:colorFor75thPercentileAtIndex:)]) {
            color75thPercentile = [self.delegate barChart:self colorFor75thPercentileAtIndex:i];
        }

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
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:9.0],
                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        CGRect label25thPercentileRect = barRect25thPercentile;
        label25thPercentileRect.origin.y += 2.0;
        label25thPercentileRect.size.height = 20.0;

        [[NSString stringWithFormat:@"%.0f",value25thPercentile] drawInRect:label25thPercentileRect withAttributes:attributes];

        CGRect label75thPercentileRect = barRect75thPercentile;
        label75thPercentileRect.origin.y += 2.0;
        label75thPercentileRect.size.height = 20.0;
        
        [[NSString stringWithFormat:@"%.0f",value75thPercentile] drawInRect:label75thPercentileRect withAttributes:attributes];
        
        NSString *barLabel = @"";
        
        if([self.delegate respondsToSelector:@selector(barChart:labelForPercentilesAtIndex:)]) {
            barLabel = [self.delegate barChart:self labelForPercentilesAtIndex:i];
        }

        CGFloat labeWidth = 50.0;
        
        CGRect labelRect = barRect25thPercentile;
        labelRect.size.width = labeWidth;
        labelRect.size.height = 50.0;
        labelRect.origin.x -= (10.0);
        labelRect.origin.y += reqHeight25thPercentile + 5.0;
        
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;

        attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:9.0],
                        NSForegroundColorAttributeName: [UIColor darkGrayColor],
                        NSParagraphStyleAttributeName: paragraphStyle };
        
        [barLabel drawInRect:labelRect withAttributes:attributes];
    }
}

@end
