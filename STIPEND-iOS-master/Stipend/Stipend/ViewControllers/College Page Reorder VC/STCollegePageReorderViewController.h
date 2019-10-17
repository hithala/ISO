//
//  STCollegePageReorderViewController.h
//  Stipend
//
//  Created by Mahesh A on 08/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STUser.h"
#import "STSectionItem.h"

@interface STCollegePageReorderViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
//UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSManagedObjectContext *localContext;
@property (nonatomic,retain) NSMutableOrderedSet *collegeSections;

@property (nonatomic, assign) BOOL                   isPresenting;

- (IBAction)doneButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

@property (nonatomic, strong) void (^cancelActionBlock)(void);
@property (nonatomic, strong) void (^doneActionBlock)(void);

@end
