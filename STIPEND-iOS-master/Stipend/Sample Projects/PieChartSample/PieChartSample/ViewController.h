//
//  ViewController.h
//  PieChartSample
//
//  Created by Arun S on 27/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPieChartView.h"
#import "STBarChartView.h"

@interface ViewController : UIViewController <STPieChartDataSourceDelegate,STBarChartDataSourceDelegate>

@property (weak, nonatomic) IBOutlet STPieChartView *pieChartView;
@property (weak, nonatomic) IBOutlet STBarChartView *barChartView;
@property (nonatomic, retain) NSArray  *sliceArray;
@property (nonatomic, retain) NSArray *colorsArray;

@end

