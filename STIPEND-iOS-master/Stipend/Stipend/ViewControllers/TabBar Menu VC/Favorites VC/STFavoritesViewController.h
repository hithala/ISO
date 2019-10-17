//
//  STFavoritesViewController.h
//  Stipend
//
//  Created by Ganesh Kumar on 13/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FavoritesViewControllerDelegate <NSObject>

@optional
- (void)showMenu;
- (void)capturedImage:(UIImage *)image;

@end

@interface STFavoritesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView                *tableView;
@property (nonatomic, weak) IBOutlet UIView                     *emptyView;

@property (nonatomic,retain) NSMutableOrderedSet           *favoritesItems;
@property (nonatomic,retain) NSManagedObjectContext          *localContext;

@property (nonatomic, assign) id<FavoritesViewControllerDelegate> delegate;

@end