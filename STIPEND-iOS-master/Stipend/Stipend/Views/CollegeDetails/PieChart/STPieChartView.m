//
//  STPieChartView.m
//  Stipend
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

    CGRect titleRect = CGRectMake(self.bounds.origin.x + 15.0, self.bounds.origin.y + 5, ((self.bounds.size.width) - 30.0), 20.0);
    
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
    
    self.title = titleString;
    
    if(titleString) {
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirHeavy FontForSize:13.0],
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

    CGFloat yValue = 0.0;
    
    for (NSUInteger i = 0; i < descCount; i++) {
        
        CGContextSetLineWidth(context, 2.0);
        CGContextSetRGBFillColor(context, 0, 0, 1.0, 1.0);
        
        UIColor *color;
        
        if([self.delegate respondsToSelector:@selector(pieChart:colorForDescriptionBulletAtIndex:)]) {
            color = [self.delegate pieChart:self colorForDescriptionBulletAtIndex:i];
        }

        CGContextSetFillColorWithColor(context, (CGColorRef)color.CGColor);
        CGRect circleRect;
        
        if([self.title length] > 0) {
            circleRect = CGRectMake(((self.bounds.size.width/2.0) + 5.0), ((self.bounds.size.height/4.0) - 5.0) + (5.0 + yValue) , 10.0, 10.0);
        } else {
            if(self.isPopularMajorsView) {
                circleRect = CGRectMake(((self.bounds.size.width/2.0) + 5.0), ((self.bounds.size.height/4.0) - 30.0) + (5.0 + yValue) , 10.0, 10.0);
            } else {
                circleRect = CGRectMake(((self.bounds.size.width/2.0) + 5.0), ((self.bounds.size.height/4.0) - 20.0) + (5.0 + yValue) , 10.0, 10.0);
            }
        }
        
        CGContextFillEllipseInRect(context, circleRect);
        
        NSString *textString = @"";
        
        if([self.delegate respondsToSelector:@selector(pieChart:valueForDescriptionAtIndex:)]) {
            textString = [self.delegate pieChart:self valueForDescriptionAtIndex:i];
        }
        
        CGFloat textHeight = [self getHeightForDescription:textString];
        CGRect textRect = CGRectMake((circleRect.origin.x + circleRect.size.width + 10.0), (circleRect.origin.y - 3.0), ((self.bounds.size.width/2.0) - 40.0), textHeight);

        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirLight FontForSize:12.0],
                                      NSForegroundColorAttributeName: [UIColor cellTextFieldTextColor],
                                      NSParagraphStyleAttributeName: paragraphStyle };

        [textString drawInRect:textRect withAttributes:attributes];
        
        yValue += (textHeight + 3.0);
    }
}

- (CGFloat) getHeightForDescription:(NSString *) description {
    
    CGFloat height = 0.0;

    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:description
                                    attributes:@{NSFontAttributeName: [UIFont fontType:eFontTypeAvenirLight FontForSize:12.0]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){((self.bounds.size.width/2.0) - 40.0), CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    height = ceilf(size.height);

    return height;
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

        CGFloat xPoint = (self.bounds.size.width/4.0) + 5.0;
        CGFloat yPoint = 0.0;

        if([self.title length] > 0) {
            yPoint = (self.bounds.size.height/2.0) + 5.0;
        }
        else {
            yPoint = (self.bounds.size.height/2.0) - 10.0;
        }
        
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
    
    self.delegate = nil;
}

@end
