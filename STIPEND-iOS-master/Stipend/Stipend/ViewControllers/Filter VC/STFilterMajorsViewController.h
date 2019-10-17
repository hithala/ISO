//
//  STFilterMajorsViewController.h
//  Stipend
//
//  Created by Ganesh Kumar on 22/10/18.
//  Copyright © 2018 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STFilterMajorsViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,retain) NSManagedObjectContext    *localContext;

@property (nonatomic, strong) NSArray                   *broadMajors;

@property (nonatomic, weak) IBOutlet UITableView          *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar          *searchBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint      *tableViewBottomConstraint;

@end
