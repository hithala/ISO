//
//  STFilterSpecificMajorsViewController.h
//  Stipend
//
//  Created by Ganesh Kumar on 22/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STFilter.h"
#import "STBroadMajor.h"
#import "STSpecificMajor.h"

@interface STFilterSpecificMajorsViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary                                *majorDetails;
@property (nonatomic, strong) NSString                                    *searchString;

@property (nonatomic, weak) IBOutlet UITableView                             *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar                             *searchBar;

@property (nonatomic,retain) NSManagedObjectContext                       *localContext;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint      *tableViewBottomConstraint;

@property (nonatomic, weak) IBOutlet UILabel                          *searchTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton                          *selectAllButton;

@property (nonatomic, strong) void (^resetUpdateActionBlock)(void);

@end
