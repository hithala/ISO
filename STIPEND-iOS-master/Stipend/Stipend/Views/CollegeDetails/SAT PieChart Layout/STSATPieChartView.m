//
//  STSATPieChartView.m
//  Stipend
//
//  Created by Arun S on 04/08/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "STSATPieChartView.h"

@implementation STSATPieChartView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPieCharts:context];
    [self drawDescription:context];
    [self drawPercentages:context];
}

- (void) updateSATLayoutItems:(NSOrderedSet *) layoutItems {
    self.pieCharts = layoutItems;
    [self setNeedsDisplay];
}

- (void)drawDescription:(CGContextRef)context  {
    
    if(self.pieCharts.count > 0) {
        
        NSInteger index = 0;
        NSInteger itemsCount = 0;
        
        for (NSInteger i = 0 ; i < self.pieCharts.count; i++) {
            STCSATPieChart *item = [self.pieCharts objectAtIndex:i];
            
            if(item.pieChartItems.count > itemsCount) {
                index = i;
                itemsCount = item.pieChartItems.count;
            }
        }
        
        STCSATPieChart *pieChart = [self.pieCharts objectAtIndex:index];
        
        NSInteger count = pieChart.pieChartItems.count;
        
        for (NSUInteger i = 0; i < count; i++) {
            
            CGContextSetLineWidth(context, 2.0);
            CGContextSetRGBFillColor(context, 0, 0, 1.0, 1.0);

            UIColor *color;
            
            color = [GREEN_COLOR_ARRAY objectAtIndex:i];
            
//            CGFloat padding = self.pieCharts.count > 2 ? 40.0 : 55.0;
//            CGRect circleRect = CGRectMake(15.0, (((self.bounds.size.height/2.0) + padding) + (i * 20.0)) , 10.0, 10.0);
            
            CGRect circleRect = CGRectMake(15.0, ((self.titleYPosition + 32.5) + (i * 20.0)) , 10.0, 10.0);
            
            CGContextSetFillColorWithColor(context, (CGColorRef)color.CGColor);
            CGContextFillEllipseInRect(context, circleRect);
            
            STCSATPieChartItem *item = [pieChart.pieChartItems objectAtIndex:i];
            
            NSString *textString = @"";
            textString = [NSString stringWithFormat:@"%@:",item.key];
            
//            CGFloat padding1 = count > 2 ? 3.0 : -10.0;
            CGRect textRect = CGRectMake((circleRect.origin.x + circleRect.size.width + 10.0), circleRect.origin.y - 2.5, 100.0, 20.0);

            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = NSTextAlignmentLeft;
            
            NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirLight FontForSize:12.0],
                                          NSForegroundColorAttributeName: [UIColor cellTextFieldTextColor],
                                          NSParagraphStyleAttributeName: paragraphStyle };
            
            [textString drawInRect:textRect withAttributes:attributes];
        }
    }
}

- (void) drawPercentages:(CGContextRef) context {
    
    NSInteger count = self.pieCharts.count;

    for (NSInteger i = 0 ; i < count; i++) {
        
        STCSATPieChart *pieChart = [self.pieCharts objectAtIndex:i];
        
        NSInteger sliceCount = pieChart.pieChartItems.count;
        
        for (NSUInteger j = 0; j < sliceCount; j++) {
        
            STCSATPieChartItem *item = [pieChart.pieChartItems objectAtIndex:j];
            
            CGFloat padding = count > 2 ? 40.0 : 55.0;
            CGRect circleRect = CGRectMake(15.0, (((self.bounds.size.height/2.0) + padding) + (j * 20.0)), 10.0, 10.0);

            NSString *textString = @"";
            textString = [NSString stringWithFormat:@"%@%%",item.value];
            
            CGRect textRect = CGRectMake((circleRect.origin.x + circleRect.size.width + 10.0), (circleRect.origin.y - 3.0), 100.0, 15.0);

            CGFloat xPoint = (i * ((self.bounds.size.width/count))) + ((self.bounds.size.width/count)/2.0);

            CGRect titleRect = CGRectMake(xPoint - (((self.bounds.size.width/3.0)/2.0) - 20.0), ((self.bounds.size.height/2.0) + 37.0 + (j * 20.0)), ((self.bounds.size.width/3.0) - 40.0), 20.0);

            CGRect percetageRect = CGRectZero;
            
            if(count == 1) {
                percetageRect = titleRect;
            } else if(count == 2) {
               
                if(IS_IPAD) {
                    percetageRect = titleRect;
//                    percetageRect.origin.y = textRect.origin.y;
                    percetageRect.origin.y = ((self.titleYPosition + 30) + (j * 20.0));
                } else {
                    if(i == 0) {
                        percetageRect = CGRectMake((textRect.origin.x + textRect.size.width - 28.0), ((self.titleYPosition + 30) + (j * 20.0)), 50.0, 20.0);
                    } else {
                        percetageRect = titleRect;
//                        percetageRect.origin.y = textRect.origin.y;
                        percetageRect.origin.y = ((self.titleYPosition + 30) + (j * 20.0));
                    }
                }
            }
            else if(count == 3) {
                
                if(i == 0) {
                    percetageRect = CGRectMake((textRect.origin.x + textRect.size.width - 28.0), ((self.titleYPosition + 30) + (j * 20.0)), 50.0, 20.0);
                }
                else {
                    percetageRect = titleRect;
//                    percetageRect.origin.y = textRect.origin.y;
                    percetageRect.origin.y = ((self.titleYPosition + 30) + (j * 20.0));
                }
            }
            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirMedium FontForSize:12.0],
                                          NSForegroundColorAttributeName: [UIColor cellTextFieldTextColor],
                                          NSParagraphStyleAttributeName: paragraphStyle
                                          };
            
            [textString drawInRect:percetageRect withAttributes:attributes];
        }
    }
}

- (void)drawPieCharts:(CGContextRef)context  {
   
    NSInteger count = self.pieCharts.count;
    
    for (NSInteger z = 0 ; z < count; z++) {
        
        STCSATPieChart *pieChart = [self.pieCharts objectAtIndex:z];
        
        NSInteger sliceCount = pieChart.pieChartItems.count;
        
        for (NSUInteger i = 0; i < sliceCount; i++) {
            
            // Determine start angle
            CGFloat startValue = 0;
            for (NSInteger k = 0; k < i; k++) {
                
                CGFloat startSliceValue = 0.0;
                
                STCPieChartItem *pieChartItem = [pieChart.pieChartItems objectAtIndex:k];
                
                startSliceValue = ([pieChartItem.value floatValue]/100.0);
                startValue += startSliceValue;
            }
            CGFloat startAngle = startValue * 2 * M_PI - M_PI/2;
            
            // Determine end angle
            CGFloat endValue = 0;
            for (NSInteger j = i; j >= 0; j--) {
                
                CGFloat endSliceValue = 0.0;
                
                STCPieChartItem *pieChartItem = [pieChart.pieChartItems objectAtIndex:j];
                endSliceValue = ([pieChartItem.value floatValue]/100.0);
                endValue += endSliceValue;
            }
            
            CGFloat endAngle = endValue * 2 * M_PI - M_PI/2;
            
            UIColor *color;
            color = [GREEN_COLOR_ARRAY objectAtIndex:i];
            
            CGFloat xPoint = (z * ((self.bounds.size.width/count))) + ((self.bounds.size.width/count)/2.0);

            CGFloat padding1 = count > 2 ? 10.0 : 20.0;
            CGFloat radius = (((self.bounds.size.width/count)/2.0) - padding1);

            radius = radius > 70.0 ? 70.0 : radius;

            CGFloat yPoint = radius + 10;
            CGPoint circleCenter = CGPointMake(xPoint, yPoint);

//            if(IS_IPHONE) {
//
//                if([UIScreen mainScreen].bounds.size.width > 414) {
//                    radius = radius - (radius*0.50);
//                }
//            }
            
            CGContextSetFillColorWithColor(context, (CGColorRef)color.CGColor);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, circleCenter.x, circleCenter.y);
            CGContextAddArc(context, circleCenter.x, circleCenter.y, radius, startAngle, endAngle, 0);
            CGContextClosePath(context);
            CGFloat white[4] = {1, 1,
                1, 0.9};
            CGContextSetLineWidth(context, 1.0);
            CGContextSetStrokeColor(context, white);
            CGContextDrawPath(context, kCGPathFillStroke);
            
//            CGRect titleRect = CGRectMake(xPoint - (((self.bounds.size.width/3.0)/2.0) - 20.0), (self.bounds.size.height/2.0) - 10.0, ((self.bounds.size.width/3.0) - 40.0), 40.0);
//            CGFloat padding3 = count > 2 ? -10.0 : 20.0;
//            CGRect titleRect = CGRectMake(xPoint - (((self.bounds.size.width/count)/2.0) - 20.0), (self.bounds.size.height/2.0) + padding3, ((self.bounds.size.width/2.0) - 40.0), 40.0);
//            CGRect titleRect = CGRectMake(xPoint - radius, (self.bounds.size.height/2.0) + padding3, radius * 2, 40.0);
            self.titleYPosition = radius * 2 + 20;
            CGRect titleRect = CGRectMake(xPoint - radius, self.titleYPosition, radius * 2, 40.0);
            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontType:eFontTypeAvenirLight FontForSize:13.0],
                                          NSForegroundColorAttributeName: [UIColor cellTextFieldTextColor],
                                          NSParagraphStyleAttributeName: paragraphStyle
                                          };

            [pieChart.name drawInRect:titleRect withAttributes:attributes];
        }
    }
}

- (void)dealloc {
}

@end
