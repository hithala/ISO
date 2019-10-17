//
//  STFilterViewController.h
//  Stipend
//
//  Created by Arun S on 14/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STFilter.h"

extern NSString * const FilterStateDidChangeNameNotification;

@interface STFilterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> //UITableViewController

@property (nonatomic,strong) NSMutableDictionary *filterDataSourceDictionary;
@property (nonatomic,assign) SortType                               sortType;

@property (nonatomic,retain) NSManagedObjectContext            *localContext;

@property (nonatomic, assign) BOOL                         hasResettedFilter;

@property (nonatomic, retain) UIButton                       *rightBarButton;

@property (nonatomic, weak) IBOutlet UITableView *tableView;


- (void)updateFilter:(STFilter *)filter inContext:(NSManagedObjectContext *) localContext;

@end
