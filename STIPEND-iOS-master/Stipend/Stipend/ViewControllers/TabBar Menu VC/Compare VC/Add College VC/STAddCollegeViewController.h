//
//  STAddCollegeViewController.h
//  Stipend
//
//  Created by sourcebits on 28/07/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STAddCollegeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView                                   *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar                                   *searchBar;

@property (nonatomic,retain) NSManagedObjectContext                             *localContext;

@property (nonatomic,retain) NSMutableArray                                      *searchArray;
@property (nonatomic,assign) BOOL                                          showRecentSearches;
@property (nonatomic,assign) BOOL                                       isFavoriteAllSelected;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint            *tableViewBottomConstraint;


@end
