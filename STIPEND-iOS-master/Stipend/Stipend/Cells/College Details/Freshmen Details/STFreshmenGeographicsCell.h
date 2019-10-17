//
//  STFreshmenGeographicsCell.h
//  Stipend
//
//  Created by Arun S on 25/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPieChartView.h"
#import "STCPieChartItem.h"

@interface STFreshmenGeographicsCell : UITableViewCell <STPieChartDataSourceDelegate>

@property (nonatomic,retain) NSOrderedSet          *pieChartDetails;
@property (nonatomic,weak) IBOutlet STPieChartView  *pieChartView;

- (void) updatePieChartViewWithDetails:(NSOrderedSet *) details;

@end
