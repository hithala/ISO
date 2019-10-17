//
//  STFilterStateViewController.h
//  Stipend
//
//  Created by Arun S on 14/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFilterStateViewController : UITableViewController //UIViewController<UITableViewDelegate, UITableViewDataSource> //UITableViewController

@property (nonatomic, strong) NSMutableArray *selectedStateNameList;
@property (nonatomic, strong) NSMutableArray *selectedStateCodeList;

//@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
