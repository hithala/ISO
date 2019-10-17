//
//  STPieChartView.m
//  PieChartSample
//
//  Created by Arun S on 27/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STPieChartView.h"

#define CIRCLE_RADIUS   70.0

@implementation STPieChartView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.circleRadius = CIRCLE_RADIUS;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        self.circleRadius = CIRCLE_RADIUS;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
   
    [super drawRect:rect];
    
    [self drawTitle];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPieChart:context];
    [self drawDescription:context];
}

- (void)drawTitle  {

    CGRect titleRect = CGRectMake(self.bounds.origin.x + 10.0, self.bounds.origin.y + 10.0, ((self.bounds.size.width) - 40.0), 20.0);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    UIColor *titleColor = nil;
    
    if([self.delegate respondsToSelector:@selector(colorOfTitleText:)]) {
        titleColor = [self.delegate colorOfTitleText:self];
    }
    
    NSString *titleString = @"";
    
    if([self.delegate respondsToSelector:@selector(valueOfTitleText:)]) {
        titleString = [self.delegate valueOfTitleText:self];
    }
    
    if(titleString) {
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:12.0],
                                      NSForegroundColorAttributeName: titleColor,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        [titleString drawInRect:titleRect withAttributes:attributes];
    }
}

- (void)drawDescription:(CGContextRef)context  {

    NSInteger descCount = 0;
    
    if([self.delegate respondsToSelector:@selector(numberOfDescriptionsInPieChart:)]) {
        descCount = [self.delegate numberOfDescriptionsInPieChart:self];
    }

    for (NSUInteger i = 0; i < descCount; i++) {
        
        CGContextSetLineWidth(context, 2.0);
        CGContextSetRGBFillColor(context, 0, 0, 1.0, 1.0);
        
        UIColor *color;
        
        if([self.delegate respondsToSelector:@selector(pieChart:colorForDescriptionBulletAtIndex:)]) {
            color = [self.delegate pieChart:self colorForDescriptionBulletAtIndex:i];
        }

        CGContextSetFillColorWithColor(context, (CGColorRef)color.CGColor);
        CGRect circleRect = CGRectMake(((self.bounds.size.width/2.0)), ((self.bounds.size.height/4.0) - 10.0) + (self.bounds.origin.y + (i * 20)) , 10.0, 10.0);
        CGContextFillEllipseInRect(context, circleRect);
        
        CGRect textRect = CGRectMake((circleRect.origin.x + circleRect.size.width + 10.0), (circleRect.origin.y - 2.0), ((self.bounds.size.width/2.0) - 20.0), 15.0);

        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        UIColor *textColor = nil;
        
        if([self.delegate respondsToSelector:@selector(pieChart:colorForDescriptionBulletAtIndex:)]) {
            textColor = [self.delegate pieChart:self colorForDescriptionBulletAtIndex:i];
        }

        NSString *textString = @"";
        
        if([self.delegate respondsToSelector:@selector(pieChart:valueForDescriptionAtIndex:)]) {
            textString = [self.delegate pieChart:self valueForDescriptionAtIndex:i];
        }

        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:11.0],
                                      NSForegroundColorAttributeName: textColor,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        [textString drawInRect:textRect withAttributes:attributes];
    }
}

- (void)drawPieChart:(CGContextRef)context  {
    
    NSInteger sliceCount = 0;
    
    if([self.delegate respondsToSelector:@selector(numberOfSlicesInPieChart:)]) {
        sliceCount = [self.delegate numberOfSlicesInPieChart:self];
    }
    
    for (NSUInteger i = 0; i < sliceCount; i++) {
        
        // Determine start angle
        CGFloat startValue = 0;
        for (NSInteger k = 0; k < i; k++) {
            
            CGFloat startSliceValue = 0.0;
            
            if([self.delegate respondsToSelector:@selector(pieChart:valueForSliceAtIndex:)]) {
                startSliceValue = ([self.delegate pieChart:self valueForSliceAtIndex:k]/100.0);
            }
            
            startValue += startSliceValue;
        }
        CGFloat startAngle = startValue * 2 * M_PI - M_PI/2;
        
        // Determine end angle
        CGFloat endValue = 0;
        for (NSInteger j = i; j >= 0; j--) {
            
            CGFloat endSliceValue = 0.0;

            if([self.delegate respondsToSelector:@selector(pieChart:valueForSliceAtIndex:)]) {
                endSliceValue = ([self.delegate pieChart:self valueForSliceAtIndex:j]/100.0);
            }

            endValue += endSliceValue;
        }
        CGFloat endAngle = endValue * 2 * M_PI - M_PI/2;
        
        UIColor *color;
        
        if([self.delegate respondsToSelector:@selector(pieChart:colorForSliceAtIndex:)]) {
            color = [self.delegate pieChart:self colorForSliceAtIndex:i];
        }

        CGFloat xPoint = (self.bounds.size.width/4.0);
        CGFloat yPoint = (self.bounds.size.height/2.0);
        
        CGPoint circleCenter = CGPointMake(xPoint, yPoint);
        
        CGContextSetFillColorWithColor(context, (CGColorRef)color.CGColor);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, circleCenter.x, circleCenter.y);
        CGContextAddArc(context, circleCenter.x, circleCenter.y, self.circleRadius, startAngle, endAngle, 0);
        CGContextClosePath(context);
        CGFloat white[4] = {1, 1,
            1, 0.9};
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColor(context, white);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

- (void)dealloc {
    
}

@end
