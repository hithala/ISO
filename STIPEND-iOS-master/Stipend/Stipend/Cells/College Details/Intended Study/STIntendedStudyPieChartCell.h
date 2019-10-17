//
//  STIntendedStudyPieChartCell.h
//  Stipend
//
//  Created by Arun S on 24/06/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPieChartView.h"

@interface STIntendedStudyPieChartCell : UITableViewCell <STPieChartDataSourceDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellSeparatorHeightConstraint;

@property (nonatomic,retain) NSOrderedSet                             *pieChartDetails;
@property (nonatomic,retain) IBOutlet STPieChartView                     *pieChartView;

- (void) updatePieChartViewWithDetails:(NSOrderedSet *) details;

@end
