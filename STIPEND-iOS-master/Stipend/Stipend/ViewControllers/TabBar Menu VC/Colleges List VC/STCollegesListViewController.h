//
//  STCollegesListViewController.h
//  Stipend
//
//  Created by Ganesh Kumar on 12/05/15.
//  Copyright (c) 2015 Sourcebits. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    eActionTypeReloadCollege = 0,
    eActionTypeResetFilter = 1
}ActionType;

@protocol CollegesListViewControllerDelegate <NSObject>

@optional
- (void)showMenu;
- (void)capturedImage:(UIImage *)image;

@end

@interface STCollegesListViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView                  *searchResultTableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *searchTableBottomConstraint;

@property (strong, nonatomic) UIPageViewController                       *pageController;
@property (strong, nonatomic) UISearchBar                                     *searchBar;

@property (nonatomic, assign) id<CollegesListViewControllerDelegate>            delegate;

@property (strong, nonatomic) NSArray                               *rightBarButtonItems;
@property (nonatomic, assign) NSUInteger                     searchTableViewSectionCount;
@property (nonatomic, assign) NSUInteger                            selectedCollegeIndex;

@property (nonatomic, retain) NSArray                                       *collegeList;

@property (nonatomic,retain) NSMutableArray                                 *searchArray;

@property (nonatomic,assign) BOOL                                     showRecentSearches;

@property (nonatomic, weak) IBOutlet UIView                            *networkErrorView;
@property (nonatomic, weak) IBOutlet UILabel                            *errorTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel                         *errorSubTitleLabel;
@property (nonatomic, weak) IBOutlet UIButton                              *reloadButton;

- (IBAction)onReloadAction:(id)sender;

@end
