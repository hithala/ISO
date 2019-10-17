//
//  ViewController.m
//  PieChartSample
//
//  Created by Arun S on 27/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pieChartView.delegate = self;
    self.barChartView.delegate = self;

    NSArray *slices = [NSArray arrayWithObjects:[NSNumber numberWithFloat:20],
                       [NSNumber numberWithFloat:19],
                       [NSNumber numberWithFloat:17],
                       [NSNumber numberWithFloat:15],
                       [NSNumber numberWithFloat:13],
                       [NSNumber numberWithFloat:9],
                       [NSNumber numberWithFloat:7],
                       nil];
    self.sliceArray = slices;
    
    // Set up the colors for the slices
    NSArray *colors = [NSArray arrayWithObjects:
                       [UIColor colorWithRed:16/255.0 green:92/255.0 blue:203/255.0 alpha:1],
                       [UIColor colorWithRed:19/255.0 green:111/255.0 blue:226/255.0 alpha:1],
                       [UIColor colorWithRed:30/255.0 green:128/255.0 blue:240/255.0 alpha:1],
                       [UIColor colorWithRed:49/255.0 green:143/255.0 blue:246/255.0 alpha:1],
                       [UIColor colorWithRed:80/255.0 green:163/255.0 blue:247/255.0 alpha:1],
                       [UIColor colorWithRed:146/255.0 green:197/255.0 blue:247/255.0 alpha:1],
                       [UIColor colorWithRed:173/255.0 green:213/255.0 blue:254/255.0 alpha:1],nil];
    
    self.colorsArray = colors;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//PIE CHART DATASOURCES


- (NSUInteger)numberOfSlicesInPieChart:(STPieChartView *)pieChart {

    return [self.sliceArray count];
}

- (CGFloat)pieChart:(STPieChartView *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    
    return [[self.sliceArray objectAtIndex:index] floatValue];
}

- (UIColor *)pieChart:(STPieChartView *)pieChart colorForSliceAtIndex:(NSUInteger)index {
    
    return [self.colorsArray objectAtIndex:index];
}

- (NSUInteger)numberOfDescriptionsInPieChart:(STPieChartView *)pieChart {
    
    return [self.sliceArray count];
}

- (NSString *)pieChart:(STPieChartView *)pieChart valueForDescriptionAtIndex:(NSUInteger)index {
    
    return [NSString stringWithFormat:@"1900 - 1600  %.0f%%",[[self.sliceArray objectAtIndex:index] floatValue]];
}

- (UIColor *)pieChart:(STPieChartView *)pieChart colorForDescriptionBulletAtIndex:(NSUInteger)index {
    
    return [self.colorsArray objectAtIndex:index];
}

- (NSString *)valueOfTitleText:(STPieChartView *)pieChart {
   
    return @"ETHNICITY";
}

- (UIColor *)colorOfTitleText:(STPieChartView *)pieChart {
    
    return [UIColor blackColor];
}

// BAR CHART DATASOURCES

- (CGFloat) minimumYValueOfBarChart:(STBarChartView *)barChart {
    return 0.0;
}
- (CGFloat) maximumYValueOfBarChart:(STBarChartView *)barChart {
    return 1000.0;
}

- (NSUInteger)numberOfBarsInBarChart:(STBarChartView *)barChart {
    return 3;
}

- (NSUInteger)barChart:(STBarChartView *)barChart valueFor25thPercentileAtIndex:(NSUInteger)index {
    return 520.0;
}
- (UIColor *)barChart:(STBarChartView *)barChart colorFor25thPercentileAtIndex:(NSUInteger)index {
    return [UIColor colorWithRed:26.0/255.0 green:193.0/255.0 blue:66.0/255.0 alpha:1.0];
}

- (NSUInteger)barChart:(STBarChartView *)barChart valueFor75thPercentileAtIndex:(NSUInteger)index {
    return 720.0;
}
- (UIColor *)barChart:(STBarChartView *)barChart colorFor75thPercentileAtIndex:(NSUInteger)index {
    return [UIColor colorWithRed:54.0/255.0 green:145.0/255.0 blue:242.0/255.0 alpha:1.0];
}

- (NSString *)barChart:(STBarChartView *)barChart labelForPercentilesAtIndex:(NSUInteger)index {
    
    if(index == 0) {
        return @"Chemistry";
    }
    else if(index == 1) {
        return @"Critical Reading";
    }
    else {
    }
    
    return @"Math";
}

@end
