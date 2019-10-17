//
//  CollegePageBaseViewController.h
//  StipendTesting
//
//  Created by Ganesh Kumar on 26/05/15.
//  Copyright (c) 2015 Source bits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPieChartView.h"

@interface CollegePageBaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, STPieChartDataSourceDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
